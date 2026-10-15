// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_medication_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingMedicationPlan _$OnboardingMedicationPlanFromJson(Map<String, dynamic> json) => _OnboardingMedicationPlan(
      userID: json['userID'] as String,
      groupID: json['groupID'] as String,
      doseReceiverID: json['doseReceiverID'] as String,
      createdDateTime: DateTime.parse(json['createdDateTime'] as String),
      schedules: (json['schedules'] as List<dynamic>).map((e) => MedicationSchedule.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$OnboardingMedicationPlanToJson(_OnboardingMedicationPlan instance) => <String, dynamic>{
      'userID': instance.userID,
      'groupID': instance.groupID,
      'doseReceiverID': instance.doseReceiverID,
      'createdDateTime': instance.createdDateTime.toIso8601String(),
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
    };
