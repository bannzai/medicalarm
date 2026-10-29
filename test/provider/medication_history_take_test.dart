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

import 'medication_history_take_test.mocks.dart';

// AlarmKit 停止分岐(platform channel)に入らないよう useAlarmKit はデフォルト(false)のままにする
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

MedicationHistory buildMedicationHistory({required String id}) {
  return MedicationHistory(
    id: id,
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
  late MedicationHistoryTake medicationHistoryTake;

  setUp(() {
    database = MockGroupDatabase();
    collectionReference = MockMedicationHistoryCollectionReference();
    documentReference = MockMedicationHistoryDocumentReference();
    when(database.medicationHistoriesReference()).thenReturn(collectionReference);
    when(collectionReference.doc(any)).thenReturn(documentReference);
    when(documentReference.id).thenReturn('generated-id');
    when(documentReference.set(any, any)).thenAnswer((_) async {});
    medicationHistoryTake = MedicationHistoryTake(database: database, userID: 'user-a');
  });

  // #253: 既存記録の再書き込みで新規ランダム ID の doc へ書くと、パスと id フィールドの食い違う複製ドキュメントが増殖する
  group('MedicationHistoryTake.call の書き込み先ドキュメント ID', () {
    test('既存の medicationHistory がある場合は同じドキュメント ID へ書き込む(複製を作らない)', () async {
      final existingMedicationHistory = buildMedicationHistory(id: 'existing-history-id');

      final result = await medicationHistoryTake.call(
        medicationHistory: existingMedicationHistory,
        newMedicationHistoryID: null,
        recordedDateTime: existingMedicationHistory.recordedDateTime,
        scheduledRecordedDate: existingMedicationHistory.scheduledRecordedDate,
        medicine: buildMedicine(),
        medicationSchedule: medicationSchedule,
        memberSettings: null,
      );

      verify(collectionReference.doc('existing-history-id')).called(1);
      expect(result.id, 'existing-history-id');
      expect(verify(documentReference.set(captureAny, captureAny)).captured.first, existingMedicationHistory);
    });

    // 呼び出し元は書き込みの完了前に、行に反映された記録が自分の take かを ID で照合する
    test('medicationHistory が null で newMedicationHistoryID がある場合は、その ID の doc へ新規作成する', () async {
      final newDocumentReference = MockMedicationHistoryDocumentReference();
      when(collectionReference.doc('new-history-id')).thenReturn(newDocumentReference);
      when(newDocumentReference.id).thenReturn('new-history-id');
      when(newDocumentReference.set(any, any)).thenAnswer((_) async {});

      final result = await medicationHistoryTake.call(
        medicationHistory: null,
        newMedicationHistoryID: 'new-history-id',
        recordedDateTime: DateTime(2026, 7, 16, 9, 2),
        scheduledRecordedDate: DateTime(2026, 7, 16),
        medicine: buildMedicine(),
        medicationSchedule: medicationSchedule,
        memberSettings: null,
      );

      verify(collectionReference.doc('new-history-id')).called(1);
      expect(result.id, 'new-history-id');
      expect((verify(newDocumentReference.set(captureAny, captureAny)).captured.first as MedicationHistory).id, 'new-history-id');
    });

    test('medicationHistory と newMedicationHistoryID が null の場合は自動採番の doc へ新規作成する', () async {
      final result = await medicationHistoryTake.call(
        medicationHistory: null,
        newMedicationHistoryID: null,
        recordedDateTime: DateTime(2026, 7, 16, 9, 2),
        scheduledRecordedDate: DateTime(2026, 7, 16),
        medicine: buildMedicine(),
        medicationSchedule: medicationSchedule,
        memberSettings: null,
      );

      verify(collectionReference.doc(null)).called(1);
      expect(result.id, 'generated-id');
      expect(result.userID, 'user-a');
      expect(result.recordedByUserID, 'user-a');
    });
  });
}
