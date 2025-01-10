import 'package:flutter/material.dart';
import 'package:medicalarm/style/color.dart';

class SectionTitle extends StatelessWidget {
  final IconData icon;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: TextColor.main),
              const SizedBox(width: 8.0),
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
          const SizedBox(height: 10.0),
          ...children,
        ],
      ),
    );
  }
}
