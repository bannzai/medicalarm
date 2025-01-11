import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/style/color.dart';

class MedicineNotificationSettingLabel extends StatelessWidget {
  const MedicineNotificationSettingLabel({
    super.key,
    required this.notificationSetting,
    required this.notificationSettings,
    required this.index,
  });

  final MedicineNotificationSetting notificationSetting;
  final ValueNotifier<List<MedicineNotificationSetting>> notificationSettings;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          final result = await showTimePicker(
            context: context,
            initialTime: notificationSetting.reminderTime.toTimeOfDay(),
          );
          if (result != null) {
            final copied = [...notificationSettings.value];
            copied[index] = copied[index].copyWith(reminderTime: MedicineNotificationSettingReminderTime(hour: result.hour, minute: result.minute));
            notificationSettings.value = copied;
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
                notificationSetting.reminderTime.toTimeString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
