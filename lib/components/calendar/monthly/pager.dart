import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/calendar/const.dart';
import 'package:medicalarm/components/calendar/day/tile.dart';
import 'package:medicalarm/components/calendar/monthly/calendar.dart';
import 'package:medicalarm/components/calendar/weekly/line.dart';
import 'package:medicalarm/entity/medication_achievement.dart';
import 'package:medicalarm/features/calendar/components/day_detail_sheet.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

class MonthCalendarPager extends HookConsumerWidget {
  const MonthCalendarPager({
    super.key,
    required this.displayedMonth,
  });

  final DateTime displayedMonth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(allMedicinesProvider).valueOrNull;
    final medicationHistories = ref.watch(medicationHistoriesByDateRangeProvider(monthDateTimeRange(month: displayedMonth))).valueOrNull;

    // 日付タイルごとに集計すると 1 か月分の走査を日数回繰り返すため、表示月の分だけまとめて求める (#278)。
    // 集計に必要なデータが揃っていない間は空のまま(ドット無し)にして、従来どおりカレンダーを表示する
    final achievements = useMemoized(() {
      if (medicines == null || medicationHistories == null) {
        return <int, DayMedicationAchievement?>{};
      }
      return {
        for (var day = 1; day <= DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day; day++)
          day: dayMedicationAchievement(
            medicines: medicines,
            medicationHistories: medicationHistories,
            date: DateTime(displayedMonth.year, displayedMonth.month, day),
          ),
      };
    }, [medicines, medicationHistories, displayedMonth]);

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
                    showCalendarDayDetailSheet(context, date: date);
                  },
                  selected: isSameDay(today(), date),
                  // 週の行には翌月の日付も並ぶため、当月の日だけ達成状態を表示する
                  medicationAchievement: isSameMonth(date, displayedMonth) ? achievements[date.day] : null,
                );
              },
            );
          }),
    );
  }
}
