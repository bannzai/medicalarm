// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicineImpl _$$MedicineImplFromJson(Map<String, dynamic> json) => _$MedicineImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      frequency: MedicationFrequency.fromJson(json['frequency'] as Map<String, dynamic>),
      schedules: (json['schedules'] as List<dynamic>).map((e) => MedicationSchedule.fromJson(e as Map<String, dynamic>)).toList(),
      notificationSetting: MedicineNotificationSetting.fromJson(json['notificationSetting'] as Map<String, dynamic>),
      stock: (json['stock'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      doseReceiver: json['doseReceiver'] == null ? null : MedicineDoseReceiver.fromJson(json['doseReceiver'] as Map<String, dynamic>),
      memo: json['memo'] as String,
      memoImageURL: json['memoImageURL'] as String,
      createdDateTime: const ClientCreatedTimestamp().fromJson(json['createdDateTime'] as Timestamp?),
      updatedDateTime: const ClientUpdatedTimestamp().fromJson(json['updatedDateTime'] as Timestamp?),
      serverCreatedDateTime: const ServerCreatedTimestamp().fromJson(json['serverCreatedDateTime']),
      serverUpdatedDateTime: const ServerUpdatedTimestamp().fromJson(json['serverUpdatedDateTime']),
    );

Map<String, dynamic> _$$MedicineImplToJson(_$MedicineImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'frequency': instance.frequency.toJson(),
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
      'notificationSetting': instance.notificationSetting.toJson(),
      'stock': instance.stock,
      'unit': instance.unit,
      'doseReceiver': instance.doseReceiver?.toJson(),
      'memo': instance.memo,
      'memoImageURL': instance.memoImageURL,
      'createdDateTime': const ClientCreatedTimestamp().toJson(instance.createdDateTime),
      'updatedDateTime': const ClientUpdatedTimestamp().toJson(instance.updatedDateTime),
      'serverCreatedDateTime': const ServerCreatedTimestamp().toJson(instance.serverCreatedDateTime),
      'serverUpdatedDateTime': const ServerUpdatedTimestamp().toJson(instance.serverUpdatedDateTime),
    };

_$MedicineNotificationSettingImpl _$$MedicineNotificationSettingImplFromJson(Map<String, dynamic> json) => _$MedicineNotificationSettingImpl(
      isReminderEnabled: json['isReminderEnabled'] as bool,
      isFollowupEnabled: json['isFollowupEnabled'] as bool,
      useCriticalAlert: json['useCriticalAlert'] as bool,
    );

Map<String, dynamic> _$$MedicineNotificationSettingImplToJson(_$MedicineNotificationSettingImpl instance) => <String, dynamic>{
      'isReminderEnabled': instance.isReminderEnabled,
      'isFollowupEnabled': instance.isFollowupEnabled,
      'useCriticalAlert': instance.useCriticalAlert,
    };

_$MedicationScheduleImpl _$$MedicationScheduleImplFromJson(Map<String, dynamic> json) => _$MedicationScheduleImpl(
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MedicationScheduleImplToJson(_$MedicationScheduleImpl instance) => <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
      'amount': instance.amount,
    };

_$MedicineDoseReceiverImpl _$$MedicineDoseReceiverImplFromJson(Map<String, dynamic> json) => _$MedicineDoseReceiverImpl(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$MedicineDoseReceiverImplToJson(_$MedicineDoseReceiverImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
