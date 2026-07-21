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

@GenerateNiceMocks([
  MockSpec<MedicationHistoryTake>(),
  MockSpec<MedicationHistoryRevert>(),
  MockSpec<RegisterReminderLocalNotification>(),
])
void main() {
  late MockMedicationHistoryTake medicationHistoryTake;
  late MockMedicationHistoryRevert medicationHistoryRevert;
  late MockRegisterReminderLocalNotification registerReminderLocalNotification;

  setUp(() {
    medicationHistoryTake = MockMedicationHistoryTake();
    medicationHistoryRevert = MockMedicationHistoryRevert();
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
        recordedDateTime: anyNamed('recordedDateTime'),
        scheduledRecordedDate: anyNamed('scheduledRecordedDate'),
        medicine: anyNamed('medicine'),
        medicationSchedule: anyNamed('medicationSchedule'),
        memberSettings: anyNamed('memberSettings'),
      )).captured;
      expect(captured, hasLength(1));
      expect(captured.single, isNull);
    });
  });
}
