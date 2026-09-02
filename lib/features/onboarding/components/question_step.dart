import 'package:flutter/material.dart';
import 'package:medicalarm/features/onboarding/components/layout.dart';
import 'package:medicalarm/features/onboarding/steps.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// 選択肢をタップすると回答を [answer] に保存して次の画面へ進む質問画面。
/// 戻ってきた時は保存済みの回答を選択状態で表示する
class OnboardingQuestionStep<T extends Enum> extends StatelessWidget {
  final OnboardingStep step;
  final String title;
  final String? subtitle;
  final List<({String label, T value})> options;
  final ValueNotifier<T?> answer;
  final ValueNotifier<int> stepIndex;

  const OnboardingQuestionStep({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.answer,
    required this.stepIndex,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return OnboardingStepLayout(
      title: title,
      subtitle: subtitle,
      bottom: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final option in options) ...[
            Semantics(
              identifier: 'onboarding_option_${option.value.name}',
              button: true,
              child: Material(
                color: answer.value == option.value ? primaryColor.withValues(alpha: 0.12) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    analytics.logEvent(name: 'onboarding_answered', parameters: {'step': step.name, 'answer': option.value.name});
                    answer.value = option.value;
                    stepIndex.value += 1;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: answer.value == option.value ? primaryColor : AppColors.border, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(option.label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                        ),
                        Icon(Icons.chevron_right, color: primaryColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
