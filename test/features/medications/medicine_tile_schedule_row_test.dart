import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/entity/medication_frequency.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';
import 'package:medicalarm/features/medications/page.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/group_member_notification_settings.dart';
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

Medicine buildMedicine({int? minimumDoseIntervalHours}) {
  return Medicine(
    id: 'medicine-1',
    userID: 'user-a',
    name: '共有薬X',
    frequency: const MedicationFrequency.daily(),
    schedules: const [medicationSchedule],
    doseReceiver: const DoseReceiver(id: 'dose-receiver-1', userID: 'user-a', name: '自分'),
    memo: '',
    memoImageURL: '',
    minimumDoseIntervalHours: minimumDoseIntervalHours,
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

// buildMedicationHistory() の take を打ち消す revert ドキュメント。MedicationHistoryRevert.call の返り値を模す
MedicationHistory buildRevertMedicationHistory() {
  final takeMedicationHistory = buildMedicationHistory();
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
    recordedDateTime: DateTime.now(),
    scheduledRecordedDate: takeMedicationHistory.scheduledRecordedDate,
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

// revert 追記の snapshot 反映後(take が打ち消された後)の未チェック状態の行
MedicationGroupScheduleRow buildUncheckedScheduleRow({int? minimumDoseIntervalHours}) {
  return MedicationGroupScheduleRow(
    id: 'row-1',
    medicationHistory: null,
    medicine: buildMedicine(minimumDoseIntervalHours: minimumDoseIntervalHours),
    medicationSchedule: medicationSchedule,
    quantityMemo: '',
    date: DateTime.now(),
  );
}

@GenerateNiceMocks([
  MockSpec<MedicationHistoryTake>(),
  MockSpec<MedicationHistoryRevert>(),
  MockSpec<MedicationHistoryUndoRevert>(),
  MockSpec<RecentMedicationHistoriesFetch>(),
  MockSpec<RegisterReminderLocalNotification>(),
])
void main() {
  late MockMedicationHistoryTake medicationHistoryTake;
  late MockMedicationHistoryRevert medicationHistoryRevert;
  late MockMedicationHistoryUndoRevert medicationHistoryUndoRevert;
  late MockRecentMedicationHistoriesFetch recentMedicationHistoriesFetch;
  late MockRegisterReminderLocalNotification registerReminderLocalNotification;

  setUp(() {
    medicationHistoryTake = MockMedicationHistoryTake();
    medicationHistoryRevert = MockMedicationHistoryRevert();
    medicationHistoryUndoRevert = MockMedicationHistoryUndoRevert();
    recentMedicationHistoriesFetch = MockRecentMedicationHistoriesFetch();
    registerReminderLocalNotification = MockRegisterReminderLocalNotification();
    when(medicationHistoryTake.call(
      medicationHistory: anyNamed('medicationHistory'),
      recordedDateTime: anyNamed('recordedDateTime'),
      scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
      medicine: anyNamed('medicine'),
      medicationSchedule: anyNamed('medicationSchedule'),
      memberSettings: anyNamed('memberSettings'),
    )).thenAnswer((_) async => buildMedicationHistory());
    when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory')))
        .thenAnswer((_) async => buildRevertMedicationHistory());
    when(medicationHistoryUndoRevert.call(revertMedicationHistory: anyNamed('revertMedicationHistory'))).thenAnswer((_) async => true);
    when(recentMedicationHistoriesFetch.call(recordedSinceDateTime: anyNamed('recordedSinceDateTime'))).thenAnswer((_) async => []);
    when(registerReminderLocalNotification.call()).thenAnswer((_) async {});
  });

  Future<void> pumpScheduleRow(WidgetTester tester, {required MedicationGroupScheduleRow scheduleRow}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          medicationHistoryTakeProvider.overrideWith((ref) => medicationHistoryTake),
          medicationHistoryRevertProvider.overrideWith((ref) => medicationHistoryRevert),
          medicationHistoryUndoRevertProvider.overrideWith((ref) => medicationHistoryUndoRevert),
          recentMedicationHistoriesFetchProvider.overrideWith((ref) => recentMedicationHistoriesFetch),
          registerReminderLocalNotificationProvider.overrideWith((ref) => registerReminderLocalNotification),
          // take の実行経路(#81 の間隔チェック後の記録)が読む依存。FirebaseAuth 等の実体へ触れないよう固定値にする
          appUserIDProvider.overrideWith((ref) => 'user-a'),
          groupMemberNotificationSettingsProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MedicineTileScheduleRow(scheduleRow: scheduleRow),
          ),
        ),
      ),
    );
  }

  // #253: アンチェックは take ドキュメントを削除せず revert アクションを即時追記する論理削除。
  // SnackBar の「元に戻す」は直前に書いた revert ドキュメントの物理削除で取り消す
  group('MedicineTileScheduleRow のアンチェック(論理削除)', () {
    testWidgets('アンチェックで revert が即時 1 回発行され、SnackBar が表示される', (tester) async {
      final scheduleRow = buildCheckedScheduleRow();
      await pumpScheduleRow(tester, scheduleRow: scheduleRow);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // SnackBar の表示アニメーションを進める
      await tester.pump(const Duration(milliseconds: 750));

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      expect(find.text('服薬記録を取り消しました'), findsOneWidget);
      expect(find.text('元に戻す'), findsOneWidget);

      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured, hasLength(1));
      expect((captured.single as MedicationHistory).id, scheduleRow.medicationHistory!.id);
      // undo は発行されない
      verifyNever(medicationHistoryUndoRevert.call(revertMedicationHistory: anyNamed('revertMedicationHistory')));
    });

    testWidgets('SnackBar を放置して閉じても追加の書き込み・削除は発行されない', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      // SnackBar の表示時間(8 秒)を経過させ、退場アニメーションの完了を待つ
      await tester.pump(const Duration(seconds: 9));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
      await tester.pump();
      expect(find.text('服薬記録を取り消しました'), findsNothing);

      verify(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).called(1);
      verify(registerReminderLocalNotification.call()).called(1);
      verifyNever(medicationHistoryUndoRevert.call(revertMedicationHistory: anyNamed('revertMedicationHistory')));
      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
    });

    testWidgets('元に戻すをタップすると revert の取り下げ(undo)が発行され、チェック済み表示に戻る', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      await tester.tap(find.text('元に戻す'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      final captured = verify(medicationHistoryUndoRevert.call(revertMedicationHistory: captureAnyNamed('revertMedicationHistory'))).captured;
      expect(captured, hasLength(1));
      // 取り下げ対象は take ではなく、直前に書いた revert ドキュメントであること
      expect((captured.single as MedicationHistory).id, buildRevertMedicationHistory().id);
      // undo は revert の取り下げで戻すため、take の再作成は発行されない
      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
    });

    testWidgets('SnackBar 表示中のチェックし直しは元に戻すと同義で、revert の取り下げ(undo)だけが発行される', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();
      final captured = verify(medicationHistoryUndoRevert.call(revertMedicationHistory: captureAnyNamed('revertMedicationHistory'))).captured;
      expect(captured, hasLength(1));
      expect((captured.single as MedicationHistory).id, buildRevertMedicationHistory().id);
      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
    });

    // 低速回線などで revert の書き込みが遅延している間のチェックし直しが take と誤解釈されると、
    // 後から完了した revert に打ち消されてユーザーの訂正が無視される。書き込み中も undo として扱うこと
    testWidgets('revert 書き込みの完了前のチェックし直しも undo と同義で、take は発行されない', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 書き込みが未完了なので SnackBar はまだ表示されていない
      expect(find.text('元に戻す'), findsNothing);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      revertCompleter.complete(buildRevertMedicationHistory());
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      final captured = verify(medicationHistoryUndoRevert.call(revertMedicationHistory: captureAnyNamed('revertMedicationHistory'))).captured;
      expect(captured, hasLength(1));
      expect((captured.single as MedicationHistory).id, buildRevertMedicationHistory().id);
      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
      // undo が消化済みなので SnackBar は表示されない
      await tester.pump(const Duration(milliseconds: 750));
      expect(find.text('服薬記録を取り消しました'), findsNothing);
    });

    // チェックし直し(undo)の完了前に再アンチェックされた場合、破棄すると undo 完了時に
    // チェック済みへ巻き戻されてユーザーの最新操作が消える。undo 完了後に取消を引き継いで発行すること
    testWidgets('undo の実行中の再アンチェックは破棄されず、undo 完了後に取消(revert)として発行される', (tester) async {
      final undoCompleter = Completer<bool>();
      when(medicationHistoryUndoRevert.call(revertMedicationHistory: anyNamed('revertMedicationHistory'))).thenAnswer((_) => undoCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      // アンチェック → revert 追記の snapshot 反映で行の medicationHistory が null になる
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      // SnackBar 猶予中にチェックし直し(undo 開始。完了は保留)、undo 完了前に再アンチェック
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      undoCompleter.complete(true);
      await tester.pumpAndSettle();

      // 再アンチェックが undo で復元された take への取消として発行される(1回目のアンチェックと合わせて計2回)
      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured, hasLength(2));
      expect((captured[1] as MedicationHistory).id, 'history-1');
      // ユーザーの最新操作(アンチェック)が維持される
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
    });
  });

  // #81: 最低服用間隔が空いていない場合は注意ダイアログを挟む。記録自体は無効化しない
  group('MedicineTileScheduleRow の服用間隔チェック', () {
    void verifyTakeCalled(int count) {
      final verification = verify(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
      verification.called(count);
    }

    void verifyTakeNeverCalled() {
      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
    }

    testWidgets('間隔内に直近の服用があると注意ダイアログが表示され、キャンセルで記録されない', (tester) async {
      // buildMedicationHistory() の recordedDateTime は現在時刻 = 間隔(6時間)内の直近服用
      when(recentMedicationHistoriesFetch.call(recordedSinceDateTime: anyNamed('recordedSinceDateTime')))
          .thenAnswer((_) async => [buildMedicationHistory()]);
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow(minimumDoseIntervalHours: 6));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(find.text('服用間隔が空いていません'), findsOneWidget);

      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      // 記録は作られず、チェック表示も実状態(未チェック)へ戻る
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      verifyTakeNeverCalled();
    });

    testWidgets('注意ダイアログで記録するを選ぶと take が発行される(無効化されない)', (tester) async {
      when(recentMedicationHistoriesFetch.call(recordedSinceDateTime: anyNamed('recordedSinceDateTime')))
          .thenAnswer((_) async => [buildMedicationHistory()]);
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow(minimumDoseIntervalHours: 6));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('記録する'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      verifyTakeCalled(1);
    });

    testWidgets('間隔内に有効な服用が無ければダイアログなしで記録される', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow(minimumDoseIntervalHours: 6));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(find.text('服用間隔が空いていません'), findsNothing);
      verifyTakeCalled(1);
    });

    testWidgets('間隔設定の無い薬は直近履歴の取得自体を行わずに記録される', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      verifyNever(recentMedicationHistoriesFetch.call(recordedSinceDateTime: anyNamed('recordedSinceDateTime')));
      verifyTakeCalled(1);
    });

    // 低速回線などで直近履歴の取得が遅延している間にアンチェックされた場合、取得完了後の継続が
    // ユーザーの最新操作(未チェック)を追い越して記録してはならない
    testWidgets('間隔チェックの取得中にアンチェックした場合、取得完了後も記録されない', (tester) async {
      final fetchCompleter = Completer<List<MedicationHistory>>();
      when(recentMedicationHistoriesFetch.call(recordedSinceDateTime: anyNamed('recordedSinceDateTime'))).thenAnswer((_) => fetchCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow(minimumDoseIntervalHours: 6));

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 取得完了前にアンチェック
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      fetchCompleter.complete([]);
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      verifyTakeNeverCalled();
      expect(find.text('服用間隔が空いていません'), findsNothing);
    });
  });
}
