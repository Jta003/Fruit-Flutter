import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF6F8F3);
  static const green = Color(0xFF2F9E6D);
  static const greenDark = Color(0xFF156C47);
  static const lime = Color(0xFFE8F6D6);
  static const card = Color(0xFFFFFFFF);
  static const text = Color(0xFF17211C);
  static const muted = Color(0xFF78827B);
  static const border = Color(0xFFE5ECE4);
  static const orange = Color(0xFFFFB23E);
  static const red = Color(0xFFE34D4D);
}

TextStyle titleStyle({
  double size = 16,
  Color color = AppColors.text,
  double height = 1.1,
}) {
  return TextStyle(
    fontSize: size,
    height: height,
    fontWeight: FontWeight.w800,
    color: color,
    letterSpacing: 0,
  );
}

TextStyle bodyStyle({
  double size = 14,
  Color color = AppColors.text,
  double height = 1.2,
}) {
  return TextStyle(
    fontSize: size,
    height: height,
    fontWeight: FontWeight.w500,
    color: color,
    letterSpacing: 0,
  );
}

BoxDecoration premiumCardDecoration({double radius = 28}) {
  return BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.white.withAlpha(204)), // 0.8 * 255 = 204
    boxShadow: softShadow(),
  );
}

List<BoxShadow> softShadow() {
  return [
    BoxShadow(
      color: const Color(0xFF38543C).withAlpha(20), // 0.08 * 255 = 20
      blurRadius: 26,
      offset: const Offset(0, 14),
    ),
  ];
}

String formatNumber(num value) {
  if (value is int || value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}
