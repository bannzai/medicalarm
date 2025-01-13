import 'package:flutter/material.dart';

class AutoFitText extends StatelessWidget {
  final String text;
  final double? width;
  final AlignmentGeometry? alignment;
  final TextAlign? textAlign;
  final TextStyle? style;

  // ignore: use_super_parameters
  const AutoFitText({
    super.key,
    required this.text,
    this.width,
    this.alignment,
    this.textAlign,
    this.style,
  });

  @override
  Widget build(Object context) {
    return Container(
      width: width,
      alignment: alignment,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, textAlign: textAlign, style: style),
      ),
    );
  }
}
