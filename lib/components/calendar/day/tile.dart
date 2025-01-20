import 'package:flutter/material.dart';
import 'package:medicalarm/components/calendar/const.dart';
import 'package:medicalarm/components/calendar/day/badge.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

class CalendarDayTile extends StatelessWidget {
  final DateTime date;
  final Weekday weekday;
  final Diary? diary;
  final Function(DateTime)? onTap;

  const CalendarDayTile.grayout({
    Key? key,
    required DateTime date,
    required Weekday weekday,
  }) : this(
          key: key,
          onTap: null,
          weekday: weekday,
          diary: null,
          date: date,
        );

  const CalendarDayTile({
    super.key,
    required this.date,
    required this.weekday,
    required this.diary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onTap = this.onTap;
    return Expanded(
      child: RawMaterialButton(
        onPressed: () => onTap != null ? onTap(date) : null,
        child: SizedBox(
          height: CalendarConst.tileHeight,
          child: Column(
            children: <Widget>[
              _content(),
              CalendarDayBadge(diary: diary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          if (_isToday)
            Positioned(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          Positioned(
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: _textColor(),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Color _textColor() {
    if (_isToday) {
      return Colors.white;
    }
    final weekdayColor = switch (weekday) {
      Weekday.Sunday => weekday.weekdayColor(),
      Weekday.Monday => TextColor.gray,
      Weekday.Tuesday => TextColor.gray,
      Weekday.Wednesday => TextColor.gray,
      Weekday.Thursday => TextColor.gray,
      Weekday.Friday => TextColor.gray,
      Weekday.Saturday => weekday.weekdayColor()
    };
    final onTap = this.onTap;
    final alpha = (255 * (onTap != null ? 1 : 0.4)).floor();
    return weekdayColor.withAlpha(alpha);
  }

  bool get _isToday => isSameDay(date, today());
}
