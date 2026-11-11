import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/calendar/const.dart';
import 'package:medicalarm/components/calendar/monthly/pager.dart';
import 'package:medicalarm/components/calendar/weekly/badge.dart';
import 'package:medicalarm/components/calendar/weekly/pager.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/features/home/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/l10n/app_localizations.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

// #543: 文字サイズ最大 (倍率 3.0) で、ホーム画面の下のタブの文字と週カレンダーの日付・曜日が切れずに表示されることを確かめる。
// 幅は iPhone 17 の論理幅 (402)
const _deviceSize = Size(402, 874);

/// 週カレンダーの日付のセルの幅。左右に 10 の余白を取って 7 等分する
const double _weeklyDayCellWidth = (402 - 10 * 2) / 7;

/// 曜日・月カレンダーの日付のセルの幅。余白を取らずに 7 等分する
const double _weekdayCellWidth = 402 / 7;

/// [child] を、文字の倍率 [textScaleFactor] の画面の下端に置いて描画する。日記は無い状態にする。
Future<void> _pump(WidgetTester tester, {required double textScaleFactor, required Widget child}) async {
  tester.view.physicalSize = _deviceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        currentGroupDatabaseProvider.overrideWith((ref) => GroupDatabase(groupID: 'test-group')),
        diariesForDateTimeRangeProvider.overrideWith((ref, dateTimeRange) => Stream.value(<Diary>[])),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: false),
        home: MediaQuery(
          data: MediaQueryData(size: _deviceSize, textScaler: TextScaler.linear(textScaleFactor)),
          child: Scaffold(
            body: Align(alignment: Alignment.bottomCenter, child: child),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// [text] の文字が、1 行で描くのに要る幅と高さのまま描かれている (横・縦に切れていない) ことを確かめる。
void _expectNotClipped(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text).first);
  expect(paragraph.size.width, greaterThanOrEqualTo(paragraph.getMaxIntrinsicWidth(double.infinity) - 0.01), reason: '$text が横に切れている');
  expect(paragraph.size.height, greaterThanOrEqualTo(paragraph.getMaxIntrinsicHeight(double.infinity) - 0.01), reason: '$text が縦に切れている');
}

/// [text] の描画後の矩形 (FittedBox の縮小を含む) が、[area] の中に収まっていることを確かめる。
void _expectInside(WidgetTester tester, {required String text, required Rect area}) {
  final textRect = tester.getRect(find.text(text).first);
  expect(textRect.left, greaterThanOrEqualTo(area.left - 0.01), reason: '$text が $area の左にはみ出している ($textRect)');
  expect(textRect.right, lessThanOrEqualTo(area.right + 0.01), reason: '$text が $area の右にはみ出している ($textRect)');
  expect(textRect.top, greaterThanOrEqualTo(area.top - 0.01), reason: '$text が $area の上にはみ出している ($textRect)');
  expect(textRect.bottom, lessThanOrEqualTo(area.bottom + 0.01), reason: '$text が $area の下にはみ出している ($textRect)');
}

void main() {
  for (final locale in ['ja', 'en']) {
    for (final textScaleFactor in [1.0, 3.0]) {
      group('$locale・文字の倍率 $textScaleFactor', () {
        setUp(() {
          L = lookupAppLocalizations(Locale(locale));
        });

        testWidgets('下のタブの文字が切れずにタブの中に収まる', (tester) async {
          final tabController = TabController(length: 4, vsync: tester);
          addTearDown(tabController.dispose);
          await _pump(
            tester,
            textScaleFactor: textScaleFactor,
            child: HomePageTabBar(tabController: tabController),
          );

          expect(tester.takeException(), isNull);
          // 既定の倍率と同じ高さ (アイコンと文字の Tab の既定の高さ 72 + 選択中の下線の太さ 2) のまま変わらない
          expect(tester.getSize(find.byType(HomePageTabBar)).height, 74);
          for (final (index, label) in [L.medication, L.history, L.calendar, L.settings].indexed) {
            // 文字サイズの設定にかかわらず、既定の倍率で描く
            expect(tester.renderObject<RenderParagraph>(find.text(label)).textScaler, TextScaler.noScaling);
            // テスト用のフォントは英字も 1 文字が正方形になり、既定の倍率でも「Medication」がタブの幅を超えて実機と合わないため、
            // 1 文字の幅が実機と同じ日本語でだけ幅を確かめる。英語の幅は simulator のスクリーンショットで確かめる
            if (locale == 'ja') {
              _expectNotClipped(tester, label);
              _expectInside(tester, text: label, area: tester.getRect(find.byType(Tab).at(index)));
            }
          }
        });

        testWidgets('週カレンダーの日付と曜日が切れずにセルの中に収まる', (tester) async {
          await _pump(
            tester,
            textScaleFactor: textScaleFactor,
            child: WeeklyCalendarPager(
              // 選択日の丸 (白い数字) も含めて確かめるため、表示する週の中の今日を選ぶ
              date: ValueNotifier(today()),
              pageController: PageController(initialPage: todayCalendarPageIndex),
            ),
          );

          expect(tester.takeException(), isNull);
          if (textScaleFactor == 1.0) {
            // 既定の倍率では従来の高さ (曜日 30・日付 50) のまま変わらない
            expect(tester.getSize(find.byType(WeekdayBadge).first).height, WeekdayBadgeConst.height);
            expect(tester.getSize(find.byType(PageView)).height, CalendarConst.weeklyTileHeight);
          }
          final pageViewRect = tester.getRect(find.byType(PageView));
          for (final day in weekcalendarDataSource[todayCalendarPageIndex].map((date) => '${date.day}')) {
            _expectNotClipped(tester, day);
            final dayRect = tester.getRect(find.text(day).first);
            _expectInside(tester, text: day, area: Rect.fromLTRB(dayRect.left, pageViewRect.top, dayRect.right, pageViewRect.bottom));
            expect(dayRect.width, lessThanOrEqualTo(_weeklyDayCellWidth + 0.01), reason: '日付 $day がセルの幅 $_weeklyDayCellWidth を超えている ($dayRect)');
          }
          for (final weekday in Weekday.values) {
            _expectNotClipped(tester, weekday.weekdayShortString());
            final weekdayRect = tester.getRect(find.text(weekday.weekdayShortString()).first);
            expect(
              weekdayRect.width,
              lessThanOrEqualTo(_weekdayCellWidth + 0.01),
              reason: '曜日 ${weekday.weekdayShortString()} がセルの幅を超えている ($weekdayRect)',
            );
            expect(weekdayRect.bottom, lessThanOrEqualTo(pageViewRect.top + 0.01), reason: '曜日 ${weekday.weekdayShortString()} が日付の行に重なっている');
          }
        });
      });
    }
  }

  for (final textScaleFactor in [1.0, 3.0]) {
    testWidgets('月カレンダーは文字の倍率 $textScaleFactor でも overflow せず、2 桁の日付がセルの幅に収まる', (tester) async {
      L = lookupAppLocalizations(const Locale('ja'));
      await _pump(
        tester,
        textScaleFactor: textScaleFactor,
        child: MonthCalendarPager(displayedMonth: DateTime(2026, 11, 1)),
      );

      expect(tester.takeException(), isNull);
      _expectNotClipped(tester, '30');
      final dayRect = tester.getRect(find.text('30').last);
      expect(dayRect.width, lessThanOrEqualTo(_weekdayCellWidth + 0.01), reason: '日付 30 がセルの幅を超えている ($dayRect)');
    });
  }
}
