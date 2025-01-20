import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/calendar/const.dart';
import 'package:medicalarm/components/calendar/day/tile.dart';
import 'package:medicalarm/components/calendar/weekly/line.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/provider/diary.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

const double _horizontalPadding = 10;

class WeeklyCalendarPager extends HookConsumerWidget {
  final Function(DateTime, Diary?, List<Diary>) onTap;
  const WeeklyCalendarPager({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaries = ref.watch(diariesForDateTimeRangeProvider(dateTimeRange: allDateTimeRange())).asData?.valueOrNull ?? [];
    final pageController = usePageController();

    return LimitedBox(
      maxHeight: CalendarConst.monthlyCalendarHeight,
      child: PageView.builder(
        controller: pageController,
        physics: const PageScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final days = menstruationWeekCalendarDataSource[index];

          return SizedBox(
            width: MediaQuery.of(context).size.width - _horizontalPadding * 2,
            height: CalendarConst.monthlyCalendarHeight,
            child: CalendarWeekLine(
              dateRange: DateTimeRange(start: days.first, end: days.last),
              horizontalPadding: _horizontalPadding,
              day: (context, weekday, date) {
                final diary = diaries.firstWhereOrNull((e) => isSameDay(e.diaryDate, date));
                return CalendarDayTile(
                    weekday: weekday,
                    date: date,
                    diary: diary,
                    onTap: (date) {
                      analytics.logEvent(name: 'did_select_day_tile_on_menstruation');

                      onTap(date, diary, diaries);
                    });
              },
            ),
          );
        },
      ),
    );
  }

  DateTimeRange allDateTimeRange() {
    final date = today();
    return DateTimeRange(start: date.subtract(const Duration(days: 90)), end: date.add(const Duration(days: 90)));
  }
}

final todayCalendarPageIndex =
    menstruationWeekCalendarDataSource.lastIndexWhere((element) => element.where((element) => isSameDay(element, today())).isNotEmpty);

final List<List<DateTime>> menstruationWeekCalendarDataSource = () {
  final base = today();

  var begin = base.subtract(const Duration(days: 90));
  final beginWeekdayOffset = WeekdayFunctions.weekdayFromDate(begin).index;
  begin = begin.subtract(Duration(days: beginWeekdayOffset));

  var end = base.add(const Duration(days: 90));
  final endWeekdayOffset = Weekday.values.last.index - WeekdayFunctions.weekdayFromDate(end).index;
  end = end.addDays(endWeekdayOffset);

  var diffDay = daysBetween(begin, end);
  diffDay += Weekday.values.length - diffDay % Weekday.values.length;
  List<DateTime> days = [];
  for (int i = 0; i < diffDay; i++) {
    days.add(begin.addDays(i));
  }
  return List.generate(
      ((diffDay) / Weekday.values.length).round(), (i) => days.sublist(i * Weekday.values.length, i * Weekday.values.length + Weekday.values.length));
}();
