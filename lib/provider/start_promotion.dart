import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/utils/functions/firebase_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'start_promotion.g.dart';

@Riverpod(keepAlive: false, dependencies: [])
StartPromotion startPromotion(Ref ref) {
  return StartPromotion();
}

class StartPromotion {
  // 返り値はisSuccess(=!isAlreadyExists)
  Future<bool> call({required int promotionDayCount}) async {
    final isAlraedyExists = await functions.startPromotion(promotionDayCount: promotionDayCount);
    return !isAlraedyExists;
  }
}
