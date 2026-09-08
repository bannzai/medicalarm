import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/entity/onboarding_medication_plan.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medications/components/card_layout.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/current_group_id.dart';
import 'package:medicalarm/provider/dose_receiver.dart';
import 'package:medicalarm/provider/onboarding_medication_plan.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

/// 薬がまだ登録されていないときだけ、作成日以降のカレンダーに保存済みプランを表示する。
class MedicationPlaceholderCards extends ConsumerWidget {
  /// カレンダーで選択している日。
  final DateTime date;

  const MedicationPlaceholderCards({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupID = ref.watch(currentGroupIDProvider);
    if (groupID == null || ref.watch(hasRegisteredMedicinesProvider).asData?.value != false) return const SizedBox.shrink();
    final plan = ref.watch(onboardingMedicationPlanStoreProvider(userID: ref.watch(appUserIDProvider), groupID: groupID));
    if (plan == null || date.date().isBefore(plan.createdDateTime.date())) return const SizedBox.shrink();
    final doseReceiver = ref.watch(doseReceiversProvider).valueOrNull?.firstWhereOrNull((receiver) => receiver.id == plan.doseReceiverID);
    if (doseReceiver == null) return const SizedBox.shrink();

    return Column(
      children: [
        for (final schedule in plan.schedules) ...[
          MedicationPlaceholderTile(plan: plan, schedule: schedule, doseReceiverName: doseReceiver.name),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

/// 薬の代わりに登録導線を持つカード。服薬済みとして記録できるチェック欄は持たない。
class MedicationPlaceholderTile extends HookConsumerWidget {
  /// 保存済みの未登録プラン。
  final OnboardingMedicationPlan plan;

  /// このカードに表示する時刻。
  final MedicationSchedule schedule;

  /// プランに紐づくデフォルト服用者の現在の名前。
  final String doseReceiverName;

  const MedicationPlaceholderTile({super.key, required this.plan, required this.schedule, required this.doseReceiverName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOperating = useState(false);
    final customerInfo = ref.watch(customerInfoProvider);

    return MedicationCardLayout(
      time: schedule.toTimeString(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(doseReceiverName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(L.onboardingMedicationPlaceholderTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(L.onboardingMedicationPlaceholderBody),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              Semantics(
                  identifier: 'onboarding_placeholder_add_${schedule.id}',
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(L.addMedicine),
                    onPressed: isOperating.value
                        ? null
                        : () async {
                            if (isOperating.value) return;
                            isOperating.value = true;
                            analytics.logEvent(name: 'onboarding_placeholder_add_pressed');
                            await showMedicineForm(
                              context,
                              null,
                              initialSchedules: plan.schedules
                                  .take(MedicationSchedule.maxCount(hasPremiumEntitlement: customerInfo.value?.hasPremiumEntitlement))
                                  .toList(),
                            );
                            if (context.mounted) isOperating.value = false;
                          },
                  )),
              Semantics(
                  identifier: 'onboarding_placeholder_delete_${schedule.id}',
                  child: TextButton(
                    onPressed: isOperating.value
                        ? null
                        : () async {
                            if (isOperating.value) return;
                            isOperating.value = true;
                            analytics.logEvent(name: 'onboarding_placeholder_delete');
                            try {
                              await ref
                                  .read(onboardingMedicationPlanStoreProvider(userID: plan.userID, groupID: plan.groupID).notifier)
                                  .removeSchedule(scheduleID: schedule.id);
                            } catch (error) {
                              if (context.mounted) showErrorAlert(context, error.toString());
                            } finally {
                              if (context.mounted) isOperating.value = false;
                            }
                          },
                    child: Text(L.delete),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
