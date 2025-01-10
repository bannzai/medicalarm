import 'package:flutter/material.dart';
import 'package:medicalarm/style/color.dart';

class SectionTitle extends StatelessWidget {
  final Widget icon;
  final String text;
  final List<Widget> children;

  const SectionTitle({
    super.key,
    required this.icon,
    required this.text,
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.main,
              ),
            ),
          ],
        ),
        ...children,
      ],
    );
  }
}
