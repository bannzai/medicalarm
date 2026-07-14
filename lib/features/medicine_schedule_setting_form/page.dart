import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/entity/group_member_notification_settings.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/focus_connect/section.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/notification_setting/section.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/group_member_notification_settings.dart';
import 'package:medicalarm/theme/form.dart';

/// スケジュールの通知設定画面。
///
/// - 新規薬(未保存: [medicine] が null): 従来どおり [schedules] テンプレートへ書き込む。
/// - 既存薬の編集([medicine] が非 null): テンプレートは変更せず、自分のメンバー個別通知設定
///   ([groupMemberNotificationSettingsProvider])へ upsert する。初期値は有効設定の解決規則
///   ([resolveEffectiveNotificationSetting])で決める。
class MedicineScheduleSettingFormPage extends HookConsumerWidget {
  final MedicationSchedule schedule;
  final ValueNotifier<List<MedicationSchedule>> schedules;
  final int index;
  final Medicine? medicine;
  const MedicineScheduleSettingFormPage({
    super.key,
    required this.schedule,
    required this.schedules,
    required this.index,
    required this.medicine,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicine = this.medicine;

    // 新規薬(未保存): テンプレート(schedules)へ書き込む従来動作。
    if (medicine == null) {
      return _ScheduleSettingScaffold(
        schedule: schedule,
        initialSetting: MemberScheduleNotificationSetting(
          isReminderEnabled: schedule.notificationSetting.isReminderEnabled,
          isFollowupEnabled: schedule.notificationSetting.isFollowupEnabled,
          useCriticalAlert: schedule.notificationSetting.useCriticalAlert,
          criticalAlertVolume: schedule.notificationSetting.criticalAlertVolume,
          useAlarmKit: schedule.notificationSetting.useAlarmKit,
          focusConnectScheduleID: schedule.focusConnectSetting?.focusConnectScheduleID,
        ),
        onChanged: (setting) {
          final copied = [...schedules.value];
          copied[index] = copied[index].copyWith(
            notificationSetting: MedicineScheduleNotificationSetting(
              isReminderEnabled: setting.isReminderEnabled,
              isFollowupEnabled: setting.isFollowupEnabled,
              useCriticalAlert: setting.useCriticalAlert,
              criticalAlertVolume: setting.criticalAlertVolume,
              useAlarmKit: setting.useAlarmKit,
            ),
            focusConnectSetting: MedicineScheduleFocusConnectSetting(focusConnectScheduleID: setting.focusConnectScheduleID),
          );
          schedules.value = copied;
        },
      );
    }

    // 既存薬: 自分のメンバー個別通知設定へ upsert する。テンプレート(schedules)は変更しない。
    final memberSettingsAsync = ref.watch(groupMemberNotificationSettingsProvider);
    final memberSettingsUpdate = ref.watch(groupMemberNotificationSettingsUpdateProvider);
    final currentUserID = ref.watch(appUserIDProvider);
    return memberSettingsAsync.when(
      loading: () => const IndicatorPage(),
      error: (error, stackTrace) => RetryPage(exception: error),
      data: (memberSettings) => _ScheduleSettingScaffold(
        schedule: schedule,
        initialSetting: resolveEffectiveNotificationSetting(
          medicine: medicine,
          schedule: schedule,
          memberSettings: memberSettings,
          currentUserID: currentUserID,
        ),
        onChanged: (setting) {
          memberSettingsUpdate.call(
            current: memberSettings,
            medicineID: medicine.id,
            scheduleID: schedule.id,
            setting: setting,
          );
        },
      ),
    );
  }
}

/// 通知設定 UI の共通スキャフォールド。6 項目を [initialSetting] で初期化し、変更のたびに
/// [onChanged] へ組み立てた [MemberScheduleNotificationSetting] を渡す。書き込み先の差異は
/// [onChanged] が吸収する。
class _ScheduleSettingScaffold extends HookWidget {
  final MedicationSchedule schedule;
  final MemberScheduleNotificationSetting initialSetting;
  final void Function(MemberScheduleNotificationSetting setting) onChanged;

  const _ScheduleSettingScaffold({
    required this.schedule,
    required this.initialSetting,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isReminderEnabled = useState(initialSetting.isReminderEnabled);
    final isFollowupEnabled = useState(initialSetting.isFollowupEnabled);
    final useCriticalAlert = useState(initialSetting.useCriticalAlert);
    final criticalAlertVolume = useState(initialSetting.criticalAlertVolume);
    final useAlarmKit = useState(initialSetting.useAlarmKit);
    final focusConnectScheduleID = useState(initialSetting.focusConnectScheduleID);
    final primaryColor = Theme.of(context).colorScheme.primary;

    // onChanged は既存薬モードで memberSettings 更新のたびに差し替わるため、最新を参照して stale を避ける。
    final onChangedRef = useRef(onChanged);
    onChangedRef.value = onChanged;

    // リスナー登録は初回のみ。build ごとに addListener すると重複登録で多重書き込みになるため useEffect で 1 度だけ張る。
    useEffect(() {
      void listener() {
        onChangedRef.value(MemberScheduleNotificationSetting(
          isReminderEnabled: isReminderEnabled.value,
          isFollowupEnabled: isFollowupEnabled.value,
          useCriticalAlert: useCriticalAlert.value,
          criticalAlertVolume: criticalAlertVolume.value,
          useAlarmKit: useAlarmKit.value,
          focusConnectScheduleID: focusConnectScheduleID.value,
        ));
      }

      isReminderEnabled.addListener(listener);
      isFollowupEnabled.addListener(listener);
      useCriticalAlert.addListener(listener);
      criticalAlertVolume.addListener(listener);
      useAlarmKit.addListener(listener);
      focusConnectScheduleID.addListener(listener);
      return () {
        isReminderEnabled.removeListener(listener);
        isFollowupEnabled.removeListener(listener);
        useCriticalAlert.removeListener(listener);
        criticalAlertVolume.removeListener(listener);
        useAlarmKit.removeListener(listener);
        focusConnectScheduleID.removeListener(listener);
      };
    }, []);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: FormTheme(
        child: Scaffold(
          appBar: AppBar(
            title: Text(L.medicationScheduleNotificationSetting, style: TextStyle(color: primaryColor)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MedicineScheduleNotificationSettingSection(
                    isReminderEnabled: isReminderEnabled,
                    isFollowupEnabled: isFollowupEnabled,
                    useCriticalAlert: useCriticalAlert,
                    criticalAlertVolume: criticalAlertVolume,
                    useAlarmKit: useAlarmKit,
                  ),
                  MedicineScheduleFocusConnectSettingSection(
                    schedule: schedule,
                    focusConnectScheduleID: focusConnectScheduleID,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
