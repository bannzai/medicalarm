import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';

/// 課金転換型オンボーディングの画面。表示順は宣言順で、[onboardingSteps] が US 長尺 / JP 短尺に応じて絞り込む。
/// 設計: documents/onboarding-funnel-design.md
enum OnboardingStep {
  // 価値宣言
  welcome,
  // ペイン認識: 飲み忘れ経験
  painForgot,
  // ペイン認識: 飲んだか思い出せない不安 (長尺のみ)
  painWorry,
  // 質問の合間に挟む価値提示 (長尺のみ)
  valueReminder,
  // パーソナライズ: 誰の服薬を管理するか
  careTarget,
  // パーソナライズ: 1日の服用回数
  dailyDoseCount,
  // パーソナライズ: 管理する薬の数
  medicineCount,
  // Before / After の価値提示 (長尺のみ)
  beforeAfter,
  // コミットメント: 目標設定 (長尺のみ)
  goal,
  // プラン生成演出
  planGenerating,
  // 結果提示。CTA でペイウォールへ
  planResult;

  /// JP 短尺ファネルで省く画面。回答が結果画面に反映されない感情的な演出画面と、ペインの重ね聞きが対象
  bool get isLongFormOnly {
    switch (this) {
      case OnboardingStep.painWorry:
      case OnboardingStep.valueReminder:
      case OnboardingStep.beforeAfter:
      case OnboardingStep.goal:
        return true;
      case OnboardingStep.welcome:
      case OnboardingStep.painForgot:
      case OnboardingStep.careTarget:
      case OnboardingStep.dailyDoseCount:
      case OnboardingStep.medicineCount:
      case OnboardingStep.planGenerating:
      case OnboardingStep.planResult:
        return false;
    }
  }

  /// 戻るボタンを出さない画面。プラン生成中と結果画面から質問へ戻すと演出が再生され体験が崩れるため
  bool get canGoBack {
    switch (this) {
      case OnboardingStep.welcome:
      case OnboardingStep.planGenerating:
      case OnboardingStep.planResult:
        return false;
      case OnboardingStep.painForgot:
      case OnboardingStep.painWorry:
      case OnboardingStep.valueReminder:
      case OnboardingStep.careTarget:
      case OnboardingStep.dailyDoseCount:
      case OnboardingStep.medicineCount:
      case OnboardingStep.beforeAfter:
      case OnboardingStep.goal:
        return true;
    }
  }
}

/// ファネルに含める画面を順序どおりに返す。JP 短尺では [OnboardingStep.isLongFormOnly] の画面を省く
List<OnboardingStep> onboardingSteps({required bool isShortForm}) {
  return OnboardingStep.values.where((step) => !(isShortForm && step.isLongFormOnly)).toList();
}

/// 端末ロケールが日本語なら JP 短尺、それ以外は US 長尺として扱う
bool isShortFormOnboarding({required String languageCode}) {
  return languageCode == 'ja';
}

/// 「薬を飲み忘れたことはありますか」の回答
enum OnboardingForgotFrequency { often, sometimes, rarely }

extension OnboardingForgotFrequencyLabel on OnboardingForgotFrequency {
  String get label {
    switch (this) {
      case OnboardingForgotFrequency.often:
        return L.onboardingFrequencyOften;
      case OnboardingForgotFrequency.sometimes:
        return L.onboardingFrequencySometimes;
      case OnboardingForgotFrequency.rarely:
        return L.onboardingFrequencyRarely;
    }
  }
}

/// 「飲んだかどうか思い出せず不安になったことは」の回答
enum OnboardingWorryFrequency { often, sometimes, never }

extension OnboardingWorryFrequencyLabel on OnboardingWorryFrequency {
  String get label {
    switch (this) {
      case OnboardingWorryFrequency.often:
        return L.onboardingFrequencyOften;
      case OnboardingWorryFrequency.sometimes:
        return L.onboardingFrequencySometimes;
      case OnboardingWorryFrequency.never:
        return L.onboardingFrequencyNever;
    }
  }
}

/// 「誰の服薬を管理しますか」の回答
enum OnboardingCareTarget { self, family, selfAndFamily }

extension OnboardingCareTargetPlan on OnboardingCareTarget {
  String get label {
    switch (this) {
      case OnboardingCareTarget.self:
        return L.onboardingCareTargetSelf;
      case OnboardingCareTarget.family:
        return L.onboardingCareTargetFamily;
      case OnboardingCareTarget.selfAndFamily:
        return L.onboardingCareTargetSelfAndFamily;
    }
  }

  /// 結果画面のプランで想定する服用者数。無料プランの上限 ([DoseReceiver.maxCount]) と比較してプレミアム訴求の要否を決める
  int get doseReceiverCount {
    switch (this) {
      case OnboardingCareTarget.self:
        return 1;
      case OnboardingCareTarget.family:
        return 2;
      case OnboardingCareTarget.selfAndFamily:
        return 3;
    }
  }
}

/// 「1日に何回薬を飲みますか」の回答
enum OnboardingDailyDoseCount { once, twice, threeOrMore }

extension OnboardingDailyDoseCountPlan on OnboardingDailyDoseCount {
  String get label {
    switch (this) {
      case OnboardingDailyDoseCount.once:
        return L.onboardingDailyDoseOnce;
      case OnboardingDailyDoseCount.twice:
        return L.onboardingDailyDoseTwice;
      case OnboardingDailyDoseCount.threeOrMore:
        return L.onboardingDailyDoseThreeOrMore;
    }
  }

  /// 結果画面のプランで想定する 1 薬あたりの通知スケジュール数。無料プランの上限 ([MedicationSchedule.maxCount]) と比較する
  int get scheduleCount {
    switch (this) {
      case OnboardingDailyDoseCount.once:
        return 1;
      case OnboardingDailyDoseCount.twice:
        return 2;
      case OnboardingDailyDoseCount.threeOrMore:
        return 3;
    }
  }
}

/// 「管理する薬はいくつありますか」の回答
enum OnboardingMedicineCount { oneToTwo, threeToFive, sixOrMore }

extension OnboardingMedicineCountPlan on OnboardingMedicineCount {
  String get label {
    switch (this) {
      case OnboardingMedicineCount.oneToTwo:
        return L.onboardingMedicineCountOneToTwo;
      case OnboardingMedicineCount.threeToFive:
        return L.onboardingMedicineCountThreeToFive;
      case OnboardingMedicineCount.sixOrMore:
        return L.onboardingMedicineCountSixOrMore;
    }
  }

  /// 結果画面のプランで想定する薬の登録数の下限。無料プランの上限 ([Medicine.maxCount]) と比較する
  int get medicineCount {
    switch (this) {
      case OnboardingMedicineCount.oneToTwo:
        return 1;
      case OnboardingMedicineCount.threeToFive:
        return 3;
      case OnboardingMedicineCount.sixOrMore:
        return 6;
    }
  }
}

/// 「目標を決めましょう」の回答 (長尺のみ)
enum OnboardingGoal { zeroMissed, keepRecording, watchFamily }

extension OnboardingGoalLabel on OnboardingGoal {
  String get label {
    switch (this) {
      case OnboardingGoal.zeroMissed:
        return L.onboardingGoalZeroMissed;
      case OnboardingGoal.keepRecording:
        return L.onboardingGoalKeepRecording;
      case OnboardingGoal.watchFamily:
        return L.onboardingGoalWatchFamily;
    }
  }
}

/// 回答から想定したプランが無料プランの登録上限 (服用者数・通知スケジュール数・薬の数のいずれか) を超えるならプレミアムプランを勧める
bool onboardingRecommendsPremium({
  required OnboardingCareTarget? careTarget,
  required OnboardingDailyDoseCount? dailyDoseCount,
  required OnboardingMedicineCount? medicineCount,
}) {
  return (careTarget?.doseReceiverCount ?? 0) > DoseReceiver.maxCount(hasPremiumEntitlement: false) ||
      (dailyDoseCount?.scheduleCount ?? 0) > MedicationSchedule.maxCount(hasPremiumEntitlement: false) ||
      (medicineCount?.medicineCount ?? 0) > Medicine.maxCount(hasPremiumEntitlement: false);
}
