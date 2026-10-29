import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_user.g.dart';

@Riverpod(dependencies: [appUser])
String appUserID(AppUserIDRef ref) {
  return ref.watch(appUserProvider).asData?.value.id ?? FirebaseAuth.instance.currentUser!.uid;
}

@Riverpod(dependencies: [userDatabase])
Stream<AppUser> appUser(AppUserRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return database.userReference().snapshots().map((event) => event.data()!);
}

/// サーバーにある user ドキュメントを取得する。ドキュメントが無ければ null を返す。
///
/// [appUserProvider] のリスナーは、クライアントの書き込みの確定を、Cloud Functions が先に書いた値の受信より前に流すことがある。
/// その途中の値で判断できない処理が、サーバーの値で判定し直すために使う (#465)。
class ServerAppUserFetch {
  final UserDatabase database;

  ServerAppUserFetch({required this.database});

  Future<AppUser?> call() async {
    return (await database.userReference().get(const GetOptions(source: Source.server))).data();
  }
}

@Riverpod(dependencies: [userDatabase])
ServerAppUserFetch serverAppUserFetch(Ref ref) {
  return ServerAppUserFetch(database: ref.watch(userDatabaseProvider));
}
