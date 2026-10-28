import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalarm/components/alert/discard.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/style/color.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';

/// 最低服用間隔が空いていない状態で服薬記録をつけようとした時の注意ダイアログ (#81)。
/// 記録自体は無効化せず、続行(true)・キャンセル(false)をユーザーに委ねる。閉じた場合は null
Future<bool?> showDoseIntervalWarningDialog(
  BuildContext context, {
  required int minimumDoseIntervalHours,
  required DateTime latestTakeRecordedDateTime,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => DiscardDialog(
      title: L.doseIntervalWarningTitle,
      message: Text(
        L.doseIntervalWarningMessage(
          // 前日以前の服用は時刻だけだと直近と誤読するため、日付を含めて表示する
          isSameDay(latestTakeRecordedDateTime, DateTime.now())
              ? DateFormat.Hm().format(latestTakeRecordedDateTime)
              : DateFormat('M/d HH:mm').format(latestTakeRecordedDateTime),
          minimumDoseIntervalHours,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            L.cancel,
            style: const TextStyle(
              color: TextColor.gray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            L.doseIntervalWarningTakeAnyway,
            style: const TextStyle(color: TextColor.danger, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}
