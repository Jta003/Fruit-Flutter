import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants.dart';

class ScoreRingPainter extends CustomPainter {
  ScoreRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bg = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.green, Color(0xFFA8DC5E)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(5), -math.pi / 2, math.pi * 2, false, bg);
    canvas.drawArc(rect.deflate(5), -math.pi / 2, math.pi * 2 * progress, false, fg);
  }

  @override
  bool shouldRepaint(covariant ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class FocusRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(184) // 0.72 * 255 = 184
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final rect = Offset.zero & size;
    const gap = math.pi / 8;
    for (var i = 0; i < 4; i++) {
      canvas.drawArc(rect.deflate(4), i * math.pi / 2 + gap, math.pi / 2 - gap * 2, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
