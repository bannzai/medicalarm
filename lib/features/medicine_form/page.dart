import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/section.dart';
import 'package:medicalarm/style/button.dart';

class MedicineFormPage extends HookConsumerWidget {
  final Medicine? medicine;

  const MedicineFormPage({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicine = useState(this.medicine);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Form', style: TextStyle(color: primaryColor)),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: TextFormField(
                initialValue: medicine.value?.name,
                onChanged: (value) {
                  medicine.value = medicine.value?.copyWith(name: value);
                },
                decoration: const InputDecoration(
                  hintText: '薬の名前',
                ),
              ),
            ),
            Section(
              icon: Icons.schedule,
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
    return Column(
      children: [
        for (var notificationSetting in notificationSettings)
          TextFormField(
            initialValue: notificationSetting.reminderTime.toTimeString(),
          ),
        TextButton.icon(
          onPressed: () {
            // TODO: 追加ボタンを押したときの処理
          },
          icon: const Icon(Icons.add),
          label: const Text('服用時刻を追加', style: TextStyle(fontWeight: FontWeight.bold)),
          style: secondaryButtonStyle.merge(capsuleButtonStyle),
        ),
      ],
    );
  }
}
