import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dose_receiver.g.dart';

@Riverpod(dependencies: [currentGroupDatabase])
Stream<List<DoseReceiver>> doseReceivers(DoseReceiversRef ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return database.doseReceiversReference().snapshots().map((event) => event.docs.map((doc) => doc.data()).toList());
}

class DoseReceiverAdd {
  final GroupDatabase database;
  // 作成者(creator)の uid。DoseReceiver.userID に設定する。
  final String userID;

  DoseReceiverAdd({required this.database, required this.userID});

  Future<DoseReceiver> call({
    required String name,
  }) async {
    // add() はランダムなドキュメント ID を別途採番するため、id フィールドと実際のドキュメント ID が
    // 食い違い、読み込み時の id 上書きで参照が一致しなくなる。doc() への set で一致を保証する (#246)
    final docRef = database.doseReceiversReference().doc();
    final doseReceiver = DoseReceiver(
      id: docRef.id,
      userID: userID,
      name: name,
    );
    await docRef.set(doseReceiver, SetOptions(merge: true));
    return doseReceiver;
  }
}

@Riverpod(dependencies: [currentGroupDatabase, appUserID])
DoseReceiverAdd doseReceiverAdd(DoseReceiverAddRef ref) {
  return DoseReceiverAdd(database: ref.watch(currentGroupDatabaseProvider), userID: ref.watch(appUserIDProvider));
}

class FirstDoseReceiverAdd {
  final GroupDatabase database;
  final String userID;

  FirstDoseReceiverAdd({required this.database, required this.userID});

  Future<void> call() async {
    // 空のキャッシュ snapshot や複数メンバーの同時初期化で呼ばれても既存の firstUser ドキュメント
    // (編集済みの name・作成者 userID・タイムスタンプ)を上書きしないよう、サーバー読み取りを伴う
    // トランザクションで「存在しない場合のみ作成」する
    final docRef = database.doseReceiverReference(doseReceiverID: DoseReceiver.firstUserID);
    await docRef.firestore.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        return;
      }
      transaction.set(docRef, DoseReceiver.firstUser(userID: userID));
    });
  }
}

@Riverpod(dependencies: [currentGroupDatabase, appUserID])
FirstDoseReceiverAdd firstDoseReceiverAdd(FirstDoseReceiverAddRef ref) {
  return FirstDoseReceiverAdd(database: ref.watch(currentGroupDatabaseProvider), userID: ref.watch(appUserIDProvider));
}

class DoseReceiverUpdate {
  final GroupDatabase database;

  DoseReceiverUpdate({required this.database});

  Future<DoseReceiver> call({
    required DoseReceiver doseReceiver,
    required String name,
  }) async {
    final collectionRef = database.doseReceiversReference();
    final docRef = collectionRef.doc(doseReceiver.id);
    final newDoseReceiver = doseReceiver.copyWith(name: name);
    await docRef.set(newDoseReceiver, SetOptions(merge: true));
    return newDoseReceiver;
  }
}

@Riverpod(dependencies: [currentGroupDatabase])
DoseReceiverUpdate doseReceiverUpdate(DoseReceiverUpdateRef ref) {
  final database = ref.watch(currentGroupDatabaseProvider);
  return DoseReceiverUpdate(database: database);
}
