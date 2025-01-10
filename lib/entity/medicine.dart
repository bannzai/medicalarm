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
    required List<MedicineNotificationSetting> notifications,
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
class MedicineNotificationSetting with _$MedicineNotificationSetting {
  @JsonSerializable(explicitToJson: true)
  const factory MedicineNotificationSetting({
    required int dosingCount,
    required MedicineNotificationSettingReminderTime reminderTime,
    required bool isEnabled,
    required bool useCriticalAlert,
    required String who,
  }) = _MedicineNotificationSetting;
  const MedicineNotificationSetting._();

  factory MedicineNotificationSetting.fromJson(Map<String, dynamic> json) => _$MedicineNotificationSettingFromJson(json);
}

@freezed
class MedicineNotificationSettingReminderTime with _$MedicineNotificationSettingReminderTime {
  @JsonSerializable(explicitToJson: true)
  const factory MedicineNotificationSettingReminderTime({
    required int hour,
    required int minute,
  }) = _MedicineNotificationSettingReminderTime;
  const MedicineNotificationSettingReminderTime._();

  factory MedicineNotificationSettingReminderTime.fromJson(Map<String, dynamic> json) => _$MedicineNotificationSettingReminderTimeFromJson(json);
}
