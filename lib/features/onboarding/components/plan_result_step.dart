import 'package:flutter/material.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/onboarding/components/layout.dart';
import 'package:medicalarm/features/onboarding/steps.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// 結果提示。回答から組み立てたプランを示し、上限超過ならプレミアム訴求を添えて CTA でペイウォールへ送る
class OnboardingPlanResultStep extends StatelessWidget {
  final OnboardingCareTarget? careTarget;
  final OnboardingDailyDoseCount? dailyDoseCount;
  final OnboardingMedicineCount? medicineCount;
  final OnboardingGoal? goal;
  final VoidCallback onPlanStartPressed;

  const OnboardingPlanResultStep({
    super.key,
    required this.careTarget,
    required this.dailyDoseCount,
    required this.medicineCount,
    required this.goal,
    required this.onPlanStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final careTarget = this.careTarget;
    final dailyDoseCount = this.dailyDoseCount;
    final medicineCount = this.medicineCount;
    final goal = this.goal;
    final recommendsPremium = onboardingRecommendsPremium(careTarget: careTarget, dailyDoseCount: dailyDoseCount, medicineCount: medicineCount);

    return OnboardingStepLayout(
      title: L.onboardingPlanResultTitle,
      subtitle: goal == null ? null : L.onboardingPlanResultGoalFormat(goal.label),
      bottom: ElevatedButton(
        onPressed: () {
          analytics.logEvent(name: 'onboarding_plan_start_pressed', parameters: {'recommends_premium': recommendsPremium});
          onPlanStartPressed();
        },
        child: Text(L.onboardingPlanStart),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingCard(
            child: Column(
              children: [
                if (careTarget != null) ...[
                  _PlanRow(icon: Icons.person, label: L.onboardingPlanDoseReceivers, value: careTarget.label),
                  const Divider(height: 24, color: AppColors.border),
                ],
                if (dailyDoseCount != null) ...[
                  _PlanRow(icon: Icons.alarm, label: L.onboardingPlanDailyReminders, value: dailyDoseCount.label),
                  const Divider(height: 24, color: AppColors.border),
                ],
                if (medicineCount != null) ...[
                  _PlanRow(icon: Icons.medication, label: L.onboardingPlanMedicines, value: medicineCount.label),
                  const Divider(height: 24, color: AppColors.border),
                ],
                _PlanRow(icon: Icons.volume_up, label: L.onboardingPlanCriticalAlert, value: L.onboardingPlanCriticalAlertValue),
              ],
            ),
          ),
          if (recommendsPremium) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.workspace_premium, color: primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          L.onboardingPremiumRecommendedTitle,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(L.onboardingPremiumRecommendedBody, style: const TextStyle(fontSize: 14, height: 1.5)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _PlanRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    // ラベルはアイコンの隣に左寄せで残り幅を取り、値は右寄せで折り返す。長い文言や大きな文字サイズでも overflow しない
    return Row(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
