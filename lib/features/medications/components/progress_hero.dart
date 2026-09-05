import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medications/entity/grouped.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

// 今日の進捗ヒーロー (#276)。選択日の服用済み数/予定数とプログレスバー、次に飲む薬を表示する
class MedicationsProgressHero extends StatelessWidget {
  final DateTime date;
  final List<MedicationGroup> groups;
  const MedicationsProgressHero({super.key, required this.date, required this.groups});

  @override
  Widget build(BuildContext context) {
    final scheduleRows = groups.expand((group) => group.scheduleRows).toList();
    // 薬が未登録・選択日に服薬予定が無い場合に 0/0 の進捗を出さない
    if (scheduleRows.isEmpty) {
      return const SizedBox.shrink();
    }

    final takenCount = scheduleRows.where((row) => row.medicationHistory != null).length;
    // 今日以外を選択している場合、nextDoseGroup が今日判定で null を返すため date による分岐は不要
    final next = nextDoseGroup(groups: groups, now: DateTime.now());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isSameDay(date, today())
                      ? L.todayMedicationProgressTitle
                      : L.medicationProgressTitleForDate(DateFormat(DateFormat.NUM_MONTH_DAY).format(date)),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Text(
                L.medicationProgressCountLabel(takenCount, scheduleRows.length),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: takenCount / scheduleRows.length,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              color: Colors.white,
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    L.medicationNextDoseLabel(
                      next.scheduleTime.toTimeString(),
                      next.doseReceiver.name,
                      next.scheduleRows.firstWhere((row) => row.medicationHistory == null).medicine.name,
                    ),
                    style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
