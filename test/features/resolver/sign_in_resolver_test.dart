import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/components/retry/page.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/features/resolver/auth.dart';
import 'package:medicalarm/utils/analytics/error.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_resolver_test.mocks.dart';

/// 記録した例外を保持する ErrorLogger。テストでは Firebase を初期化しないため Crashlytics を呼ばずに差し替える。
class _RecordingErrorLogger extends ErrorLogger {
  /// recordError に渡された例外。記録した順に並ぶ。
  final List<Object?> recordedErrors = [];

  @override
  void recordError(dynamic exception, StackTrace? stack) {
    recordedErrors.add(exception);
  }
}

/// [firebaseAuth] で SignInResolver を描画する。サインインできたら uid を表示する。
Future<void> _pumpSignInResolver(WidgetTester tester, {required FirebaseAuth firebaseAuth}) {
  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: SignInResolver(firebaseAuth: firebaseAuth, builder: (context, user) => Text('signed-in: ${user.uid}')),
      ),
    ),
  );
}

@GenerateNiceMocks([MockSpec<FirebaseAuth>(), MockSpec<UserCredential>(), MockSpec<User>()])
void main() {
  // 匿名サインインが失敗してもスピナーのまま止まらず、再試行の画面から抜けられる (#582)。
  group('SignInResolver の匿名サインインの失敗', () {
    late _RecordingErrorLogger recordingErrorLogger;

    setUp(() {
      final originalErrorLogger = errorLogger;
      recordingErrorLogger = _RecordingErrorLogger();
      errorLogger = recordingErrorLogger;
      addTearDown(() => errorLogger = originalErrorLogger);
    });

    testWidgets('signInAnonymously が例外を出したら、スピナーではなく再試行の画面を出して失敗を記録する', (tester) async {
      final firebaseAuth = MockFirebaseAuth();
      final signInException = FirebaseAuthException(code: 'network-request-failed');
      when(firebaseAuth.signInAnonymously()).thenThrow(signInException);

      await _pumpSignInResolver(tester, firebaseAuth: firebaseAuth);
      await tester.pump();

      expect(find.byType(RetryPage), findsOneWidget);
      expect(find.byType(IndicatorPage), findsNothing);
      expect(recordingErrorLogger.recordedErrors, [signInException]);
      verify(firebaseAuth.signInAnonymously()).called(1);
    });

    testWidgets('失敗の後に再試行を押すと匿名サインインをやり直し、成功すれば先の画面を描画する', (tester) async {
      final firebaseAuth = MockFirebaseAuth();
      final user = MockUser();
      when(user.uid).thenReturn('anonymous-user');
      final userCredential = MockUserCredential();
      when(userCredential.user).thenReturn(user);
      var signInCallCount = 0;
      when(firebaseAuth.signInAnonymously()).thenAnswer((_) async {
        signInCallCount++;
        if (signInCallCount == 1) {
          throw FirebaseAuthException(code: 'network-request-failed');
        }
        return userCredential;
      });

      await _pumpSignInResolver(tester, firebaseAuth: firebaseAuth);
      await tester.pump();
      expect(find.byType(RetryPage), findsOneWidget);

      await tester.tap(find.text(L.retry));
      await tester.pump();
      await tester.pump();

      expect(signInCallCount, 2);
      expect(find.byType(RetryPage), findsNothing);
      expect(find.text('signed-in: anonymous-user'), findsOneWidget);
    });
  });

  // サインインの成功で AuthResolver が先の画面へ切り替えると、signInAnonymously の完了前に SignInResolver が破棄される。
  // 破棄後の完了・失敗を、サインインの失敗として記録したり破棄済みの状態へ書き込んだりしない。
  group('SignInResolver が匿名サインインの完了前に破棄された時', () {
    late _RecordingErrorLogger recordingErrorLogger;

    setUp(() {
      final originalErrorLogger = errorLogger;
      recordingErrorLogger = _RecordingErrorLogger();
      errorLogger = recordingErrorLogger;
      addTearDown(() => errorLogger = originalErrorLogger);
    });

    testWidgets('破棄の後にサインインが成功しても、例外も失敗の記録も出ない', (tester) async {
      final firebaseAuth = MockFirebaseAuth();
      final user = MockUser();
      when(user.uid).thenReturn('anonymous-user');
      final userCredential = MockUserCredential();
      when(userCredential.user).thenReturn(user);
      final signInCompleter = Completer<UserCredential>();
      when(firebaseAuth.signInAnonymously()).thenAnswer((_) => signInCompleter.future);

      await _pumpSignInResolver(tester, firebaseAuth: firebaseAuth);
      await tester.pumpWidget(const SizedBox());
      signInCompleter.complete(userCredential);
      await tester.pump();

      expect(recordingErrorLogger.recordedErrors, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('破棄の後にサインインが失敗しても、破棄済みの状態へ書き込まない', (tester) async {
      final firebaseAuth = MockFirebaseAuth();
      final signInCompleter = Completer<UserCredential>();
      when(firebaseAuth.signInAnonymously()).thenAnswer((_) => signInCompleter.future);

      await _pumpSignInResolver(tester, firebaseAuth: firebaseAuth);
      await tester.pumpWidget(const SizedBox());
      signInCompleter.completeError(FirebaseAuthException(code: 'network-request-failed'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('SignInResolver の匿名サインインの成功', () {
    testWidgets('サインイン済みのユーザーがいれば匿名サインインをせずに先の画面を描画する', (tester) async {
      final firebaseAuth = MockFirebaseAuth();
      final user = MockUser();
      when(user.uid).thenReturn('existing-user');
      when(firebaseAuth.currentUser).thenReturn(user);

      await _pumpSignInResolver(tester, firebaseAuth: firebaseAuth);
      await tester.pump();

      expect(find.text('signed-in: existing-user'), findsOneWidget);
      verifyNever(firebaseAuth.signInAnonymously());
    });
  });
}
