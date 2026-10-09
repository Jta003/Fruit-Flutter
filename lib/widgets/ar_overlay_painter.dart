import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants.dart';

/// วาดกรอบ AR scanner สี่มุม + เส้น scan ที่เคลื่อนที่ลงมา
class ArScanFramePainter extends CustomPainter {
  ArScanFramePainter({
    required this.scanProgress,
    required this.isDetected,
    this.pulseValue = 0.0,
  });

  final double scanProgress; // 0.0 - 1.0 ตำแหน่งเส้น scan
  final bool isDetected;
  final double pulseValue; // 0.0 - 1.0 สำหรับ pulse เมื่อตรวจพบ

  @override
  void paint(Canvas canvas, Size size) {
    final cornerColor = isDetected ? AppColors.green : Colors.white;
    final cornerLength = size.width * 0.12;

    final cornerPaint = Paint()
      ..color = cornerColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // มุมบนซ้าย
    canvas.drawLine(Offset(0, cornerLength), Offset.zero, cornerPaint);
    canvas.drawLine(Offset.zero, Offset(cornerLength, 0), cornerPaint);
    // มุมบนขวา
    canvas.drawLine(Offset(size.width - cornerLength, 0), Offset(size.width, 0), cornerPaint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), cornerPaint);
    // มุมล่างซ้าย
    canvas.drawLine(Offset(0, size.height - cornerLength), Offset(0, size.height), cornerPaint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), cornerPaint);
    // มุมล่างขวา
    canvas.drawLine(Offset(size.width - cornerLength, size.height), Offset(size.width, size.height), cornerPaint);
    canvas.drawLine(Offset(size.width, size.height - cornerLength), Offset(size.width, size.height), cornerPaint);

    if (!isDetected) {
      // เส้น scan สีเขียวไล่สี
      final scanY = size.height * scanProgress;
      final scanPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.green.withAlpha(0),
            AppColors.green.withAlpha(180),
            AppColors.green.withAlpha(240),
            AppColors.green.withAlpha(180),
            AppColors.green.withAlpha(0),
          ],
          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
        ).createShader(Rect.fromLTWH(0, scanY - 20, size.width, 40))
        ..style = PaintingStyle.fill;

      canvas.drawRect(Rect.fromLTWH(0, scanY - 18, size.width, 36), scanPaint);

      // เส้นหลัก scan line
      final linePaint = Paint()
        ..color = AppColors.green.withAlpha(220)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(0, scanY), Offset(size.width, scanY), linePaint);
    } else {
      // Pulse glow เมื่อตรวจพบ
      final glowAlpha = (math.sin(pulseValue * math.pi * 2) * 0.5 + 0.5);
      final glowPaint = Paint()
        ..color = AppColors.green.withAlpha((glowAlpha * 100).toInt())
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      const inset = 6.0;
      canvas.drawRect(
        Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2),
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ArScanFramePainter old) =>
      old.scanProgress != scanProgress ||
      old.isDetected != isDetected ||
      old.pulseValue != pulseValue;
}

/// วาดเส้นเชื่อมจากกรอบผลไม้ไปยัง Info Card (AR connector line)
class ArConnectorPainter extends CustomPainter {
  ArConnectorPainter({
    required this.start,
    required this.end,
    required this.color,
    this.alpha = 200,
  });

  final Offset start;
  final Offset end;
  final Color color;
  final int alpha;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(alpha)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(start.dx, start.dy);
    final mid = Offset((start.dx + end.dx) / 2, start.dy);
    path.quadraticBezierTo(mid.dx, mid.dy, end.dx, end.dy);
    canvas.drawPath(path, paint);

    // จุดกลมที่ปลายเส้น
    canvas.drawCircle(start, 4, Paint()..color = color.withAlpha(alpha));
    canvas.drawCircle(end, 3, Paint()..color = color.withAlpha(alpha));
  }

  @override
  bool shouldRepaint(covariant ArConnectorPainter old) =>
      old.start != start || old.end != end || old.alpha != alpha;
}
