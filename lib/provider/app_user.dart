import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_user.g.dart';

@Riverpod(dependencies: [userDatabase])
String appUserID(AppUserIDRef ref) {
  throw UnimplementedError();
}

@Riverpod(dependencies: [userDatabase])
Stream<AppUser> appUser(AppUserRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return database.userReference().snapshots().map((event) => event.data()!);
}
