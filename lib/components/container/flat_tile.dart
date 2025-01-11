import 'package:flutter/material.dart';
import 'package:medicalarm/style/color.dart';

class FlatTile extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const FlatTile({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final padding = this.padding ?? const EdgeInsets.symmetric(vertical: 6.0);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
