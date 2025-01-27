import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_schedule_notification_form.dart/page.dart';

class MedicineScheduleNotificationSettingButton extends StatelessWidget {
  final MedicationSchedule schedule;
  final ValueNotifier<List<MedicationSchedule>> schedules;
  final int index;
  const MedicineScheduleNotificationSettingButton({
    super.key,
    required this.schedule,
    required this.schedules,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineScheduleNotificationFormPage(
              schedule: schedule,
              schedules: schedules,
              index: index,
            ),
          ),
        );
      },
      icon: const Icon(Icons.settings),
    );
  }
}
