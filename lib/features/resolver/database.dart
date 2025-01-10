// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/components/loading/indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/app_user.dart';
import 'package:medicalarm/features/resolver/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

abstract class _CollectionPath {
  static const String users = "/users";
}

@Riverpod(keepAlive: true, dependencies: [])
UserDatabase userDatabase(UserDatabaseRef ref) {
  throw UnimplementedError("userDatabase is not implemented");
}

class UserDatabase {
  final String userID;
  UserDatabase({required this.userID});

  final FromFirestore<AppUser> _userFromFirestore = (snapshot, options) => AppUser.fromJson(snapshot.data()!..["id"] = snapshot.id);
  final ToFirestore<AppUser> _userToFirestore = (user, options) => user.toJson();
  DocumentReference<AppUser> userReference() => FirebaseFirestore.instance.collection(_CollectionPath.users).doc(userID).withConverter(
        fromFirestore: _userFromFirestore,
        toFirestore: _userToFirestore,
      );
}

class UserDatabaseResolver extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;

  const UserDatabaseResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserChangesProvider).asData?.value;

    useEffect(() {
      if (user == null) {
        ref.invalidate(userDatabaseProvider);
      }
      return null;
    }, [user]);

    if (user != null) {
      return ProviderScope(
        overrides: [userDatabaseProvider.overrideWith((ref) => UserDatabase(userID: user.uid))],
        child: Consumer(
          builder: ((context, ref, child) => builder(context)),
        ),
      );
    } else {
      return const IndicatorPage();
    }
  }
}
