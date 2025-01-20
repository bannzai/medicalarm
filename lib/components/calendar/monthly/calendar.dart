import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:medicalarm/components/calendar/calculator.dart';
import 'package:medicalarm/components/calendar/const.dart';
import 'package:medicalarm/components/calendar/weekly/badge.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

class MonthCalendar extends HookConsumerWidget {
  final DateTime dateForMonth;
  final Widget Function(BuildContext, List<Diary>, DateTimeRange) weekCalendarBuilder;

  const MonthCalendar({
    super.key,
    required this.dateForMonth,
    required this.weekCalendarBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTimeRange = _monthRange(dateForMonth: dateForMonth);
    final diaries = ref.watch(diariesForDateTimeRangeProvider(dateTimeRange: dateTimeRange));

    return diaries.when(
      data: (diaries) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                Weekday.values.length,
                (index) => Expanded(
                  child: WeekdayBadge(
                    weekday: Weekday.values[index],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            ...List.generate(CalendarConst.maxLineCount, (offset) {
              if (weeks.length <= offset) {
                return const Column(
                  children: [
                    SizedBox(height: CalendarConst.monthlyTileHeight),
                    Divider(height: 1),
                  ],
                );
              }

              final weekCalendar = weekCalendarBuilder(context, diaries, weeks[offset]);
              return Column(
                children: [
                  weekCalendar,
                  const Divider(height: 1),
                ],
              );
            }),
          ],
        );
      },
      error: (error, _) => Text(error.toString()),
      loading: () => const Indicator(),
    );
  }

  DateTimeRange _monthRange({required DateTime dateForMonth}) {
    return DateTimeRange(
        start: DateTime(dateForMonth.year, dateForMonth.month, 1), end: DateTime(dateForMonth.year, dateForMonth.month + 1, 0, 23, 59, 59));
  }

  WeekCalendarDateTimeRangeCalculator get _calculator => WeekCalendarDateTimeRangeCalculator(dateForMonth);
  List<DateTimeRange> get weeks =>
      List.generate(_calculator.weeklineCount(), (index) => index + 1).map((line) => _calculator.dateRangeOfLine(line)).toList();
}
