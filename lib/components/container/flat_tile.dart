import 'package:flutter/material.dart';
import 'package:medicalarm/style/color.dart';

class FlatTile extends StatelessWidget {
  final Widget child;
  const FlatTile({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
