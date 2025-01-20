import 'package:timezone/timezone.dart';

// dateTime.addDays(n) だと n * 24 * 60 * 59 * 1000 が足されるので、サマータイムの国ではずれる
extension DateTimeAdd on DateTime {
  DateTime addDays(int offset) {
    return DateTime(
      year,
      month,
      day + offset,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}

extension TZDateTimeAdd on TZDateTime {
  TZDateTime addDays(int offset) {
    return TZDateTime(
      location,
      year,
      month,
      day + offset,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}

extension Date on DateTime {
  DateTime date() {
    return DateTime(year, month, day);
  }
}

extension TZDate on TZDateTime {
  TZDateTime date() {
    return TZDateTime(location, year, month, day);
  }
}

bool isSameDay(DateTime lhs, DateTime rhs) => lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day;

bool isSameMonth(DateTime lhs, DateTime rhs) => lhs.year == rhs.year && lhs.month == rhs.month;

extension DateTimeMonth on DateTime {
  bool isPreviousMonth(DateTime date) {
    if (isSameMonth(date, this)) {
      return false;
    }
    return isBefore(date);
  }
}

DateTime today() {
  return DateTime.now().date();
}

DateTime now() {
  return DateTime.now();
}

// Reference: https://stackoverflow.com/questions/52713115/flutter-find-the-number-of-days-between-two-dates/67679455#67679455
// 同じ日だと0を返す
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
