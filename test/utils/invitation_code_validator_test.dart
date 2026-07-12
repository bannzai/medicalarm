import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/utils/invitation_code_validator.dart';

void main() {
  // 招待コードはサーバーの ALPHABET(ABCDEFGHJKMNPQRSTVWXY3456789) の 8 文字のみ有効
  group('isValidInvitationCode', () {
    test('ALPHABET の 8 文字は有効', () {
      expect(isValidInvitationCode('ABCDEFGH'), isTrue);
      expect(isValidInvitationCode('3456789A'), isTrue);
      expect(isValidInvitationCode('KMNPQRST'), isTrue);
    });

    test('桁数が 8 でなければ無効', () {
      expect(isValidInvitationCode('ABCDEFG'), isFalse);
      expect(isValidInvitationCode('ABCDEFGHJ'), isFalse);
      expect(isValidInvitationCode(''), isFalse);
    });

    test('除外文字(I/L/O/U/Z/0/1/2)を含むと無効', () {
      expect(isValidInvitationCode('IIIIIIII'), isFalse);
      expect(isValidInvitationCode('ABCDEFG0'), isFalse);
      expect(isValidInvitationCode('ABCDEFG1'), isFalse);
      expect(isValidInvitationCode('ABCDEFGZ'), isFalse);
    });

    test('小文字は無効(入力側で大文字化される前提)', () {
      expect(isValidInvitationCode('abcdefgh'), isFalse);
    });
  });
}
