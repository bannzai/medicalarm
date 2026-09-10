import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/onboarding/components/layout.dart';

/// 回答を「あなた専用プラン」に変換するローディング演出。[duration] 経過後に自動で次の画面へ進む
class OnboardingPlanGeneratingStep extends HookWidget {
  static const duration = Duration(milliseconds: 2400);

  final ValueNotifier<int> stepIndex;

  const OnboardingPlanGeneratingStep({super.key, required this.stepIndex});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final controller = useAnimationController(duration: duration);
    useAnimation(controller);

    useEffect(() {
      void onStatusChanged(AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          stepIndex.value += 1;
        }
      }

      controller.addStatusListener(onStatusChanged);
      controller.forward();
      return () => controller.removeStatusListener(onStatusChanged);
    }, [controller]);

    final messages = [L.onboardingPlanGeneratingAnalyzing, L.onboardingPlanGeneratingSchedule, L.onboardingPlanGeneratingReady];
    final messageIndex = (controller.value * messages.length).floor().clamp(0, messages.length - 1);

    return OnboardingStepLayout(
      title: L.onboardingPlanGeneratingTitle,
      subtitle: null,
      bottom: null,
      child: Column(
        children: [
          const SizedBox(height: 40),
          SizedBox(
            width: 96,
            height: 96,
            child: CircularProgressIndicator(
              value: controller.value,
              strokeWidth: 8,
              backgroundColor: primaryColor.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(primaryColor),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            messages[messageIndex],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
