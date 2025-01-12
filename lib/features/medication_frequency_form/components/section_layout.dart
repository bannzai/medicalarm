import 'package:flutter/material.dart';
import 'package:medicalarm/components/container/flat_tile.dart';

class MedicationFrequencyFormSectionLayout extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Widget> children;

  const MedicationFrequencyFormSectionLayout({
    super.key,
    required this.icon,
    required this.text,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
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
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FlatTile(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
