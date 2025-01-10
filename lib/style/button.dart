import 'package:flutter/material.dart';
import 'package:medicalarm/style/color.dart';

ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      side: const BorderSide(),
    );

ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

ButtonStyle get textButtonStyle => TextButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: TextColor.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      minimumSize: const Size(double.infinity, 48.0),
    );
