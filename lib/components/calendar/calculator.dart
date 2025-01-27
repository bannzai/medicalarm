import 'package:flutter/material.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

class WeekCalendarDateTimeRangeCalculator {
  final DateTime dateForMonth;

  WeekCalendarDateTimeRangeCalculator(this.dateForMonth);

  DateTimeRange dateRangeOfLine(int line) {
    if (line == 1) {
      return DateTimeRange(
        start: DateTime(dateForMonth.year, dateForMonth.month, 1 - _previousMonthDayCount()),
        end: DateTime(dateForMonth.year, dateForMonth.month, Weekday.values.length - _previousMonthDayCount()),
      );
    }
    if (line == weeklineCount()) {
      return DateTimeRange(
        start: DateTime(dateForMonth.year, dateForMonth.month, Weekday.values.length * (line - 1) + 1 - _previousMonthDayCount()),
        end: DateTime(dateForMonth.year, dateForMonth.month, _lastDay()),
      );
    }
    var beginDay = Weekday.values.length * (line - 1) - _previousMonthDayCount() + 1;
    var endDay = Weekday.values.length * line - _previousMonthDayCount();
    return DateTimeRange(
      start: DateTime(dateForMonth.year, dateForMonth.month, beginDay),
      end: DateTime(dateForMonth.year, dateForMonth.month, endDay),
    );
  }

  int _lastDay() => DateTime(dateForMonth.year, dateForMonth.month + 1, 0).day;
  int _weekdayOffset() => WeekdayFunctions.weekdayFromDate(_firstDayOfMonth(dateForMonth)).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int _tileCount() => _previousMonthDayCount() + _lastDay();
  int weeklineCount() => (_tileCount() / Weekday.values.length).ceil();

  DateTime _firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
}
