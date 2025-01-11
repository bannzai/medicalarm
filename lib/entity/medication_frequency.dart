import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_frequency.freezed.dart';
part 'medication_frequency.g.dart';

@freezed
sealed class MedicationFrequency with _$MedicationFrequency {
  // 毎日
  @JsonSerializable(explicitToJson: true)
  const factory MedicationFrequency.daily() = DailyMedicationFrequency;

  // X日ごと
  @JsonSerializable(explicitToJson: true)
  const factory MedicationFrequency.everyXDays({
    required int interval,
  }) = EveryXDaysMedicationFrequency;

  // 特定の曜日
  @JsonSerializable(explicitToJson: true)
  const factory MedicationFrequency.specificDayOfWeek({
    required List<int> daysOfWeek,
  }) = SpecificDayOfWeekMedicationFrequency;

  // 月の特定日
  @JsonSerializable(explicitToJson: true)
  const factory MedicationFrequency.specificDayOfMonth({
    required List<int> daysOfMonth,
  }) = SpecificDayOfMonthMedicationFrequency;

  // 奇数日 / 偶数日
  @JsonSerializable(explicitToJson: true)
  const factory MedicationFrequency.oddOrEvenDay({
    required bool isOddDay,
  }) = OddOrEvenDayMedicationFrequency;

  // 周期
  @JsonSerializable(explicitToJson: true)
  const factory MedicationFrequency.cycle({
    // 連続服用日数
    required int consecutiveDays,
    // 休薬日数
    required int restDays,
  }) = CycleMedicationFrequency;

  factory MedicationFrequency.fromJson(Map<String, dynamic> json) => _$MedicationFrequencyFromJson(json);
}
