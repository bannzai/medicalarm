import 'package:intl/intl.dart';

class DateTimeFormatter {
  // 12:20:30
  static String clock(int hour, minute, second) {
    final format = NumberFormat("00");
    return "${format.format(hour)}:${format.format(minute)}:${format.format(second)}";
  }
}
