// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_receiver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DoseReceiverImpl _$$DoseReceiverImplFromJson(Map<String, dynamic> json) => _$DoseReceiverImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$$DoseReceiverImplToJson(_$DoseReceiverImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };
