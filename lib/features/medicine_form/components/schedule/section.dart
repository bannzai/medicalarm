import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/add_button.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/delete_button.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/label.dart';

class MedicineScheduleSection extends StatelessWidget {
  final ValueNotifier<List<MedicationSchedule>> schedules;
  const MedicineScheduleSection({super.key, required this.schedules});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (index, schedule) in schedules.value.indexed) ...[
          Row(
            children: [
              MedicineScheduleReminderTime(
                schedule: schedule,
                schedules: schedules,
                index: index,
              ),
              MedicineScheduleDeleteButton(schedule: schedule, schedules: schedules),
            ],
          ),
          const SizedBox(height: 6),
        ],
        const SizedBox(height: 10),
        MedicineScheduleAddButton(schedules: schedules),
      ],
    );
  }
}
