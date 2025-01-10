import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Widget> children;

  const Section({
    super.key,
    required this.icon,
    required this.text,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: foregroundColor,
              ),
              const SizedBox(width: 8.0),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: foregroundColor,
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
