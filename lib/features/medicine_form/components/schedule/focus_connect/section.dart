import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/utils/foundation/cast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

const focusConnectAccessToken = 'f6c5cc5d-248c-4ed4-accc-e8a74018d41d';

class MedicineScheduleFocusConnectSettingSection extends HookConsumerWidget {
  final MedicationSchedule schedule;
  final ValueNotifier<String?> focusConnectID;

  const MedicineScheduleFocusConnectSettingSection({
    super.key,
    required this.schedule,
    required this.focusConnectID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCode = useState(const Uuid().v4());
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      final returnedAuthCode = tryCast<String>(uri.queryParameters['authCode']);
      if (returnedAuthCode != authCode.value) {
        return;
      }
      if (uri.path == '/focus-connect/schedule') {
        focusConnectID.value = tryCast<String>(uri.queryParameters['focusConnectID']);
      }
    });

    return MedicineFormSectionLayout(
      icon: Icons.notifications,
      text: L.notificationSetting,
      children: [
        ListTile(
          onTap: () {
            if (focusConnectID.value != null) {
              launchUrl(
                Uri.parse(
                  'focus-connect://schedule/delete?accessToken=$focusConnectAccessToken&focusConnectID=${focusConnectID.value}&authCode=${authCode.value}',
                ),
              );
            } else {
              final start = '${schedule.hour}:${schedule.minute}:30';
              final end = '${schedule.hour + 3}:${schedule.minute}:00';
              launchUrl(
                Uri.parse(
                  'focus-connect://schedule/add?accessToken=$focusConnectAccessToken&intervalStartTimeOfDay=$start&intervalEndTimeOfDay=$end&repeats=true&authCode=${authCode.value}',
                ),
              );
            }
          },
          title: const Text('通知受信から服薬記録するまで他のアプリをブロックする'),
          subtitle: const Text('通知受信から服薬記録するまで他のアプリをブロックする機能が有効になります。'),
          trailing: focusConnectID.value != null ? const Icon(Icons.check) : const Icon(Icons.check_box_outline_blank),
        ),
      ],
    );
  }
}
