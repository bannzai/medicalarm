import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'group_member_notification_settings.g.dart';
part 'group_member_notification_settings.freezed.dart';

/// グループ内の「自分だけ」の通知設定を表すエンティティ。
///
/// Firestore 上では `/groups/{groupID}/memberNotificationSettings/{userID}` に保存される。
/// [MedicationSchedule.notificationSetting] はテンプレート(共有デフォルト)として残り、
/// メンバーが個別に上書きした設定を [settings] に medicineID -> scheduleID の 2 段マップで持つ。
@freezed
abstract class GroupMemberNotificationSettings with _$GroupMemberNotificationSettings {
  const GroupMemberNotificationSettings._();

  @JsonSerializable(explicitToJson: true)
  const factory GroupMemberNotificationSettings({
    /// ドキュメント ID。userID と同一。
    required String id,
    required String groupID,
    required String userID,

    /// medicineID -> scheduleID -> 個別通知設定 の 2 段マップ。
    @Default({}) Map<String, Map<String, MemberScheduleNotificationSetting>> settings,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _GroupMemberNotificationSettings;

  factory GroupMemberNotificationSettings.fromJson(Map<String, dynamic> json) => _$GroupMemberNotificationSettingsFromJson(json);
}

/// メンバー個別の 1 スケジュール分の通知設定。
///
/// [MedicineScheduleNotificationSetting] と同じ項目に加え、端末個人の設定である
/// Focus 連携([focusConnectScheduleID])を含める。
@freezed
abstract class MemberScheduleNotificationSetting with _$MemberScheduleNotificationSetting {
  const MemberScheduleNotificationSetting._();

  @JsonSerializable(explicitToJson: true)
  const factory MemberScheduleNotificationSetting({
    required bool isReminderEnabled,
    required bool isFollowupEnabled,
    required bool useCriticalAlert,
    @Default(0.5) double criticalAlertVolume,
    @Default(false) bool useAlarmKit,

    /// Focus 連携も端末個人の設定なので個別部に含める。
    String? focusConnectScheduleID,
  }) = _MemberScheduleNotificationSetting;

  factory MemberScheduleNotificationSetting.fromJson(Map<String, dynamic> json) => _$MemberScheduleNotificationSettingFromJson(json);
}
