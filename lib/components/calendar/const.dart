abstract class CalendarConst {
  static const double weekdayBadgeHeight = 30;
  static const double tileHeight = 80;
  // NOTE: 2025年3月では6行になる
  static const int maxLineCount = 6;
  static const double dividerHeight = 1;

  static double get monthlyCalendarHeight => weekdayBadgeHeight + (tileHeight + dividerHeight) * maxLineCount;
}
