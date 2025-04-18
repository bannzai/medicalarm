import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/style/button.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:uuid/uuid.dart';

class MedicineScheduleAddButton extends HookConsumerWidget {
  const MedicineScheduleAddButton({
    super.key,
    required this.schedules,
  });

  final ValueNotifier<List<MedicationSchedule>> schedules;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    final registerReminderLocalNotification = ref.read(registerReminderLocalNotificationProvider);

    return Column(
      children: [
        if (schedules.value.length >= MedicationSchedule.maxCount(isPremium: customerInfo?.isPremium)) ...[
          Text(L.medicationScheduleLimit(MedicationSchedule.maxCount(isPremium: customerInfo?.isPremium)),
              style: const TextStyle(color: TextColor.danger)),
          const SizedBox(height: 4),
          if (customerInfo?.isPremium == false) ...[
            TextButton(
              onPressed: () {
                showPremiumIntroductionSheet(context);
              },
              child: Text(
                L.increaseMedicationScheduleLimit(MedicationSchedule.maxCount(isPremium: true)),
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
        TextButton.icon(
          onPressed: schedules.value.length >= MedicationSchedule.maxCount(isPremium: customerInfo?.isPremium)
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
                        criticalAlertVolume: 0.5,
                      ),
                      focusConnectSetting: const MedicineScheduleFocusConnectSetting(),
                    ),
                  ];
                },
          icon: const Icon(Icons.add),
          label: Text(L.addMedicationSchedule, style: const TextStyle(fontWeight: FontWeight.bold)),
          style: capsuleTextButtonStyle(context),
        ),
      ],
    );
  }
}
