import 'package:flutter/material.dart';

class MedicineFormSectionLayout extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Widget> children;

  const MedicineFormSectionLayout({
    super.key,
    required this.icon,
    required this.text,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                // 文字を拡大して見出しが行に収まらない時に、はみ出さず単語の境目で折り返すため Flexible で行の残りの幅に収める (#474)
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: foregroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}
