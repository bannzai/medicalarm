import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'medication_history_revert_test.mocks.dart';

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

@GenerateNiceMocks([
  MockSpec<GroupDatabase>(),
  MockSpec<CollectionReference<MedicationHistory>>(as: #MockMedicationHistoryCollectionReference),
  MockSpec<DocumentReference<MedicationHistory>>(as: #MockMedicationHistoryDocumentReference),
])
void main() {
  late MockGroupDatabase database;
  late MockMedicationHistoryCollectionReference collectionReference;
  late MockMedicationHistoryDocumentReference documentReference;
  late MedicationHistoryRevert medicationHistoryRevert;

  setUp(() {
    database = MockGroupDatabase();
    collectionReference = MockMedicationHistoryCollectionReference();
    documentReference = MockMedicationHistoryDocumentReference();
    when(database.medicationHistoriesReference()).thenReturn(collectionReference);
    when(collectionReference.doc(any)).thenReturn(documentReference);
    when(documentReference.id).thenReturn('take-1-revert');
    when(documentReference.set(any, any)).thenAnswer((_) async {});
    // 取消操作をした人(user-b)は take の記録者(user-a)と別人のケースで検証する
    medicationHistoryRevert = MedicationHistoryRevert(database: database, userID: 'user-b');
  });

  // #253: アンチェックは take の物理削除ではなく revert アクションの追記(論理削除)
  group('MedicationHistoryRevert.call', () {
    test('take の id から決定的に導出したドキュメント ID へ書き込む(多重取消でも 1 ドキュメントに収束する)', () async {
      await medicationHistoryRevert.call(takeMedicationHistory: buildTakeMedicationHistory());

      verify(collectionReference.doc('take-1-revert')).called(1);
    });

    test('取消対象の take を内包した revert アクションを、取消操作をした人の uid で作成する', () async {
      final takeMedicationHistory = buildTakeMedicationHistory();

      final result = await medicationHistoryRevert.call(takeMedicationHistory: takeMedicationHistory);

      expect(result.actionKind, MedicationHistoryActionKind.revert);
      expect(result.action, isA<RevertMedicationHistoryAction>());
      expect((result.action as RevertMedicationHistoryAction).takeAction, takeMedicationHistory);
      expect(result.userID, 'user-b');
      expect(result.recordedByUserID, 'user-b');
      // 日付範囲クエリ(medicationHistoriesByDate)で take と同じ日に取得されるよう、日付軸は take に合わせる
      expect(result.scheduledRecordedDate, takeMedicationHistory.scheduledRecordedDate);
      // 取消時点から起算し直すと内包した take の医療データの保持期間が延びてしまうため、take の保持期限を引き継ぐ
      expect(result.ttlExpiresDateTime, takeMedicationHistory.ttlExpiresDateTime);
      expect(verify(documentReference.set(captureAny, captureAny)).captured.first, result);
    });
  });
}
