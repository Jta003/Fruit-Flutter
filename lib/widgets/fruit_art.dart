import 'package:flutter/material.dart';
import '../models/fruit.dart';

class FruitArt extends StatelessWidget {
  const FruitArt({super.key, required this.kind});

  final FruitKind kind;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: FruitPainter(kind));
  }
}

class FruitPainter extends CustomPainter {
  FruitPainter(this.kind);

  final FruitKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    final w = size.width;
    final h = size.height;
    canvas.save();
    canvas.translate(w * .06, h * .08);
    canvas.scale(.88, .88);

    switch (kind) {
      case FruitKind.apple:
        _apple(canvas, Size(w, h), paint);
      case FruitKind.banana:
        _banana(canvas, Size(w, h), paint);
      case FruitKind.orange:
        _orange(canvas, Size(w, h), paint);
      case FruitKind.mango:
        _mango(canvas, Size(w, h), paint);
      case FruitKind.grapes:
        _grapes(canvas, Size(w, h), paint);
      case FruitKind.strawberry:
        _strawberry(canvas, Size(w, h), paint);
      case FruitKind.kiwi:
        _kiwi(canvas, Size(w, h), paint);
      case FruitKind.chickoo:
        _chickoo(canvas, Size(w, h), paint);
      case FruitKind.cherry:
        _cherry(canvas, Size(w, h), paint);
    }

    canvas.restore();
  }

  void _apple(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    paint.shader = const LinearGradient(
      colors: [Color(0xFFFF6F61), Color(0xFFD82E2F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawOval(Rect.fromLTWH(w * .17, h * .28, w * .66, h * .58), paint);
    paint.shader = null;
    paint.color = const Color(0xFF7B4A24);
    paint.strokeWidth = w * .08;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * .52, h * .28), Offset(w * .58, h * .08), paint);
    paint.color = const Color(0xFF46A852);
    canvas.drawOval(Rect.fromLTWH(w * .58, h * .1, w * .26, h * .16), paint);
    paint.color = Colors.white.withAlpha(82); // 0.32 * 255 = 82
    canvas.drawOval(Rect.fromLTWH(w * .28, h * .38, w * .16, h * .18), paint);
  }

  void _banana(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    paint
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = w * .24
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFE36E), Color(0xFFF2A51B)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final path = Path()
      ..moveTo(w * .2, h * .36)
      ..quadraticBezierTo(w * .55, h * .9, w * .88, h * .28);
    canvas.drawPath(path, paint);
    paint
      ..style = PaintingStyle.fill
      ..shader = null
      ..color = const Color(0xFF7B4A24);
    canvas.drawCircle(Offset(w * .21, h * .36), w * .055, paint);
    canvas.drawCircle(Offset(w * .88, h * .28), w * .055, paint);
  }

  void _orange(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    paint.shader = const RadialGradient(
      colors: [Color(0xFFFFC55B), Color(0xFFFF8A1E)],
      center: Alignment.topLeft,
      radius: 1.1,
    ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawCircle(Offset(w * .5, h * .56), w * .34, paint);
    paint.shader = null;
    paint.color = const Color(0xFF4CA64A);
    canvas.drawOval(Rect.fromLTWH(w * .52, h * .18, w * .24, h * .14), paint);
    paint.color = Colors.white.withAlpha(61); // 0.24 * 255 = 61
    canvas.drawCircle(Offset(w * .38, h * .44), w * .08, paint);
  }

  void _mango(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    paint.shader = const LinearGradient(
      colors: [Color(0xFFFFD15C), Color(0xFFFF8D2A), Color(0xFFD84F45)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, w, h));
    final path = Path()
      ..moveTo(w * .32, h * .18)
      ..cubicTo(w * .82, h * .08, w * .92, h * .58, w * .6, h * .82)
      ..cubicTo(w * .18, h * 1.02, w * .04, h * .42, w * .32, h * .18);
    canvas.drawPath(path, paint);
    paint.shader = null;
    paint.color = const Color(0xFF55A64D);
    canvas.drawOval(Rect.fromLTWH(w * .42, h * .12, w * .22, h * .12), paint);
    paint.color = Colors.white.withAlpha(61); // 0.24 * 255 = 61
    canvas.drawOval(Rect.fromLTWH(w * .35, h * .34, w * .14, h * .22), paint);
  }

  void _grapes(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    paint.color = const Color(0xFF6A4E91);
    canvas.drawCircle(Offset(w * .4, h * .3), w * .15, paint);
    canvas.drawCircle(Offset(w * .6, h * .3), w * .15, paint);
    canvas.drawCircle(Offset(w * .5, h * .45), w * .15, paint);
    canvas.drawCircle(Offset(w * .35, h * .55), w * .15, paint);
    canvas.drawCircle(Offset(w * .65, h * .55), w * .15, paint);
    canvas.drawCircle(Offset(w * .5, h * .7), w * .15, paint);
    
    paint.color = const Color(0xFF55A64D);
    canvas.drawRect(Rect.fromLTWH(w * .45, h * .1, w * .1, h * .2), paint);
  }

  void _strawberry(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    paint.color = const Color(0xFFE34D4D);
    final path = Path()
      ..moveTo(w * .5, h * .9)
      ..cubicTo(w * .1, h * .7, w * .1, h * .2, w * .5, h * .2)
      ..cubicTo(w * .9, h * .2, w * .9, h * .7, w * .5, h * .9);
    canvas.drawPath(path, paint);
    
    paint.color = Colors.white.withAlpha(153); // 0.6 * 255 = 153
    canvas.drawCircle(Offset(w * .4, h * .4), 2, paint);
    canvas.drawCircle(Offset(w * .6, h * .4), 2, paint);
    canvas.drawCircle(Offset(w * .5, h * .55), 2, paint);
    canvas.drawCircle(Offset(w * .35, h * .7), 2, paint);
    canvas.drawCircle(Offset(w * .65, h * .7), 2, paint);
    
    paint.color = const Color(0xFF55A64D);
    canvas.drawOval(Rect.fromLTWH(w * .3, h * .15, w * .4, h * .15), paint);
  }

  void _kiwi(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    // Brown skin
    paint.color = const Color(0xFF8B5A2B);
    canvas.drawCircle(Offset(w * .5, h * .52), w * .38, paint);
    // Green flesh
    paint.color = const Color(0xFF8EE000);
    canvas.drawCircle(Offset(w * .5, h * .52), w * .32, paint);
    // Cream center
    paint.color = const Color(0xFFE8F5B5);
    canvas.drawCircle(Offset(w * .5, h * .52), w * .14, paint);
    // Black seeds
    paint.color = const Color(0xFF222222);
    for (int i = 0; i < 8; i++) {
      final double angle = i * 3.14159 / 4;
      final double r = w * .22;
      canvas.drawCircle(
        Offset(w * .5 + r * 0.9 * (i % 2 == 0 ? 1 : 0.8) * (i == 0 || i == 4 ? 1 : (i == 2 || i == 6 ? 0 : 0.7)),
               h * .52 + r * 0.9 * (i % 2 == 0 ? 1 : 0.8) * (i == 2 || i == 6 ? 1 : (i == 0 || i == 4 ? 0 : 0.7))),
        1.8,
        paint,
      );
    }
  }

  void _chickoo(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    paint.shader = const LinearGradient(
      colors: [Color(0xFFB07D4F), Color(0xFF7A4A21)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawOval(Rect.fromLTWH(w * .2, h * .25, w * .6, h * .56), paint);
    paint.shader = null;
    paint.color = const Color(0xFF553010);
    canvas.drawCircle(Offset(w * .5, h * .24), w * .04, paint);
    paint.color = Colors.white.withAlpha(50);
    canvas.drawOval(Rect.fromLTWH(w * .3, h * .36, w * .18, h * .2), paint);
  }

  void _cherry(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    // Green stems
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * .04
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF46A852);
    final stem1 = Path()
      ..moveTo(w * .36, h * .6)
      ..quadraticBezierTo(w * .42, h * .28, w * .6, h * .15);
    final stem2 = Path()
      ..moveTo(w * .68, h * .62)
      ..quadraticBezierTo(w * .56, h * .28, w * .6, h * .15);
    canvas.drawPath(stem1, paint);
    canvas.drawPath(stem2, paint);

    // Green leaf
    paint.style = PaintingStyle.fill;
    canvas.drawOval(Rect.fromLTWH(w * .56, h * .1, w * .24, h * .12), paint);

    // Cherries
    paint.shader = const RadialGradient(
      colors: [Color(0xFFFF3344), Color(0xFF880015)],
      center: Alignment.topLeft,
      radius: 0.9,
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawCircle(Offset(w * .36, h * .68), w * .22, paint);
    canvas.drawCircle(Offset(w * .68, h * .7), w * .22, paint);
    paint.shader = null;

    // Highlights
    paint.color = Colors.white.withAlpha(160);
    canvas.drawCircle(Offset(w * .3, h * .62), w * .05, paint);
    canvas.drawCircle(Offset(w * .62, h * .64), w * .05, paint);
  }

  @override
  bool shouldRepaint(covariant FruitPainter oldDelegate) => oldDelegate.kind != kind;
}
