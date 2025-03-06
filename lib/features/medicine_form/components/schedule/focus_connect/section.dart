import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

const focusConnectAccessToken = 'f6c5cc5d-248c-4ed4-accc-e8a74018d41d';

class MedicineScheduleFocusConnectSettingSection extends HookConsumerWidget {
  final MedicationSchedule schedule;
  final ValueNotifier<bool> isEnabled;

  const MedicineScheduleFocusConnectSettingSection({
    super.key,
    required this.schedule,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MedicineFormSectionLayout(
      icon: Icons.notifications,
      text: L.notificationSetting,
      children: [
        ListTile(
          onTap: () {
            final start = '${schedule.hour}:${schedule.minute}:30';
            final end = '${schedule.hour + 3}:${schedule.minute}:00';
            final authCode = const Uuid().v4();
            launchUrl(
              Uri.parse(
                'focus-connect://schedule?accessToken=$focusConnectAccessToken&intervalStartTimeOfDay=$start&intervalEndTimeOfDay=$end&repeats=true&authCode=$authCode',
              ),
            );
          },
          title: const Text('通知受信から服薬記録するまで他のアプリをブロックする'),
          subtitle: const Text('通知受信から服薬記録するまで他のアプリをブロックする機能が有効になります。'),
        ),
      ],
    );
  }
}
