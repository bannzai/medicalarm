import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';

class MedicineScheduleDeleteButton extends StatelessWidget {
  const MedicineScheduleDeleteButton({
    super.key,
    required this.schedules,
    required this.schedule,
  });

  final ValueNotifier<List<MedicationSchedule>> schedules;
  final MedicationSchedule schedule;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        schedules.value = schedules.value.where((element) => element != schedule).toList();
      },
      icon: const Icon(Icons.delete),
    );
  }
}
