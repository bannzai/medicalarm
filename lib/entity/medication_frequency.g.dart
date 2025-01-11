// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_frequency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyMedicationFrequencyImpl _$$DailyMedicationFrequencyImplFromJson(Map<String, dynamic> json) => _$DailyMedicationFrequencyImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DailyMedicationFrequencyImplToJson(_$DailyMedicationFrequencyImpl instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$EveryXDaysMedicationFrequencyImpl _$$EveryXDaysMedicationFrequencyImplFromJson(Map<String, dynamic> json) => _$EveryXDaysMedicationFrequencyImpl(
      interval: (json['interval'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$EveryXDaysMedicationFrequencyImplToJson(_$EveryXDaysMedicationFrequencyImpl instance) => <String, dynamic>{
      'interval': instance.interval,
      'runtimeType': instance.$type,
    };

_$SpecificDayOfWeekMedicationFrequencyImpl _$$SpecificDayOfWeekMedicationFrequencyImplFromJson(Map<String, dynamic> json) =>
    _$SpecificDayOfWeekMedicationFrequencyImpl(
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SpecificDayOfWeekMedicationFrequencyImplToJson(_$SpecificDayOfWeekMedicationFrequencyImpl instance) => <String, dynamic>{
      'daysOfWeek': instance.daysOfWeek,
      'runtimeType': instance.$type,
    };

_$SpecificDayOfMonthMedicationFrequencyImpl _$$SpecificDayOfMonthMedicationFrequencyImplFromJson(Map<String, dynamic> json) =>
    _$SpecificDayOfMonthMedicationFrequencyImpl(
      daysOfMonth: (json['daysOfMonth'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SpecificDayOfMonthMedicationFrequencyImplToJson(_$SpecificDayOfMonthMedicationFrequencyImpl instance) => <String, dynamic>{
      'daysOfMonth': instance.daysOfMonth,
      'runtimeType': instance.$type,
    };

_$OddOrEvenDayMedicationFrequencyImpl _$$OddOrEvenDayMedicationFrequencyImplFromJson(Map<String, dynamic> json) =>
    _$OddOrEvenDayMedicationFrequencyImpl(
      isOddDay: json['isOddDay'] as bool,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$OddOrEvenDayMedicationFrequencyImplToJson(_$OddOrEvenDayMedicationFrequencyImpl instance) => <String, dynamic>{
      'isOddDay': instance.isOddDay,
      'runtimeType': instance.$type,
    };

_$CycleMedicationFrequencyImpl _$$CycleMedicationFrequencyImplFromJson(Map<String, dynamic> json) => _$CycleMedicationFrequencyImpl(
      consecutiveDays: (json['consecutiveDays'] as num).toInt(),
      restDays: (json['restDays'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$CycleMedicationFrequencyImplToJson(_$CycleMedicationFrequencyImpl instance) => <String, dynamic>{
      'consecutiveDays': instance.consecutiveDays,
      'restDays': instance.restDays,
      'runtimeType': instance.$type,
    };
