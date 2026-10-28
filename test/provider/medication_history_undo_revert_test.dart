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

import 'medication_history_undo_revert_test.mocks.dart';

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

// user-b が take-1 を取り消した revert ドキュメント
MedicationHistory buildRevertMedicationHistory({
  String recordedByUserID = 'user-b',
  DateTime? recordedDateTime,
}) {
  return MedicationHistory(
    id: 'take-1-revert',
    userID: recordedByUserID,
    recordedByUserID: recordedByUserID,
    medicine: buildMedicine(),
    actionKind: MedicationHistoryActionKind.revert,
    action: MedicationHistoryAction.revert(
      takeAction: buildTakeMedicationHistory(),
      medicationSchedule: medicationSchedule,
    ),
    memo: '',
    recordedDateTime: recordedDateTime ?? DateTime(2026, 7, 16, 9, 5),
    scheduledRecordedDate: DateTime(2026, 7, 16),
    ttlExpiresDateTime: DateTime(2027, 7, 16),
  );
}

@GenerateNiceMocks([
  MockSpec<GroupDatabase>(),
  MockSpec<FirebaseFirestore>(),
  MockSpec<Transaction>(),
  MockSpec<CollectionReference<MedicationHistory>>(as: #MockMedicationHistoryCollectionReference),
  MockSpec<DocumentReference<MedicationHistory>>(as: #MockMedicationHistoryDocumentReference),
  MockSpec<DocumentSnapshot<MedicationHistory>>(as: #MockMedicationHistoryDocumentSnapshot),
])
void main() {
  late MockGroupDatabase database;
  late MockFirebaseFirestore firestore;
  late MockTransaction transaction;
  late MockMedicationHistoryCollectionReference collectionReference;
  late MockMedicationHistoryDocumentReference revertDocumentReference;
  late MockMedicationHistoryDocumentReference takeDocumentReference;
  late MockMedicationHistoryDocumentSnapshot revertSnapshot;
  late MockMedicationHistoryDocumentSnapshot takeSnapshot;
  late MedicationHistoryUndoRevert medicationHistoryUndoRevert;

  setUp(() {
    database = MockGroupDatabase();
    firestore = MockFirebaseFirestore();
    transaction = MockTransaction();
    collectionReference = MockMedicationHistoryCollectionReference();
    revertDocumentReference = MockMedicationHistoryDocumentReference();
    takeDocumentReference = MockMedicationHistoryDocumentReference();
    revertSnapshot = MockMedicationHistoryDocumentSnapshot();
    takeSnapshot = MockMedicationHistoryDocumentSnapshot();
    when(database.medicationHistoriesReference()).thenReturn(collectionReference);
    when(collectionReference.doc('take-1-revert')).thenReturn(revertDocumentReference);
    when(collectionReference.doc('take-1')).thenReturn(takeDocumentReference);
    when(revertDocumentReference.firestore).thenReturn(firestore);
    // runTransaction はトランザクションハンドラをそのまま実行して結果を返す
    when(firestore.runTransaction<bool>(any, timeout: anyNamed('timeout'), maxAttempts: anyNamed('maxAttempts'))).thenAnswer((invocation) {
      return (invocation.positionalArguments.first as Future<bool> Function(Transaction))(transaction);
    });
    when(transaction.get<MedicationHistory>(revertDocumentReference)).thenAnswer((_) async => revertSnapshot);
    when(transaction.get<MedicationHistory>(takeDocumentReference)).thenAnswer((_) async => takeSnapshot);
    medicationHistoryUndoRevert = MedicationHistoryUndoRevert(database);
  });

  // #253: 「元に戻す」= 直前に書いた revert の取り下げ。混在環境・同時操作に備えトランザクションで原子的に行う
  group('MedicationHistoryUndoRevert.call', () {
    test('自分の revert が残っていて take も実在する場合、revert の削除だけを行い true を返す', () async {
      final revertMedicationHistory = buildRevertMedicationHistory();
      when(revertSnapshot.data()).thenReturn(revertMedicationHistory);
      when(takeSnapshot.exists).thenReturn(true);

      expect(await medicationHistoryUndoRevert.call(revertMedicationHistory: revertMedicationHistory), true);

      verify(transaction.delete(revertDocumentReference)).called(1);
      verifyNever(transaction.set(any, any));
    });

    test('旧クライアントに take が物理削除されている場合、take を復元してから revert を削除する', () async {
      final revertMedicationHistory = buildRevertMedicationHistory();
      when(revertSnapshot.data()).thenReturn(revertMedicationHistory);
      when(takeSnapshot.exists).thenReturn(false);

      expect(await medicationHistoryUndoRevert.call(revertMedicationHistory: revertMedicationHistory), true);

      final captured = verify(transaction.set(captureAny, captureAny)).captured;
      expect(captured.first, takeDocumentReference);
      expect((captured[1] as MedicationHistory).id, 'take-1');
      verify(transaction.delete(revertDocumentReference)).called(1);
    });

    test('別メンバーの取消が同じドキュメントを上書きしている場合、取り下げずに false を返す', () async {
      when(revertSnapshot.data()).thenReturn(buildRevertMedicationHistory(recordedByUserID: 'user-c'));
      when(takeSnapshot.exists).thenReturn(true);

      expect(await medicationHistoryUndoRevert.call(revertMedicationHistory: buildRevertMedicationHistory()), false);

      verifyNever(transaction.delete(any));
      verifyNever(transaction.set(any, any));
    });

    test('revert が既に消えている場合、take の実在だけを保証して true を返す(削除は行わない)', () async {
      when(revertSnapshot.data()).thenReturn(null);
      when(takeSnapshot.exists).thenReturn(false);

      expect(await medicationHistoryUndoRevert.call(revertMedicationHistory: buildRevertMedicationHistory()), true);

      verify(transaction.set(takeDocumentReference, any)).called(1);
      verifyNever(transaction.delete(any));
    });

    test('take アクションの MedicationHistory を渡すと ArgumentError になる', () async {
      expect(
        () => medicationHistoryUndoRevert.call(revertMedicationHistory: buildTakeMedicationHistory()),
        throwsArgumentError,
      );
    });
  });
}
