import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/theme/form.dart';

class MedicineNotificationSettingFormPage extends HookConsumerWidget {
  final MedicineNotificationSetting medicineNotificationSetting;
  const MedicineNotificationSettingFormPage({super.key, required this.medicineNotificationSetting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReminderEnabled = useState(medicineNotificationSetting.isReminderEnabled);
    final isFollowupEnabled = useState(medicineNotificationSetting.isFollowupEnabled);
    final useCriticalAlert = useState(medicineNotificationSetting.useCriticalAlert);
    final doserName = useState(medicineNotificationSetting.doserName ?? '');
    return FormTheme(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('服用通知の設定'),
        ),
        body: SafeArea(
            child: Column(
          children: [
            SwitchListTile(
              value: isReminderEnabled.value,
              onChanged: (value) {
                isReminderEnabled.value = value;
              },
              title: const Text('服用時の通知を有効にする'),
            ),
            SwitchListTile(
              value: isFollowupEnabled.value,
              onChanged: (value) {
                isFollowupEnabled.value = value;
              },
              title: const Text('フォローアップ通知を有効にする'),
              subtitle: const Text('最初の通知から30分の間に服薬を記録しない場合、フォローアップ通知が送信されます'),
            ),
            SwitchListTile(
              value: useCriticalAlert.value,
              onChanged: (value) {
                useCriticalAlert.value = value;
              },
              title: const Text('マナーモードでも通知する'),
              subtitle: const Text('集中モードがONまたはデバイスが消音時でも、重大な通知はロック画面に表示されますサウンドが再生されます'),
            ),
            TextFormField(
              initialValue: doserName.value,
              onChanged: (value) {
                doserName.value = value;
              },
              decoration: const InputDecoration(hintText: '服用者(お子さんのお名前など)'),
            ),
          ],
        )),
      ),
    );
  }
}
