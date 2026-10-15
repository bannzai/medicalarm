import 'dart:convert';

import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/entity/onboarding_medication_plan.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/shared_preferences.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/shared_preferences/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_medication_plan.g.dart';

/// 仮設定の通知に使用中のアカウントとグループ。
(String, String)? _notificationOwner;

/// 切り替え前の通知登録が切り替え後の通知を復活させないための世代。
int _notificationRevision = 0;

/// OS への仮設定の登録と解除を直列に処理する。
Future<void> _notificationOperation = Future.value();

/// アカウント・グループを離れるときに仮設定の通知を解除する。
Future<void> cancelOnboardingMedicationPlanNotifications() {
  _notificationOwner = null;
  return _synchronizeOnboardingMedicationPlanNotifications(plan: null);
}

/// 最後に要求された設定だけを残し、登録途中の削除も後続の解除で確定する。
Future<void> _synchronizeOnboardingMedicationPlanNotifications({required OnboardingMedicationPlan? plan}) {
  final revision = ++_notificationRevision;
  final operation = _notificationOperation.then((_) async {
    await localNotificationService.cancelOnboardingMedicationPlanNotifications();
    if (revision != _notificationRevision || plan == null) {
      return;
    }
    await localNotificationService.registerOnboardingMedicationPlanNotifications(plan: plan);
  });
  // 呼び出し元には失敗を伝えつつ、後続の解除・再試行は実行できるようにする。
  _notificationOperation = operation.catchError((Object _) {});
  return operation;
}

/// アーカイブ済みを含め、薬が登録されたことを検知する。
@Riverpod(dependencies: [currentGroupDatabase])
Stream<bool> hasRegisteredMedicines(Ref ref) {
  return ref.watch(currentGroupDatabaseProvider).medicinesReference().limit(1).snapshots().map((snapshot) => snapshot.docs.isNotEmpty);
}

/// アカウントとグループを境界に仮設定の保存・解除を管理する。
@Riverpod(keepAlive: true, dependencies: [sharedPreferences])
class OnboardingMedicationPlanStore extends _$OnboardingMedicationPlanStore {
  /// 同一設定に対する保存・削除の順序を保つ。
  Future<void> _storageOperation = Future.value();

  /// JSON 配列で ID を区切り、異なる ID の組み合わせによる衝突を防ぐ。
  String get _key => '${StringKey.onboardingMedicationPlan}:${jsonEncode([userID, groupID])}';

  @override
  OnboardingMedicationPlan? build({required String userID, required String groupID}) {
    final saved = ref.watch(sharedPreferencesProvider).getString(_key);
    if (saved == null) {
      return null;
    }
    final plan = OnboardingMedicationPlan.fromJson(jsonDecode(saved) as Map<String, dynamic>);
    return plan.userID == userID && plan.groupID == groupID ? plan : null;
  }

  /// ユーザーが選んだ回数で仮設定を作る。同じ設定があれば作成日時を保つ。
  Future<OnboardingMedicationPlan?> create({required int dailyDoseCount, required bool hasMedicines}) {
    if (dailyDoseCount < 1 || dailyDoseCount > 3) {
      throw ArgumentError.value(dailyDoseCount, 'dailyDoseCount');
    }
    if (hasMedicines) {
      return remove().then((_) => null);
    }
    _notificationOwner = (userID, groupID);
    final notificationRevision = ++_notificationRevision;
    final operation = _storageOperation.then((_) async {
      // 時刻と上限はオンボーディングの承認済み仕様。3 回は「3 回以上」の回答に対応する。
      final plan = OnboardingMedicationPlan(
        userID: userID,
        groupID: groupID,
        doseReceiverID: DoseReceiver.firstUserID,
        createdDateTime: state?.createdDateTime ?? DateTime.now(),
        schedules: (switch (dailyDoseCount) {
          1 => [8],
          2 => [8, 19],
          _ => [8, 12, 19],
        })
            .map((hour) => MedicationSchedule(
                  id: 'onboarding-$hour',
                  hour: hour,
                  // 承認済みの仮設定は正時に案内する。薬・用量は未登録なので空欄にする。
                  minute: 0,
                  quantityMemo: '',
                  notificationSetting: const MedicineScheduleNotificationSetting(
                    isReminderEnabled: true,
                    isFollowupEnabled: false,
                    useCriticalAlert: false,
                    // 登録フォームへ引き継いだ後に Critical Alert を有効にしても無音にならないよう通常の新規設定と揃える。
                    criticalAlertVolume: 0.5,
                    useAlarmKit: false,
                  ),
                  focusConnectSetting: null,
                ))
            .toList(),
      );
      if (!await ref.read(sharedPreferencesProvider).setString(_key, jsonEncode(plan.toJson()))) {
        throw StateError('服薬時刻の仮設定を保存できませんでした');
      }
      state = plan;
    });
    _storageOperation = operation.catchError((Object _) {});
    return operation.then((_) async {
      if (_notificationOwner == (userID, groupID) && notificationRevision == _notificationRevision) {
        await _synchronizeOnboardingMedicationPlanNotifications(plan: state);
      }
      return state;
    });
  }

  /// 手動削除または薬の登録により仮設定を永続的に取り除く。
  Future<void> remove() {
    final notificationCancellation = _notificationOwner == (userID, groupID) ? cancelOnboardingMedicationPlanNotifications() : Future<void>.value();
    final operation = _storageOperation.then((_) => _removeStoredPlan());
    _storageOperation = operation.catchError((Object _) {});
    return Future.wait([operation, notificationCancellation]).then((_) {});
  }

  /// 指定した時刻だけを消し、最後の時刻を消した場合は仮設定自体を取り除く。
  Future<void> removeSchedule({required String scheduleID}) {
    final notificationRevision = _notificationOwner == (userID, groupID) ? ++_notificationRevision : null;
    final operation = _storageOperation.then((_) async {
      final plan = state;
      if (plan == null || !plan.schedules.any((schedule) => schedule.id == scheduleID)) {
        return;
      }
      if (plan.schedules.length == 1) {
        // remove() と同じ保存削除処理を使う。キュー内から remove() 自体を待つと自身の完了待ちになる。
        await _removeStoredPlan();
        return;
      }
      final updatedPlan = plan.copyWith(schedules: plan.schedules.where((schedule) => schedule.id != scheduleID).toList());
      if (!await ref.read(sharedPreferencesProvider).setString(_key, jsonEncode(updatedPlan.toJson()))) {
        throw StateError('服薬時刻の仮設定を保存できませんでした');
      }
      state = updatedPlan;
    });
    _storageOperation = operation.catchError((Object _) {});
    return operation.then((_) async {
      if (_notificationOwner == (userID, groupID) && notificationRevision == _notificationRevision) {
        await _synchronizeOnboardingMedicationPlanNotifications(plan: state);
      }
    });
  }

  /// 保存キュー内で使用する全時刻の削除処理。
  Future<void> _removeStoredPlan() async {
    if (!await ref.read(sharedPreferencesProvider).remove(_key)) {
      throw StateError('服薬時刻の仮設定を削除できませんでした');
    }
    state = null;
  }

  /// 表示中の設定を通知へ反映し、薬が登録済みなら保存内容も削除する。
  Future<void> synchronizeNotifications({required bool hasMedicines}) {
    _notificationOwner = (userID, groupID);
    if (hasMedicines) {
      return remove();
    }
    return _synchronizeOnboardingMedicationPlanNotifications(plan: state);
  }
}
