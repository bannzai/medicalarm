// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Medicine _$MedicineFromJson(Map<String, dynamic> json) => _Medicine(
      id: json['id'] as String,
      userID: json['userID'] as String,
      name: json['name'] as String,
      frequency: MedicationFrequency.fromJson(json['frequency'] as Map<String, dynamic>),
      schedules: (json['schedules'] as List<dynamic>).map((e) => MedicationSchedule.fromJson(e as Map<String, dynamic>)).toList(),
      doseReceiver: DoseReceiver.fromJson(json['doseReceiver'] as Map<String, dynamic>),
      memo: json['memo'] as String,
      memoImageURL: json['memoImageURL'] as String,
      archivedDateTime: const NullableTimestampConverter().fromJson(json['archivedDateTime'] as Timestamp?),
      pausedDateTime: const NullableTimestampConverter().fromJson(json['pausedDateTime'] as Timestamp?),
      beganDateTime: const TimestampConverter().fromJson(json['beganDateTime'] as Timestamp),
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$MedicineToJson(_Medicine instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'name': instance.name,
      'frequency': instance.frequency.toJson(),
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
      'doseReceiver': instance.doseReceiver.toJson(),
      'memo': instance.memo,
      'memoImageURL': instance.memoImageURL,
      'archivedDateTime': const NullableTimestampConverter().toJson(instance.archivedDateTime),
      'pausedDateTime': const NullableTimestampConverter().toJson(instance.pausedDateTime),
      'beganDateTime': const TimestampConverter().toJson(instance.beganDateTime),
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };

_MedicineScheduleNotificationSetting _$MedicineScheduleNotificationSettingFromJson(Map<String, dynamic> json) => _MedicineScheduleNotificationSetting(
      isReminderEnabled: json['isReminderEnabled'] as bool,
      isFollowupEnabled: json['isFollowupEnabled'] as bool,
      useCriticalAlert: json['useCriticalAlert'] as bool,
      criticalAlertVolume: (json['criticalAlertVolume'] as num?)?.toDouble() ?? 0.5,
      useAlarmKit: json['useAlarmKit'] as bool? ?? false,
    );

Map<String, dynamic> _$MedicineScheduleNotificationSettingToJson(_MedicineScheduleNotificationSetting instance) => <String, dynamic>{
      'isReminderEnabled': instance.isReminderEnabled,
      'isFollowupEnabled': instance.isFollowupEnabled,
      'useCriticalAlert': instance.useCriticalAlert,
      'criticalAlertVolume': instance.criticalAlertVolume,
      'useAlarmKit': instance.useAlarmKit,
    };

_MedicineScheduleFocusConnectSetting _$MedicineScheduleFocusConnectSettingFromJson(Map<String, dynamic> json) => _MedicineScheduleFocusConnectSetting(
      focusConnectScheduleID: json['focusConnectScheduleID'] as String?,
    );

Map<String, dynamic> _$MedicineScheduleFocusConnectSettingToJson(_MedicineScheduleFocusConnectSetting instance) => <String, dynamic>{
      'focusConnectScheduleID': instance.focusConnectScheduleID,
    };

_MedicationSchedule _$MedicationScheduleFromJson(Map<String, dynamic> json) => _MedicationSchedule(
      id: json['id'] as String,
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
      quantityMemo: json['quantityMemo'] as String,
      notificationSetting: MedicineScheduleNotificationSetting.fromJson(json['notificationSetting'] as Map<String, dynamic>),
      focusConnectSetting: json['focusConnectSetting'] == null
          ? null
          : MedicineScheduleFocusConnectSetting.fromJson(json['focusConnectSetting'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicationScheduleToJson(_MedicationSchedule instance) => <String, dynamic>{
      'id': instance.id,
      'hour': instance.hour,
      'minute': instance.minute,
      'quantityMemo': instance.quantityMemo,
      'notificationSetting': instance.notificationSetting.toJson(),
      'focusConnectSetting': instance.focusConnectSetting?.toJson(),
    };
