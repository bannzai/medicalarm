import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/features/diary_post/page.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/date_time/date_time_range_ext.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

class CalendarWeekLine extends HookConsumerWidget {
  final DateTimeRange dateRange;
  final double horizontalPadding;
  final Widget Function(BuildContext, Weekday, DateTime) day;

  const CalendarWeekLine({
    super.key,
    required this.dateRange,
    required this.horizontalPadding,
    required this.day,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: Weekday.values.map((weekday) {
        final date = _buildDate(weekday);
        final isOutOfBoundsInLine = !dateRange.contains(date);
        if (isOutOfBoundsInLine) {
          return Expanded(child: Container());
        }

        return day(context, weekday, date);
      }).toList(),
    );
  }

  DateTime _buildDate(Weekday weekday) {
    return dateRange.start.addDays(weekday.index).date();
  }
}

void transitionWhenCalendarDayTapped(
  BuildContext context, {
  required DateTime date,
  required List<Diary> diaries,
}) {
  final diary = diaries.lastWhereOrNull((element) => isSameDay(element.diaryDate, date));
  Navigator.of(context).push(DiaryPostPageRoute.route(date, diary));
}
