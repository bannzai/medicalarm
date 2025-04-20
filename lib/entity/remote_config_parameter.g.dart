// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemoteConfigParameterImpl _$$RemoteConfigParameterImplFromJson(Map<String, dynamic> json) => _$RemoteConfigParameterImpl(
      minimumAppVersion: json['minimumAppVersion'] as String? ?? RemoteConfigParameterDefaultValues.minimumAppVersion,
      promotionDayCount: (json['promotionDayCount'] as num?)?.toInt() ?? RemoteConfigParameterDefaultValues.promotionDayCount,
      releasedVersion: json['releasedVersion'] as String? ?? RemoteConfigParameterDefaultValues.releasedVersion,
    );

Map<String, dynamic> _$$RemoteConfigParameterImplToJson(_$RemoteConfigParameterImpl instance) => <String, dynamic>{
      'minimumAppVersion': instance.minimumAppVersion,
      'promotionDayCount': instance.promotionDayCount,
      'releasedVersion': instance.releasedVersion,
    };
