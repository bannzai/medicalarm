import 'package:flutter/material.dart';
import 'package:medicalarm/style/color.dart';

class PremiumIntroductionHeader extends StatelessWidget {
  const PremiumIntroductionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Image.asset(
            "assets/premium_header.png",
            height: 140,
          ),
          const Text(
            "プレミアムプラン",
            style: TextStyle(
              color: TextColor.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
