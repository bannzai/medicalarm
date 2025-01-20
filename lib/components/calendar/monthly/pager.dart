import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:medicalarm/components/calendar/const.dart';
import 'package:medicalarm/components/calendar/day/tile.dart';
import 'package:medicalarm/components/calendar/monthly/calendar.dart';
import 'package:medicalarm/components/calendar/weekly/line.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

class MonthCalendarPager extends StatelessWidget {
  const MonthCalendarPager({
    super.key,
    required this.displayedMonth,
  });

  final DateTime displayedMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      height: CalendarConst.monthlyCalendarHeight,
      width: MediaQuery.of(context).size.width,
      child: MonthCalendar(
          dateForMonth: displayedMonth,
          weekCalendarBuilder: (context, diaries, weekDateRange) {
            return CalendarWeekLine(
              dateRange: weekDateRange,
              horizontalPadding: 0,
              day: (context, weekday, date) {
                if (date.isPreviousMonth(displayedMonth)) {
                  return CalendarDayTile.grayout(
                    weekday: weekday,
                    date: date,
                  );
                }
                return CalendarDayTile(
                  weekday: weekday,
                  date: date,
                  diary: diaries.firstWhereOrNull((e) => isSameDay(e.diaryDate, date)),
                  onTap: (date) {
                    analytics.logEvent(name: 'did_select_day_tile_on_calendar_card');
                    transitionWhenCalendarDayTapped(context, date: date, diaries: diaries);
                  },
                  selected: isSameDay(today(), date),
                );
              },
            );
          }),
    );
  }
}
