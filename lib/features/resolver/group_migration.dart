import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/group_create.dart';
import 'package:medicalarm/utils/analytics/error.dart';

/// Firestore WriteBatch 1 回で実行できる書き込み操作の上限。
/// Firestore の仕様上、1 バッチあたり最大 500 オペレーションのため。
const int _firestoreBatchLimit = 500;

/// [items] を [size] 件ずつのチャンクに分割する。WriteBatch の上限分割に使う純粋関数。
List<List<T>> chunkList<T>(List<T> items, {int size = _firestoreBatchLimit}) {
  final chunks = <List<T>>[];
  for (var start = 0; start < items.length; start += size) {
    chunks.add(items.sublist(start, start + size > items.length ? items.length : start + size));
  }
  return chunks;
}

/// 旧 `/users/{uid}` 配下の服薬データを、グループ配下 `/groups/{groupID}` へコピーする移行本体。
///
/// 同一ドキュメント ID への set(merge) で構成されるため冪等。途中失敗しても、
/// 次回同一 [destination] に対して再実行すれば同じ結果に収束する。UI から分離しテスト可能にしている。
class GroupMigration {
  /// コピー元(旧ユーザースコープ)。
  final UserDatabase source;

  /// コピー先(グループスコープ)。
  final GroupDatabase destination;

  /// 移行時に MedicationHistory.recordedByUserID へ付与する uid(移行を実行した本人)。
  final String userID;

  GroupMigration({required this.source, required this.destination, required this.userID});

  Future<void> migrate() async {
    final medicines = (await source.medicinesReference().get()).docs.map((doc) => doc.data()).toList();
    final doseReceivers = (await source.doseReceiversReference().get()).docs.map((doc) => doc.data()).toList();
    final medicationHistories = (await source.medicationHistoriesReference().get()).docs.map((doc) => doc.data()).toList();
    final diaries = (await source.diariesReference().get()).docs.map((doc) => doc.data()).toList();

    await _setAllInBatches([for (final medicine in medicines) MapEntry(destination.medicineReference(medicineID: medicine.id), medicine)]);
    await _setAllInBatches(
      [for (final doseReceiver in doseReceivers) MapEntry(destination.doseReceiverReference(doseReceiverID: doseReceiver.id), doseReceiver)],
    );
    await _setAllInBatches([
      for (final history in medicationHistories)
        MapEntry(
          destination.medicationHistoriesReference().doc(history.id),
          history.copyWith(recordedByUserID: history.recordedByUserID ?? userID),
        ),
    ]);
    await _setAllInBatches([for (final diary in diaries) MapEntry(destination.diaryReference(diaryID: diary.id), diary)]);
  }

  Future<void> _setAllInBatches<T>(List<MapEntry<DocumentReference<T>, T>> writes) async {
    for (final chunk in chunkList(writes)) {
      final batch = FirebaseFirestore.instance.batch();
      for (final write in chunk) {
        batch.set(write.key, write.value, SetOptions(merge: true));
      }
      await batch.commit();
    }
  }
}

/// 起動時オンデマンド移行。groupMigratedDateTime が未設定のユーザーに対し、
/// ソログループ作成(未作成時) → データコピー → 完了マーカー書き込み、を実行する。
/// 実行中は Launch ローディングを表示し、完了 or 既に移行済みなら子を描画する。
class GroupMigrationResolver extends HookConsumerWidget {
  final Widget Function(BuildContext context) builder;

  const GroupMigrationResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider).valueOrNull;
    final userDatabase = ref.watch(userDatabaseProvider);
    final createGroup = ref.watch(createGroupProvider);
    final isMigrating = useState(false);

    useEffect(() {
      void f() async {
        if (appUser == null || appUser.groupMigratedDateTime != null || isMigrating.value) {
          return;
        }
        isMigrating.value = true;
        try {
          // 1. defaultGroupID があればそれを使い、無ければソログループを作成する。
          //    既に defaultGroupID がある(前回の途中失敗)なら手順 1 をスキップして 2 から再開される。
          final groupID = appUser.defaultGroupID ?? await createGroup.call(name: null, setAsDefault: true, iconName: 'home');
          // 2. 旧データをグループ配下へコピーする。
          await GroupMigration(
            source: userDatabase,
            destination: GroupDatabase(groupID: groupID),
            userID: userDatabase.userID,
          ).migrate();
          // 3. 完了マーカーを最後に書く。ここまで到達して初めて移行済みとみなす。
          await userDatabase.userReference().update({'groupMigratedDateTime': FieldValue.serverTimestamp()});
        } catch (e, st) {
          // 失敗しても例外を投げず、次回起動時に再試行する（defaultGroupID 済みなら手順 2 から再開）。
          errorLogger.recordError(e, st);
        } finally {
          isMigrating.value = false;
        }
      }

      f();
      return null;
    }, [appUser]);

    if (appUser == null || appUser.groupMigratedDateTime == null) {
      return const IndicatorPage();
    }
    return builder(context);
  }
}
