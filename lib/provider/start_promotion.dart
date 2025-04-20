import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'start_promotion.g.dart';

@Riverpod(keepAlive: false, dependencies: [])
Stream<User?> startPromotion(Ref ref) {
  return FirebaseAuth.instance.userChanges();
}

class StartPromotion {
  // 返り値はisSuccess(=!isAlreadyExists)
  Future<bool> call() async {
    final isAlraedyExists = await functions.startPromotion(promotionDayCount: 3);
    return !isAlraedyExists;
  }
}
