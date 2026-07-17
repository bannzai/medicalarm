import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';
import 'package:medicalarm/features/medications/page.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'medicine_tile_schedule_row_test.mocks.dart';

// AlarmKit 等の platform channel に触れないよう useAlarmKit はデフォルト(false)のままにする
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
    name: '共有薬X',
    frequency: const MedicationFrequency.daily(),
    schedules: const [medicationSchedule],
    doseReceiver: const DoseReceiver(id: 'dose-receiver-1', userID: 'user-a', name: '自分'),
    memo: '',
    memoImageURL: '',
    beganDateTime: DateTime(2026, 7, 1),
  );
}

MedicationHistory buildMedicationHistory() {
  return MedicationHistory(
    id: 'history-1',
    userID: 'user-a',
    recordedByUserID: 'user-a',
    medicine: buildMedicine(),
    actionKind: MedicationHistoryActionKind.take,
    action: MedicationHistoryAction.take(
      medicationSchedule: medicationSchedule,
      scheduledRecordedDate: DateTime.now(),
    ),
    memo: '',
    recordedDateTime: DateTime.now(),
    scheduledRecordedDate: DateTime.now(),
    ttlExpiresDateTime: DateTime(2027, 7, 16),
  );
}

// チェック済み(medicationHistory あり)の行。アンチェック系の動作検証に使う
MedicationGroupScheduleRow buildCheckedScheduleRow() {
  return MedicationGroupScheduleRow(
    id: 'row-1',
    medicationHistory: buildMedicationHistory(),
    medicine: buildMedicine(),
    medicationSchedule: medicationSchedule,
    quantityMemo: '',
    date: DateTime.now(),
  );
}

@GenerateNiceMocks([
  MockSpec<MedicationHistoryTake>(),
  MockSpec<MedicationHistoryDelete>(),
  MockSpec<RegisterReminderLocalNotification>(),
])
void main() {
  late MockMedicationHistoryTake medicationHistoryTake;
  late MockMedicationHistoryDelete medicationHistoryDelete;
  late MockRegisterReminderLocalNotification registerReminderLocalNotification;

  setUp(() {
    medicationHistoryTake = MockMedicationHistoryTake();
    medicationHistoryDelete = MockMedicationHistoryDelete();
    registerReminderLocalNotification = MockRegisterReminderLocalNotification();
    when(medicationHistoryDelete.call(any)).thenAnswer((_) async {});
    when(registerReminderLocalNotification.call()).thenAnswer((_) async {});
  });

  Future<void> pumpScheduleRow(WidgetTester tester, {required MedicationGroupScheduleRow scheduleRow}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          medicationHistoryTakeProvider.overrideWith((ref) => medicationHistoryTake),
          medicationHistoryDeleteProvider.overrideWith((ref) => medicationHistoryDelete),
          registerReminderLocalNotificationProvider.overrideWith((ref) => registerReminderLocalNotification),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MedicineTileScheduleRow(scheduleRow: scheduleRow),
          ),
        ),
      ),
    );
  }

  // #253: アンチェックは即時 UI 反映 + Undo つき SnackBar の遅延削除。SnackBar が閉じるまで Firestore の削除を発行しない
  group('MedicineTileScheduleRow のアンチェック(遅延削除)', () {
    testWidgets('アンチェック直後は SnackBar が表示され、削除はまだ発行されない', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // SnackBar の表示アニメーションを進める
      await tester.pump(const Duration(milliseconds: 750));

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      expect(find.text('服薬記録を取り消しました'), findsOneWidget);
      expect(find.text('元に戻す'), findsOneWidget);
      verifyNever(medicationHistoryDelete.call(any));
    });

    testWidgets('SnackBar を放置して閉じた後に削除が 1 回だけ発行される', (tester) async {
      final scheduleRow = buildCheckedScheduleRow();
      await pumpScheduleRow(tester, scheduleRow: scheduleRow);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));
      verifyNever(medicationHistoryDelete.call(any));

      // SnackBar の表示時間(8 秒)を経過させ、退場アニメーションと delete の完了を待つ
      await tester.pump(const Duration(seconds: 9));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
      await tester.pump();
      expect(find.text('服薬記録を取り消しました'), findsNothing);

      final captured = verify(medicationHistoryDelete.call(captureAny)).captured;
      expect(captured, hasLength(1));
      expect((captured.single as MedicationHistory).id, scheduleRow.medicationHistory!.id);
      verify(registerReminderLocalNotification.call()).called(1);
      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
    });

    testWidgets('元に戻すをタップすると削除は発行されず、チェック済み表示に戻る', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      await tester.tap(find.text('元に戻す'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      // Undo 後に放置時間が過ぎても削除されないこと
      await tester.pump(const Duration(seconds: 10));
      verifyNever(medicationHistoryDelete.call(any));
    });

    testWidgets('SnackBar 表示中のチェックし直しは Undo と同義で、削除も再作成(take)も発行されない', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();
      verifyNever(medicationHistoryDelete.call(any));
      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
    });
  });
}
