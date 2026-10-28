import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/group_member_notification_settings.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_member_notification_settings.g.dart';

/// 表示中グループにおける「自分」のメンバー個別通知設定。未作成の場合は null が流れる。
@Riverpod(dependencies: [currentGroupDatabase, appUserID])
Stream<GroupMemberNotificationSettings?> groupMemberNotificationSettings(Ref ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  final userID = ref.watch(appUserIDProvider);
  return database.memberNotificationSettingsReference(userID: userID).snapshots().map((snapshot) => snapshot.data());
}

/// 自分のメンバー個別通知設定のうち、1 スケジュール分(medicineID x scheduleID)を upsert する。
/// 他の medicine / schedule の既存設定は保持する(冪等)。
class GroupMemberNotificationSettingsUpdate {
  final GroupDatabase database;
  // 記録者ではなく設定の所有者(自分)の uid。ドキュメント ID にもなる。
  final String userID;

  GroupMemberNotificationSettingsUpdate({required this.database, required this.userID});

  Future<void> call({
    required GroupMemberNotificationSettings? current,
    required String medicineID,
    required String scheduleID,
    required MemberScheduleNotificationSetting setting,
  }) async {
    final base = current ?? GroupMemberNotificationSettings(id: userID, groupID: database.groupID, userID: userID);
    await database.memberNotificationSettingsReference(userID: userID).set(
          base.copyWith(settings: {
            ...base.settings,
            medicineID: {
              ...?base.settings[medicineID],
              scheduleID: setting,
            },
          }),
          SetOptions(merge: true),
        );
  }
}

@Riverpod(dependencies: [currentGroupDatabase, appUserID])
GroupMemberNotificationSettingsUpdate groupMemberNotificationSettingsUpdate(Ref ref) {
  return GroupMemberNotificationSettingsUpdate(
    database: ref.watch(currentGroupDatabaseProvider),
    userID: ref.watch(appUserIDProvider),
  );
}
