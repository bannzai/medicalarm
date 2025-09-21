// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_frequency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyMedicationFrequency _$DailyMedicationFrequencyFromJson(Map<String, dynamic> json) => DailyMedicationFrequency(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$DailyMedicationFrequencyToJson(DailyMedicationFrequency instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

EveryXDaysMedicationFrequency _$EveryXDaysMedicationFrequencyFromJson(Map<String, dynamic> json) => EveryXDaysMedicationFrequency(
      interval: (json['interval'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$EveryXDaysMedicationFrequencyToJson(EveryXDaysMedicationFrequency instance) => <String, dynamic>{
      'interval': instance.interval,
      'runtimeType': instance.$type,
    };

SpecificWeekdaysMedicationFrequency _$SpecificWeekdaysMedicationFrequencyFromJson(Map<String, dynamic> json) => SpecificWeekdaysMedicationFrequency(
      weekdays: (json['weekdays'] as List<dynamic>).map((e) => $enumDecode(_$WeekdayEnumMap, e)).toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$SpecificWeekdaysMedicationFrequencyToJson(SpecificWeekdaysMedicationFrequency instance) => <String, dynamic>{
      'weekdays': instance.weekdays.map((e) => _$WeekdayEnumMap[e]!).toList(),
      'runtimeType': instance.$type,
    };

const _$WeekdayEnumMap = {
  Weekday.Sunday: 'Sunday',
  Weekday.Monday: 'Monday',
  Weekday.Tuesday: 'Tuesday',
  Weekday.Wednesday: 'Wednesday',
  Weekday.Thursday: 'Thursday',
  Weekday.Friday: 'Friday',
  Weekday.Saturday: 'Saturday',
};

CycleMedicationFrequency _$CycleMedicationFrequencyFromJson(Map<String, dynamic> json) => CycleMedicationFrequency(
      consecutiveDays: (json['consecutiveDays'] as num).toInt(),
      restDays: (json['restDays'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$CycleMedicationFrequencyToJson(CycleMedicationFrequency instance) => <String, dynamic>{
      'consecutiveDays': instance.consecutiveDays,
      'restDays': instance.restDays,
      'runtimeType': instance.$type,
    };
