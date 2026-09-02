import 'package:flutter/material.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/onboarding/components/layout.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// 価値宣言。アプリが約束する変化を 1 画面で示し「はじめる」でファネルに入る
class OnboardingWelcomeStep extends StatelessWidget {
  final ValueNotifier<int> stepIndex;

  /// この画面がファネル内で占める位置。次のフレームの再構築前に 2 回押された時 (連打・アクセシビリティ操作) に多重で進めないための判定に使う
  final int index;

  const OnboardingWelcomeStep({super.key, required this.stepIndex, required this.index});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return OnboardingStepLayout(
      title: L.onboardingWelcomeTitle,
      subtitle: L.onboardingWelcomeBody,
      bottom: ElevatedButton(
        onPressed: () {
          if (stepIndex.value != index) {
            return;
          }
          analytics.logEvent(name: 'onboarding_start_pressed');
          stepIndex.value += 1;
        },
        child: Text(L.onboardingStart),
      ),
      child: Column(
        children: [
          Icon(Icons.notifications_active, size: 96, color: primaryColor),
          const SizedBox(height: 24),
          OnboardingCard(
            child: Column(
              children: [
                OnboardingIconRow(icon: Icons.alarm, iconColor: primaryColor, text: L.onboardingWelcomeFeatureReminder),
                const SizedBox(height: 12),
                OnboardingIconRow(icon: Icons.volume_up, iconColor: primaryColor, text: L.onboardingWelcomeFeatureCriticalAlert),
                const SizedBox(height: 12),
                OnboardingIconRow(icon: Icons.family_restroom, iconColor: primaryColor, text: L.onboardingWelcomeFeatureFamily),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
