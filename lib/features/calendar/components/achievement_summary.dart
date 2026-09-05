import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/calendar/day/achievement_dot.dart';
import 'package:medicalarm/entity/medication_achievement.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

/// カレンダー画面の月間カレンダー上部に置く達成率カード (#278)。
/// 表示中の月の達成率と、カレンダーに並ぶ達成ドットの凡例を表示する
class CalendarAchievementSummary extends HookConsumerWidget {
  final DateTime displayedMonth;
  const CalendarAchievementSummary({super.key, required this.displayedMonth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(allMedicinesProvider).valueOrNull;
    final medicationHistories = ref.watch(medicationHistoriesByDateRangeProvider(monthDateTimeRange(month: displayedMonth))).valueOrNull;
    // カレンダー本体の表示を妨げないよう、集計に必要なデータが揃うまでは何も表示しない
    if (medicines == null || medicationHistories == null) {
      return const SizedBox.shrink();
    }

    final monthlyCounts = monthlyMedicationCounts(
      medicines: medicines,
      medicationHistories: medicationHistories,
      month: displayedMonth,
      today: today(),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L.achievementMonthlyRateLabel(DateFormat(DateFormat.MONTH).format(displayedMonth)),
                style: const TextStyle(fontSize: 12, color: TextColor.gray),
              ),
              const SizedBox(height: 2),
              Text(
                // 服薬の予定が 1 件も無い月に 0% や 100% を出すと実態と食い違うため、割合を出さずに「-」を表示する。
                // 割合は切り捨てにして、1 回でも未服用が残っている月を 100% と表示しない
                monthlyCounts.scheduledCount == 0 ? '-' : '${monthlyCounts.takenCount * 100 ~/ monthlyCounts.scheduledCount}%',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final achievement in DayMedicationAchievement.values) ...[
                CalendarAchievementLegend(achievement: achievement),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 達成ドット 1 種類分の凡例。ドットと、それが表す状態のラベルを並べる
class CalendarAchievementLegend extends StatelessWidget {
  final DayMedicationAchievement achievement;
  const CalendarAchievementLegend({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDayAchievementDot(achievement: achievement),
        const SizedBox(width: 4),
        Text(
          switch (achievement) {
            DayMedicationAchievement.allTaken => L.achievementLegendAllTaken,
            DayMedicationAchievement.partiallyTaken => L.achievementLegendPartiallyTaken,
            DayMedicationAchievement.noneTaken => L.achievementLegendNoneTaken,
          },
          style: const TextStyle(fontSize: 11, color: TextColor.gray),
        ),
      ],
    );
  }
}
