import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/utils/billing/created_count.dart';

class _Item {
  final String userID;
  _Item({required this.userID});
}

void main() {
  // 個別課金ポリシー: 作成上限は一覧の総数ではなく作成者単位で数える
  group('countCreatedByUser', () {
    test('空リストは 0 件になる', () {
      expect(countCreatedByUser<_Item>(items: [], userID: 'me', creatorUserID: (item) => item.userID), 0);
    });

    test('自分が作成した件数だけを数え、他人が作成した件数は含めない', () {
      final items = [
        _Item(userID: 'me'),
        _Item(userID: 'other'),
        _Item(userID: 'me'),
        _Item(userID: 'other'),
        _Item(userID: 'other'),
      ];

      expect(countCreatedByUser(items: items, userID: 'me', creatorUserID: (item) => item.userID), 2);
    });

    test('自分の作成分が 1 件も無ければ 0 件になる', () {
      final items = [_Item(userID: 'other'), _Item(userID: 'other')];

      expect(countCreatedByUser(items: items, userID: 'me', creatorUserID: (item) => item.userID), 0);
    });
  });
}
