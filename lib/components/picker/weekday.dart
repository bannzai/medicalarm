import 'package:flutter/material.dart';
import 'package:medicalarm/utils/date_time/weekday.dart';

class WeekdayPicker extends StatelessWidget {
  final ValueNotifier<List<Weekday>> weekdays;
  const WeekdayPicker({super.key, required this.weekdays});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final weekday in Weekday.values) ...[
          ListTile(
            title: Text(
              weekday.weekdayString(),
            ),
            onTap: () {
              if (weekdays.value.contains(weekday)) {
                weekdays.value = [...weekdays.value]..removeWhere((e) => e == weekday);
              } else {
                weekdays.value = {...weekdays.value, weekday}.toList();
              }
            },
          ),
        ],
      ],
    );
  }
}
