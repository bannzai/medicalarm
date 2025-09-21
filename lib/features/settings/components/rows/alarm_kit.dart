import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:medicalarm/utils/alarm_kit_service.dart';
import 'package:medicalarm/utils/shared_preferences/keys.dart';
import 'package:medicalarm/provider/shared_preferences.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/preium_introduction/premium_introduction_sheet.dart';

class AlarmKitSetting extends HookConsumerWidget {
  const AlarmKitSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AlarmKit可用性チェック
    final isAlarmKitAvailableFuture = useFuture(AlarmKitService.isAvailable());
    final isAlarmKitAvailable = isAlarmKitAvailableFuture.data;

    // SharedPreferencesから設定値を取得
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    final isEnabled = useState(sharedPreferences.getBool(BoolKey.useAlarmKit) ?? false);

    final isLoading = useState(false);
    final customerInfo = ref.watch(customerInfoProvider).asData?.value;

    // AlarmKitが利用できない場合は何も表示しない
    if (isAlarmKitAvailable != true) {
      return const SizedBox.shrink();
    }

    final isPremium = customerInfo?.isPremium ?? false;
    final isTrial = customerInfo?.isInPromotion ?? false;
    final canUseFeature = isPremium || isTrial;

    return ListTile(
      title: Row(
        children: [
          Text(
            'アラーム機能',
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
          if (!canUseFeature) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]
        ],
      ),
      subtitle: const Text(
        '目覚まし同様の通知が鳴ります。サイレントモードや集中モード時でも確実に通知されます',
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      trailing: Stack(
        alignment: Alignment.center,
        children: [
          Switch(
            value: isEnabled.value,
            onChanged: canUseFeature
                ? (value) async {
                    if (isLoading.value) {
                      return;
                    }

                    // プレミアム機能でない場合はプレミアム紹介画面を表示
                    if (!canUseFeature) {
                      showPremiumIntroductionSheet(context);
                      return;
                    }

                    analytics.logEvent(
                      name: 'did_toggle_alarm_kit_setting',
                      parameters: {'enabled': value},
                    );

                    isLoading.value = true;
                    try {
                      if (value) {
                        // AlarmKit有効時は権限リクエスト
                        final hasPermission = await AlarmKitService.requestPermission();
                        if (hasPermission) {
                          // SharedPreferencesに設定を保存
                          await sharedPreferences.setBool(BoolKey.useAlarmKit, true);
                          isEnabled.value = true;

                          // 通知の再登録処理
                          final registerReminderLocalNotification = ref.read(registerReminderLocalNotificationProvider);
                          await registerReminderLocalNotification();
                        } else {
                          // 権限が拒否された場合はエラーメッセージ表示
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('アラーム機能の権限が必要です。設定から許可してください。'),
                              ),
                            );
                          }
                        }
                      } else {
                        // AlarmKit無効時
                        await sharedPreferences.setBool(BoolKey.useAlarmKit, false);
                        isEnabled.value = false;

                        // 通知の再登録処理
                        final registerReminderLocalNotification = ref.read(registerReminderLocalNotificationProvider);
                        await registerReminderLocalNotification();
                      }
                    } catch (e) {
                      analytics.debug(name: 'alarm_kit_setting_error', parameters: {'error': e.toString()});
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('設定の変更に失敗しました。もう一度お試しください。'),
                          ),
                        );
                      }
                    } finally {
                      isLoading.value = false;
                    }
                  }
                : () {
                    showPremiumIntroductionSheet(context);
                  },
          ),
          if (isLoading.value)
            const SizedBox(
              width: 40,
              height: 40,
              child: Indicator(),
            )
        ],
      ),
    );
  }
}
