import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_schedule_setting_form/page.dart';

class MedicineScheduleNotificationSettingButton extends StatelessWidget {
  final Medicine? medicine;
  final MedicationSchedule schedule;
  final ValueNotifier<List<MedicationSchedule>> schedules;
  final int index;
  const MedicineScheduleNotificationSettingButton({
    super.key,
    required this.medicine,
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
            builder: (context) => MedicineScheduleSettingFormPage(
              medicine: medicine,
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
