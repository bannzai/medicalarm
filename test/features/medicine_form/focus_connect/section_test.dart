import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/features/medicine_form/components/schedule/focus_connect/section.dart';

void main() {
  const authCode = 'auth-code';

  group('focusConnectScheduleReturnAction', () {
    test('connected=true: 返った ID を保存する', () {
      expect(
        focusConnectScheduleReturnAction(
          uri: Uri.parse('medicalarm:///focus-connect/schedule?connected=true&authCode=$authCode&focusConnectScheduleID=schedule-1'),
          authCode: authCode,
        ),
        isA<FocusConnectScheduleReturnSave>().having((save) => save.focusConnectScheduleID, 'focusConnectScheduleID', 'schedule-1'),
      );
    });

    test('connected=true で focusConnectScheduleID が無い: 保存する ID は null', () {
      expect(
        focusConnectScheduleReturnAction(uri: Uri.parse('medicalarm:///focus-connect/schedule?connected=true&authCode=$authCode'), authCode: authCode),
        isA<FocusConnectScheduleReturnSave>().having((save) => save.focusConnectScheduleID, 'focusConnectScheduleID', isNull),
      );
    });

    test('connected が無い戻り: connected=true でないので ID を消す (変更前と同じ扱い)', () {
      expect(
        focusConnectScheduleReturnAction(
          uri: Uri.parse('medicalarm:///focus-connect/schedule?authCode=$authCode&focusConnectScheduleID=schedule-1'),
          authCode: authCode,
        ),
        isA<FocusConnectScheduleReturnClear>(),
      );
    });

    test('connected=true&unlocked=true: 解除の成功なので ID をそのまま保つ', () {
      expect(
        focusConnectScheduleReturnAction(
          uri: Uri.parse('medicalarm:///focus-connect/schedule?connected=true&unlocked=true&authCode=$authCode&focusConnectScheduleID=schedule-1'),
          authCode: authCode,
        ),
        isA<FocusConnectScheduleReturnKeep>(),
      );
    });

    test('connected=false: 削除の完了なので ID を消す', () {
      expect(
        focusConnectScheduleReturnAction(
          uri: Uri.parse('medicalarm:///focus-connect/schedule?connected=false&authCode=$authCode&focusConnectScheduleID=schedule-1'),
          authCode: authCode,
        ),
        isA<FocusConnectScheduleReturnClear>(),
      );
    });

    test('connected=false&reason=not-found: Focus の側でスケジュールが消えているので ID を消す', () {
      expect(
        focusConnectScheduleReturnAction(
          uri: Uri.parse('medicalarm:///focus-connect/schedule?connected=false&reason=not-found&authCode=$authCode&focusConnectScheduleID=schedule-1'),
          authCode: authCode,
        ),
        isA<FocusConnectScheduleReturnClear>(),
      );
    });

    test('connected=false&reason=limit-reached: 連携の状態は変わらないので ID をそのまま保つ', () {
      expect(
        focusConnectScheduleReturnAction(
          uri: Uri.parse('medicalarm:///focus-connect/schedule?connected=false&reason=limit-reached&authCode=$authCode'),
          authCode: authCode,
        ),
        isA<FocusConnectScheduleReturnKeep>(),
      );
    });

    test('authCode が一致しない戻りは、not-found でも扱わない', () {
      expect(
        focusConnectScheduleReturnAction(
          uri: Uri.parse('medicalarm:///focus-connect/schedule?connected=false&reason=not-found&authCode=other&focusConnectScheduleID=schedule-1'),
          authCode: authCode,
        ),
        isA<FocusConnectScheduleReturnKeep>(),
      );
    });

    test('authCode が無い戻りは扱わない', () {
      expect(
        focusConnectScheduleReturnAction(
          uri: Uri.parse('medicalarm:///focus-connect/schedule?connected=false&reason=not-found&focusConnectScheduleID=schedule-1'),
          authCode: authCode,
        ),
        isA<FocusConnectScheduleReturnKeep>(),
      );
    });

    test('Focus Connect のスケジュール以外のパスは扱わない', () {
      expect(
        focusConnectScheduleReturnAction(uri: Uri.parse('medicalarm:///other?connected=false&authCode=$authCode'), authCode: authCode),
        isA<FocusConnectScheduleReturnKeep>(),
      );
    });
  });

  group('focusConnectScheduleUnlockURL', () {
    test('解除の URL に authCode・連携の ID・アプリの ID が付く', () {
      final url = focusConnectScheduleUnlockURL(focusConnectScheduleID: 'schedule-1', authCode: authCode);
      expect(url.scheme, 'focus-connect');
      expect(url.host, 'schedule');
      expect(url.path, '/unlock');
      expect(url.queryParameters, {'focusConnectScheduleID': 'schedule-1', 'focusConnectAppID': focusConnectAppID, 'authCode': authCode});
    });
  });
}
