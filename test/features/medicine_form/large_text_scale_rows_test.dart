import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/additional_info/dose_receiver.dart';
import 'package:medicalarm/features/medicine_form/components/begin/tile.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/quantity_memo_text_field.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/section.dart';
import 'package:medicalarm/l10n/app_localizations.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

import 'text_lines.dart';

/// ローカル通知プラグインに触れないテスト用の RegisterReminderLocalNotification。
class _FakeRegisterReminderLocalNotification extends RegisterReminderLocalNotification {
  _FakeRegisterReminderLocalNotification(super.ref);

  @override
  Future<void> call() async {}
}

/// 文字を最大にした時の倍率。iOS のアクセシビリティの文字サイズの最大 (AX5) が本文の約 3 倍のため 3.0 を使う
const _largestTextScaleFactor = 3.0;

/// 服用開始日・服用スケジュールの見出し・服用者を描画する幅。
/// テスト用フォント (FlutterTest) は 1 文字が fontSize 四方の幅になり実機のフォントより横に長い。
/// 修正前の実装で、幅 600 で実機 (iPhone 17) と同じく単語の途中で折り返す・はみ出すため 600 を使う
const _labelRowSurfaceWidth = 600.0;

/// 服用スケジュールの行を描画する幅。幅 600 では修正前の実装でも時刻欄に「08:00」が 1 行で収まり再現しないため、
/// 実機 (iPhone 17) の論理幅 402 を使う。修正前の実装では幅 402 で「08: / 00」と 2 行に割れる
const _scheduleRowSurfaceWidth = 402.0;

/// [child] を、幅 [width]・端末の文字サイズの倍率 [textScaleFactor]・文字を太くする設定 [boldText] で描画する。
Future<void> _pump(
  WidgetTester tester, {
  required double width,
  required double textScaleFactor,
  required Widget child,
  // iOS の文字を太くする設定の既定 (オフ)
  bool boldText = false,
}) async {
  // 服用スケジュールの見出し・行・追加ボタンが縦に収まる高さ
  const height = 1600.0;
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        customerInfoProvider.overrideWith((ref) => const Stream.empty()),
        registerReminderLocalNotificationProvider.overrideWith((ref) => _FakeRegisterReminderLocalNotification(ref)),
      ],
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, height), textScaler: TextScaler.linear(textScaleFactor), boldText: boldText),
          child: Scaffold(body: SingleChildScrollView(child: child)),
        ),
      ),
    ),
  );
}

/// 08:00 の服用スケジュールが 1 件ある MedicineScheduleSection。
MedicineScheduleSection _medicineScheduleSection() {
  return MedicineScheduleSection(
    schedules: ValueNotifier([
      const MedicationSchedule(
        id: 'schedule-1',
        hour: 8,
        minute: 0,
        quantityMemo: '',
        notificationSetting: MedicineScheduleNotificationSetting(isReminderEnabled: true, isFollowupEnabled: false, useCriticalAlert: false),
        focusConnectSetting: null,
      ),
    ]),
    medicine: null,
  );
}

/// 容量欄に入力した文字の、画面上の矩形。
Rect _quantityMemoInputTextRect(WidgetTester tester) {
  final editable = tester
      .state<EditableTextState>(find.descendant(of: find.byType(MedicineScheduleQuantityMemoTextField), matching: find.byType(EditableText)))
      .renderEditable;
  return MatrixUtils.transformRect(
    editable.getTransformTo(null),
    editable.getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: editable.plainText.length)).single.toRect(),
  );
}

/// 薬の登録フォームの服用開始日・服用スケジュールの見出し・服用スケジュールの行・服用者で、
/// 英語表示で文字を拡大してもラベルが単語の途中で折り返されず、行からはみ出さないことを検証する。
/// https://github.com/bannzai/medicalarm/issues/474
void main() {
  tearDown(() {
    L = lookupAppLocalizations(const Locale('ja'));
  });

  group('英語表示で文字を拡大した時', () {
    setUp(() {
      L = lookupAppLocalizations(const Locale('en'));
    });

    testWidgets('服用開始日のラベルは単語の境目で折り返されはみ出さない', (WidgetTester tester) async {
      await _pump(
        tester,
        width: _labelRowSurfaceWidth,
        textScaleFactor: _largestTextScaleFactor,
        child: MedicationBeginTile(begin: ValueNotifier(DateTime(2026, 1, 1))),
      );

      expect(tester.takeException(), isNull);
      expectWrappedAtWordBoundaries(tester, text: L.medicationStartDate);
      expect(find.text('2026/01/01'), findsOneWidget);
    });

    testWidgets('服用スケジュールの見出しは単語の境目で折り返されはみ出さない', (WidgetTester tester) async {
      await _pump(tester, width: _labelRowSurfaceWidth, textScaleFactor: _largestTextScaleFactor, child: _medicineScheduleSection());

      expect(tester.takeException(), isNull);
      expectWrappedAtWordBoundaries(tester, text: L.medicationSchedule);
    });

    testWidgets('服用スケジュールの行の時刻欄は 1 行で表示されはみ出さない', (WidgetTester tester) async {
      await _pump(tester, width: _scheduleRowSurfaceWidth, textScaleFactor: _largestTextScaleFactor, child: _medicineScheduleSection());

      expect(tester.takeException(), isNull);
      expect(lineTexts(tester, text: '08:00'), ['08:00']);
    });

    // テスト用フォント (FlutterTest) は太字でも文字の幅が変わらないため、時刻欄の最小幅の計算が太字を反映しているかは
    // このテストでは検出できない (反映を外しても通る)。文字を太くする設定で例外が出ず 1 行に収まることだけを確かめる
    testWidgets('文字を太くする設定でも服用スケジュールの行の時刻欄は 1 行で表示されはみ出さない', (WidgetTester tester) async {
      await _pump(
        tester,
        width: _scheduleRowSurfaceWidth,
        textScaleFactor: _largestTextScaleFactor,
        boldText: true,
        child: _medicineScheduleSection(),
      );

      expect(tester.takeException(), isNull);
      expect(lineTexts(tester, text: '08:00'), ['08:00']);
    });

    // https://github.com/bannzai/medicalarm/issues/489
    testWidgets('服用スケジュールの容量欄の浮いたラベルは入力した文字に重ならない', (WidgetTester tester) async {
      await _pump(tester, width: _scheduleRowSurfaceWidth, textScaleFactor: _largestTextScaleFactor, child: _medicineScheduleSection());
      await tester.enterText(find.byType(MedicineScheduleQuantityMemoTextField), '1 tablet');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final labelRect = tester.getRect(find.text(L.quantity));
      final inputTextRect = _quantityMemoInputTextRect(tester);
      expect(labelRect.overlaps(inputTextRect), isFalse, reason: 'ラベル $labelRect と入力した文字 $inputTextRect が重なっている');
    });

    testWidgets('服用者のラベルは単語の境目で折り返されはみ出さない', (WidgetTester tester) async {
      await _pump(
        tester,
        width: _labelRowSurfaceWidth,
        textScaleFactor: _largestTextScaleFactor,
        child: MedicineDoseReceiverTile(doseReceiver: ValueNotifier(null)),
      );

      expect(tester.takeException(), isNull);
      expectWrappedAtWordBoundaries(tester, text: L.doseReceiver);
      expect(find.text(L.defaultDoseReceiver), findsOneWidget);
    });
  });

  group('日本語表示・既定の文字サイズの時', () {
    testWidgets('服用開始日のラベルと値は 1 行で表示される', (WidgetTester tester) async {
      await _pump(
        tester,
        width: _scheduleRowSurfaceWidth,
        textScaleFactor: 1.0,
        child: MedicationBeginTile(begin: ValueNotifier(DateTime(2026, 1, 1))),
      );

      expect(tester.takeException(), isNull);
      expect(lineTexts(tester, text: L.medicationStartDate), [L.medicationStartDate]);
      expect(lineTexts(tester, text: '2026/01/01'), ['2026/01/01']);
    });

    testWidgets('服用スケジュールの見出しと時刻欄は 1 行で表示され、容量欄の大きさは幅 180・高さ 48 のまま', (WidgetTester tester) async {
      await _pump(tester, width: _scheduleRowSurfaceWidth, textScaleFactor: 1.0, child: _medicineScheduleSection());

      expect(tester.takeException(), isNull);
      expect(lineTexts(tester, text: L.medicationSchedule), [L.medicationSchedule]);
      expect(lineTexts(tester, text: '08:00'), ['08:00']);
      expect(tester.getSize(find.byType(MedicineScheduleQuantityMemoTextField)), const Size(180, 48));
    });

    testWidgets('服用者のラベルと値は 1 行で表示される', (WidgetTester tester) async {
      await _pump(
        tester,
        width: _scheduleRowSurfaceWidth,
        textScaleFactor: 1.0,
        child: MedicineDoseReceiverTile(doseReceiver: ValueNotifier(null)),
      );

      expect(tester.takeException(), isNull);
      expect(lineTexts(tester, text: L.doseReceiver), [L.doseReceiver]);
      expect(lineTexts(tester, text: L.defaultDoseReceiver), [L.defaultDoseReceiver]);
    });
  });
}
