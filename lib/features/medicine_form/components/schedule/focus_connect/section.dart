import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/alert/ok.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/utils/foundation/cast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

const focusConnectAppID = 'jmHpoAiQQw0GqE9oFEEH';

class MedicineScheduleFocusConnectSettingSection extends HookConsumerWidget {
  final MedicationSchedule schedule;
  final ValueNotifier<String?> focusConnectScheduleID;

  const MedicineScheduleFocusConnectSettingSection({
    super.key,
    required this.schedule,
    required this.focusConnectScheduleID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCode = useState(const Uuid().v4());
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      final returnedAuthCode = tryCast<String>(uri.queryParameters['authCode']);
      debugPrint('returnedAuthCode: $returnedAuthCode, authCode: ${authCode.value}, uri: $uri, path: ${uri.path}');
      if (returnedAuthCode != authCode.value) {
        return;
      }
      if (uri.path == '/focus-connect/schedule') {
        final connected = tryCast<String>(uri.queryParameters['connected']) == 'true';
        if (connected == true) {
          focusConnectScheduleID.value = tryCast<String>(uri.queryParameters['focusConnectScheduleID']);
        } else {
          focusConnectScheduleID.value = null;
        }
      }
    });

    return MedicineFormSectionLayout(
      icon: Icons.notifications,
      text: L.notificationSetting,
      children: [
        ListTile(
          onTap: () async {
            final canOpen = await canLaunchUrl(Uri.parse('focus-connect://'));
            if (!canOpen) {
              if (context.mounted) {
                showOKDialog(
                  context,
                  icon: Icons.install_desktop,
                  title: 'Focusがインストールされていません',
                  message: 'Focusをインストールします',
                  ok: () async {
                    await launchUrl(
                      Uri.parse('https://apps.apple.com/app/id1663997320'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                );
              }
              return;
            }

            if (focusConnectScheduleID.value != null) {
              launchUrl(
                Uri.parse(
                  'focus-connect://schedule/delete?focusConnectAppID=$focusConnectAppID&focusConnectScheduleID=${focusConnectScheduleID.value}&authCode=${authCode.value}',
                ),
              );
            } else {
              final start = '${schedule.hour}:${schedule.minute}:30';
              final end = '${schedule.hour + 4}:${schedule.minute}:00';
              launchUrl(
                Uri.parse(
                  'focus-connect://schedule/add?focusConnectAppID=$focusConnectAppID&intervalStartTimeOfDay=$start&intervalEndTimeOfDay=$end&repeats=true&authCode=${authCode.value}',
                ),
              );
            }
          },
          title: const Text('通知受信から服薬記録するまで他のアプリをブロックする'),
          subtitle: const Text('通知受信から服薬記録するまで他のアプリをブロックする機能が有効になります。'),
          trailing: focusConnectScheduleID.value != null ? const Icon(Icons.check) : const Icon(Icons.check_box_outline_blank),
        ),
      ],
    );
  }
}
