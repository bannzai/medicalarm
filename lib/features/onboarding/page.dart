import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/onboarding/components/before_after_step.dart';
import 'package:medicalarm/features/onboarding/components/message_step.dart';
import 'package:medicalarm/features/onboarding/components/plan_generating_step.dart';
import 'package:medicalarm/features/onboarding/components/plan_result_step.dart';
import 'package:medicalarm/features/onboarding/components/question_step.dart';
import 'package:medicalarm/features/onboarding/components/welcome_step.dart';
import 'package:medicalarm/features/onboarding/steps.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// 初回起動時の課金転換型オンボーディング。価値宣言 → ペイン認識 → パーソナライズ → (価値提示・目標設定) → プラン生成 → 結果提示の順に進み、
/// 結果画面の CTA で [onPlanStartPressed] を呼ぶ。設計: documents/onboarding-funnel-design.md
class OnboardingPage extends HookConsumerWidget {
  /// 画面遷移アニメーションの長さ。AnimatedSwitcher の duration と、遷移中に戻る操作を無視する時間で同じ値を使う
  static const transitionDuration = Duration(milliseconds: 250);

  final bool isShortForm;
  // ペイウォール表示と完了の永続化は OnboardingResolver が担う (PromotionStartPage と同じ resolver → page の分担) ため、
  // 結果画面の CTA だけをコールバックで親へ返す
  final VoidCallback onPlanStartPressed;

  const OnboardingPage({
    super.key,
    required this.isShortForm,
    required this.onPlanStartPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = useMemoized(() => onboardingSteps(isShortForm: isShortForm), [isShortForm]);
    final stepIndex = useState(0);
    final forgotFrequency = useState<OnboardingForgotFrequency?>(null);
    final worryFrequency = useState<OnboardingWorryFrequency?>(null);
    final careTarget = useState<OnboardingCareTarget?>(null);
    final dailyDoseCount = useState<OnboardingDailyDoseCount?>(null);
    final medicineCount = useState<OnboardingMedicineCount?>(null);
    final goal = useState<OnboardingGoal?>(null);
    final isTransitioning = useState(false);
    final primaryColor = Theme.of(context).colorScheme.primary;

    final step = steps[stepIndex.value.clamp(0, steps.length - 1)];

    useEffect(() {
      analytics.logEvent(name: 'onboarding_started', parameters: {'form': isShortForm ? 'short' : 'long', 'total': steps.length});
      return null;
    }, []);
    useEffect(() {
      analytics.logEvent(name: 'onboarding_step_shown', parameters: {'step': step.name, 'index': stepIndex.value + 1, 'total': steps.length});
      return null;
    }, [step]);
    useEffect(() {
      isTransitioning.value = true;
      // step が変わるたび・unmount 時に cancel されるため、破棄済みの ValueNotifier へ書き込まない
      final timer = Timer(transitionDuration, () => isTransitioning.value = false);
      return timer.cancel;
    }, [step]);

    void goBack() {
      // 戻るボタンと Android の戻る操作は AnimatedSwitcher の IgnorePointer の外にあるため、遷移中の連打で複数ステップ戻らないよう遷移中は無視する
      if (isTransitioning.value || stepIndex.value <= 0) {
        return;
      }
      analytics.logEvent(name: 'onboarding_back_pressed', parameters: {'step': step.name});
      stepIndex.value -= 1;
    }

    return PopScope(
      // Android の戻る操作でオンボーディングの外へ抜けないようにし、質問画面では前の画面へ戻す
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && step.canGoBack) {
          goBack();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: step.canGoBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: primaryColor,
                  tooltip: L.onboardingBack,
                  onPressed: isTransitioning.value ? null : goBack,
                )
              : null,
          title: Semantics(
            identifier: 'onboarding_progress',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (stepIndex.value + 1) / steps.length,
                minHeight: 8,
                backgroundColor: primaryColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: transitionDuration,
          // 遷移中の二重タップで古い画面の選択肢を再度押したり、新しい画面の同じ位置の選択肢を意図せず選んだりしないため、
          // アニメーションが完了するまで入力を無視する。退場側は reverse 中に isCompleted が false になるため同じ式で無視できる
          transitionBuilder: (child, animation) => AnimatedBuilder(
            animation: animation,
            builder: (context, child) => IgnorePointer(
              ignoring: !animation.isCompleted,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: child,
          ),
          child: KeyedSubtree(
            key: ValueKey(step),
            child: switch (step) {
              OnboardingStep.welcome => OnboardingWelcomeStep(stepIndex: stepIndex, index: stepIndex.value),
              OnboardingStep.painForgot => OnboardingQuestionStep(
                  step: step,
                  title: L.onboardingPainForgotTitle,
                  subtitle: null,
                  options: [for (final value in OnboardingForgotFrequency.values) (label: value.label, value: value)],
                  answer: forgotFrequency,
                  stepIndex: stepIndex,
                  index: stepIndex.value,
                ),
              OnboardingStep.painWorry => OnboardingQuestionStep(
                  step: step,
                  title: L.onboardingPainWorryTitle,
                  subtitle: null,
                  options: [for (final value in OnboardingWorryFrequency.values) (label: value.label, value: value)],
                  answer: worryFrequency,
                  stepIndex: stepIndex,
                  index: stepIndex.value,
                ),
              OnboardingStep.valueReminder => OnboardingMessageStep(
                  step: step,
                  icon: Icons.notifications_active,
                  title: L.onboardingValueReminderTitle,
                  body: L.onboardingValueReminderBody,
                  stepIndex: stepIndex,
                  index: stepIndex.value,
                ),
              OnboardingStep.careTarget => OnboardingQuestionStep(
                  step: step,
                  title: L.onboardingCareTargetTitle,
                  subtitle: L.onboardingCareTargetSubtitle,
                  options: [for (final value in OnboardingCareTarget.values) (label: value.label, value: value)],
                  answer: careTarget,
                  stepIndex: stepIndex,
                  index: stepIndex.value,
                ),
              OnboardingStep.dailyDoseCount => OnboardingQuestionStep(
                  step: step,
                  title: L.onboardingDailyDoseCountTitle,
                  subtitle: L.onboardingDailyDoseCountSubtitle,
                  options: [for (final value in OnboardingDailyDoseCount.values) (label: value.label, value: value)],
                  answer: dailyDoseCount,
                  stepIndex: stepIndex,
                  index: stepIndex.value,
                ),
              OnboardingStep.medicineCount => OnboardingQuestionStep(
                  step: step,
                  title: L.onboardingMedicineCountTitle,
                  subtitle: null,
                  options: [for (final value in OnboardingMedicineCount.values) (label: value.label, value: value)],
                  answer: medicineCount,
                  stepIndex: stepIndex,
                  index: stepIndex.value,
                ),
              OnboardingStep.beforeAfter => OnboardingBeforeAfterStep(stepIndex: stepIndex, index: stepIndex.value),
              OnboardingStep.goal => OnboardingQuestionStep(
                  step: step,
                  title: L.onboardingGoalTitle,
                  subtitle: L.onboardingGoalSubtitle,
                  options: [for (final value in OnboardingGoal.values) (label: value.label, value: value)],
                  answer: goal,
                  stepIndex: stepIndex,
                  index: stepIndex.value,
                ),
              OnboardingStep.planGenerating => OnboardingPlanGeneratingStep(stepIndex: stepIndex),
              OnboardingStep.planResult => OnboardingPlanResultStep(
                  careTarget: careTarget.value,
                  dailyDoseCount: dailyDoseCount.value,
                  medicineCount: medicineCount.value,
                  goal: goal.value,
                  onPlanStartPressed: onPlanStartPressed,
                ),
            },
          ),
        ),
      ),
    );
  }
}
