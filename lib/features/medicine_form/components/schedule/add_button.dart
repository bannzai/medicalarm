import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:uuid/uuid.dart';

class MedicineScheduleAddButton extends HookConsumerWidget {
  const MedicineScheduleAddButton({
    super.key,
    required this.schedules,
  });

  final ValueNotifier<List<MedicationSchedule>> schedules;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerReminderLocalNotification = ref.read(registerReminderLocalNotificationProvider);

    return Column(
      children: [
        if (schedules.value.length >= MedicationSchedule.maxScheduleCount) ...[
          const SizedBox(height: 10),
          const Text('服用スケジュールは${MedicationSchedule.maxScheduleCount}つまで登録できます。'),
        ],
        TextButton.icon(
          onPressed: schedules.value.length >= MedicationSchedule.maxScheduleCount
              ? null
              : () {
                  unawaited(registerReminderLocalNotification());
                  schedules.value = [
                    ...schedules.value,
                    MedicationSchedule(
                      id: const Uuid().v4(),
                      hour: 10,
                      minute: 00,
                      quantityMemo: '',
                      notificationSetting: const MedicineScheduleNotificationSetting(
                        isReminderEnabled: true,
                        isFollowupEnabled: true,
                        useCriticalAlert: false,
                      ),
                    ),
                  ];
                },
          icon: const Icon(Icons.add),
          label: const Text('服用スケジュールを追加', style: TextStyle(fontWeight: FontWeight.bold)),
          style: capsuleTextButtonStyle(context),
        ),
      ],
    );
  }
}
