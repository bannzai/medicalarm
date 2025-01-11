import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/notification_setting/add_button.dart';
import 'package:medicalarm/features/medicine_form/components/notification_setting/delete_button.dart';
import 'package:medicalarm/features/medicine_form/components/notification_setting/label.dart';

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
              MedicineNotificationSettingDeleteButton(notificationSettings: notificationSettings, notificationSetting: notificationSetting),
            ],
          ),
          const SizedBox(height: 6),
        ],
        const SizedBox(height: 10),
        MedicineNotificationSettingAddButton(notificationSettings: notificationSettings),
      ],
    );
  }
}
