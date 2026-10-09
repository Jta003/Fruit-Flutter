import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/fruit.dart';
import '../providers/fruit_provider.dart';
import '../widgets/fruit_art.dart';
import '../widgets/ar_overlay_painter.dart';
import '../widgets/mock_widgets.dart';
import '../core/detection_helper.dart';

class ArScanScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final VoidCallback onClose;
  final ValueChanged<Fruit> onDetected;

  const ArScanScreen({
    super.key,
    required this.cameras,
    required this.onClose,
    required this.onDetected,
  });

  @override
  State<ArScanScreen> createState() => _ArScanScreenState();
}

class _ArScanScreenState extends State<ArScanScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  final DetectionHelper _detectionHelper = DetectionHelper();

  bool _isDetected = false;
  bool _isCapturing = false;
  String _statusText = 'จัดผลไม้ให้อยู่ในกรอบสีเขียว';
  Fruit? _detectedFruit;
  double _confidence = 0.0;

  // Animations
  late AnimationController _scanLineController;
  late AnimationController _pulseController;
  late AnimationController _cardSlideController;
  late AnimationController _infoFadeController;

  late Animation<double> _scanLineAnim;
  late Animation<double> _pulseAnim;
  late Animation<Offset> _cardSlideAnim;
  late Animation<double> _infoFadeAnim;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initializeCamera();
  }

  void _initAnimations() {
    // เส้น scan เคลื่อนลง loop
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );

    // Pulse glow เมื่อตรวจพบ
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_pulseController);

    // Card slide up จากล่าง
    _cardSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardSlideAnim = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardSlideController, curve: Curves.elasticOut));

    // Fade in ข้อมูลโภชนาการ
    _infoFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _infoFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _infoFadeController, curve: Curves.easeOut),
    );
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) {
      setState(() => _statusText = 'ไม่พบกล้องในเครื่อง');
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
        setState(() => _statusText = 'จัดผลไม้ให้อยู่ในกรอบสีเขียว');
      }
    } catch (e) {
      if (mounted) setState(() => _statusText = 'เกิดข้อผิดพลาด: $e');
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
    if ((aiLabel.contains('chickoo') || aiLabel.contains('chiku') || aiLabel.contains('sapodilla')) &&
        kindName.contains('chickoo')) return true;
    if (aiLabel.contains('cherr') && kindName.contains('cherr')) return true;
    return false;
  }

  Fruit? _findFruitMatch(String label, int index, List<Fruit> fruits) {
    try {
      return fruits.firstWhere(
        (f) => _isSameFruitType(label, f.kind.name) || _isSameFruitType(label, f.name),
      );
    } catch (_) {}
    if (index >= 0 && index < fruits.length) return fruits[index];
    return null;
  }

  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing || _isDetected) return;

    setState(() {
      _isCapturing = true;
      _statusText = 'AI กำลังวิเคราะห์...';
    });

    try {
      final xFile = await _controller!.takePicture();
      final result = await _detectionHelper.classifyImagePath(xFile.path);

      if (result != null && mounted) {
        final fruits = context.read<FruitProvider>().fruits;
        final matchedFruit = _findFruitMatch(result.label, result.index, fruits);
        if (matchedFruit != null) {
          await _showArResult(matchedFruit, result.confidence);
          return;
        }
      }

      if (mounted) {
        setState(() {
          _statusText = 'ไม่พบผลไม้ กรุณาลองใหม่';
          _isCapturing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusText = 'เกิดข้อผิดพลาด กรุณาลองใหม่';
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _showArResult(Fruit fruit, double confidence) async {
    if (_isDetected) return;

    _scanLineController.stop();

    setState(() {
      _isDetected = true;
      _isCapturing = false;
      _detectedFruit = fruit;
      _confidence = confidence;
      _statusText = 'ตรวจพบ: ${fruit.name}';
    });

    _pulseController.repeat();
    await _cardSlideController.forward();
    await _infoFadeController.forward();
  }

  Future<void> _quickSelect(Fruit fruit) async {
    if (_isDetected) return;
    await _showArResult(fruit, 0.99);
  }

  void _resetScan() {
    _scanLineController.repeat();
    _pulseController.stop();
    _cardSlideController.reset();
    _infoFadeController.reset();

    setState(() {
      _isDetected = false;
      _isCapturing = false;
      _detectedFruit = null;
      _confidence = 0.0;
      _statusText = 'จัดผลไม้ให้อยู่ในกรอบสีเขียว';
    });
  }

  void _confirmAndNavigate() {
    if (_detectedFruit == null) return;
    widget.onDetected(_detectedFruit!);
    _resetScan();
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _pulseController.dispose();
    _cardSlideController.dispose();
    _infoFadeController.dispose();
    _controller?.dispose();
    _detectionHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fruits = context.watch<FruitProvider>().fruits;
    final size = MediaQuery.of(context).size;

    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.green),
              const SizedBox(height: 16),
              Text(_statusText,
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: Camera Preview เต็มจอ
          CameraPreview(_controller!),

          // Layer 2: มืดด้านข้างของกรอบสแกน (vignette)
          _buildVignette(size),

          // Layer 3: AR Frame + scan line บริเวณกลางจอ
          _buildArFrame(size),

          // Layer 4: UI controls บนสุด
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                if (!_isDetected) _buildBottomControls(fruits),
                if (_isDetected && _detectedFruit != null)
                  _buildArInfoCard(_detectedFruit!),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Layer มืดรอบกรอบ scan เพื่อให้ดูเหมือน AR
  Widget _buildVignette(Size size) {
    final frameSize = size.width * 0.7;
    final frameTop = size.height * 0.28;
    final frameLeft = (size.width - frameSize) / 2;

    return Stack(
      children: [
        // ด้านบน
        Positioned(
          top: 0, left: 0, right: 0,
          height: frameTop,
          child: Container(color: Colors.black.withAlpha(140)),
        ),
        // ด้านล่าง
        Positioned(
          top: frameTop + frameSize, left: 0, right: 0, bottom: 0,
          child: Container(color: Colors.black.withAlpha(140)),
        ),
        // ด้านซ้าย
        Positioned(
          top: frameTop, left: 0,
          width: frameLeft,
          height: frameSize,
          child: Container(color: Colors.black.withAlpha(140)),
        ),
        // ด้านขวา
        Positioned(
          top: frameTop, right: 0,
          width: frameLeft,
          height: frameSize,
          child: Container(color: Colors.black.withAlpha(140)),
        ),
      ],
    );
  }

  /// กรอบ AR + scan line animation
  Widget _buildArFrame(Size size) {
    final frameSize = size.width * 0.7;
    final frameTop = size.height * 0.28;
    final frameLeft = (size.width - frameSize) / 2;

    return Positioned(
      top: frameTop,
      left: frameLeft,
      width: frameSize,
      height: frameSize,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scanLineAnim, _pulseAnim]),
        builder: (context, _) {
          return CustomPaint(
            painter: ArScanFramePainter(
              scanProgress: _scanLineAnim.value,
              isDetected: _isDetected,
              pulseValue: _pulseAnim.value,
            ),
          );
        },
      ),
    );
  }

  /// Top bar: ปิด + ชื่อ + flash + status
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ปุ่มปิด
              _glassButton(
                icon: Icons.close_rounded,
                onTap: widget.onClose,
              ),
              // ชื่อโหมด
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(160),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.green.withAlpha(180), width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'AR Nutrition Scanner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              // ปุ่ม flash
              _glassButton(
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
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Status bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _isDetected
                  ? AppColors.green.withAlpha(200)
                  : Colors.black.withAlpha(170),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isDetected ? AppColors.green : Colors.white.withAlpha(60),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isCapturing
                      ? Icons.hourglass_top_rounded
                      : _isDetected
                          ? Icons.check_circle_rounded
                          : Icons.document_scanner_rounded,
                  size: 15,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  _statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ปุ่มกระจก (glassmorphism circle button)
  Widget _glassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withAlpha(130),
          border: Border.all(color: Colors.white.withAlpha(70)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  /// ปุ่มถ่ายภาพ + Quick Select bar
  Widget _buildBottomControls(List<Fruit> fruits) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ปุ่มถ่ายหลัก
        GestureDetector(
          onTap: _captureAndAnalyze,
          child: Container(
            width: 80, height: 80,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isCapturing ? Colors.grey.shade600 : AppColors.green,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.green.withAlpha(160),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Center(
                child: _isCapturing
                    ? const SizedBox(
                        width: 30, height: 30,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 36),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isCapturing ? 'AI กำลังวิเคราะห์...' : 'แตะถ่ายภาพเพื่อสแกน AR',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            shadows: [Shadow(color: Colors.black, blurRadius: 8)],
          ),
        ),
        const SizedBox(height: 14),
        // Quick Select bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(170),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withAlpha(35)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'หรือเลือกผลไม้เพื่อดู AR ทันที:',
                style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 11),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: fruits.map((fruit) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => _quickSelect(fruit),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.green.withAlpha(160)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 22, height: 22,
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
      ],
    );
  }

  /// AR Info Card ที่ slide ขึ้นมาพร้อมข้อมูลโภชนาการ (Dark Glassmorphism)
  Widget _buildArInfoCard(Fruit fruit) {
    return SlideTransition(
      position: _cardSlideAnim,
      child: FadeTransition(
        opacity: _infoFadeAnim,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(200),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.green.withAlpha(180),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.green.withAlpha(60),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header ของ card
                _buildCardHeader(fruit),
                // ตารางข้อมูลโภชนาการ
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: FadeTransition(
                    opacity: _infoFadeAnim,
                    child: Column(
                      children: [
                        // Row 1: kcal + sugar
                        Row(
                          children: [
                            Expanded(child: _nutriStat(Icons.local_fire_department_rounded, 'แคลอรี', '${fruit.kcal.toStringAsFixed(0)} kcal', const Color(0xFFFF6B3D))),
                            const SizedBox(width: 10),
                            Expanded(child: _nutriStat(Icons.water_drop_rounded, 'น้ำตาล', '${fruit.sugar.toStringAsFixed(1)} g', const Color(0xFFFFB23E))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Row 2: carbs + protein
                        Row(
                          children: [
                            Expanded(child: _nutriStat(Icons.grain_rounded, 'คาร์โบไฮเดรต', '${fruit.carbs.toStringAsFixed(1)} g', const Color(0xFF8B9FF4))),
                            const SizedBox(width: 10),
                            Expanded(child: _nutriStat(Icons.fitness_center_rounded, 'โปรตีน', '${fruit.protein.toStringAsFixed(1)} g', const Color(0xFF4FC3F7))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Row 3: fat + vitamin C
                        Row(
                          children: [
                            Expanded(child: _nutriStat(Icons.opacity_rounded, 'ไขมัน', '${fruit.fat.toStringAsFixed(1)} g', const Color(0xFFE28EFF))),
                            const SizedBox(width: 10),
                            Expanded(child: _nutriStat(Icons.shield_rounded, 'วิตามิน C', '${fruit.vitaminC.toStringAsFixed(1)} mg', const Color(0xFF69F0AE))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Row 4: fiber + health score
                        Row(
                          children: [
                            Expanded(child: _nutriStat(Icons.grass_rounded, 'ไฟเบอร์', '${fruit.fiber.toStringAsFixed(1)} g', const Color(0xFF80CBC4))),
                            const SizedBox(width: 10),
                            Expanded(child: _healthScoreStat(fruit.score)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // ปุ่มดูรายละเอียด + สแกนใหม่
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _resetScan,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(20),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white.withAlpha(60)),
                                  ),
                                  child: const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.refresh_rounded, color: Colors.white70, size: 16),
                                        SizedBox(width: 6),
                                        Text('สแกนใหม่', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: _confirmAndNavigate,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.green, Color(0xFF5CBF7A)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.green.withAlpha(120),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.open_in_new_rounded, color: Colors.white, size: 16),
                                        SizedBox(width: 6),
                                        Text('ดูรายละเอียดเต็ม', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(Fruit fruit) {
    final confidencePct = (_confidence * 100).toStringAsFixed(0);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.green.withAlpha(80), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(bottom: BorderSide(color: AppColors.green.withAlpha(80))),
      ),
      child: Row(
        children: [
          // ไอคอนผลไม้
          Container(
            width: 52, height: 52,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.green.withAlpha(120)),
            ),
            child: FruitArt(kind: fruit.kind),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        fruit.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.green.withAlpha(60),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.green.withAlpha(120)),
                      ),
                      child: Text(
                        'AR',
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  fruit.scientificName,
                  style: TextStyle(
                    color: Colors.white.withAlpha(140),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 12, color: AppColors.green.withAlpha(200)),
                    const SizedBox(width: 4),
                    Text(
                      'AI ยืนยัน $confidencePct%  •  ${fruit.servingSize}',
                      style: TextStyle(
                        color: Colors.white.withAlpha(170),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// กล่องข้อมูลโภชนาการแต่ละชนิด
  Widget _nutriStat(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 10)),
                Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Health Score แบบ Ring Indicator
  Widget _healthScoreStat(int score) {
    final scoreColor = score >= 85
        ? const Color(0xFF69F0AE)
        : score >= 70
            ? const Color(0xFFFFD740)
            : const Color(0xFFFF6E6E);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scoreColor.withAlpha(18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scoreColor.withAlpha(60)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28, height: 28,
            child: CustomPaint(
              painter: _MiniScoreRing(score / 100, scoreColor),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Health Score', style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 10)),
                Text('$score/100', style: TextStyle(color: scoreColor, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mini Score Ring สำหรับแสดงใน AR Card
class _MiniScoreRing extends CustomPainter {
  _MiniScoreRing(this.progress, this.color);
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = Colors.white.withAlpha(30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    final rect = Offset.zero & size;
    canvas.drawArc(rect.deflate(2), -math.pi / 2, math.pi * 2, false, bg);
    canvas.drawArc(rect.deflate(2), -math.pi / 2, math.pi * 2 * progress, false, fg);
  }

  @override
  bool shouldRepaint(covariant _MiniScoreRing old) => old.progress != progress;
}
