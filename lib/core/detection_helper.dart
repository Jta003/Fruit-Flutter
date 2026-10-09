import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class FruitDetectionResult {
  final String label;
  final int index;
  final double confidence;
  final String source;

  FruitDetectionResult({
    required this.label,
    required this.index,
    required this.confidence,
    required this.source,
  });

  @override
  String toString() => '$label (${(confidence * 100).toStringAsFixed(1)}%) via $source';
}

class DetectionHelper {
  static final DetectionHelper _instance = DetectionHelper._internal();
  factory DetectionHelper() => _instance;
  DetectionHelper._internal();

  Interpreter? _interpreter;
  ImageLabeler? _mlKitLabeler;
  List<String> _labels = [];
  bool _isInitialized = false;

  static const double confidenceThreshold = 0.55;

  List<String> get labels => _labels;
  bool get isReady => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 1. โหลด labels.txt (รองรับทั้ง assets/models/ และ assets/)
      String labelsData = "";
      try {
        labelsData = await rootBundle.loadString('assets/models/labels.txt');
      } catch (_) {
        labelsData = await rootBundle.loadString('assets/labels.txt');
      }

      _labels = labelsData
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .map((line) {
            final parts = line.split(RegExp(r'\s+'));
            return parts.length > 1 ? parts.sublist(1).join(' ') : parts[0];
          })
          .toList();
      debugPrint('Loaded AI Labels (${_labels.length}): $_labels');

      // 2. โหลดโมเดล Custom TFLite
      const candidatePaths = [
        'assets/models/fruit_model.tflite',
        'assets/model_unquant.tflite',
        'assets/fruit_model.tflite',
      ];

      for (final modelPath in candidatePaths) {
        if (_interpreter != null) break;
        try {
          _interpreter = await Interpreter.fromAsset(modelPath);
          debugPrint('Custom TFLite model loaded successfully from $modelPath!');
        } catch (_) {
          try {
            final byteData = await rootBundle.load(modelPath);
            final buffer = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
            _interpreter = Interpreter.fromBuffer(buffer);
            debugPrint('Custom TFLite model loaded from buffer $modelPath!');
          } catch (_) {}
        }
      }

      // 3. โหลด Google ML Kit Base Labeler สำรอง
      try {
        final options = ImageLabelerOptions(confidenceThreshold: 0.35);
        _mlKitLabeler = ImageLabeler(options: options);
        debugPrint('ML Kit Base Labeler initialized successfully!');
      } catch (mlErr) {
        debugPrint('ML Kit Labeler init note: $mlErr');
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing DetectionHelper: $e');
    }
  }

  /// วิเคราะห์ภาพสดจากกล้อง (CameraImage) ตรงไปยังโมเดล TFLite โดยแปลง YUV/BGRA เข้า 224x224 ทันที
  Future<FruitDetectionResult?> processCameraFrame(CameraImage image) async {
    if (!_isInitialized) await initialize();
    if (_interpreter == null) return null;

    try {
      final inputTensor = _extract224x224Tensor(image);
      if (inputTensor == null) return null;

      final output = [List<double>.filled(max(6, _labels.length), 0.0)];
      _interpreter!.run(inputTensor, output);

      final scores = output[0];
      int bestIdx = -1;
      double highest = -1.0;

      for (int i = 0; i < scores.length && i < _labels.length; i++) {
        if (scores[i] > highest) {
          highest = scores[i];
          bestIdx = i;
        }
      }

      if (bestIdx >= 0 && bestIdx < _labels.length) {
        return FruitDetectionResult(
          label: _labels[bestIdx],
          index: bestIdx,
          confidence: highest,
          source: 'TFLite Model',
        );
      }
    } catch (e) {
      debugPrint('Error in processCameraFrame: $e');
    }
    return null;
  }

  /// วิเคราะห์ภาพจากไฟล์รูปถ่ายเต็ม (img.Image)
  FruitDetectionResult? classifyDecodedImage(img.Image originalImage) {
    if (_interpreter == null) return null;

    try {
      final resized = img.copyResize(originalImage, width: 224, height: 224);

      final inputTensor = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              final pixel = resized.getPixel(x, y);
              return [
                (pixel.r - 127.5) / 127.5,
                (pixel.g - 127.5) / 127.5,
                (pixel.b - 127.5) / 127.5,
              ];
            },
          ),
        ),
      );

      final output = [List<double>.filled(max(6, _labels.length), 0.0)];
      _interpreter!.run(inputTensor, output);

      final scores = output[0];
      int bestIdx = -1;
      double highest = -1.0;

      for (int i = 0; i < scores.length && i < _labels.length; i++) {
        if (scores[i] > highest) {
          highest = scores[i];
          bestIdx = i;
        }
      }

      if (bestIdx >= 0 && bestIdx < _labels.length) {
        return FruitDetectionResult(
          label: _labels[bestIdx],
          index: bestIdx,
          confidence: highest,
          source: 'TFLite Snapshot',
        );
      }
    } catch (e) {
      debugPrint('Error in classifyDecodedImage: $e');
    }
    return null;
  }

  /// วิเคราะห์จากไฟล์รูปที่ถ่าย (รองรับทั้ง TFLite และ ML Kit สำรอง)
  Future<FruitDetectionResult?> classifyImagePath(String path) async {
    if (!_isInitialized) await initialize();

    FruitDetectionResult? bestResult;

    // 1. ตรวจสอบด้วย TFLite Model
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded != null) {
        // Crop ส่วนกลางของภาพเพื่อให้ได้เฉพาะวัตถุหลัก
        final size = min(decoded.width, decoded.height);
        final x = (decoded.width - size) ~/ 2;
        final y = (decoded.height - size) ~/ 2;
        final cropped = img.copyCrop(decoded, x: x, y: y, width: size, height: size);

        final result = classifyDecodedImage(cropped);
        if (result != null) {
          bestResult = result;
          if (result.confidence >= confidenceThreshold) {
            return result;
          }
        }
      }
    } catch (e) {
      debugPrint('TFLite classify image path error: $e');
    }

    // 2. ตรวจสอบสำรองด้วย Google ML Kit
    if (_mlKitLabeler != null) {
      try {
        final inputImage = InputImage.fromFilePath(path);
        final labels = await _mlKitLabeler!.processImage(inputImage);
        for (final label in labels) {
          debugPrint('ML Kit fallback label: ${label.label} (${label.confidence})');
          final text = label.label.toLowerCase();

          for (int i = 0; i < _labels.length; i++) {
            final fruitName = _labels[i].toLowerCase();
            if (text.contains(fruitName) || fruitName.contains(text)) {
              if (bestResult == null || label.confidence > bestResult.confidence) {
                bestResult = FruitDetectionResult(
                  label: _labels[i],
                  index: i,
                  confidence: label.confidence,
                  source: 'ML Kit AI',
                );
              }
            }
          }
        }
      } catch (e) {
        debugPrint('ML Kit classify error: $e');
      }
    }

    return bestResult;
  }

  /// ตัวช่วยดึงภาพจากตรงกลางเฟรมกล้อง Crop เป็น 224x224 และ Normalize เป็น [-1, 1] สำหรับ TFLite
  List<List<List<List<double>>>>? _extract224x224Tensor(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int boxSize = min(width, height);
    final int startX = (width - boxSize) ~/ 2;
    final int startY = (height - boxSize) ~/ 2;

    const int targetSize = 224;
    final double step = boxSize / targetSize;

    if (Platform.isAndroid && image.format.group == ImageFormatGroup.yuv420) {
      final yPlane = image.planes[0];
      final uPlane = image.planes[1];
      final vPlane = image.planes[2];

      final yBytes = yPlane.bytes;
      final uBytes = uPlane.bytes;
      final vBytes = vPlane.bytes;

      final yRowStride = yPlane.bytesPerRow;
      final uRowStride = uPlane.bytesPerRow;
      final vRowStride = vPlane.bytesPerRow;

      final uPixelStride = uPlane.bytesPerPixel ?? 1;
      final vPixelStride = vPlane.bytesPerPixel ?? 1;

      final tensor = List.generate(
        1,
        (_) => List.generate(
          targetSize,
          (ty) {
            final int srcY = (startY + (ty * step)).toInt().clamp(0, height - 1);
            final int uvY = srcY >> 1;

            return List.generate(
              targetSize,
              (tx) {
                final int srcX = (startX + (tx * step)).toInt().clamp(0, width - 1);
                final int uvX = srcX >> 1;

                final int yVal = yBytes[srcY * yRowStride + srcX];
                final int uVal = uBytes[uvY * uRowStride + uvX * uPixelStride];
                final int vVal = vBytes[uvY * vRowStride + uvX * vPixelStride];

                // YUV to RGB conversion
                final double r = (yVal + 1.402 * (vVal - 128)).clamp(0.0, 255.0);
                final double g = (yVal - 0.344136 * (uVal - 128) - 0.714136 * (vVal - 128)).clamp(0.0, 255.0);
                final double b = (yVal + 1.772 * (uVal - 128)).clamp(0.0, 255.0);

                return [
                  (r - 127.5) / 127.5,
                  (g - 127.5) / 127.5,
                  (b - 127.5) / 127.5,
                ];
              },
            );
          },
        ),
      );
      return tensor;
    } else if (image.planes.isNotEmpty) {
      // Fallback สำหรับ BGRA หรือฟอร์แมตอื่น
      final plane = image.planes[0];
      final bytes = plane.bytes;
      final rowStride = plane.bytesPerRow;
      final pixelStride = plane.bytesPerPixel ?? 4;

      final tensor = List.generate(
        1,
        (_) => List.generate(
          targetSize,
          (ty) {
            final int srcY = (startY + (ty * step)).toInt().clamp(0, height - 1);
            return List.generate(
              targetSize,
              (tx) {
                final int srcX = (startX + (tx * step)).toInt().clamp(0, width - 1);
                final int offset = srcY * rowStride + srcX * pixelStride;

                if (offset + 2 < bytes.length) {
                  final b = bytes[offset];
                  final g = bytes[offset + 1];
                  final r = bytes[offset + 2];
                  return [
                    (r - 127.5) / 127.5,
                    (g - 127.5) / 127.5,
                    (b - 127.5) / 127.5,
                  ];
                }
                return [0.0, 0.0, 0.0];
              },
            );
          },
        ),
      );
      return tensor;
    }

    return null;
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _mlKitLabeler?.close();
    _mlKitLabeler = null;
    _isInitialized = false;
  }
}
