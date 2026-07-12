import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group.g.dart';

/// 指定グループの購読。グループ設定画面など特定グループを名指しする用途で使う。
@Riverpod(dependencies: [groupDatabase])
Stream<Group> group(Ref ref, {required String groupID}) {
  final database = ref.watch(groupDatabaseProvider(groupID: groupID));
  return database.groupReference().snapshots().map((event) => event.data()!);
}

/// グループ名を更新する。オーナーのみが呼び出す想定。
class GroupNameUpdate {
  final GroupDatabase database;

  GroupNameUpdate({required this.database});

  Future<void> call({required String name}) async {
    final docRef = database.groupReference();
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final currentGroup = (await transaction.get(docRef)).data()!;
      transaction.set(docRef, currentGroup.copyWith(name: name), SetOptions(merge: true));
    });
  }
}

@Riverpod(dependencies: [groupDatabase])
GroupNameUpdate groupNameUpdate(Ref ref, {required String groupID}) {
  return GroupNameUpdate(database: ref.watch(groupDatabaseProvider(groupID: groupID)));
}
