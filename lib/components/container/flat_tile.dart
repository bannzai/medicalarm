import 'package:flutter/material.dart';
import 'package:medicalarm/style/color.dart';

/// 白背景・角丸・枠線のタイル。フォームの ListTile 系の行を囲むのに使う。
/// Flutter 3.44 から、背景色を持つ Container で ListTile を囲むと debug 時に
/// 「ListTile background color or ink splashes may be invisible」の assertion になるため、
/// 背景と枠線を Material の shape で描き、ListTile の ink をこの Material に載せる (#370)
class FlatTile extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const FlatTile({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 6.0),
        child: child,
      ),
    );
  }
}
