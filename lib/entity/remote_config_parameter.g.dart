// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RemoteConfigParameter _$RemoteConfigParameterFromJson(Map<String, dynamic> json) => _RemoteConfigParameter(
      minimumAppVersion: json['minimumAppVersion'] as String? ?? RemoteConfigParameterDefaultValues.minimumAppVersion,
      promotionDayCount: (json['promotionDayCount'] as num?)?.toInt() ?? RemoteConfigParameterDefaultValues.promotionDayCount,
      releasedVersion: json['releasedVersion'] as String? ?? RemoteConfigParameterDefaultValues.releasedVersion,
    );

Map<String, dynamic> _$RemoteConfigParameterToJson(_RemoteConfigParameter instance) => <String, dynamic>{
      'minimumAppVersion': instance.minimumAppVersion,
      'promotionDayCount': instance.promotionDayCount,
      'releasedVersion': instance.releasedVersion,
    };
