import 'package:cloud_firestore/cloud_firestore.dart';
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
    required List<MedicineNotification> notifications,
    required int? stock,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _Medicine;
  const Medicine._();

  factory Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);
}

@freezed
class MedicineNotification with _$MedicineNotification {
  @JsonSerializable(explicitToJson: true)
  const factory MedicineNotification({
    required int dosingCount,
    required MedicineNotificationReminderTime reminderTime,
    required bool isEnabled,
    required bool useCriticalAlert,
  }) = _MedicineNotification;
  const MedicineNotification._();

  factory MedicineNotification.fromJson(Map<String, dynamic> json) => _$MedicineNotificationFromJson(json);
}

@freezed
class MedicineNotificationReminderTime with _$MedicineNotificationReminderTime {
  @JsonSerializable(explicitToJson: true)
  const factory MedicineNotificationReminderTime({
    required int hour,
    required int minute,
  }) = _MedicineNotificationReminderTime;
  const MedicineNotificationReminderTime._();

  factory MedicineNotificationReminderTime.fromJson(Map<String, dynamic> json) => _$MedicineNotificationReminderTimeFromJson(json);
}
