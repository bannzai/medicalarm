import 'package:flutter/material.dart';

class FormTheme extends StatelessWidget {
  final Widget child;
  const FormTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: primaryColor),
          elevation: 1,
        ),
      ),
      child: child,
    );
  }
}
