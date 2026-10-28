import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/entity/group_invitation.dart';
import 'package:medicalarm/entity/group_member_notification_settings.dart';
import 'package:medicalarm/entity/group_user_profile.dart';

void main() {
  // Firestore ドキュメント相当の Map からの復元を検証する。
  group('Group.fromJson / toJson', () {
    test('全フィールドを復元できる', () {
      final group = Group.fromJson({
        'id': 'group-1',
        'memberUserIDs': ['user-a', 'user-b'],
        'name': '家族',
        'ownerUserID': 'user-a',
        'iconName': 'family',
        'createdDateTime': Timestamp.fromDate(DateTime(2026, 1, 1)),
        'updatedDateTime': Timestamp.fromDate(DateTime(2026, 1, 2)),
        'serverCreatedDateTime': Timestamp.fromDate(DateTime(2026, 1, 1)),
        'serverUpdatedDateTime': Timestamp.fromDate(DateTime(2026, 1, 2)),
      });

      expect(group.id, 'group-1');
      expect(group.memberUserIDs, ['user-a', 'user-b']);
      expect(group.name, '家族');
      expect(group.ownerUserID, 'user-a');
      expect(group.iconName, 'family');

      final json = group.toJson();
      expect(json['memberUserIDs'], ['user-a', 'user-b']);
      expect(json['name'], '家族');
      expect(json['iconName'], 'family');
    });

    test('iconName が無いドキュメントは home にフォールバックする', () {
      final group = Group.fromJson({
        'id': 'group-2',
        'memberUserIDs': ['user-a'],
        'name': null,
        'ownerUserID': null,
      });

      expect(group.iconName, 'home');
      expect(group.name, isNull);
      expect(group.ownerUserID, isNull);
    });
  });

  group('GroupInvitation', () {
    test('status 文字列を enum に相互変換できる', () {
      final invitation = GroupInvitation.fromJson({
        'id': 'invitation-1',
        'groupID': 'group-1',
        'inviterUserID': 'user-a',
        'invitationCode': 'ABCD2345',
        'status': 'pending',
        'expiresDateTime': Timestamp.fromDate(DateTime(2026, 1, 8)),
      });

      expect(invitation.status, GroupInvitationStatus.pending);
      expect(invitation.invitationCode, 'ABCD2345');
      expect(invitation.toJson()['status'], 'pending');
    });
  });

  group('GroupUserProfile', () {
    test('複合 documentID を生成できる', () {
      expect(
        GroupUserProfile.documentID(groupID: 'group-1', userID: 'user-a'),
        'GroupUserProfile_groups_group-1_users_user-a',
      );
    });

    test('fromJson で displayName を復元できる', () {
      final profile = GroupUserProfile.fromJson({
        'id': 'GroupUserProfile_groups_group-1_users_user-a',
        'groupID': 'group-1',
        'userID': 'user-a',
        'displayName': 'お母さん',
      });

      expect(profile.groupID, 'group-1');
      expect(profile.userID, 'user-a');
      expect(profile.displayName, 'お母さん');
    });
  });

  group('GroupMemberNotificationSettings', () {
    test('ネストした settings マップを復元できる', () {
      final settings = GroupMemberNotificationSettings.fromJson({
        'id': 'user-a',
        'groupID': 'group-1',
        'userID': 'user-a',
        'settings': {
          'medicine-1': {
            'schedule-1': {
              'isReminderEnabled': true,
              'isFollowupEnabled': false,
              'useCriticalAlert': true,
              'criticalAlertVolume': 0.8,
              'useAlarmKit': false,
              'focusConnectScheduleID': 'focus-1',
            },
          },
        },
      });

      final setting = settings.settings['medicine-1']!['schedule-1']!;
      expect(setting.isReminderEnabled, true);
      expect(setting.useCriticalAlert, true);
      expect(setting.criticalAlertVolume, 0.8);
      expect(setting.focusConnectScheduleID, 'focus-1');
    });

    test('settings が無い場合は空マップになる', () {
      final settings = GroupMemberNotificationSettings.fromJson({
        'id': 'user-a',
        'groupID': 'group-1',
        'userID': 'user-a',
      });

      expect(settings.settings, isEmpty);
    });
  });

  // 通知設定にはタイムスタンプが無いため toJson/fromJson の完全ラウンドトリップを検証する。
  group('MemberScheduleNotificationSetting roundtrip', () {
    test('toJson した値を fromJson で復元しても等しい', () {
      const original = MemberScheduleNotificationSetting(
        isReminderEnabled: true,
        isFollowupEnabled: true,
        useCriticalAlert: false,
        criticalAlertVolume: 0.3,
        useAlarmKit: true,
        focusConnectScheduleID: 'focus-9',
      );

      expect(MemberScheduleNotificationSetting.fromJson(original.toJson()), original);
    });

    test('デフォルト値(volume 0.5 / useAlarmKit false / focus null)を復元できる', () {
      const original = MemberScheduleNotificationSetting(
        isReminderEnabled: false,
        isFollowupEnabled: false,
        useCriticalAlert: false,
      );

      final restored = MemberScheduleNotificationSetting.fromJson(original.toJson());
      expect(restored.criticalAlertVolume, 0.5);
      expect(restored.useAlarmKit, false);
      expect(restored.focusConnectScheduleID, isNull);
    });
  });
}
