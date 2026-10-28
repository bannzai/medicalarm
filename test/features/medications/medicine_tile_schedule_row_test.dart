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
  MockSpec<RecentMedicationHistoriesFetch>(),
  MockSpec<RegisterReminderLocalNotification>(),
])
void main() {
  late MockMedicationHistoryTake medicationHistoryTake;
  late MockMedicationHistoryRevert medicationHistoryRevert;
  late MockRecentMedicationHistoriesFetch recentMedicationHistoriesFetch;
  late MockRegisterReminderLocalNotification registerReminderLocalNotification;

  setUp(() {
    medicationHistoryTake = MockMedicationHistoryTake();
    medicationHistoryRevert = MockMedicationHistoryRevert();
    recentMedicationHistoriesFetch = MockRecentMedicationHistoriesFetch();
    registerReminderLocalNotification = MockRegisterReminderLocalNotification();
    // 新しい take の書き込み先 ID。既定の take の返り値 buildMedicationHistory() と同じ ID にする
    when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-1');
    when(medicationHistoryTake.call(
      medicationHistory: anyNamed('medicationHistory'),
      newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
      recordedDateTime: anyNamed('recordedDateTime'),
      scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
      medicine: anyNamed('medicine'),
      medicationSchedule: anyNamed('medicationSchedule'),
      memberSettings: anyNamed('memberSettings'),
    )).thenAnswer((_) async => buildMedicationHistory());
    when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory')))
        .thenAnswer((_) async => buildRevertMedicationHistory());
    when(recentMedicationHistoriesFetch.call(recordedSinceDateTime: anyNamed('recordedSinceDateTime'))).thenAnswer((_) async => []);
    when(registerReminderLocalNotification.call()).thenAnswer((_) async {});
  });

  Future<void> pumpScheduleRow(WidgetTester tester, {required MedicationGroupScheduleRow scheduleRow}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // take 経路が参照する uid とメンバー個別通知設定を Firebase 非依存で解決させる
          appUserIDProvider.overrideWith((ref) => 'user-a'),
          groupMemberNotificationSettingsProvider.overrideWith((ref) => Stream.value(null)),
          medicationHistoryTakeProvider.overrideWith((ref) => medicationHistoryTake),
          medicationHistoryRevertProvider.overrideWith((ref) => medicationHistoryRevert),
          recentMedicationHistoriesFetchProvider.overrideWith((ref) => recentMedicationHistoriesFetch),
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

  // #253: アンチェックは take ドキュメントを削除せず revert アクションを即時追記する論理削除。
  // 「元に戻す」機能は持たず、チェックし直しは新しい take の追記として記録する
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
      // 「元に戻す」アクションは提供しない
      expect(find.text('元に戻す'), findsNothing);

      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured, hasLength(1));
      expect((captured.single as MedicationHistory).id, scheduleRow.medicationHistory!.id);
    });

    testWidgets('SnackBar を放置して閉じても追加の書き込みは発行されない', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      // SnackBar の表示時間を経過させ、退場アニメーションの完了を待つ
      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
      expect(find.text('服薬記録を取り消しました'), findsNothing);

      verify(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).called(1);
      verify(registerReminderLocalNotification.call()).called(1);
      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
    });

    testWidgets('アンチェック後のチェックし直しは、打ち消された既存 take への上書きではなく新しい take の追記として発行される', (tester) async {
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      final captured = verify(medicationHistoryTake.call(
        medicationHistory: captureAnyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).captured;
      expect(captured, hasLength(1));
      // medicationHistory: null = 自動採番の新規ドキュメントとして追記される
      expect(captured.single, isNull);
    });

    // 低速回線などで revert の書き込みが遅延している間のチェックし直しが「既存 take への上書き」と
    // 誤解釈されると、後から完了した revert に打ち消されてユーザーの訂正が無視される
    testWidgets('revert 書き込みの完了前のチェックし直しも、新しい take の追記として発行される', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 書き込みが未完了なので SnackBar はまだ表示されていない
      expect(find.text('服薬記録を取り消しました'), findsNothing);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      revertCompleter.complete(buildRevertMedicationHistory());
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      final captured = verify(medicationHistoryTake.call(
        medicationHistory: captureAnyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).captured;
      expect(captured, hasLength(1));
      expect(captured.single, isNull);
    });

    // チェックし直しの take が行に反映される前の再アンチェックで、行に残っている取消済みの古い take を
    // 取り消すと、後から完了した新しい take が残ってチェック済みに戻り、最後の取消が失われる
    testWidgets('チェックし直しの take の書き込み完了前の再アンチェックは、完了した take を取り消す', (tester) async {
      final takeCompleter = Completer<MedicationHistory>();
      final retakeMedicationHistory = buildMedicationHistory().copyWith(id: 'history-2');
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) => takeCompleter.future);
      when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-2');
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      // アンチェック → チェックし直し → take の完了前に再アンチェック
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      takeCompleter.complete(retakeMedicationHistory);
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1', 'history-2']);
    });

    testWidgets('チェックし直しの take の実行中に古い take の snapshot が遅れて届いても、再アンチェックはチェックし直しの take を取り消す', (tester) async {
      final retakeCompleter = Completer<MedicationHistory>();
      final retakeMedicationHistory = buildMedicationHistory().copyWith(id: 'history-2');
      var takeCount = 0;
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) {
        takeCount += 1;
        return takeCount == 1 ? Future.value(buildMedicationHistory()) : retakeCompleter.future;
      });
      var newMedicationHistoryIDCount = 0;
      when(medicationHistoryTake.newMedicationHistoryID()).thenAnswer((_) {
        newMedicationHistoryIDCount += 1;
        return newMedicationHistoryIDCount == 1 ? 'history-1' : 'history-2';
      });
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      // 新規チェック(history-1) → アンチェック → チェックし直し(history-2 の書き込み中)
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // history-1 の snapshot が遅れて行に届く
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());
      retakeCompleter.complete(retakeMedicationHistory);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1', 'history-2']);
    });

    // オフライン・低速回線では take の書き込みの Future が完了しないまま、ローカルの書き込みが行に反映される。
    // この状態のアンチェックが書き込みの完了を待つと、取消が発行されないままサーバーに take だけが残る
    testWidgets('take の書き込み完了前でも、行に反映された記録のアンチェックは待たずに取り消す', (tester) async {
      final takeCompleter = Completer<MedicationHistory>();
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) => takeCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // ローカルの書き込みが行に反映される
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1']);
    });

    // 取消済みの古い take の snapshot で未チェックに戻ると、ユーザーがチェックし直して take が重複し、
    // 後のアンチェックで片方しか取り消せない
    testWidgets('チェックし直しの take の書き込み中に古い take の取消が行に届いても、チェック済みのまま表示する', (tester) async {
      final retakeCompleter = Completer<MedicationHistory>();
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) => retakeCompleter.future);
      when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-2');
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      // アンチェック → チェックし直し(history-2 の書き込み中)
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // history-1 の取消が行に反映される
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());
      await tester.pump();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      retakeCompleter.complete(buildMedicationHistory().copyWith(id: 'history-2'));
      await tester.pumpAndSettle();

      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1', 'history-2']);
      verify(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).called(1);
    });

    testWidgets('take の書き込み中に他メンバーの記録が行に届いても、アンチェックは自分の take を取り消す', (tester) async {
      final takeCompleter = Completer<MedicationHistory>();
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) => takeCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 他メンバーが同じ予定に記録した take (自分の書き込み先とは別の ID) が行に届く
      final otherMemberScheduleRow = buildCheckedScheduleRow();
      await pumpScheduleRow(
        tester,
        scheduleRow: otherMemberScheduleRow.copyWith(medicationHistory: otherMemberScheduleRow.medicationHistory!.copyWith(id: 'history-other')),
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      takeCompleter.complete(buildMedicationHistory());
      await tester.pumpAndSettle();

      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1']);
    });

    testWidgets('チェックし直しの take の完了後・行への反映前の再アンチェックは、その take を取り消す', (tester) async {
      final retakeMedicationHistory = buildMedicationHistory().copyWith(id: 'history-2');
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) async => retakeMedicationHistory);
      when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-2');
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      // 行の記録は古い take のまま (snapshot 未反映) で再アンチェック
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1', 'history-2']);
    });
  });

  // #81: 最低服用間隔が空いていない場合は注意ダイアログを挟む。記録自体は無効化しない
  group('MedicineTileScheduleRow の服用間隔チェック', () {
    void verifyTakeCalled(int count) {
      final verification = verify(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
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
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
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
