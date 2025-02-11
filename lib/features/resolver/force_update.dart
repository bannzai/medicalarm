import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/alert/ok.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/force_update.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:medicalarm/utils/platform/platform.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateResolver extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;

  const ForceUpdateResolver({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkForceUpdate = ref.watch(checkForceUpdateProvider);
    final shouldForceUpdate = useState(false);
    useEffect(() {
      void f() async {
        try {
          // 多少データが変更される可能性があるが、それは許容する。ほとんど問題はないはず
          // 起動時間を優先する
          if (await checkForceUpdate()) {
            shouldForceUpdate.value = true;
          }
        } catch (e, st) {
          errorLogger.recordError(e, st);
        }
      }

      f();
      return null;
    }, [checkForceUpdate]);

    if (shouldForceUpdate.value) {
      Future.microtask(() async {
        if (context.mounted) {
          await showOKDialog(context, icon: Icons.error, title: L.updateRequired, message: L.updateRequiredMessage(storeName), ok: () async {
            await launchUrl(
              Uri.parse(forceUpdateStoreURL),
              mode: LaunchMode.externalApplication,
            );
          });
        }
      });
      return const IndicatorPage();
    }

    return builder(context);
  }
}
