import 'package:flutter/material.dart';

ButtonStyle get capsuleButtonStyle => TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      shape: const StadiumBorder(),
      elevation: 1,
    );

ButtonStyle get secondaryButtonStyle => ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
    );
