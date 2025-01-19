import 'package:medicalarm/style/color.dart';
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
    return Container(
      width: 20,
      height: WeekdayBadgeConst.height,
      color: Colors.white,
      child: Center(
        child: Text(weekday.weekdayString(),
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 9,
            ).merge(TextStyle(color: weekday.weekdayColor()))),
      ),
    );
  }
}
