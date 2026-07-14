import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/group.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_groups.g.dart';

/// 自分が所属する全グループ。memberUserIDs に自分の uid を含むグループを購読する。
@Riverpod(dependencies: [userDatabase])
Stream<List<Group>> userGroups(Ref ref) {
  final database = ref.watch(userDatabaseProvider);
  return FirebaseFirestore.instance
      .collection('/groups')
      .where('memberUserIDs', arrayContains: database.userID)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Group.fromJson(doc.data()..['id'] = doc.id)).toList());
}
