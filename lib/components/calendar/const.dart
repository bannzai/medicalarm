abstract class CalendarConst {
  static const double weekdayBadgeHeight = 30;
  static const double monthlyTileHeight = 80;
  // CalendarDayTile の日付の領域 (40) と、その下の日記のメモのアイコン (CalendarDayBadge の size 10) が収まる高さ。
  // 48 ではメモがある日に 2px はみ出していた (#429)
  static const double weeklyTileHeight = 50;
  // NOTE: 2025年3月では6行になる
  static const int maxLineCount = 6;
  static const double dividerHeight = 1;

  static double get monthlyCalendarHeight => weekdayBadgeHeight + (monthlyTileHeight + dividerHeight) * maxLineCount;
}
