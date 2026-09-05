import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medication_achievement.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

/// 達成サマリーが服薬記録を読む範囲 (#278)。
/// 連続記録の遡り上限([maxConsecutiveLookbackDays])より前の記録は集計に影響しないため、
/// 全件の listen ではなく上限までの期間で絞って読む
DateTimeRange medicationAchievementLookbackDateTimeRange({required DateTime today}) {
  return DateTimeRange(
    start: today.date().addDays(-maxConsecutiveLookbackDays),
    end: DateTime(today.year, today.month, today.day, 23, 59, 59),
  );
}

/// 服薬履歴画面の一覧上部に置く達成サマリー (#278)。
/// 「今週の服薬」と「連続記録」の 2 枚のカードで、続けられていることを数字で実感できるようにする
class MedicationAchievementSummary extends HookConsumerWidget {
  const MedicationAchievementSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicinesAsync = ref.watch(allMedicinesProvider);
    // 連続記録は今日から過去へ遡って判定するため、遡り上限までの期間の服薬記録を対象にする
    final medicationHistoriesAsync = ref.watch(medicationHistoriesByDateRangeProvider(medicationAchievementLookbackDateTimeRange(today: today())));
    final medicines = medicinesAsync.valueOrNull;
    final medicationHistories = medicationHistoriesAsync.valueOrNull;
    // サマリーは一覧の補助情報のため、集計に必要なデータが揃うまでは何も表示せず一覧の表示を妨げない
    if (medicines == null || medicationHistories == null) {
      // release では非表示のままにするが、debug では読み込み中とエラーのどちらで止まっているかを
      // 画面で確認できるようにする (シミュレータ検証でサマリー非表示の原因を切り分けられなかったため)
      if (kDebugMode) {
        return Text(
          'achievement summary waiting: medicines=$medicinesAsync histories=$medicationHistoriesAsync',
          style: const TextStyle(fontSize: 10, color: TextColor.danger),
        );
      }
      return const SizedBox.shrink();
    }

    final weeklyCounts = weeklyMedicationCounts(medicines: medicines, medicationHistories: medicationHistories, date: today());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: MedicationAchievementCard(
            label: L.achievementWeeklyLabel,
            value: '${weeklyCounts.takenCount}',
            valueSuffix: L.achievementWeeklyCountSuffix(weeklyCounts.scheduledCount),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: MedicationAchievementCard(
            label: L.achievementStreakLabel,
            value: '${consecutiveAchievedDaysCount(medicines: medicines, medicationHistories: medicationHistories, today: today())}',
            valueSuffix: L.achievementStreakDaysSuffix,
          ),
        ),
      ],
    );
  }
}

/// 達成サマリーの 1 枚分のカード。[label] の下に、大きい [value] と小さい [valueSuffix] を並べて表示する
class MedicationAchievementCard extends StatelessWidget {
  final String label;
  final String value;
  final String valueSuffix;

  const MedicationAchievementCard({
    super.key,
    required this.label,
    required this.value,
    required this.valueSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: TextColor.gray)),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
                TextSpan(
                  text: valueSuffix,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
