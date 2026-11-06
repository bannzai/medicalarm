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
import 'package:medicalarm/utils/analytics/error.dart';
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

/// 失敗の記録を捨てる [ErrorLogger]。take の失敗経路を Firebase 未初期化のテスト環境で通すために使う
class _NoopErrorLogger implements ErrorLogger {
  @override
  void recordError(dynamic exception, StackTrace? stack) {}

  @override
  void log(String message) {}
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

      takeCompleter.complete(buildMedicationHistory().copyWith(id: 'history-2'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1', 'history-2']);
    });

    testWidgets('チェックし直しの take の実行中に古い take の snapshot が遅れて届いても、再アンチェックはチェックし直しの take を取り消す', (tester) async {
      final retakeCompleter = Completer<MedicationHistory>();
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
      retakeCompleter.complete(buildMedicationHistory().copyWith(id: 'history-2'));
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

    testWidgets('チェックとアンチェックを書き込みの完了前に繰り返しても、反映された各 take を取り消す', (tester) async {
      // オフラインを模して、どちらの take の書き込みも完了させない
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) => Completer<MedicationHistory>().future);
      var newMedicationHistoryIDCount = 0;
      when(medicationHistoryTake.newMedicationHistoryID()).thenAnswer((_) {
        newMedicationHistoryIDCount += 1;
        return newMedicationHistoryIDCount == 1 ? 'history-1' : 'history-2';
      });
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      // チェック(history-1) → アンチェック → チェック(history-2) → アンチェック
      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byType(Checkbox));
        await tester.pump();
      }
      // history-1 のローカルの書き込みが行に反映される
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());
      await tester.pump();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1']);
    });

    testWidgets('アンチェック済みの古い take の書き込みが失敗しても、後のチェックし直しの表示を戻さない', (tester) async {
      final firstTakeCompleter = Completer<MedicationHistory>();
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
        return takeCount == 1 ? firstTakeCompleter.future : Completer<MedicationHistory>().future;
      });
      var newMedicationHistoryIDCount = 0;
      when(medicationHistoryTake.newMedicationHistoryID()).thenAnswer((_) {
        newMedicationHistoryIDCount += 1;
        return newMedicationHistoryIDCount == 1 ? 'history-1' : 'history-2';
      });
      // 失敗の記録先の Crashlytics は Firebase 未初期化のテスト環境では使えないため、記録しない実装に差し替える
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      // チェック(history-1) → アンチェック → チェック(history-2)
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byType(Checkbox));
        await tester.pump();
      }
      firstTakeCompleter.completeError(Exception('take failed'));
      await tester.pump();
      await tester.pump();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      // チェックし直しの take (history-2) が書き込まれている
      final captured = verify(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: captureAnyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).captured;
      expect(captured, ['history-1', 'history-2']);
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
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) async => buildMedicationHistory().copyWith(id: 'history-2'));
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

    // #483: 取消に失敗した take が取消待ちに残ると、後でその記録が行に届いた時に未チェックと表示され、
    // サーバーに有効な take が残っているのに飲み忘れに見えて二重服用を招く
    testWidgets('行に反映される前の take の取消が失敗したら、その記録が行に届いてもチェック済みのまま表示する', (tester) async {
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) async => buildMedicationHistory().copyWith(id: 'history-2'));
      when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-2');
      var revertCount = 0;
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) async {
        revertCount += 1;
        if (revertCount == 2) {
          throw Exception('revert failed');
        }
        return buildRevertMedicationHistory();
      });
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      // アンチェック(history-1 の取消は成功) → チェックし直し(history-2) → 行への反映前の再アンチェック(取消は失敗)
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
      }
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      // 取消できなかった history-2 が行に届く
      final checkedScheduleRow = buildCheckedScheduleRow();
      await pumpScheduleRow(
        tester,
        scheduleRow: checkedScheduleRow.copyWith(medicationHistory: checkedScheduleRow.medicationHistory!.copyWith(id: 'history-2')),
      );
      await tester.pump();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
    });

    // #483: 行に反映される前の take の取消が失敗した後のアンチェックが、行に残る取消済みの古い take を取り消すと、
    // 取消できなかった take が残ったまま未チェックと表示される
    testWidgets('行に反映される前の take の取消が失敗した後のアンチェックは、その take を取り消し直す', (tester) async {
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) async => buildMedicationHistory().copyWith(id: 'history-2'));
      when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-2');
      var revertCount = 0;
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) async {
        revertCount += 1;
        if (revertCount == 2) {
          throw Exception('revert failed');
        }
        return buildRevertMedicationHistory();
      });
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      // アンチェック(成功) → チェックし直し(history-2) → 再アンチェック(失敗)
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
      }
      // 取消の失敗のエラーダイアログを閉じてから、もう一度アンチェックする
      await tester.tap(find.text('閉じる'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1', 'history-2', 'history-2']);
    });

    // #479: 取り消せなかった take は有効な記録として残るため、後から別の操作をしていても実状態はチェック済み。
    // 未チェックのまま残すと、次のチェックで有効な take が重複する。
    // 取消の書き込み中のチェックし直しは取消の結果を待つため、再アンチェックで取りやめたチェックし直しの take は発行されない (#443)
    testWidgets('古い取消の書き込み中にチェックし直してから再アンチェックし、古い取消が失敗したら、取り消せなかった記録をチェック済みへ戻す', (tester) async {
      final firstRevertCompleter = Completer<MedicationHistory>();
      var revertCount = 0;
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) {
        revertCount += 1;
        return revertCount == 1 ? firstRevertCompleter.future : Future.value(buildRevertMedicationHistory());
      });
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) async => buildMedicationHistory().copyWith(id: 'history-2'));
      when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-2');
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      // アンチェック(history-1 の取消は書き込み中) → チェックし直し(取消の結果待ち) → 再アンチェック(チェックし直しを取りやめる)
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      // 古い history-1 の取消が失敗する
      firstRevertCompleter.completeError(Exception('revert failed'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);

      // 次のアンチェックは、取り消せなかった history-1 を取り消し直す。取消の失敗のエラーダイアログを閉じてから操作する
      await tester.tap(find.text('閉じる'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
      final capturedReverts = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(capturedReverts.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1', 'history-1']);
    });

    // チェックし直しが取消の結果を待っている間に取消が失敗したら、取り消せずに残った記録をチェック済みで表示する。
    // チェックし直しの take は発行されないため、take の失敗の設定は使われない (#443)
    testWidgets('取消の結果を待つチェックし直しの後に取消が失敗したら、残った take をチェック済みで表示する', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) async {
        throw Exception('take failed');
      });
      when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-2');
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      // アンチェック(history-1 の取消は書き込み中) → チェックし直し(取消の結果待ち)
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      // 古い history-1 の取消も失敗する
      revertCompleter.completeError(Exception('revert failed'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
    });

    // #483: 取消の書き込み中にその take が行に反映された後で取消が失敗したら、取消を始めた時点の古い行ではなく
    // 今の行 (取り消せなかった take が載っている) で表示を戻す
    testWidgets('取消の書き込み中に take が行に反映された後で取消が失敗したら、チェック済みの表示へ戻す', (tester) async {
      when(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).thenAnswer((_) async => buildMedicationHistory().copyWith(id: 'history-2'));
      when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-2');
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      // チェック(history-2 は行に未反映) → アンチェック(history-2 の取消は書き込み中)
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 取消の書き込み中に history-2 が行に届く
      final checkedScheduleRow = buildCheckedScheduleRow();
      await pumpScheduleRow(
        tester,
        scheduleRow: checkedScheduleRow.copyWith(medicationHistory: checkedScheduleRow.medicationHistory!.copyWith(id: 'history-2')),
      );
      await tester.pump();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, false);
      // history-2 の取消が失敗する
      revertCompleter.completeError(Exception('revert failed'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
    });

    // take の書き込み中に行が他メンバーの記録に入れ替わった後で take が失敗したら、take を始めた時点の古い行 (記録なし) ではなく
    // 今の行で表示を戻す
    testWidgets('take の書き込み中に行に別の記録が届いた後で take が失敗したら、チェック済みの表示へ戻す', (tester) async {
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
      when(medicationHistoryTake.newMedicationHistoryID()).thenReturn('history-2');
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      // チェック(history-2 の take は書き込み中)
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 書き込み中に別の記録 (history-1) が行に届く
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());
      await tester.pump();
      // history-2 の take が失敗する
      takeCompleter.completeError(Exception('take failed'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
    });

    testWidgets('最新の取消が失敗した時は、チェック済みの表示へ戻す', (tester) async {
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) async {
        throw Exception('revert failed');
      });
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
    });

    // 取消の結果を待つ間に取消の snapshot が行に届いても、チェックし直しを破棄せず、取り消せた後に新しい take を追記する (#443)
    testWidgets('取消の書き込み中にチェックし直し、取消の snapshot が届いてから取消が成功したら、新しい take を 1 件追記する', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 取消のローカルの書き込みが行に反映される
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());
      await tester.pump();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);

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
      expect(captured, [null]);
    });

    // 待っている take が失敗して取消対象が無かった場合は、取り消せなかった記録も無いため、チェックし直しの take を追記する (#443)
    testWidgets('取消が待っている take が失敗した後は、チェックし直しの take を追記する', (tester) async {
      final firstTakeCompleter = Completer<MedicationHistory>();
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
        return takeCount == 1 ? firstTakeCompleter.future : Future.value(buildMedicationHistory().copyWith(id: 'history-2'));
      });
      var newMedicationHistoryIDCount = 0;
      when(medicationHistoryTake.newMedicationHistoryID()).thenAnswer((_) {
        newMedicationHistoryIDCount += 1;
        return newMedicationHistoryIDCount == 1 ? 'history-1' : 'history-2';
      });
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());

      // チェック(history-1 の書き込み中) → アンチェック(history-1 の完了待ち) → チェックし直し(取消の結果待ち)
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byType(Checkbox));
        await tester.pump();
      }
      firstTakeCompleter.completeError(Exception('take failed'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      final captured = verify(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: captureAnyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).captured;
      expect(captured, ['history-1', 'history-2']);
      verifyNever(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory')));
    });

    // オフラインでは取消の書き込みの Future がサーバーの応答まで完了しないため、チェックし直しの take は取消が同期されるまで発行されない (#443)
    testWidgets('取消の書き込みが完了しない間のチェックし直しは、チェック済みで表示し take を発行しない', (tester) async {
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory')))
          .thenAnswer((_) => Completer<MedicationHistory>().future);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());
      await tester.pump();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
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

    // 取消の結果を待つ間に日付の切り替え等で行が破棄されたら、チェックし直しの take は書かない。
    // 作り直された行は待ち状態を引き継がず未チェックと表示されるため、そこでのチェックと重複する (#443)
    testWidgets('取消の書き込み中にチェックし直してから行が破棄され、戻った行でチェックしたら、take は 1 件だけ書き込む', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 別の日付へ移って行が破棄され、取消のローカルの書き込みが反映された未チェックの行として作り直される
      await tester.pumpWidget(const SizedBox());
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      revertCompleter.complete(buildRevertMedicationHistory());
      await tester.pumpAndSettle();

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

    // 取消の snapshot が行に届いた後の再アンチェックでも、書き込み中の取消の結果を待つ対象から外さない (#443)
    testWidgets('取消の snapshot が届いた後に再アンチェックしてチェックし直し、取消が失敗した場合、新しい take を追記しない', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      // アンチェック(取消は書き込み中) → チェックし直し(取消の結果待ち)
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 取消のローカルの書き込みが行に反映される
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());
      await tester.pump();
      // 再アンチェック → チェックし直し
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      revertCompleter.completeError(Exception('revert failed'));
      await tester.pumpAndSettle();

      verifyNever(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      ));
      verify(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).called(1);
    });

    // 取消の snapshot で行の記録が消えた後に取消が失敗しても、取り消せなかった take が残るのでチェック済みへ戻す (#443)
    testWidgets('取消の書き込み中にチェックし直し、取消の snapshot が届いてから取消が失敗したら、チェック済みへ戻す', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());
      await tester.pump();
      revertCompleter.completeError(Exception('revert failed'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
    });

    // 取消の結果を待ってから記録しても、服用時刻は待ち明けではなくチェックし直した時刻にする (#443)
    testWidgets('取消の結果を待ったチェックし直しの take は、チェックし直した時刻を服用時刻にする', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      final checkedAfterDateTime = DateTime.now();
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      revertCompleter.complete(buildRevertMedicationHistory());
      await tester.pumpAndSettle();

      final captured = verify(medicationHistoryTake.call(
        medicationHistory: anyNamed('medicationHistory'),
        newMedicationHistoryID: anyNamed('newMedicationHistoryID'),
        recordedDateTime: captureAnyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).captured;
      expect((captured.single as DateTime).isAfter(checkedAfterDateTime), false);
    });

    // 取消の結果を待つ間に他メンバーの記録が行に届いたら、同じ予定の有効な記録があるので、チェックし直しの take を追記しない (#443)
    testWidgets('取消の結果を待つ間に他メンバーの記録が届いたら、取消が成功してもチェックし直しの take を追記しない', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // 取消のローカルの書き込みの後に、他メンバーの記録が行に届く
      await pumpScheduleRow(tester, scheduleRow: buildUncheckedScheduleRow());
      await tester.pump();
      final otherMemberScheduleRow = buildCheckedScheduleRow();
      await pumpScheduleRow(
        tester,
        scheduleRow: otherMemberScheduleRow.copyWith(medicationHistory: otherMemberScheduleRow.medicationHistory!.copyWith(id: 'history-other')),
      );
      await tester.pump();
      revertCompleter.complete(buildRevertMedicationHistory());
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
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

    // 自分の取消の書き込み中でも、行に届いた他メンバーの記録のアンチェックは、その記録を取り消す (#443)
    testWidgets('取消の書き込み中に他メンバーの記録が届いたら、そのアンチェックは他メンバーの記録を取り消す', (tester) async {
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory')))
          .thenAnswer((_) => Completer<MedicationHistory>().future);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      final otherMemberScheduleRow = buildCheckedScheduleRow();
      await pumpScheduleRow(
        tester,
        scheduleRow: otherMemberScheduleRow.copyWith(medicationHistory: otherMemberScheduleRow.medicationHistory!.copyWith(id: 'history-other')),
      );
      await tester.pump();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      final captured = verify(medicationHistoryRevert.call(takeMedicationHistory: captureAnyNamed('takeMedicationHistory'))).captured;
      expect(captured.map((medicationHistory) => (medicationHistory as MedicationHistory).id), ['history-1', 'history-other']);
    });

    // 取消が失敗すると元の take が有効なまま残るため、チェックし直しで新しい take を追記すると記録が重複する (#443)
    testWidgets('取消の書き込み中にチェックし直して取消が失敗した場合、新しい take を追記せず元の take のチェック済みに戻す', (tester) async {
      final revertCompleter = Completer<MedicationHistory>();
      when(medicationHistoryRevert.call(takeMedicationHistory: anyNamed('takeMedicationHistory'))).thenAnswer((_) => revertCompleter.future);
      final originalErrorLogger = errorLogger;
      errorLogger = _NoopErrorLogger();
      addTearDown(() => errorLogger = originalErrorLogger);
      await pumpScheduleRow(tester, scheduleRow: buildCheckedScheduleRow());

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      revertCompleter.completeError(Exception('revert failed'));
      await tester.pumpAndSettle();

      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, true);
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
