import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import '../core/constants.dart';
import '../models/fruit.dart';
import '../providers/fruit_provider.dart';
import '../widgets/mock_widgets.dart';
import '../widgets/custom_painters.dart';
import '../widgets/fruit_art.dart';
import '../core/detection_helper.dart';

class ScanScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final VoidCallback onClose;
  final ValueChanged<Fruit> onDetected;

  const ScanScreen({
    super.key, 
    required this.cameras, 
    required this.onClose, 
    required this.onDetected,
  });

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  CameraController? _controller;
  final DetectionHelper _detectionHelper = DetectionHelper();
  bool _isDetected = false;
  bool _isCapturing = false;
  String _currentLabel = "";
  double _confidence = 0.0;
  String _debugLabels = "กำลังเปิดกล้องและ AI...";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) {
      if (mounted) {
        setState(() => _debugLabels = "ไม่พบอุปกรณ์กล้องบนเครื่องนี้");
      }
      return;
    }

    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      await _detectionHelper.initialize();
      if (mounted) {
        setState(() => _debugLabels = "จัดผลไม้ให้อยู่ในกรอบ แล้วกดปุ่มถ่ายภาพด้านล่าง");
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      if (mounted) {
        setState(() => _debugLabels = "เกิดข้อผิดพลาดในการเปิดกล้อง: $e");
      }
    }
  }

  bool _isSameFruitType(String aiLabel, String kindName) {
    aiLabel = aiLabel.toLowerCase().trim();
    kindName = kindName.toLowerCase().trim();

    if (aiLabel == kindName) return true;
    if (aiLabel.contains(kindName) || kindName.contains(aiLabel)) return true;

    if (aiLabel.contains('grape') && kindName.contains('grape')) return true;
    if (aiLabel.contains('strawberr') && kindName.contains('strawberr')) return true;
    if (aiLabel.contains('appl') && kindName.contains('appl')) return true;
    if (aiLabel.contains('banan') && kindName.contains('banan')) return true;
    if (aiLabel.contains('orang') && kindName.contains('orang')) return true;
    if (aiLabel.contains('mang') && kindName.contains('mang')) return true;
    if (aiLabel.contains('kiwi') && kindName.contains('kiwi')) return true;
    if ((aiLabel.contains('chickoo') || aiLabel.contains('chiku') || aiLabel.contains('sapodilla')) && kindName.contains('chickoo')) return true;
    if (aiLabel.contains('cherr') && kindName.contains('cherr')) return true;

    return false;
  }

  Fruit? _findFruitMatch(String label, int index, List<Fruit> fruits) {
    // 1. ตรวจสอบตามชื่อ Label ที่ได้จากโมเดล (ปลอดภัยและตรงกับ labels.txt ที่สุด)
    try {
      return fruits.firstWhere((f) {
        return _isSameFruitType(label, f.kind.name) ||
               _isSameFruitType(label, f.name);
      });
    } catch (_) {}

    // 2. Fallback ตรวจสอบตาม index
    if (index >= 0 && index < fruits.length) {
      return fruits[index];
    }

    return null;
  }

  /// ถ่ายภาพและวิเคราะห์ด้วย AI เมื่อผู้ใช้กดปุ่มถ่าย (Manual Shutter Capture)
  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing || _isDetected) return;

    setState(() {
      _isCapturing = true;
      _debugLabels = "กำลังถ่ายและวิเคราะห์ภาพด้วย AI...";
    });

    try {
      final xFile = await _controller!.takePicture();
      final result = await _detectionHelper.classifyImagePath(xFile.path);

      if (result != null && mounted) {
        final fruits = context.read<FruitProvider>().fruits;
        final matchedFruit = _findFruitMatch(result.label, result.index, fruits);
        if (matchedFruit != null) {
          final confidencePct = (result.confidence * 100).toStringAsFixed(0);
          setState(() {
            _currentLabel = matchedFruit.name;
            _confidence = result.confidence;
            _debugLabels = "ตรวจพบ: ${matchedFruit.name} ($confidencePct%)";
          });
          await _selectFruit(matchedFruit, result.confidence);
          return;
        }
      }

      if (mounted) {
        setState(() {
          _debugLabels = "ไม่พบผลไม้หรือภาพไม่ชัดเจน กรุณาลองถ่ายใหม่อีกครั้ง";
          _isCapturing = false;
        });
      }
    } catch (e) {
      debugPrint('Capture error: $e');
      if (mounted) {
        setState(() {
          _debugLabels = "เกิดข้อผิดพลาดในการถ่ายภาพ กรุณาลองใหม่";
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _selectFruit(Fruit fruit, double confidence) async {
    if (_isDetected) return;

    setState(() {
      _currentLabel = fruit.name;
      _confidence = confidence;
      _isDetected = true;
      _debugLabels = "สำเร็จ! ตรวจพบ ${fruit.name} กำลังแสดงข้อมูล...";
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    widget.onDetected(fruit);

    // รีเซ็ตสถานะทั้งหมด เพื่อให้เมื่อกลับมาหน้าสแกน สามารถสแกนผลไม้อื่นต่อได้ทันที
    if (mounted) {
      setState(() {
        _isDetected = false;
        _isCapturing = false;
        _currentLabel = "";
        _confidence = 0.0;
        _debugLabels = "จัดผลไม้ให้อยู่ในกรอบ แล้วกดปุ่มถ่ายภาพด้านล่าง";
      });
    }
  }

  @override
  void dispose() {
    try {
      _controller?.pausePreview();
    } catch (_) {}
    _controller?.dispose();
    _detectionHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fruits = context.watch<FruitProvider>().fruits;

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.green),
              SizedBox(height: 16),
              Text('กำลังเปิดกล้องและโหลดโมเดล AI...', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: CameraPreview(_controller!),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                children: [
                  const StatusBarMock(isLight: true),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleIconButton(
                        icon: Icons.close_rounded,
                        onTap: widget.onClose,
                        isGlass: true,
                      ),
                      CircleIconButton(
                        icon: _controller!.value.flashMode == FlashMode.torch
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        onTap: () {
                          _controller!.setFlashMode(
                            _controller!.value.flashMode == FlashMode.torch
                                ? FlashMode.off
                                : FlashMode.torch,
                          );
                          setState(() {});
                        },
                        isGlass: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Real Fruit Scanner',
                    style: titleStyle(size: 22, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ส่องผลไม้จริงเพื่อวิเคราะห์โภชนาการแบบสดๆ',
                    style: bodyStyle(color: Colors.white.withAlpha(210)),
                  ),

                  const SizedBox(height: 10),
                  // แถบสถานะ AI Real-time
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(170),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isDetected ? AppColors.green : Colors.yellowAccent.withAlpha(160),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isDetected ? Icons.check_circle_rounded : Icons.search_rounded,
                          size: 16,
                          color: _isDetected ? AppColors.green : Colors.yellowAccent,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _debugLabels,
                            style: TextStyle(
                              color: _isDetected ? AppColors.green : Colors.yellowAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // เป้าโฟกัสกล้อง
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CustomPaint(
                      painter: FocusRingPainter(),
                    ),
                  ),

                  const Spacer(),

                  // ปุ่มกดถ่ายภาพเพื่อสแกน (Manual Shutter Button)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _captureAndAnalyze,
                        child: Container(
                          width: 76,
                          height: 76,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3.5),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isCapturing ? Colors.grey : AppColors.green,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.green.withAlpha(140),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: _isCapturing
                                  ? const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                    )
                                  : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 34),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isCapturing ? 'กำลังวิเคราะห์ภาพ...' : 'แตะปุ่มเพื่อถ่ายภาพสแกน',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // แถบเลือกผลไม้ด่วน (Quick Fruit Select Bar)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(160),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withAlpha(40)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'หรือแตะผลไม้เพื่อจำลองการสแกนทันที:',
                          style: bodyStyle(size: 11, color: Colors.white70),
                        ),
                        const SizedBox(height: 6),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: fruits.map((fruit) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  onTap: () => _selectFruit(fruit, 0.99),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(30),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.green.withAlpha(150)),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: FruitArt(kind: fruit.kind),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          fruit.name,
                                          style: const TextStyle(
                                            color: Colors.white, 
                                            fontSize: 12, 
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
