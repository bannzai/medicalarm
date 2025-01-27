import 'package:medicalarm/utils/date_time/weekday.dart';
import 'package:flutter/material.dart';

abstract class WeekdayBadgeConst {
  static const double height = 30;
}

class WeekdayBadge extends StatelessWidget {
  final Weekday weekday;
  const WeekdayBadge({
    super.key,
    required this.weekday,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: WeekdayBadgeConst.height,
      child: Center(
        child: Text(weekday.weekdayShortString(),
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 9,
            ).merge(TextStyle(color: weekday.weekdayColor()))),
      ),
    );
  }
}
