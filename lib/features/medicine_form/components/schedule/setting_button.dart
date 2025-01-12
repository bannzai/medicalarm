import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_schedule_notification_form.dart/page.dart';

class MedicineScheduleSettingButton extends StatelessWidget {
  final MedicationSchedule schedule;
  const MedicineScheduleSettingButton({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineScheduleNotificationFormPage(schedule: schedule),
          ),
        );
      },
      icon: const Icon(Icons.settings),
    );
  }
}
