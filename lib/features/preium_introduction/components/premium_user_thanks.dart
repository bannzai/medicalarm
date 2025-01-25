import 'package:flutter/material.dart';

class PremiumUserThanksRow extends StatelessWidget {
  const PremiumUserThanksRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "あなたは\vプレミアムメンバーです",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "ご利用ありがとうございます。\nお陰様でReplAIの運営を継続できています。",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
