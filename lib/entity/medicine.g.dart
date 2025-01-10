// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicineImpl _$$MedicineImplFromJson(Map<String, dynamic> json) => _$MedicineImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      memo: json['memo'] as String,
      memoImageURL: json['memoImageURL'] as String,
      notifications: (json['notifications'] as List<dynamic>).map((e) => MedicineNotificationSetting.fromJson(e as Map<String, dynamic>)).toList(),
      stock: (json['stock'] as num?)?.toInt(),
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$$MedicineImplToJson(_$MedicineImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'memo': instance.memo,
      'memoImageURL': instance.memoImageURL,
      'notifications': instance.notifications.map((e) => e.toJson()).toList(),
      'stock': instance.stock,
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };

_$MedicineNotificationSettingImpl _$$MedicineNotificationSettingImplFromJson(Map<String, dynamic> json) => _$MedicineNotificationSettingImpl(
      dosingCount: (json['dosingCount'] as num).toInt(),
      reminderTime: MedicineNotificationSettingReminderTime.fromJson(json['reminderTime'] as Map<String, dynamic>),
      isEnabled: json['isEnabled'] as bool,
      useCriticalAlert: json['useCriticalAlert'] as bool,
    );

Map<String, dynamic> _$$MedicineNotificationSettingImplToJson(_$MedicineNotificationSettingImpl instance) => <String, dynamic>{
      'dosingCount': instance.dosingCount,
      'reminderTime': instance.reminderTime.toJson(),
      'isEnabled': instance.isEnabled,
      'useCriticalAlert': instance.useCriticalAlert,
    };

_$MedicineNotificationSettingReminderTimeImpl _$$MedicineNotificationSettingReminderTimeImplFromJson(Map<String, dynamic> json) =>
    _$MedicineNotificationSettingReminderTimeImpl(
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
    );

Map<String, dynamic> _$$MedicineNotificationSettingReminderTimeImplToJson(_$MedicineNotificationSettingReminderTimeImpl instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };
