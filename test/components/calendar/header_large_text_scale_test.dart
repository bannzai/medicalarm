import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/calendar/day/today_badge.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/features/calendar/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/l10n/app_localizations.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

// #572: 文字サイズ最大 (倍率 3.0) で、服薬タブの日付の見出しとカレンダータブの月の見出しが切れずに表示されることを確かめる。
// 幅は iPhone 17 の論理幅 (402)
const _deviceSize = Size(402, 874);

/// 見出しの既定の高さ。倍率 1.0 ではこの高さのまま変わらないことを確かめる
const double _headerDefaultHeight = 50;

/// 倍率 1.0 で、見出しの高さが既定のまま、文字が FittedBox で縮められずに描かれている (既定の見た目が変わらない) ことを確かめる。
void _expectDefaultAppearance(WidgetTester tester, {required String text, required Finder header}) {
  expect(tester.getSize(header).height, _headerDefaultHeight);
  // getSize は描画前の自身の大きさを返し FittedBox の縮小を含まないため、変換後の矩形の大きさで比べる
  expect(tester.getRect(find.text(text)).size, tester.renderObject<RenderParagraph>(find.text(text)).size, reason: '$text が縮められている');
}

/// [child] を、文字の倍率 [textScaleFactor] の画面に描画する。日記は無い状態にする。
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
          child: child,
        ),
      ),
    ),
  );
  await tester.pump();
}

/// [text] の文字が切れずに、見出し [header] の中に収まっていることを確かめる。
/// 文字は 1 行で描くのに要る幅と高さのまま描かれ、描画後の矩形 (FittedBox の縮小を含む) が見出しの矩形の中にある
void _expectTextInsideHeader(WidgetTester tester, {required String text, required Finder header}) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  expect(paragraph.size.width, greaterThanOrEqualTo(paragraph.getMaxIntrinsicWidth(double.infinity) - 0.01), reason: '$text が横に切れている');
  expect(paragraph.size.height, greaterThanOrEqualTo(paragraph.getMaxIntrinsicHeight(double.infinity) - 0.01), reason: '$text が縦に切れている');
  final textRect = tester.getRect(find.text(text));
  final headerRect = tester.getRect(header);
  expect(textRect.left, greaterThanOrEqualTo(headerRect.left - 0.01), reason: '$text が見出しの左にはみ出している ($textRect / $headerRect)');
  expect(textRect.right, lessThanOrEqualTo(headerRect.right + 0.01), reason: '$text が見出しの右にはみ出している ($textRect / $headerRect)');
  expect(textRect.top, greaterThanOrEqualTo(headerRect.top - 0.01), reason: '$text が見出しの上にはみ出している ($textRect / $headerRect)');
  expect(textRect.bottom, lessThanOrEqualTo(headerRect.bottom + 0.01), reason: '$text が見出しの下にはみ出している ($textRect / $headerRect)');
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ja');
  });

  for (final locale in ['ja', 'en']) {
    for (final textScaleFactor in [1.0, 3.0]) {
      group('$locale・文字の倍率 $textScaleFactor', () {
        setUp(() {
          L = lookupAppLocalizations(Locale(locale));
          Intl.defaultLocale = locale;
          addTearDown(() => Intl.defaultLocale = null);
        });

        testWidgets('服薬タブの日付の見出しが切れずに見出しの中に収まる', (tester) async {
          await _pump(
            tester,
            textScaleFactor: textScaleFactor,
            child: Scaffold(body: TodayBadge(date: ValueNotifier(DateTime(2026, 11, 11)))),
          );

          expect(tester.takeException(), isNull);
          final dayText = DateFormat(DateFormat.NUM_MONTH_DAY).format(DateTime(2026, 11, 11));
          if (textScaleFactor == 1.0) {
            _expectDefaultAppearance(tester, text: dayText, header: find.byType(TodayBadge));
          }
          _expectTextInsideHeader(tester, text: dayText, header: find.byType(TodayBadge));
        });

        testWidgets('カレンダータブの月の見出しが切れずに見出しの中に収まる', (tester) async {
          await _pump(tester, textScaleFactor: textScaleFactor, child: const CalendarPage());

          expect(tester.takeException(), isNull);
          final monthText = DateFormat(DateFormat.YEAR_MONTH).format(today());
          final header = find.ancestor(of: find.text(monthText), matching: find.byType(Container)).first;
          if (textScaleFactor == 1.0) {
            _expectDefaultAppearance(tester, text: monthText, header: header);
          }
          _expectTextInsideHeader(tester, text: monthText, header: header);
        });
      });
    }
  }
}
