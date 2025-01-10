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
    final name = useState(medicine?.name ?? '');
    final notificationSettings = useState(medicine?.notificationSettings ?? []);
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
                initialValue: name.value,
                onChanged: (value) {
                  name.value = value;
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
                MedicineNotificationSettingSection(notificationSettings: notificationSettings),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineNotificationSettingSection extends StatelessWidget {
  final ValueNotifier<List<MedicineNotificationSetting>> notificationSettings;
  const MedicineNotificationSettingSection({super.key, required this.notificationSettings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final notificationSetting in notificationSettings.value) ...[
          Row(
            children: [
              Expanded(
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
              IconButton(
                onPressed: () {
                  notificationSettings.value = notificationSettings.value.where((element) => element != notificationSetting).toList();
                },
                icon: const Icon(Icons.delete),
              ),
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
