import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/calendar/const.dart';
import 'package:medicalarm/components/calendar/day/tile.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

// #429: 週カレンダーの日付セルは CalendarConst.weeklyTileHeight の高さに収まる必要がある。
// 日記のメモがある日はメモのアイコン (CalendarDayBadge) が日付の下に並ぶため、その分も含めて収まることを確かめる
void main() {
  Widget weeklyLine({required Diary? diary, required bool selected}) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: CalendarConst.weeklyTileHeight,
            child: Row(
              children: [CalendarDayTile(date: DateTime(2026, 10, 26), weekday: Weekday.Monday, diary: diary, onTap: (_) {}, selected: selected)],
            ),
          ),
        ),
      ),
    );
  }

  final diaryWithMemo = Diary(id: 'diary', userID: 'user', memo: 'メモ', diaryDate: DateTime(2026, 10, 26));

  for (final selected in [true, false]) {
    testWidgets('日記のメモがある日 (selected: $selected) は週カレンダーの高さで overflow しない', (tester) async {
      await tester.pumpWidget(weeklyLine(diary: diaryWithMemo, selected: selected));

      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.description), findsOneWidget);
    });

    testWidgets('日記が無い日 (selected: $selected) は週カレンダーの高さで overflow しない', (tester) async {
      await tester.pumpWidget(weeklyLine(diary: null, selected: selected));

      expect(tester.takeException(), isNull);
    });
  }
}
