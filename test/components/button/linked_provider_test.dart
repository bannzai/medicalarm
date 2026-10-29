import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/components/button/user_delete.dart';
import 'package:medicalarm/features/resolver/auth.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  // riverpod 3 の debug ビルドは scoped な firebaseUserChangesProvider を dependencies に無いまま読むと StateError にし、
  // アカウント引き継ぎのバナーを出す服薬画面がエラー表示になった (#447)
  group('アカウントのリンク状態の provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(overrides: [firebaseUserChangesProvider.overrideWith((ref) => Stream.value(null))]);
    });

    tearDown(() {
      container.dispose();
    });

    test('isAppleLinkedProvider はログイン前に false を返す', () {
      expect(container.read(isAppleLinkedProvider), false);
    });

    test('isGoogleLinkedProvider はログイン前に false を返す', () {
      expect(container.read(isGoogleLinkedProvider), false);
    });
  });
}
