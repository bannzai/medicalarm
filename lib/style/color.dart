import 'package:flutter/material.dart';

// Ref: https://saruwakakun.com/design/gallery/palette
abstract class AppColors {
  static const Color primary = Color(0xFFEE817B);
  static const Color secondary = Color(0xFFF6AFAA);
  static const Color background = Color(0xFFFCECEA);
  static const Color formBackground = AppColors.background;
  static const Color border = Color(0xFFE0E0E0);
}

abstract class TextColor {
  static const Color main = AppColors.primary;
  static const Color gray = Color(0xFF928484);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color link = Colors.blueAccent;
  static const Color danger = Color(0xFFB00020);
  static const Color discount = Color(0xFFB00020);

  static Color highEmphasis(Color color) => color.withOpacity(0.87);
  static Color mediumEmphasis(Color color) => color.withOpacity(0.6);
  static Color disabled(Color color) => color.withOpacity(0.37);
}
