import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
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
abstract class Medicine with _$Medicine {
  @JsonSerializable(explicitToJson: true)
  const factory Medicine({
    required String id,
    // 作成者(creator)の userID。グループ共有では他メンバーが閲覧・記録することもあるため所有者ではなく作成者を表す。
    required String userID,
    required String name,
    required MedicationFrequency frequency,
    required List<MedicationSchedule> schedules,
    required DoseReceiver doseReceiver,
    required String memo,
    required String memoImageURL,
    // 前回の服用から最低限空ける時間(時間単位)。null は間隔設定なし。
    // 間隔が空いていない場合でも記録・通知は無効化せず、注意の表示だけを行う (#81)
    required int? minimumDoseIntervalHours,
    @NullableTimestampConverter() DateTime? archivedDateTime,
    @NullableTimestampConverter() DateTime? pausedDateTime,
    @TimestampConverter() required DateTime beganDateTime,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _Medicine;
  const Medicine._();

  factory Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);

  static int maxCount({required bool? hasPremiumEntitlement}) => hasPremiumEntitlement == true ? 10 : 2;
}

@freezed
abstract class MedicineScheduleNotificationSetting with _$MedicineScheduleNotificationSetting {
  @JsonSerializable(explicitToJson: true)
  const factory MedicineScheduleNotificationSetting({
    required bool isReminderEnabled,
    required bool isFollowupEnabled,
    required bool useCriticalAlert,
    @Default(0.5) double criticalAlertVolume,
    @Default(false) bool useAlarmKit,
  }) = _MedicineScheduleNotificationSetting;
  const MedicineScheduleNotificationSetting._();

  factory MedicineScheduleNotificationSetting.fromJson(Map<String, dynamic> json) => _$MedicineScheduleNotificationSettingFromJson(json);
}

@freezed
abstract class MedicineScheduleFocusConnectSetting with _$MedicineScheduleFocusConnectSetting {
  @JsonSerializable(explicitToJson: true)
  const factory MedicineScheduleFocusConnectSetting({
    String? focusConnectScheduleID,
  }) = _MedicineScheduleFocusConnectSetting;
  const MedicineScheduleFocusConnectSetting._();

  factory MedicineScheduleFocusConnectSetting.fromJson(Map<String, dynamic> json) => _$MedicineScheduleFocusConnectSettingFromJson(json);
}

@freezed
abstract class MedicationSchedule with _$MedicationSchedule {
  @JsonSerializable(explicitToJson: true)
  const factory MedicationSchedule({
    required String id,
    required int hour,
    required int minute,
    required String quantityMemo,
    required MedicineScheduleNotificationSetting notificationSetting,
    required MedicineScheduleFocusConnectSetting? focusConnectSetting,
  }) = _MedicationSchedule;
  const MedicationSchedule._();

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) => _$MedicationScheduleFromJson(json);

  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(hour: hour, minute: minute);
  }

  static int maxCount({required bool? hasPremiumEntitlement}) => hasPremiumEntitlement == true ? 5 : 2;
}
