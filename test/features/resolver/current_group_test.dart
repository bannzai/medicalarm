import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/features/resolver/current_group.dart';

/// テスト用に最小限のフィールドで Group を組み立てる。
Group _group(String id) => Group(id: id, memberUserIDs: const [], name: null, ownerUserID: null);

void main() {
  // currentGroupID が所属グループから消えた際の付け替え先を決める純粋関数を検証する。
  group('fallbackCurrentGroupID', () {
    test('defaultGroupID が所属グループに存在すればそれを返す', () {
      expect(
        fallbackCurrentGroupID(groups: [_group('a'), _group('b')], defaultGroupID: 'b'),
        'b',
      );
    });

    test('defaultGroupID が所属グループに存在しなければ先頭グループを返す(再選択ループ回避)', () {
      expect(
        fallbackCurrentGroupID(groups: [_group('a'), _group('b')], defaultGroupID: 'removed'),
        'a',
      );
    });

    test('defaultGroupID が null なら先頭グループを返す', () {
      expect(
        fallbackCurrentGroupID(groups: [_group('a'), _group('b')], defaultGroupID: null),
        'a',
      );
    });

    test('所属グループが空なら null を返す(選択解除)', () {
      expect(
        fallbackCurrentGroupID(groups: const [], defaultGroupID: 'removed'),
        isNull,
      );
    });
  });
}
