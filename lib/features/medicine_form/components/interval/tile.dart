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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: FlatTile(
        child: ListTile(
          title: Text(L.minimumDoseInterval),
          subtitle: Text(L.minimumDoseIntervalDescription),
          trailing: Wrap(
            children: [
              Text(switch (minimumDoseIntervalHours.value) {
                final int hours => L.minimumDoseIntervalHoursFormat(hours),
                null => L.minimumDoseIntervalNone,
              }),
              const Icon(Icons.chevron_right),
            ],
          ),
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
