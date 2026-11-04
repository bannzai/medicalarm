import 'package:flutter_test/flutter_test.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/provider/group_create.dart';

/// [id]・[ownerUserID]・[createdDateTime] だけを指定したグループ。
Group _group({required String id, required String? ownerUserID, required DateTime? createdDateTime}) {
  return Group(id: id, memberUserIDs: const ['test-user'], name: null, ownerUserID: ownerUserID, createdDateTime: createdDateTime);
}

void main() {
  group('oldestOwnedGroupID', () {
    test('オーナーのグループのうち最も古いものを返す', () {
      final groupID = oldestOwnedGroupID(
        groups: [
          _group(id: 'newer', ownerUserID: 'test-user', createdDateTime: DateTime(2026, 11, 4, 12)),
          _group(id: 'older', ownerUserID: 'test-user', createdDateTime: DateTime(2026, 11, 4, 11)),
        ],
        ownerUserID: 'test-user',
      );

      expect(groupID, 'older');
    });

    test('招待されて所属しているだけのグループは返さない', () {
      final groupID = oldestOwnedGroupID(
        groups: [_group(id: 'invited', ownerUserID: 'other-user', createdDateTime: DateTime(2026, 11, 4))],
        ownerUserID: 'test-user',
      );

      expect(groupID, isNull);
    });

    test('ownerUserID を持たない既存のグループは返さない', () {
      final groupID = oldestOwnedGroupID(
        groups: [_group(id: 'legacy', ownerUserID: null, createdDateTime: DateTime(2026, 11, 4))],
        ownerUserID: 'test-user',
      );

      expect(groupID, isNull);
    });

    test('createdDateTime が無いグループは日時のあるグループより後ろに回す', () {
      final groupID = oldestOwnedGroupID(
        groups: [
          _group(id: 'no-date', ownerUserID: 'test-user', createdDateTime: null),
          _group(id: 'dated', ownerUserID: 'test-user', createdDateTime: DateTime(2026, 11, 4)),
        ],
        ownerUserID: 'test-user',
      );

      expect(groupID, 'dated');
    });
  });
}
