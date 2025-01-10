import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/section.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/style/color.dart';

class MedicineFormPage extends HookConsumerWidget {
  final Medicine? medicine;

  const MedicineFormPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicine = useState(this.medicine);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Form'),
      ),
      backgroundColor: AppColors.formBackground,
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              initialValue: medicine.value?.name,
              onChanged: (value) {
                medicine.value = medicine.value?.copyWith(name: value);
              },
              decoration: const InputDecoration(
                hintText: '薬の名前',
                border: OutlineInputBorder(),
              ),
            ),
            SectionTitle(
              icon: const Icon(Icons.medical_information),
              text: '服用時刻',
              children: [
                MedicineNotificationSettingSection(notificationSettings: medicine.value?.notificationSettings ?? []),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineNotificationSettingSection extends HookConsumerWidget {
  final List<MedicineNotificationSetting> notificationSettings;
  const MedicineNotificationSettingSection({super.key, required this.notificationSettings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (notificationSettings.isEmpty) {
      return TextButton.icon(
        onPressed: () {
          // TODO: 追加ボタンを押したときの処理
        },
        icon: const Icon(Icons.add),
        label: const Text('服用時刻を追加'),
        style: secondaryButtonStyle.merge(
          capsuleButtonStyle,
        ),
      );
    } else {
      return Column(
        children: [
          for (var notificationSetting in notificationSettings)
            TextFormField(
              initialValue: notificationSetting.reminderTime.toTimeString(),
            ),
        ],
      );
    }
  }
}
