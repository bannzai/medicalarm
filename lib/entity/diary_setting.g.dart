// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiarySettingImpl _$$DiarySettingImplFromJson(Map<String, dynamic> json) => _$DiarySettingImpl(
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$$DiarySettingImplToJson(_$DiarySettingImpl instance) => <String, dynamic>{
      'tags': instance.tags,
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };
