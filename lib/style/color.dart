import 'package:flutter/material.dart';

// Ref: https://saruwakakun.com/design/gallery/palette
abstract class AppColors {
  static const Color primary = Color(0xFFEE817B);
  static const Color secondary = Color(0xFFF6AFAA);
  static const Color background = Color(0xFFFCECEA);
  static const Color formBackground = Color(0xFFF5F5F5);
  static const Color border = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFE0E0E0);

  static const Color sunday = Color(0xFFE17F7F);
  static const Color saturday = Color(0xFF7FB9E1);
  static const Color weekday = Color(0xFF7E7E7E);
}

abstract class TextColor {
  static const Color main = AppColors.primary;
  static const Color gray = Color(0xFF928484);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color link = Colors.blueAccent;
  static const Color danger = Color(0xFFB00020);
  static const Color discount = Color(0xFFB00020);

  static Color highEmphasis(Color color) => color.withValues(alpha: 0.87);
  static Color mediumEmphasis(Color color) => color.withValues(alpha: 0.6);
  static Color disabled(Color color) => color.withValues(alpha: 0.37);
}
