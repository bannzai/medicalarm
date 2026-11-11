import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/calendar/const.dart';
import 'package:medicalarm/components/calendar/day/badge.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

class CalendarDayTile extends StatelessWidget {
  final DateTime date;
  final Weekday weekday;
  final Diary? diary;
  final bool selected;
  final Function(DateTime)? onTap;

  const CalendarDayTile.grayout({Key? key, required DateTime date, required Weekday weekday})
    : this(key: key, onTap: null, weekday: weekday, diary: null, date: date, selected: false);

  const CalendarDayTile({super.key, required this.date, required this.weekday, required this.diary, required this.onTap, required this.selected});

  @override
  Widget build(BuildContext context) {
    final onTap = this.onTap;
    return Expanded(
      // 月初の行に並ぶ前月のグレーアウトの日付は当月の日付と数字が重なるため (2026 年 10 月なら 27〜30)、E2E (maestro) は数字の文字列ではなく
      // タップできる日付だけに付けた日付の identifier で探す (#387)。MergeSemantics で identifier をボタンのタップ操作と同じ 1 ノードにまとめる。
      // iOS は label・操作を持たないノードをアクセシビリティ要素にせず、identifier だけのノードは XCUITest (maestro) から見えないため (#388)
      child: MergeSemantics(
        child: Semantics(
          // 端末の言語が fa・mr・ne 等だと intl は数字をその言語の数字にするため、E2E が組み立てる ASCII の日付と揃うよう en_US に固定する
          identifier: onTap != null ? 'calendar_day_tile_${DateFormat('yyyy-MM-dd', 'en_US').format(date)}' : null,
          child: RawMaterialButton(
            onPressed: () => onTap != null ? onTap(date.date()) : null,
            child: SizedBox(
              child: Column(
                children: <Widget>[
                  // 既定の大きさを下限にして、文字が大きい時は日付の数字に合わせて伸ばす。
                  // 横はセルの幅 (画面幅の 7 等分) で決まり伸ばせないため、収まらない数字だけ縮める (#543)
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: _dayBoxMinSize, minHeight: _dayBoxMinSize),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (selected) const Positioned.fill(child: _BackgroundCircle()),
                        Padding(
                          padding: const EdgeInsets.all(_dayTextPadding),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: _DayText(date: date, selected: selected, weekday: weekday, onTap: onTap),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CalendarDayBadge(date: date, diary: diary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DayText extends StatelessWidget {
  const _DayText({required this.date, required this.selected, required this.weekday, required this.onTap});

  final DateTime date;
  final bool selected;
  final Weekday weekday;
  final Function(DateTime p1)? onTap;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${date.day}',
      textAlign: TextAlign.center,
      style: _dayTextStyle.merge(
        TextStyle(
          color: () {
            if (selected) {
              return Colors.white;
            }
            final weekdayColor = switch (weekday) {
              Weekday.Sunday => weekday.weekdayColor(),
              Weekday.Monday => TextColor.gray,
              Weekday.Tuesday => TextColor.gray,
              Weekday.Wednesday => TextColor.gray,
              Weekday.Thursday => TextColor.gray,
              Weekday.Friday => TextColor.gray,
              Weekday.Saturday => weekday.weekdayColor(),
            };
            final onTap = this.onTap;
            final alpha = (255 * (onTap != null ? 1 : 0.4)).floor();
            return weekdayColor.withAlpha(alpha);
          }(),
        ),
      ),
    );
  }
}

/// 日付の数字の文字の形。セルの高さの計算 ([calendarWeeklyTileHeight]) と描画で同じものを使う。
const _dayTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);

/// 日付の領域 (選択日の丸を含む) の一辺の下限。既定の文字の大きさでの日付の領域の大きさ。
const double _dayBoxMinSize = 40;

/// 日付の数字と日付の領域の縁の間隔。既定の大きさで選択日の丸の直径が 32 (= 40 - 4 × 2) になる値。
const double _dayTextPadding = 4;

/// 週カレンダーの日付のセルの高さを、文字の倍率に合わせて返す。
/// 週カレンダーは PageView のため中身の高さに合わせて伸びず、高さを先に決める必要がある。
/// 既定の倍率では [CalendarConst.weeklyTileHeight] を返す。
double calendarWeeklyTileHeight({required BuildContext context}) {
  final dayTextPainter = TextPainter(
    text: TextSpan(text: '30', style: DefaultTextStyle.of(context).style.merge(_dayTextStyle)),
    textScaler: MediaQuery.textScalerOf(context),
    textDirection: Directionality.of(context),
  )..layout();
  // 日付の領域の下の、日記のメモのアイコン (CalendarDayBadge) の分の高さ
  const dayBadgeAreaHeight = CalendarConst.weeklyTileHeight - _dayBoxMinSize;
  final height = max(CalendarConst.weeklyTileHeight, dayTextPainter.height + _dayTextPadding * 2 + dayBadgeAreaHeight);
  dayTextPainter.dispose();
  return height;
}

class _BackgroundCircle extends StatelessWidget {
  const _BackgroundCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(_dayTextPadding),
      decoration: const BoxDecoration(
        // 選択日の数字は白のため、コントラスト比 4.5:1 を満たす primaryFilled を塗る (#287)
        color: AppColors.primaryFilled,
        shape: BoxShape.circle,
      ),
    );
  }
}
