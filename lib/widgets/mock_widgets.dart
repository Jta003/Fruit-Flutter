import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants.dart';

class StatusBarMock extends StatelessWidget {
  const StatusBarMock({super.key, this.isLight = false});

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 12);
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isGlass = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isGlass;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: isGlass ? 16 : 0, sigmaY: isGlass ? 16 : 0),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isGlass ? Colors.white.withAlpha(61) : Colors.white, // 0.24 * 255 = 61
              shape: BoxShape.circle,
              boxShadow: isGlass ? null : softShadow(),
            ),
            child: Icon(
              icon,
              color: isGlass ? Colors.white : AppColors.text,
              size: 19,
            ),
          ),
        ),
      ),
    );
  }
}

class GlassDetectionPill extends StatelessWidget {
  const GlassDetectionPill({
    super.key, 
    required this.onTap,
    this.label = "กำลังค้นหาผลไม้...",
    this.confidence = 0,
  });

  final VoidCallback onTap;
  final String label;
  final double confidence;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(61), // 0.24 * 255 = 61
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withAlpha(87)), // 0.34 * 255 = 87
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: confidence > 0.7 ? const Color(0xFF91E36A) : Colors.white.withAlpha(128),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  confidence > 0 
                    ? '$label ตรวจพบ ${(confidence * 100).toStringAsFixed(0)}%'
                    : label,
                  style: titleStyle(size: 15, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CameraPreviewMock extends StatelessWidget {
  const CameraPreviewMock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF203328), Color(0xFF7AA05B), Color(0xFFFFC15F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          for (var i = 0; i < 9; i++)
            Positioned(
              left: (20 + i * 43) % 335,
              top: 100 + (i * 79) % 495,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 80 + (i % 3) * 28,
                  height: 80 + (i % 2) * 20,
                  decoration: BoxDecoration(
                    color: [
                      AppColors.red,
                      AppColors.orange,
                      const Color(0xFF8FCB55),
                    ][i % 3].withAlpha(97), // 0.38 * 255 = 97
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          Container(color: Colors.black.withAlpha(36)), // 0.14 * 255 = 36
        ],
      ),
    );
  }
}
