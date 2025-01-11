import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';

class MedicineNotificationSettingDeleteButton extends StatelessWidget {
  const MedicineNotificationSettingDeleteButton({
    super.key,
    required this.notificationSettings,
    required this.notificationSetting,
  });

  final ValueNotifier<List<MedicineNotificationSetting>> notificationSettings;
  final MedicineNotificationSetting notificationSetting;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        notificationSettings.value = notificationSettings.value.where((element) => element != notificationSetting).toList();
      },
      icon: const Icon(Icons.delete),
    );
  }
}
