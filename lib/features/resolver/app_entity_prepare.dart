import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/provider/dose_receiver.dart';
import 'package:medicalarm/utils/analytics/error.dart';

class AppEntityPrepareResolver extends HookConsumerWidget {
  final String userID;
  final Widget Function(BuildContext context) builder;

  const AppEntityPrepareResolver({
    super.key,
    required this.userID,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doseReceivers = ref.watch(doseReceiversProvider);
    final firstDoseReceiverAdd = ref.watch(firstDoseReceiverAddProvider);
    // firstUser 作成の失敗(オフライン時のトランザクション失敗等)を保持し、Retry から再試行できるようにする。null なら失敗していない
    final initializationError = useState<Object?>(null);
    // 再試行のトリガー。インクリメントで useEffect を再実行させる
    final retryCount = useState(0);

    useEffect(() {
      void f() async {
        if (doseReceivers is AsyncData && doseReceivers.value?.isEmpty == true) {
          initializationError.value = null;
          try {
            await firstDoseReceiverAdd.call();
          } catch (e, st) {
            // オフライン時はトランザクションがキューされず失敗する。クラッシュさせず記録し、
            // Retry(または接続回復後の snapshot 再emit)からの再試行に任せる
            errorLogger.recordError(e, st);
            initializationError.value = e;
          }
        }
      }

      f();
      return null;
    }, [doseReceivers, retryCount.value]);

    if (doseReceivers.valueOrNull?.isEmpty == true && initializationError.value != null) {
      return Retry(
        retry: () => retryCount.value++,
        child: RetryPage(exception: initializationError.value!),
      );
    }
    if (doseReceivers.valueOrNull?.isEmpty == true) {
      return const IndicatorPage();
    }
    return builder(context);
  }
}
