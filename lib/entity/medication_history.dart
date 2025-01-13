import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'medication_history.freezed.dart';
part 'medication_history.g.dart';

@freezed
class MedicationHistory with _$MedicationHistory {
  const MedicationHistory._();
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistory({
    required String id,
    required Medicine medicine,
    required MedicationHistoryActionKind actionKind,
    required MedicationHistoryAction action,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _MedicationHistory;

  factory MedicationHistory.fromJson(Map<String, dynamic> json) => _$MedicationHistoryFromJson(json);
}

enum MedicationHistoryActionKind {
  take,
  revert,
  skip,
}

@freezed
sealed class MedicationHistoryAction with _$MedicationHistoryAction {
  // 服用
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistoryAction.take({
    @Default(MedicationHistoryActionKind.take) MedicationHistoryActionKind kind,
  }) = TakeMedicationHistoryAction;

  // 服用取り消し
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistoryAction.revert({
    @Default(MedicationHistoryActionKind.revert) MedicationHistoryActionKind kind,
    required MedicationHistory takeAction,
  }) = RevertMedicationHistoryAction;

  // 服用スキップ
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistoryAction.skip({
    @Default(MedicationHistoryActionKind.skip) MedicationHistoryActionKind kind,
  }) = SkipMedicationHistoryAction;

  const MedicationHistoryAction._();
  factory MedicationHistoryAction.fromJson(Map<String, dynamic> json) => _$MedicationHistoryActionFromJson(json);
}
