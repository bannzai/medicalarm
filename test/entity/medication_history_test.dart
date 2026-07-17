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
}
