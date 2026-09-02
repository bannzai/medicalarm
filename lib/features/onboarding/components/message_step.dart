import 'package:flutter/material.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/onboarding/components/layout.dart';
import 'package:medicalarm/features/onboarding/steps.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// 質問の合間に挟む価値提示画面。アイコンと見出し・本文を示し「次へ」で進む
class OnboardingMessageStep extends StatelessWidget {
  final OnboardingStep step;
  final IconData icon;
  final String title;
  final String body;
  final ValueNotifier<int> stepIndex;

  /// この画面がファネル内で占める位置。次のフレームの再構築前に 2 回押された時 (連打・アクセシビリティ操作) に多重で進めないための判定に使う
  final int index;

  const OnboardingMessageStep({
    super.key,
    required this.step,
    required this.icon,
    required this.title,
    required this.body,
    required this.stepIndex,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return OnboardingStepLayout(
      title: title,
      subtitle: null,
      bottom: ElevatedButton(
        onPressed: () {
          if (stepIndex.value != index) {
            return;
          }
          analytics.logEvent(name: 'onboarding_next_pressed', parameters: {'step': step.name});
          stepIndex.value += 1;
        },
        child: Text(L.onboardingNext),
      ),
      child: Column(
        children: [
          Icon(icon, size: 96, color: primaryColor),
          const SizedBox(height: 24),
          OnboardingCard(
            child: Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
