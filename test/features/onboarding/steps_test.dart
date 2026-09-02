import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/features/onboarding/steps.dart';

void main() {
  // US 長尺 / JP 短尺のファネル構成 (documents/onboarding-funnel-design.md) を検証する
  group('onboardingSteps', () {
    test('長尺は全画面を宣言順に含む', () {
      expect(onboardingSteps(isShortForm: false), OnboardingStep.values);
    });

    test('短尺は長尺専用の画面 (ペインの重ね聞き・価値提示・Before/After・目標設定) を省く', () {
      expect(onboardingSteps(isShortForm: true), [
        OnboardingStep.welcome,
        OnboardingStep.painForgot,
        OnboardingStep.careTarget,
        OnboardingStep.dailyDoseCount,
        OnboardingStep.medicineCount,
        OnboardingStep.planGenerating,
        OnboardingStep.planResult,
      ]);
    });

    test('どちらの形式も価値宣言で始まりプラン生成 → 結果提示で終わる (結果提示の CTA がペイウォールへの唯一の入口)', () {
      for (final isShortForm in [true, false]) {
        final steps = onboardingSteps(isShortForm: isShortForm);
        expect(steps.first, OnboardingStep.welcome);
        expect(steps[steps.length - 2], OnboardingStep.planGenerating);
        expect(steps.last, OnboardingStep.planResult);
      }
    });

    test('価値宣言・プラン生成・結果提示には戻るボタンを出さない', () {
      expect(OnboardingStep.welcome.canGoBack, isFalse);
      expect(OnboardingStep.planGenerating.canGoBack, isFalse);
      expect(OnboardingStep.planResult.canGoBack, isFalse);
      expect(OnboardingStep.painForgot.canGoBack, isTrue);
      expect(OnboardingStep.goal.canGoBack, isTrue);
    });
  });

  group('isShortFormOnboarding', () {
    test('日本語ロケールは JP 短尺', () {
      expect(isShortFormOnboarding(languageCode: 'ja'), isTrue);
    });

    test('日本語以外は US 長尺', () {
      expect(isShortFormOnboarding(languageCode: 'en'), isFalse);
      expect(isShortFormOnboarding(languageCode: 'de'), isFalse);
    });
  });

  // 回答が無料プランの登録上限 (服用者 2 人・通知スケジュール 2 件・薬 2 種類) を超える時だけプレミアムを勧める
  group('onboardingRecommendsPremium', () {
    test('すべて無料枠に収まるなら勧めない', () {
      expect(
        onboardingRecommendsPremium(
          careTarget: OnboardingCareTarget.family,
          dailyDoseCount: OnboardingDailyDoseCount.twice,
          medicineCount: OnboardingMedicineCount.oneToTwo,
        ),
        isFalse,
      );
    });

    test('未回答は勧めない', () {
      expect(onboardingRecommendsPremium(careTarget: null, dailyDoseCount: null, medicineCount: null), isFalse);
    });

    test('自分と家族 (3 人) は服用者の無料上限を超えるため勧める', () {
      expect(
        onboardingRecommendsPremium(
          careTarget: OnboardingCareTarget.selfAndFamily,
          dailyDoseCount: OnboardingDailyDoseCount.once,
          medicineCount: OnboardingMedicineCount.oneToTwo,
        ),
        isTrue,
      );
    });

    test('1 日 3 回以上は通知スケジュールの無料上限を超えるため勧める', () {
      expect(
        onboardingRecommendsPremium(
          careTarget: OnboardingCareTarget.self,
          dailyDoseCount: OnboardingDailyDoseCount.threeOrMore,
          medicineCount: OnboardingMedicineCount.oneToTwo,
        ),
        isTrue,
      );
    });

    test('薬 3 種類以上は薬の無料上限を超えるため勧める', () {
      expect(
        onboardingRecommendsPremium(
          careTarget: OnboardingCareTarget.self,
          dailyDoseCount: OnboardingDailyDoseCount.once,
          medicineCount: OnboardingMedicineCount.threeToFive,
        ),
        isTrue,
      );
    });
  });
}
