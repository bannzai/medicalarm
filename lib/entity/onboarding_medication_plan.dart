import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/medicine.dart';

part 'onboarding_medication_plan.freezed.dart';
part 'onboarding_medication_plan.g.dart';

/// 薬が未登録の間だけ端末に保存する服薬時刻の仮設定。
/// 薬・用量を確定していないため Firestore の Medicine とは独立して保存する。
@freezed
abstract class OnboardingMedicationPlan with _$OnboardingMedicationPlan {
  @JsonSerializable(explicitToJson: true)
  const factory OnboardingMedicationPlan({
    /// 設定を作成した認証ユーザー。
    required String userID,

    /// 設定を表示するグループ。
    required String groupID,

    /// 設定の対象となるデフォルトの服用者。
    required String doseReceiverID,

    /// 仮設定を始めた日時。
    required DateTime createdDateTime,

    /// 薬の登録を案内する毎日の時刻。
    required List<MedicationSchedule> schedules,
  }) = _OnboardingMedicationPlan;

  /// SharedPreferences の JSON から復元する。
  factory OnboardingMedicationPlan.fromJson(Map<String, dynamic> json) => _$OnboardingMedicationPlanFromJson(json);
}
