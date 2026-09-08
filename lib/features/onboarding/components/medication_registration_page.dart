import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/page.dart';
import 'package:medicalarm/features/onboarding/components/layout.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

/// 回答で用意した仮の時刻を見せ、最初のお薬の登録へ案内する。
class OnboardingMedicationRegistrationPage extends HookConsumerWidget {
  /// 回答から作った保存済みプランの時刻。
  final List<MedicationSchedule> schedules;

  const OnboardingMedicationRegistrationPage({super.key, required this.schedules});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpening = useState(false);
    final customerInfo = ref.watch(customerInfoProvider);

    return PopScope(
      canPop: !isOpening.value,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: OnboardingStepLayout(
          title: L.onboardingMedicationRegistrationTitle,
          subtitle: L.onboardingMedicationRegistrationBody,
          bottom: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.medication_outlined),
                label: Text(L.addMedicine),
                onPressed: isOpening.value
                    ? null
                    : () async {
                        if (isOpening.value) return;
                        isOpening.value = true;
                        analytics.logEvent(name: 'onboarding_medication_add_pressed');
                        // 無料プランのスケジュール上限は通常の登録フォームと同じ条件にする。
                        await showMedicineForm(
                          context,
                          null,
                          initialSchedules:
                              schedules.take(MedicationSchedule.maxCount(hasPremiumEntitlement: customerInfo.value?.hasPremiumEntitlement)).toList(),
                        );
                        if (context.mounted) {
                          isOpening.value = false;
                          Navigator.of(context).pop();
                        }
                      },
              ),
              TextButton(
                onPressed: isOpening.value
                    ? null
                    : () {
                        analytics.logEvent(name: 'onboarding_medication_later_pressed');
                        Navigator.of(context).pop();
                      },
                child: Text(L.onboardingMedicationLater),
              ),
            ],
          ),
          child: OnboardingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.alarm, color: Theme.of(context).colorScheme.primary, size: 48),
                const SizedBox(height: 16),
                for (final schedule in schedules)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      schedule.toTimeString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(L.onboardingMedicationPlaceholderBody, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
