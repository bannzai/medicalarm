import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class TodayBadge extends StatelessWidget {
  final ValueNotifier<DateTime> date;
  const TodayBadge({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    // 既定の高さを下限にして、文字が大きい時は日付の文字に合わせて伸ばす。
    // 横は左右の矢印の間の幅に収まらない時だけ縮める (#572。扱いは documents/DIRECTION.md の 2026-11-11 の行)
    return Container(
      color: Colors.white,
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 50),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              analytics.logEvent(name: 'today_badge_prev_day_pressed');
              date.value = date.value.subtract(const Duration(days: 1));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            // 親の高さが決まっている時に Center が縦いっぱいに広がり、見出しが画面の高さまで伸びるのを防ぐ
            child: Center(
              heightFactor: 1,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  DateFormat(DateFormat.NUM_MONTH_DAY).format(date.value),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              analytics.logEvent(name: 'today_badge_next_day_pressed');
              date.value = date.value.add(const Duration(days: 1));
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
