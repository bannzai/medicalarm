import 'package:flutter/material.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/features/localization/l.dart';

class PremiumIntroduction extends StatelessWidget {
  const PremiumIntroduction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        analytics.logEvent(name: 'tapped_premium_introduction_row');
        showPremiumIntroductionSheet(context);
      },
      title: Row(
        children: [
          Text(L.viewPremiumPlan,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
              )),
        ],
      ),
    );
  }
}
