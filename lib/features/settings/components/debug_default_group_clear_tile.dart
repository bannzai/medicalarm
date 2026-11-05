import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/error/error_alert.dart';
import 'package:medicalarm/provider/default_group_update.dart';
import 'package:medicalarm/utils/analytics/analytics.dart';

/// DEBUG ビルドの開発者メニューの行。押すと既定グループを失った状態を作る (#514)。
class DebugDefaultGroupClearTile extends ConsumerWidget {
  const DebugDefaultGroupClearTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Clear default group'),
      onTap: () async {
        analytics.logEvent(name: 'settings_debug_default_group_cleared');
        try {
          await ref.read(debugDefaultGroupClearProvider).call();
        } catch (e) {
          if (context.mounted) {
            showErrorAlert(context, e.toString());
          }
        }
      },
    );
  }
}
