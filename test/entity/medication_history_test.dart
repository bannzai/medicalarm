import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';

const medicationSchedule = MedicationSchedule(
  id: 'schedule-1',
  hour: 9,
  minute: 0,
  quantityMemo: '',
  notificationSetting: MedicineScheduleNotificationSetting(
    isReminderEnabled: true,
    isFollowupEnabled: false,
    useCriticalAlert: false,
  ),
  focusConnectSetting: null,
);

Medicine buildMedicine() {
  return Medicine(
    id: 'medicine-1',
    userID: 'user-a',
    name: 'Medicine 1',
    frequency: const MedicationFrequency.daily(),
    schedules: const [medicationSchedule],
    doseReceiver: const DoseReceiver(id: 'dose-receiver-1', userID: 'user-a', name: 'me'),
    memo: '',
    memoImageURL: '',
    minimumDoseIntervalHours: null,
    beganDateTime: DateTime(2026, 7, 1),
  );
}

MedicationHistory buildTakeMedicationHistory() {
  return MedicationHistory(
    id: 'take-1',
    userID: 'user-a',
    recordedByUserID: 'user-a',
    medicine: buildMedicine(),
    actionKind: MedicationHistoryActionKind.take,
    action: MedicationHistoryAction.take(
      medicationSchedule: medicationSchedule,
      scheduledRecordedDate: DateTime(2026, 7, 16),
    ),
    memo: '',
    recordedDateTime: DateTime(2026, 7, 16, 9, 2),
    scheduledRecordedDate: DateTime(2026, 7, 16),
    ttlExpiresDateTime: DateTime(2027, 7, 16),
  );
}

/// toJson が [FieldValue.serverTimestamp] のまま出力するサーバー時刻フィールドを、
/// Firestore サーバーが確定させた後のドキュメント(Timestamp 入り)へ置き換えて模す
dynamic materializeServerTimestamps(dynamic json) {
  if (json is Map<String, dynamic>) {
    return json.map((key, value) => MapEntry(key, materializeServerTimestamps(value)));
  }
  if (json is List) {
    return json.map(materializeServerTimestamps).toList();
  }
  if (json is FieldValue) {
    return Timestamp.fromDate(DateTime(2026, 7, 18));
  }
  return json;
}

void main() {
  // #253: アンチェックの論理削除で revert ドキュメントが medicationHistories コレクションに混在する。
  // revert の union 判別(runtimeType)と takeAction の内包構造が deserialize でクラッシュしないこと
  // (旧リリース版も同じ生成コードを持つため、この fromJson が通れば旧版の履歴取得も落ちない)
  group('MedicationHistory の revert アクションの serialize / deserialize', () {
    test('revert ドキュメントを Firestore 形式の JSON から復元できる', () {
      final revertMedicationHistory = MedicationHistory(
        id: 'take-1-revert',
        userID: 'user-b',
        recordedByUserID: 'user-b',
        medicine: buildMedicine(),
        actionKind: MedicationHistoryActionKind.revert,
        action: MedicationHistoryAction.revert(
          takeAction: buildTakeMedicationHistory(),
          medicationSchedule: medicationSchedule,
        ),
        memo: '',
        recordedDateTime: DateTime(2026, 7, 16, 9, 5),
        scheduledRecordedDate: DateTime(2026, 7, 16),
        ttlExpiresDateTime: DateTime(2027, 7, 16),
      );

      final decoded = MedicationHistory.fromJson(
        materializeServerTimestamps(revertMedicationHistory.toJson()) as Map<String, dynamic>,
      );

      expect(decoded.actionKind, MedicationHistoryActionKind.revert);
      expect(decoded.action, isA<RevertMedicationHistoryAction>());
      expect((decoded.action as RevertMedicationHistoryAction).takeAction.id, 'take-1');
      expect(decoded.action.medicationSchedule.id, medicationSchedule.id);
      expect(decoded.scheduledRecordedDate, DateTime(2026, 7, 16));
    });
  });

  // #253: 「服用済みの記録があるか」の判定(レビュー訴求等)は revert に打ち消されていない take だけを数える
  group('effectiveTakeMedicationHistories', () {
    MedicationHistory buildRevertMedicationHistory({required MedicationHistory takeMedicationHistory}) {
      return MedicationHistory(
        id: '${takeMedicationHistory.id}-revert',
        userID: 'user-a',
        recordedByUserID: 'user-a',
        medicine: buildMedicine(),
        actionKind: MedicationHistoryActionKind.revert,
        action: MedicationHistoryAction.revert(
          takeAction: takeMedicationHistory,
          medicationSchedule: medicationSchedule,
        ),
        memo: '',
        recordedDateTime: DateTime(2026, 7, 16, 9, 5),
        scheduledRecordedDate: takeMedicationHistory.scheduledRecordedDate,
        ttlExpiresDateTime: takeMedicationHistory.ttlExpiresDateTime,
      );
    }

    test('revert に打ち消された take と revert ドキュメント自体は含まれない(取消済みのみの日は空になる)', () {
      final takeMedicationHistory = buildTakeMedicationHistory();

      expect(
        effectiveTakeMedicationHistories([takeMedicationHistory, buildRevertMedicationHistory(takeMedicationHistory: takeMedicationHistory)]),
        isEmpty,
      );
    });

    test('打ち消されていない take は含まれる', () {
      final takeMedicationHistory = buildTakeMedicationHistory();

      expect(
        effectiveTakeMedicationHistories([takeMedicationHistory]).map((history) => history.id).toList(),
        ['take-1'],
      );
    });
  });

  // #81: 最低服用間隔の判定は「指定した薬の、revert に打ち消されていない直近の take」を基準にする
  group('latestEffectiveTakeRecordedDateTime', () {
    MedicationHistory buildTake({required String id, required String medicineID, required DateTime recordedDateTime}) {
      return MedicationHistory(
        id: id,
        userID: 'user-a',
        recordedByUserID: 'user-a',
        medicine: buildMedicine().copyWith(id: medicineID),
        actionKind: MedicationHistoryActionKind.take,
        action: MedicationHistoryAction.take(
          medicationSchedule: medicationSchedule,
          scheduledRecordedDate: DateTime(2026, 7, 16),
        ),
        memo: '',
        recordedDateTime: recordedDateTime,
        scheduledRecordedDate: DateTime(2026, 7, 16),
        ttlExpiresDateTime: DateTime(2027, 7, 16),
      );
    }

    MedicationHistory buildRevert({required MedicationHistory takeMedicationHistory}) {
      return MedicationHistory(
        id: '${takeMedicationHistory.id}-revert',
        userID: 'user-a',
        recordedByUserID: 'user-a',
        medicine: takeMedicationHistory.medicine,
        actionKind: MedicationHistoryActionKind.revert,
        action: MedicationHistoryAction.revert(
          takeAction: takeMedicationHistory,
          medicationSchedule: medicationSchedule,
        ),
        memo: '',
        recordedDateTime: takeMedicationHistory.recordedDateTime.add(const Duration(minutes: 5)),
        scheduledRecordedDate: takeMedicationHistory.scheduledRecordedDate,
        ttlExpiresDateTime: takeMedicationHistory.ttlExpiresDateTime,
      );
    }

    test('複数の take のうち最新の記録日時を返す', () {
      final histories = [
        buildTake(id: 'take-1', medicineID: 'medicine-1', recordedDateTime: DateTime(2026, 7, 16, 9, 0)),
        buildTake(id: 'take-2', medicineID: 'medicine-1', recordedDateTime: DateTime(2026, 7, 16, 13, 0)),
      ];

      expect(
        latestEffectiveTakeRecordedDateTime(medicationHistories: histories, medicineID: 'medicine-1'),
        DateTime(2026, 7, 16, 13, 0),
      );
    });

    test('revert に打ち消された take は基準にならず、残っている take の中の最新を返す', () {
      final latestTake = buildTake(id: 'take-2', medicineID: 'medicine-1', recordedDateTime: DateTime(2026, 7, 16, 13, 0));
      final histories = [
        buildTake(id: 'take-1', medicineID: 'medicine-1', recordedDateTime: DateTime(2026, 7, 16, 9, 0)),
        latestTake,
        buildRevert(takeMedicationHistory: latestTake),
      ];

      expect(
        latestEffectiveTakeRecordedDateTime(medicationHistories: histories, medicineID: 'medicine-1'),
        DateTime(2026, 7, 16, 9, 0),
      );
    });

    test('別の薬の take は対象外で、有効な take が無い場合は null を返す', () {
      final histories = [
        buildTake(id: 'take-1', medicineID: 'medicine-2', recordedDateTime: DateTime(2026, 7, 16, 9, 0)),
      ];

      expect(
        latestEffectiveTakeRecordedDateTime(medicationHistories: histories, medicineID: 'medicine-1'),
        isNull,
      );
    });
  });
}
