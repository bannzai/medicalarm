import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

// riverpod 3 は購読者のいない autoDispose の provider を `ref.read(provider.future)` の直後に破棄し、
// 値が届く前に破棄された future は「disposed during loading state」の StateError で失敗する (riverpod 2 では値が届いていた)。
// 値が届くまで購読して破棄を防ぐ (#447)

/// [provider] の値が届くまで購読して 1 回読む。provider が持つ [Ref] から読む時に使う。
Future<T> readFutureKeepingAlive<T>({required Ref ref, required ProviderListenable<Future<T>> provider}) async {
  final subscription = ref.listen(provider, (previous, next) {});
  try {
    return await subscription.read();
  } finally {
    subscription.close();
  }
}

/// [provider] の値が届くまで購読して 1 回読む。widget の [WidgetRef] から読む時に使う。
Future<T> readFutureKeepingAliveFromWidget<T>({required WidgetRef ref, required ProviderListenable<Future<T>> provider}) async {
  final subscription = ref.listenManual(provider, (previous, next) {});
  try {
    return await subscription.read();
  } finally {
    subscription.close();
  }
}
