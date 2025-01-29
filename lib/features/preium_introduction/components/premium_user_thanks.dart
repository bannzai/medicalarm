import 'package:flutter/material.dart';
import 'package:medicalarm/features/localization/l.dart';

class PremiumUserThanksRow extends StatelessWidget {
  const PremiumUserThanksRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          L.premiumUserThanksTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          L.premiumUserThanksMessage,
          style: const TextStyle(
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
