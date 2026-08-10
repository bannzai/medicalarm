// MedicineImageImportReviewSheet のウィジェットテスト。
// 候補の選択・名前編集・登録枠上限による選択制限・空候補表示・確定/キャンセルの戻り値を検証する。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_image_import/review_sheet.dart';

/// テスト用のスケジュールを作る。通知設定は検証対象外なので固定値。
MedicationSchedule schedule({required String id, required int hour, required int minute, required String quantityMemo}) {
  return MedicationSchedule(
    id: id,
    hour: hour,
    minute: minute,
    quantityMemo: quantityMemo,
    notificationSetting: const MedicineScheduleNotificationSetting(isReminderEnabled: true, isFollowupEnabled: true, useCriticalAlert: false),
    focusConnectSetting: const MedicineScheduleFocusConnectSetting(),
  );
}

/// テスト用の候補を作る。
MedicineImageImportCandidate candidate({required String name, bool isScheduleTimeFallback = false, int droppedScheduleCount = 0}) {
  return MedicineImageImportCandidate(
    name: name,
    schedules: [schedule(id: 'schedule-$name', hour: 8, minute: 0, quantityMemo: '1錠')],
    selected: true,
    isScheduleTimeFallback: isScheduleTimeFallback,
    droppedScheduleCount: droppedScheduleCount,
  );
}

/// シートを開くボタンだけを持つ画面を pump し、シートの戻り値を記録する関数を返す。
Future<List<MedicineImageImportCandidate>? Function()> pumpAndOpenSheet(
  WidgetTester tester, {
  required List<MedicineImageImportCandidate> candidates,
  required int maxSelectableCount,
}) async {
  List<MedicineImageImportCandidate>? result;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showMedicineImageImportReviewSheet(context: context, candidates: candidates, maxSelectableCount: maxSelectableCount);
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return () => result;
}

void main() {
  testWidgets('候補が表示され、確定で選択された候補が返る', (tester) async {
    final readResult = await pumpAndOpenSheet(
      tester,
      candidates: [
        candidate(name: 'ロキソニン'),
        candidate(name: 'ガスター'),
      ],
      maxSelectableCount: 10,
    );

    expect(find.text(L.medicineImageImportReviewTitle), findsOneWidget);
    // 名前と、頻度(毎日固定)・スケジュールの時刻・服用量が表示される
    expect(find.text('ロキソニン'), findsOneWidget);
    expect(find.text('ガスター'), findsOneWidget);
    expect(find.text('${L.daily} 08:00 1錠'), findsNWidgets(2));

    await tester.tap(find.text(L.medicineImageImportAddCount(2)));
    await tester.pumpAndSettle();

    expect(readResult()?.map((candidate) => candidate.name), ['ロキソニン', 'ガスター']);
  });

  testWidgets('チェックを外した候補は確定結果に含まれない', (tester) async {
    final readResult = await pumpAndOpenSheet(
      tester,
      candidates: [
        candidate(name: 'ロキソニン'),
        candidate(name: 'ガスター'),
      ],
      maxSelectableCount: 10,
    );

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text(L.medicineImageImportAddCount(1)));
    await tester.pumpAndSettle();

    expect(readResult()?.map((candidate) => candidate.name), ['ガスター']);
  });

  testWidgets('残り登録枠を超える候補は初期未選択で、枠を使い切っている間は追加選択できない', (tester) async {
    await pumpAndOpenSheet(
      tester,
      candidates: [
        candidate(name: 'ロキソニン'),
        candidate(name: 'ガスター'),
        candidate(name: 'ムコダイン'),
      ],
      maxSelectableCount: 2,
    );

    expect(find.text(L.medicineImageImportSelectableLimit(2)), findsOneWidget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox).at(0)).value, true);
    expect(tester.widget<Checkbox>(find.byType(Checkbox).at(1)).value, true);
    expect(tester.widget<Checkbox>(find.byType(Checkbox).at(2)).value, false);
    // 枠を使い切っているため 3 件目は選択できない
    expect(tester.widget<Checkbox>(find.byType(Checkbox).at(2)).onChanged, isNull);

    // 1 件外すと 3 件目が選択できるようになる
    await tester.tap(find.byType(Checkbox).at(0));
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox).at(2)).onChanged, isNotNull);
  });

  testWidgets('名前を編集して確定すると編集後の名前が返り、空にした候補は除外される', (tester) async {
    final readResult = await pumpAndOpenSheet(
      tester,
      candidates: [
        candidate(name: 'ロキソニン'),
        candidate(name: 'ガスター'),
      ],
      maxSelectableCount: 10,
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'ロキソニンS');
    await tester.enterText(find.byType(TextFormField).at(1), '  ');
    await tester.pumpAndSettle();

    await tester.tap(find.text(L.medicineImageImportAddCount(2)));
    await tester.pumpAndSettle();

    expect(readResult()?.map((candidate) => candidate.name), ['ロキソニンS']);
  });

  testWidgets('候補が 0 件の場合は読み取れなかった旨を表示する', (tester) async {
    final readResult = await pumpAndOpenSheet(tester, candidates: [], maxSelectableCount: 10);

    expect(find.text(L.medicineImageImportEmpty), findsOneWidget);

    await tester.tap(find.text(L.close));
    await tester.pumpAndSettle();

    expect(readResult(), isNull);
  });

  testWidgets('仮時刻・上限で除外された服用時刻がある候補には注意書きが表示される', (tester) async {
    await pumpAndOpenSheet(
      tester,
      candidates: [
        candidate(name: 'ロキソニン', isScheduleTimeFallback: true),
        candidate(name: 'ガスター', droppedScheduleCount: 1),
      ],
      maxSelectableCount: 10,
    );

    expect(find.text(L.medicineImageImportTimeFallbackCaption), findsOneWidget);
    expect(find.text(L.medicineImageImportDroppedSchedulesCaption(1)), findsOneWidget);
  });

  testWidgets('キャンセルすると null が返る', (tester) async {
    final readResult = await pumpAndOpenSheet(tester, candidates: [candidate(name: 'ロキソニン')], maxSelectableCount: 10);

    await tester.tap(find.text(L.cancel));
    await tester.pumpAndSettle();

    expect(readResult(), isNull);
  });
}
