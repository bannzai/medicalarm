import 'package:flutter/material.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/onboarding/components/layout.dart';
import 'package:medicalarm/features/onboarding/steps.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// Before / After の価値提示 (長尺のみ)。これまでの困りごとと Medicalarm 導入後の変化を並べる
class OnboardingBeforeAfterStep extends StatelessWidget {
  final ValueNotifier<int> stepIndex;

  /// この画面がファネル内で占める位置。次のフレームの再構築前に 2 回押された時 (連打・アクセシビリティ操作) に多重で進めないための判定に使う
  final int index;

  const OnboardingBeforeAfterStep({super.key, required this.stepIndex, required this.index});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return OnboardingStepLayout(
      title: L.onboardingBeforeAfterTitle,
      subtitle: null,
      bottom: ElevatedButton(
        onPressed: () {
          if (stepIndex.value != index) {
            return;
          }
          analytics.logEvent(name: 'onboarding_before_after_next', parameters: {'step': OnboardingStep.beforeAfter.name});
          stepIndex.value += 1;
        },
        child: Text(L.onboardingNext),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Section(
            label: L.onboardingBeforeLabel,
            labelColor: TextColor.gray,
            icon: Icons.close,
            iconColor: TextColor.gray,
            items: [L.onboardingBeforeItemForgot, L.onboardingBeforeItemUnsure, L.onboardingBeforeItemFamily],
          ),
          const SizedBox(height: 12),
          Icon(Icons.arrow_downward, color: primaryColor, size: 32),
          const SizedBox(height: 12),
          _Section(
            label: L.onboardingAfterLabel,
            labelColor: primaryColor,
            icon: Icons.check_circle,
            iconColor: primaryColor,
            items: [L.onboardingAfterItemReminder, L.onboardingAfterItemRecord, L.onboardingAfterItemFamily],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String label;
  final Color labelColor;
  final IconData icon;
  final Color iconColor;
  final List<String> items;

  const _Section({
    required this.label,
    required this.labelColor,
    required this.icon,
    required this.iconColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: labelColor)),
          const SizedBox(height: 10),
          for (final item in items) ...[
            OnboardingIconRow(icon: icon, iconColor: iconColor, text: item),
            if (item != items.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
