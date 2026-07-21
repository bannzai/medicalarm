import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/group_member_notification_settings.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/utils/alarm_kit_service.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medication_history.g.dart';

@Riverpod(dependencies: [currentGroupDatabase])
Stream<List<MedicationHistory>> medicationHistories(MedicationHistoriesRef ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return database.medicationHistoriesReference().snapshots().map((event) => event.docs.map((doc) => doc.data()).toList());
}

@Riverpod(dependencies: [currentGroupDatabase])
Stream<List<MedicationHistory>> medicationHistoriesByDate(MedicationHistoriesRef ref, DateTime date) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return database
      .medicationHistoriesReference()
      .where(
        'scheduledRecordedDate',
        isGreaterThanOrEqualTo: date.date(),
        isLessThanOrEqualTo: date.date().add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
      )
      .snapshots()
      .map((event) => event.docs.map((doc) => doc.data()).toList());
}

class MedicationHistoryTake {
  final GroupDatabase database;
  // 記録者(自分)の uid。userID(作成者) と recordedByUserID(記録者) の両方に設定する。
  final String userID;

  MedicationHistoryTake({required this.database, required this.userID});

  Future<MedicationHistory> call({
    required MedicationHistory? medicationHistory,
    required DateTime recordedDateTime,
    required DateTime scheduledRecordedDate,
    required Medicine medicine,
    required MedicationSchedule medicationSchedule,
    // AlarmKit 停止判定を共有テンプレートではなく記録者に有効な設定で行うために解決に使う。
    required GroupMemberNotificationSettings? memberSettings,
  }) async {
    // 既存記録の再書き込みは同じドキュメントへ上書きする。常に新規 doc() を発行すると
    // パスと id フィールドの食い違う複製ドキュメントが増殖する (#253)
    final docRef = database.medicationHistoriesReference().doc(medicationHistory?.id);

    final newMedicationHistory = medicationHistory ??
        MedicationHistory(
          id: docRef.id,
          userID: userID,
          recordedByUserID: userID,
          medicine: medicine,
          actionKind: MedicationHistoryActionKind.take,
          action: MedicationHistoryAction.take(
            medicationSchedule: medicationSchedule,
            scheduledRecordedDate: scheduledRecordedDate,
          ),
          memo: '',
          recordedDateTime: recordedDateTime,
          scheduledRecordedDate: scheduledRecordedDate,
          ttlExpiresDateTime: DateTime.now().addDays(365),
        );

    // 服用記録を保存
    await docRef.set(newMedicationHistory, SetOptions(merge: true));

    // 共有テンプレート直読みではなく、記録者に有効な設定(メンバー個別設定で有効化した場合も含む)で AlarmKit 停止を判定する。
    if (resolveEffectiveNotificationSetting(
      medicine: medicine,
      schedule: medicationSchedule,
      memberSettings: memberSettings,
      currentUserID: userID,
    ).useAlarmKit) {
      try {
        await AlarmKitService.stopAllAlarms();
        analytics.debug(name: 'medication_history_take_alarm_kit_stopped');
      } catch (e, st) {
        // AlarmKit停止に失敗しても服用記録は成功しているので継続
        errorLogger.recordError(e, st);
        analytics.debug(name: 'medication_history_take_alarm_kit_stop_failed', parameters: {
          'error': e.toString(),
        });
      }
    }

    return newMedicationHistory;
  }
}

@Riverpod(dependencies: [currentGroupDatabase, appUserID])
MedicationHistoryTake medicationHistoryTake(MedicationHistoryTakeRef ref) {
  return MedicationHistoryTake(database: ref.watch(currentGroupDatabaseProvider), userID: ref.watch(appUserIDProvider));
}

/// 服薬記録(take)の取り消しを revert アクションの追記として保存する論理削除。
/// take ドキュメントは削除せず残し、取り消し対象を [RevertMedicationHistoryAction.takeAction] に丸ごと内包した別ドキュメントを作成する (#253)
class MedicationHistoryRevert {
  final GroupDatabase database;
  // 取消操作をした本人の uid。userID(作成者) と recordedByUserID(記録者) の両方に設定する。
  final String userID;

  MedicationHistoryRevert({required this.database, required this.userID});

  Future<MedicationHistory> call({required MedicationHistory takeMedicationHistory}) async {
    // take の id から決定的に導出したドキュメント ID を使う。多重呼び出しや複数メンバーの同時取消でも
    // 同一 take への revert は 1 ドキュメントに収束し、冪等になる
    final docRef = database.medicationHistoriesReference().doc('${takeMedicationHistory.id}-revert');
    final revertMedicationHistory = MedicationHistory(
      id: docRef.id,
      userID: userID,
      recordedByUserID: userID,
      medicine: takeMedicationHistory.medicine,
      actionKind: MedicationHistoryActionKind.revert,
      action: MedicationHistoryAction.revert(
        takeAction: takeMedicationHistory,
        medicationSchedule: takeMedicationHistory.action.medicationSchedule,
      ),
      memo: '',
      recordedDateTime: DateTime.now(),
      // 取り消し対象と同じ日付軸に置き、medicationHistoriesByDate の日付範囲クエリで take と同じ日に取得されるようにする
      scheduledRecordedDate: takeMedicationHistory.scheduledRecordedDate,
      // 取り消し対象の take と同じ保持期限を引き継ぐ。取消時点から起算し直すと、内包した take の医療データの
      // 保持期間が元の記録の期限を超えて延びてしまうため
      ttlExpiresDateTime: takeMedicationHistory.ttlExpiresDateTime,
    );
    await docRef.set(revertMedicationHistory, SetOptions(merge: true));
    return revertMedicationHistory;
  }
}

@Riverpod(dependencies: [currentGroupDatabase, appUserID])
MedicationHistoryRevert medicationHistoryRevert(MedicationHistoryRevertRef ref) {
  return MedicationHistoryRevert(database: ref.watch(currentGroupDatabaseProvider), userID: ref.watch(appUserIDProvider));
}

class MedicationHistoryMemoUpdate {
  final GroupDatabase database;

  MedicationHistoryMemoUpdate(this.database);

  Future<void> call({required MedicationHistory medicationHistory, required String memo}) async {
    await database.medicationHistoriesReference().doc(medicationHistory.id).set(
          medicationHistory.copyWith(memo: memo),
          SetOptions(merge: true),
        );
  }
}

@Riverpod(dependencies: [currentGroupDatabase])
MedicationHistoryMemoUpdate medicationHistoryMemoUpdate(MedicationHistoryMemoUpdateRef ref) {
  return MedicationHistoryMemoUpdate(ref.watch(currentGroupDatabaseProvider));
}
