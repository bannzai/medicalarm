// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiaryImpl _$$DiaryImplFromJson(Map<String, dynamic> json) => _$DiaryImpl(
      id: json['id'] as String,
      userID: json['userID'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      memos: (json['memos'] as List<dynamic>).map((e) => DiaryMemo.fromJson(e as Map<String, dynamic>)).toList(),
      memo: json['memo'] as String,
      diaryDate: const TimestampConverter().fromJson(json['diaryDate'] as Timestamp),
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$$DiaryImplToJson(_$DiaryImpl instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'tags': instance.tags,
      'memos': instance.memos.map((e) => e.toJson()).toList(),
      'memo': instance.memo,
      'diaryDate': const TimestampConverter().toJson(instance.diaryDate),
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };

_$DiaryMemoImpl _$$DiaryMemoImplFromJson(Map<String, dynamic> json) => _$DiaryMemoImpl(
      medicationHistory: MedicationHistory.fromJson(json['medicationHistory'] as Map<String, dynamic>),
      memo: json['memo'] as String,
      doseReceiver: DoseReceiver.fromJson(json['doseReceiver'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DiaryMemoImplToJson(_$DiaryMemoImpl instance) => <String, dynamic>{
      'medicationHistory': instance.medicationHistory.toJson(),
      'memo': instance.memo,
      'doseReceiver': instance.doseReceiver.toJson(),
    };
