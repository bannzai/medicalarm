import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/calendar/day/tile.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

// #287: 白文字 × AppColors.primary はコントラスト比 2.60:1 で WCAG AA (通常文字 4.5:1) に届かない。
// 白文字を載せる塗り面だけを AppColors.primaryFilled に差し替える方針の回帰テスト。
void main() {
  /// WCAG 2.1 の相対輝度。https://www.w3.org/TR/WCAG21/#dfn-relative-luminance
  double relativeLuminance({required Color color}) {
    double channel({required double value}) {
      // sRGB の 8bit 値を 0..1 に正規化した上で線形化する
      return value <= 0.03928 ? value / 12.92 : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
    }

    return 0.2126 * channel(value: color.r) + 0.7152 * channel(value: color.g) + 0.0722 * channel(value: color.b);
  }

  /// WCAG 2.1 のコントラスト比。https://www.w3.org/TR/WCAG21/#dfn-contrast-ratio
  double contrastRatio({required Color foreground, required Color background}) {
    final foregroundLuminance = relativeLuminance(color: foreground);
    final backgroundLuminance = relativeLuminance(color: background);
    return (math.max(foregroundLuminance, backgroundLuminance) + 0.05) / (math.min(foregroundLuminance, backgroundLuminance) + 0.05);
  }

  /// アプリと同じ Material 2 テーマのうち、本テストが検証する塗り面に関わる設定だけを再現する。
  /// lib/main.dart の App は Firebase 初期化済みのプロバイダを前提とするため widget test から共有できず、
  /// 検証対象 (colorScheme / appBarTheme / elevatedButtonTheme / useMaterial3) だけを写している。
  ThemeData appTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, secondary: AppColors.secondary),
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryFilled, foregroundColor: Colors.white, elevation: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryFilled,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledBackgroundColor: AppColors.disabled,
        ),
      ),
      useMaterial3: false,
    );
  }

  test('AppColors.primaryFilled と白のコントラスト比は WCAG AA の通常文字 4.5:1 を満たす', () {
    expect(contrastRatio(foreground: Colors.white, background: AppColors.primaryFilled), greaterThanOrEqualTo(4.5));
  });

  test('AppColors.primary と白のコントラスト比は 4.5:1 未満のままである', () {
    // primary はアイコン・見出し等のアクセントとして据え置く方針の確認。
    // primary 自体を暗くする変更が入ったら primaryFilled との使い分けを見直す
    expect(contrastRatio(foreground: Colors.white, background: AppColors.primary), lessThan(4.5));
  });

  testWidgets('AppBar の背景は AppColors.primaryFilled で描画される', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(),
        home: Scaffold(appBar: AppBar(title: const Text('x'))),
      ),
    );

    final material = tester.widget<Material>(find.descendant(of: find.byType(AppBar), matching: find.byType(Material)).first);
    expect(material.color, AppColors.primaryFilled);
  });

  testWidgets('ElevatedButton の背景は AppColors.primaryFilled で描画される', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(),
        home: Scaffold(
          body: ElevatedButton(onPressed: () {}, child: const Text('x')),
        ),
      ),
    );

    final material = tester.widget<Material>(find.descendant(of: find.byType(ElevatedButton), matching: find.byType(Material)).first);
    expect(material.color, AppColors.primaryFilled);
  });

  group('CalendarDayTile の選択円', () {
    // CalendarDayTile は root が Expanded、子孫の CalendarDayBadge が ConsumerWidget のため、
    // Row と ProviderScope で包んで描画する
    Widget wrapWithTheme({required bool selected}) {
      return ProviderScope(
        child: MaterialApp(
          theme: appTheme(),
          home: Scaffold(
            body: Row(
              children: [CalendarDayTile(date: DateTime(2026, 9, 8), weekday: Weekday.Tuesday, diary: null, onTap: null, selected: selected)],
            ),
          ),
        ),
      );
    }

    final backgroundCircle = find.byWidgetPredicate(
      (widget) => widget is Container && (widget.decoration as BoxDecoration?)?.color == AppColors.primaryFilled,
    );

    testWidgets('selected: true では AppColors.primaryFilled で塗られる', (tester) async {
      await tester.pumpWidget(wrapWithTheme(selected: true));

      expect(backgroundCircle, findsOneWidget);
    });

    testWidgets('selected: false では選択円を描画しない', (tester) async {
      // 上のテストが選択円ではない別の Container を拾っていないことの確認
      await tester.pumpWidget(wrapWithTheme(selected: false));

      expect(backgroundCircle, findsNothing);
    });
  });
}
