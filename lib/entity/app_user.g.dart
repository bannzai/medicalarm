// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
      id: json['id'] as String?,
      defaultGroupID: json['defaultGroupID'] as String?,
      groupMigratedDateTime: const NullableTimestampConverter().fromJson(json['groupMigratedDateTime'] as Timestamp?),
      analyticsDebugIsEnabled: json['analyticsDebugIsEnabled'] as bool? ?? false,
      maybeTrialDeadlineDate: const NullableTimestampConverter().fromJson(json['maybeTrialDeadlineDate'] as Timestamp?),
      promotionStartPageCancelButtonTappedDateTime:
          const NullableTimestampConverter().fromJson(json['promotionStartPageCancelButtonTappedDateTime'] as Timestamp?),
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'defaultGroupID': instance.defaultGroupID,
      'groupMigratedDateTime': const NullableTimestampConverter().toJson(instance.groupMigratedDateTime),
      'analyticsDebugIsEnabled': instance.analyticsDebugIsEnabled,
      'maybeTrialDeadlineDate': const NullableTimestampConverter().toJson(instance.maybeTrialDeadlineDate),
      'promotionStartPageCancelButtonTappedDateTime':
          const NullableTimestampConverter().toJson(instance.promotionStartPageCancelButtonTappedDateTime),
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };
