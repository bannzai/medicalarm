import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/medicine.dart';
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

/// [medicine] の [schedule] について、[currentUserID] にとって有効な通知設定を解決する純粋関数。
///
/// ローカル通知の再登録([lib/utils/local_notification/])と通知個別設定 UI が共通で使う。
/// 解決規則:
/// 1. メンバー個別設定 [memberSettings] に (medicine.id, schedule.id) の設定があればそれをそのまま使う
/// 2. なければテンプレート [MedicationSchedule.notificationSetting] を使う。ただし [currentUserID] が
///    [medicine] の作成者(medicine.userID == currentUserID)でない場合は useCriticalAlert / useAlarmKit を
///    false に落とす(共有された薬の Critical Alert が他メンバーの端末で勝手に鳴らないようにするため)。
///    focusConnectScheduleID は作成者本人に限りテンプレート [MedicationSchedule.focusConnectSetting] から
///    引き継ぐ(グループ機能以前に Focus 連携を設定していた既存ユーザーの動作を移行後も維持するため)。
///    他メンバーには引き継がない(端末固有設定のため)。
MemberScheduleNotificationSetting resolveEffectiveNotificationSetting({
  required Medicine medicine,
  required MedicationSchedule schedule,
  required GroupMemberNotificationSettings? memberSettings,
  required String currentUserID,
}) {
  final memberSetting = memberSettings?.settings[medicine.id]?[schedule.id];
  if (memberSetting != null) {
    return memberSetting;
  }
  final isCreator = medicine.userID == currentUserID;
  return MemberScheduleNotificationSetting(
    isReminderEnabled: schedule.notificationSetting.isReminderEnabled,
    isFollowupEnabled: schedule.notificationSetting.isFollowupEnabled,
    useCriticalAlert: isCreator && schedule.notificationSetting.useCriticalAlert,
    criticalAlertVolume: schedule.notificationSetting.criticalAlertVolume,
    useAlarmKit: isCreator && schedule.notificationSetting.useAlarmKit,
    focusConnectScheduleID: isCreator ? schedule.focusConnectSetting?.focusConnectScheduleID : null,
  );
}
