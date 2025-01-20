abstract class CalendarConst {
  static const double weekdayBadgeHeight = 30;
  static const double monthlyTileHeight = 80;
  static const double weeklyTileHeight = 48;
  // NOTE: 2025年3月では6行になる
  static const int maxLineCount = 6;
  static const double dividerHeight = 1;

  static double get monthlyCalendarHeight => weekdayBadgeHeight + (monthlyTileHeight + dividerHeight) * maxLineCount;
}
