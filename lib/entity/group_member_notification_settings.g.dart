// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupMemberNotificationSettings _$GroupMemberNotificationSettingsFromJson(Map<String, dynamic> json) => _GroupMemberNotificationSettings(
      id: json['id'] as String,
      groupID: json['groupID'] as String,
      userID: json['userID'] as String,
      settings: (json['settings'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as Map<String, dynamic>).map(
                  (k, e) => MapEntry(k, MemberScheduleNotificationSetting.fromJson(e as Map<String, dynamic>)),
                )),
          ) ??
          const {},
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$GroupMemberNotificationSettingsToJson(_GroupMemberNotificationSettings instance) => <String, dynamic>{
      'id': instance.id,
      'groupID': instance.groupID,
      'userID': instance.userID,
      'settings': instance.settings.map((k, e) => MapEntry(k, e.map((k, e) => MapEntry(k, e.toJson())))),
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };

_MemberScheduleNotificationSetting _$MemberScheduleNotificationSettingFromJson(Map<String, dynamic> json) => _MemberScheduleNotificationSetting(
      isReminderEnabled: json['isReminderEnabled'] as bool,
      isFollowupEnabled: json['isFollowupEnabled'] as bool,
      useCriticalAlert: json['useCriticalAlert'] as bool,
      criticalAlertVolume: (json['criticalAlertVolume'] as num?)?.toDouble() ?? 0.5,
      useAlarmKit: json['useAlarmKit'] as bool? ?? false,
      focusConnectScheduleID: json['focusConnectScheduleID'] as String?,
    );

Map<String, dynamic> _$MemberScheduleNotificationSettingToJson(_MemberScheduleNotificationSetting instance) => <String, dynamic>{
      'isReminderEnabled': instance.isReminderEnabled,
      'isFollowupEnabled': instance.isFollowupEnabled,
      'useCriticalAlert': instance.useCriticalAlert,
      'criticalAlertVolume': instance.criticalAlertVolume,
      'useAlarmKit': instance.useAlarmKit,
      'focusConnectScheduleID': instance.focusConnectScheduleID,
    };
