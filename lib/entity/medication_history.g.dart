// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicationHistoryImpl _$$MedicationHistoryImplFromJson(Map<String, dynamic> json) => _$MedicationHistoryImpl(
      id: json['id'] as String,
      medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
      actionKind: $enumDecode(_$MedicationHistoryActionKindEnumMap, json['actionKind']),
      action: MedicationHistoryAction.fromJson(json['action'] as Map<String, dynamic>),
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$$MedicationHistoryImplToJson(_$MedicationHistoryImpl instance) => <String, dynamic>{
      'id': instance.id,
      'medicine': instance.medicine.toJson(),
      'actionKind': _$MedicationHistoryActionKindEnumMap[instance.actionKind]!,
      'action': instance.action.toJson(),
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
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TakeMedicationHistoryActionImplToJson(_$TakeMedicationHistoryActionImpl instance) => <String, dynamic>{
      'kind': _$MedicationHistoryActionKindEnumMap[instance.kind]!,
      'runtimeType': instance.$type,
    };

_$RevertMedicationHistoryActionImpl _$$RevertMedicationHistoryActionImplFromJson(Map<String, dynamic> json) => _$RevertMedicationHistoryActionImpl(
      kind: $enumDecodeNullable(_$MedicationHistoryActionKindEnumMap, json['kind']) ?? MedicationHistoryActionKind.revert,
      takeAction: MedicationHistory.fromJson(json['takeAction'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RevertMedicationHistoryActionImplToJson(_$RevertMedicationHistoryActionImpl instance) => <String, dynamic>{
      'kind': _$MedicationHistoryActionKindEnumMap[instance.kind]!,
      'takeAction': instance.takeAction.toJson(),
      'runtimeType': instance.$type,
    };

_$SkipMedicationHistoryActionImpl _$$SkipMedicationHistoryActionImplFromJson(Map<String, dynamic> json) => _$SkipMedicationHistoryActionImpl(
      kind: $enumDecodeNullable(_$MedicationHistoryActionKindEnumMap, json['kind']) ?? MedicationHistoryActionKind.skip,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SkipMedicationHistoryActionImplToJson(_$SkipMedicationHistoryActionImpl instance) => <String, dynamic>{
      'kind': _$MedicationHistoryActionKindEnumMap[instance.kind]!,
      'runtimeType': instance.$type,
    };
