import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/utils/riverpod/read_future.dart';
import 'package:riverpod/riverpod.dart';

// 値が非同期に届く autoDispose の StreamProvider。Firestore の snapshots() を読む provider と同じ形
final _delayedValueProvider = StreamProvider.autoDispose<int>((ref) async* {
  await Future<void>.delayed(const Duration(milliseconds: 10));
  yield 42;
});

// keepAlive の provider の Ref。RegisterReminderLocalNotification と同じく、購読者のいない provider を Ref から読む
final _refProvider = Provider<Ref>((ref) => ref);

void main() {
  group('readFutureKeepingAlive', () {
    test('前提: riverpod 3 は購読者のいない autoDispose の provider を ref.read(provider.future) で読むと値が届く前に破棄して失敗する', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final ref = container.read(_refProvider);

      await expectLater(ref.read(_delayedValueProvider.future), throwsA(isA<StateError>()));
    });

    test('値が届くまで購読して読むと値を返す', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final ref = container.read(_refProvider);

      expect(await readFutureKeepingAlive(ref: ref, provider: _delayedValueProvider.future), 42);
    });
  });
}
