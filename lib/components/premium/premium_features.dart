import 'package:flutter/material.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medicine.dart';

class PremiumFeatures extends StatelessWidget {
  const PremiumFeatures({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            width: 0.4,
            color: Colors.grey.shade500,
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.remove_red_eye, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(L.premiumFeatureAds),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.history, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(L.premiumFeatureHistory),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.medication, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: L.medicineRegistrationLimit,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                          ),
                          TextSpan(
                            text: '${Medicine.maxCount(hasPremiumEntitlement: false)} → ${Medicine.maxCount(hasPremiumEntitlement: true)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.schedule, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: L.notificationScheduleLimit,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                          ),
                          TextSpan(
                            text:
                                '${MedicationSchedule.maxCount(hasPremiumEntitlement: false)} → ${MedicationSchedule.maxCount(hasPremiumEntitlement: true)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: L.doseReceiverRegistrationLimit,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
                          ),
                          TextSpan(
                            text: '${DoseReceiver.maxCount(hasPremiumEntitlement: false)} → ${DoseReceiver.maxCount(hasPremiumEntitlement: true)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
