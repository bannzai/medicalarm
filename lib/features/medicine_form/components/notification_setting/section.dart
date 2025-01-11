import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/notification_setting/add_button.dart';
import 'package:medicalarm/features/medicine_form/components/notification_setting/label.dart';
import 'package:medicalarm/style/button.dart';

class MedicineNotificationSettingSection extends StatelessWidget {
  final ValueNotifier<List<MedicineNotificationSetting>> notificationSettings;
  const MedicineNotificationSettingSection({super.key, required this.notificationSettings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (index, notificationSetting) in notificationSettings.value.indexed) ...[
          Row(
            children: [
              MedicineNotificationSettingLabel(
                notificationSetting: notificationSetting,
                notificationSettings: notificationSettings,
                index: index,
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              MedicineNotificationSettingAddButton(notificationSettings: notificationSettings, notificationSetting: notificationSetting),
            ],
          ),
          const SizedBox(height: 6),
        ],
        const SizedBox(height: 10),
        TextButton.icon(
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
        ),
      ],
    );
  }
}
