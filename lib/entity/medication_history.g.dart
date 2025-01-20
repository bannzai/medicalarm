// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicationHistoryImpl _$$MedicationHistoryImplFromJson(Map<String, dynamic> json) => _$MedicationHistoryImpl(
      id: json['id'] as String,
      userID: json['userID'] as String,
      medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
      actionKind: $enumDecode(_$MedicationHistoryActionKindEnumMap, json['actionKind']),
      action: MedicationHistoryAction.fromJson(json['action'] as Map<String, dynamic>),
      memo: json['memo'] as String,
      recordedDateTime: const TimestampConverter().fromJson(json['recordedDateTime'] as Timestamp),
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$$MedicationHistoryImplToJson(_$MedicationHistoryImpl instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'medicine': instance.medicine.toJson(),
      'actionKind': _$MedicationHistoryActionKindEnumMap[instance.actionKind]!,
      'action': instance.action.toJson(),
      'memo': instance.memo,
      'recordedDateTime': const TimestampConverter().toJson(instance.recordedDateTime),
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };

const _$MedicationHistoryActionKindEnumMap = {
  MedicationHistoryActionKind.take: 'take',
  MedicationHistoryActionKind.revert: 'revert',
  MedicationHistoryActionKind.skip: 'skip',
};

_$TakeMedicationHistoryActionImpl _$$TakeMedicationHistoryActionImplFromJson(Map<String, dynamic> json) => _$TakeMedicationHistoryActionImpl(
      kind: $enumDecodeNullable(_$MedicationHistoryActionKindEnumMap, json['kind']) ?? MedicationHistoryActionKind.take,
      medicationSchedule: MedicationSchedule.fromJson(json['medicationSchedule'] as Map<String, dynamic>),
      scheduledRecordedDate: DateTime.parse(json['scheduledRecordedDate'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TakeMedicationHistoryActionImplToJson(_$TakeMedicationHistoryActionImpl instance) => <String, dynamic>{
      'kind': _$MedicationHistoryActionKindEnumMap[instance.kind]!,
      'medicationSchedule': instance.medicationSchedule.toJson(),
      'scheduledRecordedDate': instance.scheduledRecordedDate.toIso8601String(),
      'runtimeType': instance.$type,
    };

_$RevertMedicationHistoryActionImpl _$$RevertMedicationHistoryActionImplFromJson(Map<String, dynamic> json) => _$RevertMedicationHistoryActionImpl(
      kind: $enumDecodeNullable(_$MedicationHistoryActionKindEnumMap, json['kind']) ?? MedicationHistoryActionKind.revert,
      takeAction: MedicationHistory.fromJson(json['takeAction'] as Map<String, dynamic>),
      medicationSchedule: MedicationSchedule.fromJson(json['medicationSchedule'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RevertMedicationHistoryActionImplToJson(_$RevertMedicationHistoryActionImpl instance) => <String, dynamic>{
      'kind': _$MedicationHistoryActionKindEnumMap[instance.kind]!,
      'takeAction': instance.takeAction.toJson(),
      'medicationSchedule': instance.medicationSchedule.toJson(),
      'runtimeType': instance.$type,
    };

_$SkipMedicationHistoryActionImpl _$$SkipMedicationHistoryActionImplFromJson(Map<String, dynamic> json) => _$SkipMedicationHistoryActionImpl(
      kind: $enumDecodeNullable(_$MedicationHistoryActionKindEnumMap, json['kind']) ?? MedicationHistoryActionKind.skip,
      medicationSchedule: MedicationSchedule.fromJson(json['medicationSchedule'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SkipMedicationHistoryActionImplToJson(_$SkipMedicationHistoryActionImpl instance) => <String, dynamic>{
      'kind': _$MedicationHistoryActionKindEnumMap[instance.kind]!,
      'medicationSchedule': instance.medicationSchedule.toJson(),
      'runtimeType': instance.$type,
    };
