import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'medicine.g.dart';
part 'medicine.freezed.dart';

@freezed
class Medicine with _$Medicine {
  @JsonSerializable(explicitToJson: true)
  const factory Medicine({
    required String id,
    required String name,
    required String memo,
    required String memoImageURL,
    required List<MedicationSchedule> schedules,
    required MedicineNotificationSetting notificationSetting,
    required int? stock,
    required String? unit,
    required String? doseReceiverName,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _Medicine;
  const Medicine._();

  factory Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);
}

@freezed
class MedicineNotificationSetting with _$MedicineNotificationSetting {
  @JsonSerializable(explicitToJson: true)
  const factory MedicineNotificationSetting({
    required bool isReminderEnabled,
    required bool isFollowupEnabled,
    required bool useCriticalAlert,
  }) = _MedicineNotificationSetting;
  const MedicineNotificationSetting._();

  factory MedicineNotificationSetting.fromJson(Map<String, dynamic> json) => _$MedicineNotificationSettingFromJson(json);
}

@freezed
class MedicationSchedule with _$MedicationSchedule {
  @JsonSerializable(explicitToJson: true)
  const factory MedicationSchedule({
    required int hour,
    required int minute,
    // 服用量
    required int amount,
  }) = _MedicationSchedule;
  const MedicationSchedule._();

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) => _$MedicationScheduleFromJson(json);

  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(hour: hour, minute: minute);
  }
}
