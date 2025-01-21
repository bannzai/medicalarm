import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/utils/local_notification/client.dart';

class MedicineScheduleNotificationSettingSection extends HookConsumerWidget {
  final ValueNotifier<bool> isReminderEnabled;
  final ValueNotifier<bool> isFollowupEnabled;
  final ValueNotifier<bool> useCriticalAlert;

  const MedicineScheduleNotificationSettingSection({
    super.key,
    required this.isReminderEnabled,
    required this.isFollowupEnabled,
    required this.useCriticalAlert,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MedicineFormSectionLayout(
      icon: Icons.notifications,
      text: '通知設定',
      children: [
        SwitchListTile(
          value: isReminderEnabled.value,
          onChanged: (value) {
            isReminderEnabled.value = value;

            if (!value) {
              isFollowupEnabled.value = false;
            }
          },
          title: const Text('服用時の通知を有効にする'),
          subtitle: const Text('服用時刻に基づいて通知を送信します'),
        ),
        SwitchListTile(
          value: isFollowupEnabled.value,
          onChanged: (value) {
            if (!isReminderEnabled.value) {
              isFollowupEnabled.value = false;
            } else {
              isFollowupEnabled.value = value;
            }
          },
          title: const Text('フォローアップ通知を有効にする'),
          subtitle: const Text('最初の通知から30分の間に服薬を記録しない場合、フォローアップ通知が送信されます'),
        ),
        SwitchListTile(
          value: useCriticalAlert.value,
          onChanged: (value) async {
            final grand = await localNotificationService.requestPermissionWithCriticalAlert();
            if (grand == true) {
              useCriticalAlert.value = value;
            } else {
              useCriticalAlert.value = false;
            }
          },
          title: const Text('マナーモードでも通知する'),
          subtitle: const Text('集中モードがONまたはデバイスが消音時でも、重大な通知はロック画面に表示されますサウンドが再生されます'),
        ),
      ],
    );
  }
}
