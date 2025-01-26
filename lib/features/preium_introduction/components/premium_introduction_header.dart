import 'package:flutter/material.dart';

class PremiumIntroductionHeader extends StatelessWidget {
  const PremiumIntroductionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Medicalarm",
          style: TextStyle(color: Colors.black, fontFamily: "NotoSansJP", fontSize: 32, fontWeight: FontWeight.w900),
        ),
        Text(
          "プレミアムプラン",
          style: TextStyle(color: Colors.black, fontFamily: "NotoSansJP", fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
