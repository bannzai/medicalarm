import 'package:flutter/material.dart';
import 'package:medicalarm/components/picker/time.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// 時刻欄の時刻の文字の大きさ。修正前 (#474 より前) の 12 のまま、時刻欄の描画と最小幅の計算 ([medicineScheduleReminderTimeMinimumWidth]) で同じ値を使う
const _reminderTimeTextStyle = TextStyle(fontSize: 12);

/// 時刻欄の枠と時刻の間の左右の余白。修正前 (#474 より前) の 8 のまま、時刻欄の描画と最小幅の計算で同じ値を使う
const _reminderTimeHorizontalPadding = 8.0;

/// 時刻欄の枠線。時刻欄の描画と最小幅の計算で同じ値を使う
final _reminderTimeBorder = Border.all(color: AppColors.border);

/// [schedule] の時刻を 1 行で表示するのに要る時刻欄の幅。端末の文字サイズの倍率と、文字を太くする設定を含めて測る。
double medicineScheduleReminderTimeMinimumWidth({required BuildContext context, required MedicationSchedule schedule}) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: schedule.toTimeString(),
      // Text widget は端末の文字を太くする設定 (MediaQuery.boldTextOf) がオンの時に太字で描くため、測る側も同じ規則で太字にする
      style: DefaultTextStyle.of(context)
          .style
          .merge(_reminderTimeTextStyle)
          .merge(MediaQuery.boldTextOf(context) ? const TextStyle(fontWeight: FontWeight.bold) : null),
    ),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout();
  // 小数の幅のまま渡すと丸め誤差で最後の文字が次の行へ送られることがあるため切り上げる
  final textWidth = textPainter.width.ceilToDouble();
  textPainter.dispose();
  return textWidth + _reminderTimeHorizontalPadding * 2 + _reminderTimeBorder.dimensions.horizontal;
}

class MedicineScheduleReminderTime extends StatelessWidget {
  const MedicineScheduleReminderTime({
    super.key,
    required this.schedule,
    required this.schedules,
    required this.index,
  });

  final MedicationSchedule schedule;
  final ValueNotifier<List<MedicationSchedule>> schedules;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        analytics.logEvent(name: 'med_schedule_time_tapped');
        final result = await showAppTimePicker(
          context,
          initialTime: schedule.toTimeOfDay(),
        );

        if (result != null) {
          final copied = [...schedules.value];
          copied[index] = copied[index].copyWith(hour: result.hour, minute: result.minute);
          schedules.value = copied;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: _reminderTimeBorder,
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        constraints: const BoxConstraints(
          minHeight: 48,
          maxWidth: double.infinity,
          minWidth: double.infinity,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _reminderTimeHorizontalPadding),
            child: Text(
              schedule.toTimeString(),
              style: _reminderTimeTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
