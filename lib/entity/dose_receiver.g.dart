// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_receiver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DoseReceiver _$DoseReceiverFromJson(Map<String, dynamic> json) => _DoseReceiver(
      id: json['id'] as String,
      userID: json['userID'] as String,
      name: json['name'] as String,
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$DoseReceiverToJson(_DoseReceiver instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'name': instance.name,
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };
