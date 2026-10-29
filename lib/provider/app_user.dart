import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_user.g.dart';

@Riverpod(dependencies: [appUser])
String appUserID(Ref ref) {
  return ref.watch(appUserProvider).asData?.value.id ?? FirebaseAuth.instance.currentUser!.uid;
}

@Riverpod(dependencies: [userDatabase])
Stream<AppUser> appUser(Ref ref) {
  final database = ref.watch(userDatabaseProvider);
  return database.userReference().snapshots().map((event) => event.data()!);
}

/// サーバーにある user ドキュメントを取得する。ドキュメントが無ければ null を返す。
///
/// [appUserProvider] のリスナーは、クライアントの書き込みの確定を、Cloud Functions が先に書いた値の受信より前に流すことがある。
/// その途中の値で判断できない処理が、サーバーの値で判定し直すために使う (#465)。
/// Firestore の操作は `call` を持つ class を Provider から返す、というこのリポジトリの規約 (CLAUDE.md) に合わせて class にしている。
class ServerAppUserFetch {
  /// 取得する user ドキュメントの持ち主。
  final UserDatabase database;

  ServerAppUserFetch({required this.database});

  /// サーバーの user ドキュメントを返す。端末のキャッシュは使わないため、サーバーに届かない時 (オフライン等) は例外を投げる。
  Future<AppUser?> call() async {
    return (await database.userReference().get(const GetOptions(source: Source.server))).data();
  }
}

@Riverpod(dependencies: [userDatabase])
ServerAppUserFetch serverAppUserFetch(Ref ref) {
  return ServerAppUserFetch(database: ref.watch(userDatabaseProvider));
}
