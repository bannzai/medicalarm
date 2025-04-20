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
                  const Icon(Icons.remove_red_eye),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(L.premiumFeatureAds),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.history),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(L.premiumFeatureHistory),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.medication),
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
                            text: '${Medicine.maxCount(isPremium: false)} → ${Medicine.maxCount(isPremium: true)}',
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
                  const Icon(Icons.schedule),
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
                            text: '${MedicationSchedule.maxCount(isPremium: false)} → ${MedicationSchedule.maxCount(isPremium: true)}',
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
                  const Icon(Icons.person),
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
                            text: '${DoseReceiver.maxCount(isPremium: false)} → ${DoseReceiver.maxCount(isPremium: true)}',
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
