import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/current_group_id.dart';
import 'package:medicalarm/provider/onboarding_medication_plan.dart';
import 'package:medicalarm/utils/analytics/error.dart';

/// 起動・グループ切替・薬の登録・フォアグラウンド復帰に合わせ、未登録プランの通知を同期する。
class OnboardingMedicationPlanResolver extends HookConsumerWidget {
  /// 初期化済みアカウントで表示する画面。
  final Widget child;

  const OnboardingMedicationPlanResolver({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userID = ref.watch(appUserIDProvider);
    final groupID = ref.watch(currentGroupIDProvider)!;
    final planProvider = onboardingMedicationPlanStoreProvider(userID: userID, groupID: groupID);
    final plan = ref.watch(planProvider);
    final planStore = ref.watch(planProvider.notifier);
    final hasMedicines = ref.watch(hasRegisteredMedicinesProvider).asData?.value;
    final lifecycle = useAppLifecycleState();

    useEffect(() {
      return () {
        unawaited(cancelOnboardingMedicationPlanNotifications().catchError((Object error, StackTrace stackTrace) {
          errorLogger.recordError(error, stackTrace);
        }));
      };
    }, [userID, groupID]);

    useEffect(() {
      if (hasMedicines != null) {
        // build 中の Provider 更新を避け、破棄・グループ切替済みの処理を実行しない。
        var isCurrent = true;
        Future.microtask(() async {
          if (!isCurrent) return;
          try {
            await planStore.synchronizeNotifications(hasMedicines: hasMedicines);
          } catch (error, stackTrace) {
            errorLogger.recordError(error, stackTrace);
          }
        });
        return () => isCurrent = false;
      }
      return null;
    }, [userID, groupID, hasMedicines, plan, lifecycle]);

    return child;
  }
}
