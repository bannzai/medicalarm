import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

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
        DailyMedicationFrequency() => L.daily,
        EveryXDaysMedicationFrequency(interval: final interval) => L.everyXDaysFormat(interval),
        SpecificWeekdaysMedicationFrequency(weekdays: final weekdays) => weekdays.map((weekday) => weekday.weekdayShortString()).join(','),
        CycleMedicationFrequency(consecutiveDays: final consecutiveDays, restDays: final restDays) => L.cycleDaysFormat(consecutiveDays, restDays),
      };
}
