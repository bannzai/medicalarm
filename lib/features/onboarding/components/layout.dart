import 'package:flutter/material.dart';

/// オンボーディング各画面の共通レイアウト。本文はスクロール可能にし、主ボタンは下部に固定する
class OnboardingStepLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? bottom;

  const OnboardingStepLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bottom = this.bottom;
    final subtitle = this.subtitle;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor, height: 1.4),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ),
          if (bottom != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
              child: bottom,
            ),
          ],
        ],
      ),
    );
  }
}

/// 白背景の角丸カード。各画面の本文ブロックに使う
class OnboardingCard extends StatelessWidget {
  final Widget child;

  const OnboardingCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// アイコン付きの 1 行。特徴の列挙や Before / After の項目に使う
class OnboardingIconRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const OnboardingIconRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 15, height: 1.4)),
        ),
      ],
    );
  }
}
