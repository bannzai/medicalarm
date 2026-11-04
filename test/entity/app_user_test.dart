import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/app_user.dart';

void main() {
  // AppUserCreate は AppUser を merge で書くため、null のフィールドを JSON に含めると、
  // createGroup がサーバーで書いた defaultGroupID を後から届いた書き込みが null に戻す (#514)。
  group('AppUser.toJson', () {
    test('値が無い defaultGroupID と groupMigratedDateTime を書かない', () {
      final json = AppUser(id: 'test-user').toJson();

      expect(json.containsKey('defaultGroupID'), isFalse);
      expect(json.containsKey('groupMigratedDateTime'), isFalse);
    });

    test('値がある defaultGroupID と groupMigratedDateTime は書く', () {
      final json = AppUser(id: 'test-user', defaultGroupID: 'solo', groupMigratedDateTime: DateTime(2026, 11, 4)).toJson();

      expect(json['defaultGroupID'], 'solo');
      expect(json.containsKey('groupMigratedDateTime'), isTrue);
    });
  });
}
