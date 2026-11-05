import 'package:flutter/material.dart';
import 'package:medicalarm/components/container/flat_tile.dart';
import 'package:medicalarm/components/picker/number.dart';
import 'package:medicalarm/features/localization/l.dart';

/// 最低服用間隔(時間)の設定タイル。null は間隔設定なし (#81)
class MedicationIntervalTile extends StatelessWidget {
  final ValueNotifier<int?> minimumDoseIntervalHours;
  const MedicationIntervalTile({super.key, required this.minimumDoseIntervalHours});

  @override
  Widget build(BuildContext context) {
    final value = Text(switch (minimumDoseIntervalHours.value) {
      final int hours => L.minimumDoseIntervalHoursFormat(hours),
      null => L.minimumDoseIntervalNone,
    });
    // 値を trailing に置くと、文字を拡大した時に trailing が先に幅を取り、英語のラベルと説明文が単語の途中で折り返される。
    // 服用開始日の行 (#474) と同じく、拡大時はラベルと値を title の Wrap に並べる (#506)。
    // 服用開始日の行と違いこの行には説明文があり、trailing の値は 2 行の縦の中央に出る。
    // 常に title へ移すと既定の文字サイズでも値の位置が変わるため、既定の倍率では trailing のままにする
    final isTextEnlarged = MediaQuery.textScalerOf(context).scale(1) > 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: ListTile(
          // spacing は、値を trailing に置いている時のラベルとの間隔 (ListTile の horizontalTitleGap の既定 16) に揃える
          title: isTextEnlarged
              ? Wrap(alignment: WrapAlignment.spaceBetween, spacing: 16, children: [Text(L.minimumDoseInterval), value])
              : Text(L.minimumDoseInterval),
          subtitle: Text(L.minimumDoseIntervalDescription),
          trailing: isTextEnlarged ? const Icon(Icons.chevron_right) : Wrap(children: [value, const Icon(Icons.chevron_right)]),
          onTap: () async {
            final hours = await showAppNumberPicker(context, initialNumber: minimumDoseIntervalHours.value ?? 0);
            if (hours != null) {
              // ピッカーは 0 始まりの数値のみを返すため、0 を「間隔設定なし」として扱う
              minimumDoseIntervalHours.value = hours == 0 ? null : hours;
            }
          },
        ),
      ),
    );
  }
}
