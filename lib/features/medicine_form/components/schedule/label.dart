import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/style/color.dart';

class MedicineScheduleReminderTime extends StatelessWidget {
  const MedicineScheduleReminderTime({
    super.key,
    required this.schedule,
    required this.schedules,
    required this.index,
  });

  final MedicationSchedule schedule;
  final ValueNotifier<List<MedicationSchedule>> schedules;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          final result = await showTimePicker(
            context: context,
            initialTime: schedule.toTimeOfDay(),
          );
          if (result != null) {
            final copied = [...schedules.value];
            copied[index] = copied[index].copyWith(hour: result.hour, minute: result.minute);
            schedules.value = copied;
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          constraints: const BoxConstraints(
            minHeight: 48,
            maxWidth: double.infinity,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                schedule.toTimeString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
