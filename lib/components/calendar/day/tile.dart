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
  final bool selected;
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
          selected: false,
        );

  const CalendarDayTile({
    super.key,
    required this.date,
    required this.weekday,
    required this.diary,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final onTap = this.onTap;
    return Expanded(
      child: RawMaterialButton(
        onPressed: () => onTap != null ? onTap(date.date()) : null,
        child: SizedBox(
          height: CalendarConst.tileHeight,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  children: [
                    if (selected)
                      const Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: _BackgroundCircle(),
                        ),
                      ),
                    Positioned(
                      child: Align(
                        alignment: Alignment.center,
                        child: _DayText(
                          date: date,
                          selected: selected,
                          weekday: weekday,
                          onTap: onTap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CalendarDayBadge(date: date, diary: diary),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayText extends StatelessWidget {
  const _DayText({
    required this.date,
    required this.selected,
    required this.weekday,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final Weekday weekday;
  final Function(DateTime p1)? onTap;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${date.day}',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: () {
            if (selected) {
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
          }()),
    );
  }
}

class _BackgroundCircle extends StatelessWidget {
  const _BackgroundCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
