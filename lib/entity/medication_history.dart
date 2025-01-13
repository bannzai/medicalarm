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
    required MedicationHistoryAction action,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _MedicationHistory;

  factory MedicationHistory.fromJson(Map<String, dynamic> json) => _$MedicationHistoryFromJson(json);
}

enum MedicationHistoryActionKind   {
  take,
  revert,
  skip,
}

@freezed
class MedicationHistoryAction with _$MedicationHistoryAction {
  // 服用
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistoryAction.take() = TakeMedicationHistoryAction;

  // 服用予定
  @JsonSerializable(explicitToJson: true)
  const factory MedicationHistoryAction.take() = TakeMedicationHistoryAction;

  // 特定の曜日
  @JsonSerializable(explicitToJson: true)
  const factory MedicationFrequency.specificWeekdays({
    required List<Weekday> weekdays,
  }) = SpecificWeekdaysMedicationFrequency;

  // 周期
  @JsonSerializable(explicitToJson: true)
  const factory MedicationFrequency.cycle({
    // 連続服用日数
    required int consecutiveDays,
    // 休薬日数
    required int restDays,
  }) = CycleMedicationFrequency;

  const MedicationFrequency._();
  factory MedicationFrequency.fromJson(Map<String, dynamic> json) => _$MedicationFrequencyFromJson(json);

  String get displayName => switch (this) {
        DailyMedicationFrequency() => '毎日',
        EveryXDaysMedicationFrequency(interval: finakl interval) => '$interval日ごと',
        SpecificWeekdaysMedicationFrequency(weekdays: final weekdays) => weekdays.map((weekday) => weekday.weekdayShortString()).join(','),
        CycleMedicationFrequency(consecutiveDays: final consecutiveDays, restDays: final restDays) => '$consecutiveDays日服用/$restDays日休薬',
      };
}
