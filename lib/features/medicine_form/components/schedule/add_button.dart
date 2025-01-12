import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/style/button.dart';

class MedicineScheduleAddButton extends StatelessWidget {
  const MedicineScheduleAddButton({
    super.key,
    required this.schedules,
  });

  final ValueNotifier<List<MedicationSchedule>> schedules;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        schedules.value = [
          ...schedules.value,
          const MedicationSchedule(
            hour: 10,
            minute: 00,
            memo: '',
          ),
        ];
      },
      icon: const Icon(Icons.add),
      label: const Text('服用時刻を追加', style: TextStyle(fontWeight: FontWeight.bold)),
      style: secondaryButtonStyle.merge(capsuleButtonStyle),
    );
  }
}
