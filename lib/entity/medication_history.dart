import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:medicalarm/entity/timestamp.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/medicine.dart';

part 'medication_history.freezed.dart';
part 'medication_history.g.dart';

@freezed
abstract class MedicationHistory with _$MedicationHistory {
  const MedicationHistory._();
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistory({
    required String id,
    // 作成者(creator)の userID。グループ共有では記録した本人とは限らないため recordedByUserID を別途持つ。
    required String userID,
    // この記録を実際に行ったユーザーの uid。旧データには存在しないため nullable。新規記録では userID と同じ値が入る。
    String? recordedByUserID,
    required Medicine medicine,
    required MedicationHistoryActionKind actionKind,
    required MedicationHistoryAction action,
    required String memo,
    @TimestampConverter() required DateTime recordedDateTime,
    // 2025-01-19の服用予定だったのに、2025-01-20に服用した場合、scheduledRecordedDateは2025-01-20になる
    @TimestampConverter() required DateTime scheduledRecordedDate,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
    @NullableTimestampConverter() required DateTime ttlExpiresDateTime,
  }) = _MedicationHistory;

  factory MedicationHistory.fromJson(Map<String, dynamic> json) => _$MedicationHistoryFromJson(json);
}

enum MedicationHistoryActionKind {
  take,
  revert,
  skip,
}

/// 論理削除(revert アクションの追記)を考慮した「有効な服薬記録(take)」の一覧を返す (#253)。
/// take のうち、それを打ち消す revert が存在しないものだけが「服用済み」の根拠になる。
/// revert ドキュメント自体は同じコレクションに混在するため、take 以外は結果に含めない
List<MedicationHistory> effectiveTakeMedicationHistories(List<MedicationHistory> medicationHistories) {
  return medicationHistories
      .where((history) =>
          history.action is TakeMedicationHistoryAction &&
          !medicationHistories.any((other) => switch (other.action) {
                RevertMedicationHistoryAction(takeAction: final takeAction) => takeAction.id == history.id,
                TakeMedicationHistoryAction() || SkipMedicationHistoryAction() => false,
              }))
      .toList();
}

/// 指定した薬の直近の有効な服用(take)の記録日時を返す。有効な take が無い場合は null。
/// 最低服用間隔([Medicine.minimumDoseIntervalHours])の判定に使う (#81)
DateTime? latestEffectiveTakeRecordedDateTime({
  required List<MedicationHistory> medicationHistories,
  required String medicineID,
}) {
  return effectiveTakeMedicationHistories(medicationHistories)
      .where((history) => history.medicine.id == medicineID)
      .map((history) => history.recordedDateTime)
      .maxOrNull;
}

@freezed
sealed class MedicationHistoryAction with _$MedicationHistoryAction {
  // 服用
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistoryAction.take({
    @Default(MedicationHistoryActionKind.take) MedicationHistoryActionKind kind,
    required MedicationSchedule medicationSchedule,
    // 2025-01-19の服用予定だったのに、2025-01-20に服用した場合、scheduledRecordedDateは2025-01-20になる
    @TimestampConverter() required DateTime scheduledRecordedDate,
  }) = TakeMedicationHistoryAction;

  // 服用取り消し
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistoryAction.revert({
    @Default(MedicationHistoryActionKind.revert) MedicationHistoryActionKind kind,
    required MedicationHistory takeAction,
    required MedicationSchedule medicationSchedule,
  }) = RevertMedicationHistoryAction;

  // 服用スキップ
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistoryAction.skip({
    @Default(MedicationHistoryActionKind.skip) MedicationHistoryActionKind kind,
    required MedicationSchedule medicationSchedule,
  }) = SkipMedicationHistoryAction;

  const MedicationHistoryAction._();
  factory MedicationHistoryAction.fromJson(Map<String, dynamic> json) => _$MedicationHistoryActionFromJson(json);
}
