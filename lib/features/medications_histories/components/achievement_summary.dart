import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medication_achievement.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/provider/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

/// 服薬履歴画面の一覧上部に置く達成サマリー (#278)。
/// 「今週の服薬」と「連続記録」の 2 枚のカードで、続けられていることを数字で実感できるようにする
class MedicationAchievementSummary extends HookConsumerWidget {
  const MedicationAchievementSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicines = ref.watch(allMedicinesProvider).valueOrNull;
    // 連続記録は今日から過去へ遡って判定するため、日付を絞らず服薬記録の全件を対象にする
    final medicationHistories = ref.watch(medicationHistoriesProvider).valueOrNull;
    // サマリーは一覧の補助情報のため、集計に必要なデータが揃うまでは何も表示せず一覧の表示を妨げない
    if (medicines == null || medicationHistories == null) {
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
