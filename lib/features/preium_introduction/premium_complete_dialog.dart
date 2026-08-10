import 'package:flutter/material.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class PremiumCompleteDialog extends StatelessWidget {
  final VoidCallback onClose;

  const PremiumCompleteDialog({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L.premiumRegistrationComplete,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            L.premiumRegistrationThanks,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                analytics.logEvent(name: 'premium_complete_close_pressed');
                Navigator.of(context).pop();
                onClose();
              },
              child: Text(L.ok),
            ),
          ),
        ],
      ),
    );
  }
}
