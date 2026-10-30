import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/calendar/monthly/pager.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/provider/diary.dart';

// #387: 2026 年 10 月は木曜始まりのため、月間カレンダーの 1 行目に前月 (9/27〜9/30) のグレーアウトの日付が並び、
// 27〜30 の数字が当月の日付と重複する。E2E (maestro) が数字の文字列で今日の日付を探すと前月側をタップして日付詳細シートが開かないため、
// 当月の日付だけを identifier で一意に特定できることを確かめる
void main() {
  testWidgets('前月のグレーアウトと数字が重なる日でも、当月の日付は identifier で 1 つに特定できる', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          diariesForDateTimeRangeProvider(
            dateTimeRange: DateTimeRange(start: DateTime(2026, 10, 1), end: DateTime(2026, 10, 31, 23, 59, 59)),
          ).overrideWith((ref) => Stream.value(<Diary>[])),
        ],
        child: MaterialApp(
          home: Scaffold(body: MonthCalendarPager(displayedMonth: DateTime(2026, 10, 1))),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('30'), findsNWidgets(2));
    expect(find.bySemanticsIdentifier('calendar_day_tile_2026-10-30'), findsOneWidget);
    expect(find.bySemanticsIdentifier('calendar_day_tile_2026-09-30'), findsNothing);
    // identifier が付いているのは当月側 (最終行) の 30 で、1 行目の前月の 30 ではない
    expect(tester.getCenter(find.bySemanticsIdentifier('calendar_day_tile_2026-10-30')).dy, greaterThan(tester.getCenter(find.text('30').first).dy));
  });
}
