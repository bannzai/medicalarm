import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/calendar/monthly/pager.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

/// 月間カレンダーで服薬記録と日記を振り返る画面 (#62)。
/// 日付タイルをタップすると、その日の服薬記録と日記をまとめた [CalendarDayDetailSheet] が開く
class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayedMonth = useState(today());

    return Scaffold(
      appBar: AppBar(
        title: Text(L.calendar),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 既定の高さを下限にして、文字が大きい時は月の文字に合わせて伸ばす。
              // 横は左右の矢印の間の幅に収まらない時だけ縮める (#572。扱いは documents/DIRECTION.md の 2026-11-11 の行)
              Container(
                color: Colors.white,
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 50),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        analytics.logEvent(name: 'calendar_previous_month_button_pressed');
                        displayedMonth.value = DateTime(displayedMonth.value.year, displayedMonth.value.month - 1, 1);
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
                            DateFormat(DateFormat.YEAR_MONTH).format(displayedMonth.value),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        analytics.logEvent(name: 'calendar_next_month_button_pressed');
                        displayedMonth.value = DateTime(displayedMonth.value.year, displayedMonth.value.month + 1, 1);
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
              // テーマの dividerColor (黒) を避け、カレンダーの罫線と揃えた薄い色にする
              const Divider(height: 1, color: AppColors.border),
              MonthCalendarPager(displayedMonth: displayedMonth.value),
            ],
          ),
        ),
      ),
    );
  }
}
