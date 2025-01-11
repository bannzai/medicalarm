import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/style/button.dart';

class MedicineNotificationSettingAddButton extends StatelessWidget {
  const MedicineNotificationSettingAddButton({
    super.key,
    required this.notificationSettings,
  });

  final ValueNotifier<List<MedicineNotificationSetting>> notificationSettings;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        notificationSettings.value = [
          ...notificationSettings.value,
          const MedicineNotificationSetting(
            reminderTime: MedicineNotificationSettingReminderTime(hour: 10, minute: 00),
            dosingCount: 1,
            isEnabled: true,
            useCriticalAlert: false,
            doserName: null,
          ),
        ];
      },
      icon: const Icon(Icons.add),
      label: const Text('服用時刻を追加', style: TextStyle(fontWeight: FontWeight.bold)),
      style: secondaryButtonStyle.merge(capsuleButtonStyle),
    );
  }
}
