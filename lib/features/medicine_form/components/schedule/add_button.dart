import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/style/button.dart';
import 'package:uuid/uuid.dart';

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
          MedicationSchedule(
            id: const Uuid().v4(),
            hour: 10,
            minute: 00,
            quantityMemo: '',
            notificationSetting: const MedicineScheduleNotificationSetting(
              isReminderEnabled: true,
              isFollowupEnabled: true,
              useCriticalAlert: false,
            ),
          ),
        ];
      },
      icon: const Icon(Icons.add),
      label: const Text('服用スケジュールを追加', style: TextStyle(fontWeight: FontWeight.bold)),
      style: capsuleTextButtonStyle(context),
    );
  }
}
