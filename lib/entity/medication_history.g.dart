// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicationHistory _$MedicationHistoryFromJson(Map<String, dynamic> json) => _MedicationHistory(
      id: json['id'] as String,
      userID: json['userID'] as String,
      medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
      actionKind: $enumDecode(_$MedicationHistoryActionKindEnumMap, json['actionKind']),
      action: MedicationHistoryAction.fromJson(json['action'] as Map<String, dynamic>),
      memo: json['memo'] as String,
      recordedDateTime: const TimestampConverter().fromJson(json['recordedDateTime'] as Timestamp),
      scheduledRecordedDate: const TimestampConverter().fromJson(json['scheduledRecordedDate'] as Timestamp),
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
      ttlExpiresDateTime: DateTime.parse(json['ttlExpiresDateTime'] as String),
    );

Map<String, dynamic> _$MedicationHistoryToJson(_MedicationHistory instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'medicine': instance.medicine.toJson(),
      'actionKind': _$MedicationHistoryActionKindEnumMap[instance.actionKind]!,
      'action': instance.action.toJson(),
      'memo': instance.memo,
      'recordedDateTime': const TimestampConverter().toJson(instance.recordedDateTime),
      'scheduledRecordedDate': const TimestampConverter().toJson(instance.scheduledRecordedDate),
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
      'ttlExpiresDateTime': instance.ttlExpiresDateTime.toIso8601String(),
    };

const _$MedicationHistoryActionKindEnumMap = {
  MedicationHistoryActionKind.take: 'take',
  MedicationHistoryActionKind.revert: 'revert',
  MedicationHistoryActionKind.skip: 'skip',
};

TakeMedicationHistoryAction _$TakeMedicationHistoryActionFromJson(Map<String, dynamic> json) => TakeMedicationHistoryAction(
      kind: $enumDecodeNullable(_$MedicationHistoryActionKindEnumMap, json['kind']) ?? MedicationHistoryActionKind.take,
      medicationSchedule: MedicationSchedule.fromJson(json['medicationSchedule'] as Map<String, dynamic>),
      scheduledRecordedDate: const TimestampConverter().fromJson(json['scheduledRecordedDate'] as Timestamp),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$TakeMedicationHistoryActionToJson(TakeMedicationHistoryAction instance) => <String, dynamic>{
      'kind': _$MedicationHistoryActionKindEnumMap[instance.kind]!,
      'medicationSchedule': instance.medicationSchedule.toJson(),
      'scheduledRecordedDate': const TimestampConverter().toJson(instance.scheduledRecordedDate),
      'runtimeType': instance.$type,
    };

RevertMedicationHistoryAction _$RevertMedicationHistoryActionFromJson(Map<String, dynamic> json) => RevertMedicationHistoryAction(
      kind: $enumDecodeNullable(_$MedicationHistoryActionKindEnumMap, json['kind']) ?? MedicationHistoryActionKind.revert,
      takeAction: MedicationHistory.fromJson(json['takeAction'] as Map<String, dynamic>),
      medicationSchedule: MedicationSchedule.fromJson(json['medicationSchedule'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$RevertMedicationHistoryActionToJson(RevertMedicationHistoryAction instance) => <String, dynamic>{
      'kind': _$MedicationHistoryActionKindEnumMap[instance.kind]!,
      'takeAction': instance.takeAction.toJson(),
      'medicationSchedule': instance.medicationSchedule.toJson(),
      'runtimeType': instance.$type,
    };

SkipMedicationHistoryAction _$SkipMedicationHistoryActionFromJson(Map<String, dynamic> json) => SkipMedicationHistoryAction(
      kind: $enumDecodeNullable(_$MedicationHistoryActionKindEnumMap, json['kind']) ?? MedicationHistoryActionKind.skip,
      medicationSchedule: MedicationSchedule.fromJson(json['medicationSchedule'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$SkipMedicationHistoryActionToJson(SkipMedicationHistoryAction instance) => <String, dynamic>{
      'kind': _$MedicationHistoryActionKindEnumMap[instance.kind]!,
      'medicationSchedule': instance.medicationSchedule.toJson(),
      'runtimeType': instance.$type,
    };
