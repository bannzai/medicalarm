import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

class TodayBadge extends StatelessWidget {
  final ValueNotifier<DateTime> date;
  const TodayBadge({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              analytics.logEvent(name: 'today_badge_prev_day_pressed');
              date.value = date.value.subtract(const Duration(days: 1));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          Center(
            child: Text(
              DateFormat(DateFormat.NUM_MONTH_DAY).format(date.value),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const Spacer(),
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
