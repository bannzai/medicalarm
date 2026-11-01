import 'package:flutter/material.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/add_button.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/delete_button.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/label.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/notification_setting_button.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/quantity_memo_text_field.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/features/localization/l.dart';

/// 時刻欄と容量欄の間隔。修正前 (#474 より前) の間隔 10 のまま、描画と容量欄の幅の計算で同じ値を使う
const _reminderTimeToQuantityMemoGap = 10.0;

/// 容量欄の幅の上限。既定の文字サイズでは修正前 (#474 より前) の固定幅 180 のまま表示する
const _quantityMemoMaximumWidth = 180.0;

/// 容量欄の高さの下限。既定の文字サイズでは修正前 (#489 より前) の固定の高さ 48 のまま表示する
const _quantityMemoMinimumHeight = 48.0;

class MedicineScheduleSection extends StatelessWidget {
  final ValueNotifier<List<MedicationSchedule>> schedules;
  // 編集中の既存薬。新規薬(未保存)作成時は null。個別通知設定の書き込み先分岐に使う。
  final Medicine? medicine;
  const MedicineScheduleSection({super.key, required this.schedules, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return MedicineFormSectionLayout(
      icon: Icons.schedule,
      text: L.medicationSchedule,
      children: [
        const SizedBox(height: 10),
        for (final (index, schedule) in schedules.value.indexed) ...[
          Padding(
            // 容量欄は initialValue を初回だけ読むため、行を削除した時に後ろの行が削除した行の入力状態を引き継がないよう schedule ごとに区別する (#402)
            key: ValueKey(schedule.id),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  // 容量欄の幅を 180 に固定すると、文字を拡大した時に時刻欄が時刻の 1 行分より狭くなり「08: / 00」と割れる。
                  // 時刻欄が時刻を 1 行で表示できる幅を残せない時だけ容量欄を縮める。既定の文字サイズでは容量欄は 180 のまま (#474)
                  child: LayoutBuilder(
                    builder: (context, constraints) => Row(
                      children: [
                        Expanded(
                          child: MedicineScheduleReminderTime(schedule: schedule, schedules: schedules, index: index),
                        ),
                        const SizedBox(width: _reminderTimeToQuantityMemoGap),
                        SizedBox(
                          width: (constraints.maxWidth -
                                  _reminderTimeToQuantityMemoGap -
                                  medicineScheduleReminderTimeMinimumWidth(context: context, schedule: schedule))
                              .clamp(0, _quantityMemoMaximumWidth),
                          // 高さを固定すると、文字を拡大した時に浮いたラベルと入力した文字が収まらず重なる。
                          // 既定以下の文字サイズでは修正前 (#489 より前) の高さのまま表示し、文字を拡大した時だけ中身に合わせて伸ばす (#489)
                          child: ConstrainedBox(
                            constraints: MediaQuery.textScalerOf(context).scale(quantityMemoFontSize) <= quantityMemoFontSize
                                ? const BoxConstraints.tightFor(height: _quantityMemoMinimumHeight)
                                : const BoxConstraints(minHeight: _quantityMemoMinimumHeight),
                            child: MedicineScheduleQuantityMemoTextField(schedule: schedule, schedules: schedules, index: index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                MedicineScheduleNotificationSettingButton(schedule: schedule, schedules: schedules, index: index, medicine: medicine),
                MedicineScheduleDeleteButton(schedule: schedule, schedules: schedules),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        Center(
          child: MedicineScheduleAddButton(schedules: schedules),
        ),
      ],
    );
  }
}
