import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/diary.dart';
import 'package:medicalarm/style/color.dart';

class CalendarDayBadge extends HookConsumerWidget {
  final DateTime date;
  final Diary? diary;

  const CalendarDayBadge({
    super.key,
    required this.date,
    required this.diary,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diary = this.diary;

    List<Widget> widgets = [];

    if (diary != null) {
      if (diary.memo.isNotEmpty) {
        widgets.add(
          const Icon(
            Icons.description,
            size: 10,
            color: Colors.grey,
          ),
        );
      }
    }

    if (widgets.length > 3) {
      final remain = widgets.length - 2;
      widgets = widgets.sublist(0, 2);
      widgets.add(
        Text(
          '+$remain',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: TextColor.highEmphasis(
              TextColor.black,
            ),
          ),
        ),
      );
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (final element in widgets.indexed) ...[
        element.$2,
        if (element.$1 != widgets.indexed.last.$1) const SizedBox(width: 2),
      ],
    ]);
  }
}
