import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/alert/ok.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/section_layout.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

const focusConnectAppID = 'jmHpoAiQQw0GqE9oFEEH';

/// Focus から Medicalarm へ届いた戻り (`medicalarm:///focus-connect/schedule?...`) を受けて、連携の ID をどう扱うか。
sealed class FocusConnectScheduleReturnAction {
  const FocusConnectScheduleReturnAction();
}

/// 連携が作られた。Focus が返した ID を保存する。
class FocusConnectScheduleReturnSave extends FocusConnectScheduleReturnAction {
  /// Focus が作ったスケジュールの ID。Focus が付けなかった時は null
  final String? focusConnectScheduleID;
  const FocusConnectScheduleReturnSave({required this.focusConnectScheduleID});
}

/// 連携が無くなった (削除した・Focus の側でスケジュールが見つからない)。ID を消す。
class FocusConnectScheduleReturnClear extends FocusConnectScheduleReturnAction {
  const FocusConnectScheduleReturnClear();
}

/// 連携の状態が変わらない戻りか、Medicalarm が開いたものではない戻り。ID をそのまま保つ。
class FocusConnectScheduleReturnKeep extends FocusConnectScheduleReturnAction {
  const FocusConnectScheduleReturnKeep();
}

/// [uri] の `connected`・`unlocked`・`reason`・`authCode`・`focusConnectScheduleID` から、連携の ID の扱いを決める。
/// パラメータ名と値は Focus が返すものに合わせる。[authCode] は Focus を開いた時に渡した値で、一致しない戻りは扱わない。
FocusConnectScheduleReturnAction focusConnectScheduleReturnAction({required Uri uri, required String authCode}) {
  final parameters = uri.queryParameters;
  if (uri.path != '/focus-connect/schedule' || parameters['authCode'] != authCode) {
    return const FocusConnectScheduleReturnKeep();
  }
  if (parameters['connected'] == 'true') {
    // 解除が成功した戻り。連携は続いている
    if (parameters['unlocked'] == 'true') {
      return const FocusConnectScheduleReturnKeep();
    }
    return FocusConnectScheduleReturnSave(focusConnectScheduleID: parameters['focusConnectScheduleID']);
  }
  // 上限に達してスケジュールを作れなかった戻り。連携の状態は変わっていない
  if (parameters['reason'] == 'limit-reached') {
    return const FocusConnectScheduleReturnKeep();
  }
  return const FocusConnectScheduleReturnClear();
}

/// 服薬を記録した時に Focus の制限を解除する URL。[authCode] は戻りをこの記録の分だけ受け取るために渡す。
Uri focusConnectScheduleUnlockURL({required String focusConnectScheduleID, required String authCode}) {
  return Uri.parse(
    'focus-connect://schedule/unlock?focusConnectScheduleID=$focusConnectScheduleID&focusConnectAppID=$focusConnectAppID&authCode=$authCode',
  );
}

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
    // 戻りの購読は 1 回だけ張り、画面を閉じる時に解除する。build のたびに listen すると購読が重なり、閉じた後も残る
    useEffect(() {
      return AppLinks().uriLinkStream.listen((uri) {
        switch (focusConnectScheduleReturnAction(uri: uri, authCode: authCode.value)) {
          case FocusConnectScheduleReturnSave(focusConnectScheduleID: final returnedFocusConnectScheduleID):
            focusConnectScheduleID.value = returnedFocusConnectScheduleID;
          case FocusConnectScheduleReturnClear():
            focusConnectScheduleID.value = null;
          case FocusConnectScheduleReturnKeep():
            break;
        }
      }).cancel;
    }, []);

    return MedicineFormSectionLayout(
      icon: Icons.notifications,
      text: L.notificationSetting,
      children: [
        ListTile(
          onTap: () async {
            analytics.logEvent(name: 'med_sched_focus_connect_tapped');
            final canOpen = await canLaunchUrl(Uri.parse('focus-connect://'));
            if (!canOpen) {
              if (context.mounted) {
                showOKDialog(
                  context,
                  icon: Icons.install_desktop,
                  title: L.focusNotInstalled,
                  message: L.focusInstallMessage,
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
          title: Text(L.focusConnectBlockOtherApps),
          subtitle: Text(L.focusConnectBlockOtherAppsDescription),
          trailing: focusConnectScheduleID.value != null ? const Icon(Icons.check) : const Icon(Icons.check_box_outline_blank),
        ),
      ],
    );
  }
}
