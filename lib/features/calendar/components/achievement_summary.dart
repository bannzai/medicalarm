import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/calendar/day/achievement_dot.dart';
import 'package:medicalarm/entity/medication_achievement.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';

/// カレンダー画面の月間カレンダー上部に置く達成率カード (#278)。
/// 表示中の月の達成率と、カレンダーに並ぶ達成ドットの凡例を表示する
class CalendarAchievementSummary extends HookConsumerWidget {
  final DateTime displayedMonth;
  const CalendarAchievementSummary({super.key, required this.displayedMonth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(allMedicinesProvider).valueOrNull;
    final medicationHistories = ref.watch(medicationHistoriesByDateRangeProvider(monthDateTimeRange(month: displayedMonth))).valueOrNull;
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;
    // カレンダー本体の表示を妨げないよう、集計に必要なデータが揃うまでは何も表示しない
    if (medicines == null || medicationHistories == null) {
      return const SizedBox.shrink();
    }

    // 過去月の達成状況は集計値も含めてプレミアム加入者に限定し、非加入者には加入導線を出す
    if (!canDisplayMonthlyAchievement(month: displayedMonth, today: today(), hasPremiumEntitlement: customerInfo?.hasPremiumEntitlement)) {
      return const CalendarAchievementPremiumGate();
    }

    final monthlyCounts = monthlyMedicationCounts(
      medicines: medicines,
      takeDoseKeysByDate: effectiveTakeDoseKeysByDate(medicationHistories),
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

/// 過去月の達成状況を非加入者に見せない時に、達成率カードの代わりに置くプレミアム加入導線 (#278)。
/// カードごと消すと理由が伝わらないため、日付詳細シートの過去日制限と同じ鍵アイコンと加入導線のリンクを出す
class CalendarAchievementPremiumGate extends StatelessWidget {
  const CalendarAchievementPremiumGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 20, color: Theme.of(context).colorScheme.primary),
          Expanded(
            child: TextButton(
              onPressed: () {
                analytics.logEvent(name: 'calendar_achievement_premium_pressed');
                showPremiumIntroductionSheet(context);
              },
              child: Text(
                L.premiumRequired,
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
            ),
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
