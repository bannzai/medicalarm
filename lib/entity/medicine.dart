import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'medicine.g.dart';
part 'medicine.freezed.dart';

// NOTE:
// "Medicine" は「薬」そのものを指すため、服薬に限らず、薬に関連する通知（例: 購入リマインダーやストック通知など）も含めた広義の意味で使えます。
// 「薬」という単語に焦点を当てたい場合。
// "Medication" は「服薬」を意味し、薬を飲む行為やそれに関連する情報を強調します。
// 服薬管理を主目的としたアプリで、薬の管理全般よりも服薬行為に焦点を当てている場合。

@freezed
class Medicine with _$Medicine {
  @JsonSerializable(explicitToJson: true)
  const factory Medicine({
    required String id,
    required String userID,
    required String name,
    required MedicationFrequency frequency,
    required List<MedicationSchedule> schedules,
    // null の場合は デフォルトdoseReciver(=User,自分)として扱う
    required MedicineDoseReceiver? doseReceiver,
    required String memo,
    required String memoImageURL,
    @NullableTimestampConverter() DateTime? archivedDateTime,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _Medicine;
  const Medicine._();

  factory Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);
}

@freezed
class MedicineScheduleNotificationSetting with _$MedicineScheduleNotificationSetting {
  @JsonSerializable(explicitToJson: true)
  const factory MedicineScheduleNotificationSetting({
    required bool isReminderEnabled,
    required bool isFollowupEnabled,
    required bool useCriticalAlert,
  }) = _MedicineScheduleNotificationSetting;
  const MedicineScheduleNotificationSetting._();

  factory MedicineScheduleNotificationSetting.fromJson(Map<String, dynamic> json) => _$MedicineScheduleNotificationSettingFromJson(json);
}

@freezed
class MedicationSchedule with _$MedicationSchedule {
  @JsonSerializable(explicitToJson: true)
  const factory MedicationSchedule({
    required int hour,
    required int minute,
    required String quantityMemo,
    required MedicineScheduleNotificationSetting notificationSetting,
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

@freezed
class MedicineDoseReceiver with _$MedicineDoseReceiver {
  @JsonSerializable(explicitToJson: true)
  const factory MedicineDoseReceiver({
    // lib/entity/DoseReceiver とは同期をとってないので、IDがnot foundの可能性がある
    required String id,
    required String name,
  }) = _MedicineDoseReceiver;
  const MedicineDoseReceiver._();

  factory MedicineDoseReceiver.fromJson(Map<String, dynamic> json) => _$MedicineDoseReceiverFromJson(json);
}
