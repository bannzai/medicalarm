import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_schedule_setting_form/page.dart';

class MedicineScheduleNotificationSettingButton extends StatelessWidget {
  final MedicationSchedule schedule;
  final ValueNotifier<List<MedicationSchedule>> schedules;
  final int index;
  // 編集中の既存薬。新規薬(未保存)作成時は null。個別通知設定の書き込み先分岐に使う。
  final Medicine? medicine;
  const MedicineScheduleNotificationSettingButton({
    super.key,
    required this.schedule,
    required this.schedules,
    required this.index,
    required this.medicine,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineScheduleSettingFormPage(
              schedule: schedule,
              schedules: schedules,
              index: index,
              medicine: medicine,
            ),
          ),
        );
      },
      icon: const Icon(Icons.settings),
    );
  }
}
