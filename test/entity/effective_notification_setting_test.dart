import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/group_member_notification_settings.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medicine.dart';

/// テンプレート(共有デフォルト)側の通知設定。
/// Critical Alert / AlarmKit / Focus 連携をすべて有効にしておき、有効設定の解決で
/// これらが作成者判定・フォールバック規則によってどう扱われるかを検証する。
const _templateSchedule = MedicationSchedule(
  id: 'schedule-1',
  hour: 9,
  minute: 0,
  quantityMemo: '',
  notificationSetting: MedicineScheduleNotificationSetting(
    isReminderEnabled: true,
    isFollowupEnabled: true,
    useCriticalAlert: true,
    criticalAlertVolume: 0.8,
    useAlarmKit: true,
  ),
  focusConnectSetting: MedicineScheduleFocusConnectSetting(focusConnectScheduleID: 'template-focus'),
);

Medicine _buildMedicine({required String creatorUserID}) {
  return Medicine(
    id: 'medicine-1',
    userID: creatorUserID,
    name: 'テスト薬',
    frequency: const MedicationFrequency.daily(),
    schedules: const [_templateSchedule],
    doseReceiver: DoseReceiver(id: 'dose-1', userID: creatorUserID, name: '本人'),
    memo: '',
    memoImageURL: '',
    beganDateTime: DateTime(2026, 1, 1),
  );
}

GroupMemberNotificationSettings _buildMemberSettings({required String userID, required MemberScheduleNotificationSetting setting}) {
  return GroupMemberNotificationSettings(
    id: userID,
    groupID: 'group-1',
    userID: userID,
    settings: {
      'medicine-1': {'schedule-1': setting},
    },
  );
}

void main() {
  group('resolveEffectiveNotificationSetting', () {
    test('作成者 + 個別設定あり: 個別設定がそのまま返る', () {
      const memberSetting = MemberScheduleNotificationSetting(
        isReminderEnabled: false,
        isFollowupEnabled: false,
        useCriticalAlert: true,
        criticalAlertVolume: 0.3,
        useAlarmKit: true,
        focusConnectScheduleID: 'member-focus',
      );

      final result = resolveEffectiveNotificationSetting(
        medicine: _buildMedicine(creatorUserID: 'me'),
        schedule: _templateSchedule,
        memberSettings: _buildMemberSettings(userID: 'me', setting: memberSetting),
        currentUserID: 'me',
      );

      expect(result, memberSetting);
    });

    test('作成者 + 個別設定なし: テンプレートを使い Critical/AlarmKit/focusConnect をテンプレ値のまま引き継ぐ', () {
      final result = resolveEffectiveNotificationSetting(
        medicine: _buildMedicine(creatorUserID: 'me'),
        schedule: _templateSchedule,
        memberSettings: null,
        currentUserID: 'me',
      );

      expect(result.isReminderEnabled, true);
      expect(result.isFollowupEnabled, true);
      expect(result.useCriticalAlert, true);
      expect(result.criticalAlertVolume, 0.8);
      expect(result.useAlarmKit, true);
      // 作成者本人はテンプレートの focusConnectSetting を引き継ぐ(既存ユーザーの Focus 連携を移行後も維持)
      expect(result.focusConnectScheduleID, 'template-focus');
    });

    test('非作成者 + 個別設定あり: 明示した個別設定は非作成者でもそのまま有効', () {
      const memberSetting = MemberScheduleNotificationSetting(
        isReminderEnabled: true,
        isFollowupEnabled: false,
        useCriticalAlert: true,
        useAlarmKit: true,
        focusConnectScheduleID: 'member-focus',
      );

      final result = resolveEffectiveNotificationSetting(
        medicine: _buildMedicine(creatorUserID: 'other'),
        schedule: _templateSchedule,
        memberSettings: _buildMemberSettings(userID: 'me', setting: memberSetting),
        currentUserID: 'me',
      );

      expect(result, memberSetting);
      expect(result.useCriticalAlert, true);
      expect(result.useAlarmKit, true);
    });

    test('非作成者 + 個別設定なし: テンプレートを使うが Critical Alert / AlarmKit は false に落ちる', () {
      final result = resolveEffectiveNotificationSetting(
        medicine: _buildMedicine(creatorUserID: 'other'),
        schedule: _templateSchedule,
        memberSettings: null,
        currentUserID: 'me',
      );

      expect(result.isReminderEnabled, true);
      expect(result.isFollowupEnabled, true);
      expect(result.useCriticalAlert, false);
      expect(result.useAlarmKit, false);
      // 音量そのものはテンプレ値のまま(有効化フラグ側で無効化される)
      expect(result.criticalAlertVolume, 0.8);
      expect(result.focusConnectScheduleID, isNull);
    });

    test('focusConnect(個別設定あり): 個別設定の focusConnectScheduleID が最優先で返る', () {
      const memberSetting = MemberScheduleNotificationSetting(
        isReminderEnabled: true,
        isFollowupEnabled: false,
        useCriticalAlert: false,
        focusConnectScheduleID: 'member-focus',
      );

      expect(
        resolveEffectiveNotificationSetting(
          medicine: _buildMedicine(creatorUserID: 'me'),
          schedule: _templateSchedule,
          memberSettings: _buildMemberSettings(userID: 'me', setting: memberSetting),
          currentUserID: 'me',
        ).focusConnectScheduleID,
        'member-focus',
      );
    });

    test('focusConnect(作成者フォールバック): 個別設定が無ければテンプレートの focusConnectSetting を引き継ぐ', () {
      expect(
        resolveEffectiveNotificationSetting(
          medicine: _buildMedicine(creatorUserID: 'me'),
          schedule: _templateSchedule,
          memberSettings: null,
          currentUserID: 'me',
        ).focusConnectScheduleID,
        'template-focus',
      );
    });

    test('focusConnect(非作成者フォールバック): 個別設定が無ければテンプレートに設定があっても null', () {
      expect(
        resolveEffectiveNotificationSetting(
          medicine: _buildMedicine(creatorUserID: 'other'),
          schedule: _templateSchedule,
          memberSettings: null,
          currentUserID: 'me',
        ).focusConnectScheduleID,
        isNull,
      );
    });

    test('別 medicine/schedule の個別設定しか無い場合はテンプレートにフォールバックする', () {
      final result = resolveEffectiveNotificationSetting(
        medicine: _buildMedicine(creatorUserID: 'me'),
        schedule: _templateSchedule,
        memberSettings: const GroupMemberNotificationSettings(
          id: 'me',
          groupID: 'group-1',
          userID: 'me',
          settings: {
            'other-medicine': {
              'other-schedule': MemberScheduleNotificationSetting(
                isReminderEnabled: false,
                isFollowupEnabled: false,
                useCriticalAlert: false,
              ),
            },
          },
        ),
        currentUserID: 'me',
      );

      // 対象 medicine/schedule の個別設定が無いのでテンプレートベース(作成者なので focusConnect も引き継ぐ)
      expect(result.isReminderEnabled, true);
      expect(result.focusConnectScheduleID, 'template-focus');
    });
  });
}
