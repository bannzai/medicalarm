import 'package:medicalarm/utils/date_time/weekday.dart';
import 'package:flutter/material.dart';

abstract class WeekdayBadgeConst {
  static const double height = 30;
}

class WeekdayBadge extends StatelessWidget {
  final Weekday weekday;
  const WeekdayBadge({super.key, required this.weekday});

  @override
  Widget build(BuildContext context) {
    // 既定の高さを下限にして、文字が大きい時は曜日の文字に合わせて伸ばす。
    // 横はセルの幅 (画面幅の 7 等分) で決まり伸ばせないため、収まらない曜日 (英語の Mon・Wed 等) だけ縮める (#543)
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 20, minHeight: WeekdayBadgeConst.height),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            weekday.weekdayShortString(),
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 9).merge(TextStyle(color: weekday.weekdayColor())),
          ),
        ),
      ),
    );
  }
}
