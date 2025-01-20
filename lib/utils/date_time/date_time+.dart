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
