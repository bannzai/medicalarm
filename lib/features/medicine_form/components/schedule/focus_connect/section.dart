import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';

class MedicineScheduleFocusConnectSettingSection extends HookConsumerWidget {
  final ValueNotifier<bool> isEnabled;

  const MedicineScheduleFocusConnectSettingSection({
    super.key,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MedicineFormSectionLayout(
      icon: Icons.notifications,
      text: L.notificationSetting,
      children: [
        SwitchListTile(
          value: isEnabled.value,
          onChanged: (value) {
            isEnabled.value = value;
          },
          title: const Text('通知受信から服薬記録するまで他のアプリをブロックする'),
          subtitle: const Text('通知受信から服薬記録するまで他のアプリをブロックする機能が有効になります。'),
        ),
      ],
    );
  }
}
