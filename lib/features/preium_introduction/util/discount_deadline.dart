import 'package:medicalarm/utils/date_time.dart';
import 'package:medicalarm/utils/purchase/purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

part 'discount_deadline.g.dart';

@Riverpod()
class Tick extends _$Tick {
  Timer? _timer;

  @override
  DateTime build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = DateTime.now();
    });
    return DateTime.now();
  }
}

@Riverpod()
bool isOverDiscountDeadline(IsOverDiscountDeadlineRef ref, {required DateTime? discountEntitlementDeadlineDate}) {
  if (discountEntitlementDeadlineDate == null) {
    // NOTE: discountEntitlementDeadlineDate が存在しない時はbackendの方でまだ期限を決めていないのでfalse状態で扱う
    return false;
  }
  final timer = ref.watch(tickProvider);
  return timer.isAfter(discountEntitlementDeadlineDate);
}

@Riverpod(dependencies: [customerInfo])
bool hiddenCountdownDiscountDeadline(HiddenCountdownDiscountDeadlineRef ref, {required DateTime? discountEntitlementDeadlineDate}) {
  final customerInfo = ref.watch(customerInfoProvider).asData?.value;
  return customerInfo?.isInDiscountDuration == false;
}

@Riverpod()
Duration durationToDiscountPriceDeadline(DurationToDiscountPriceDeadlineRef ref, {required DateTime discountEntitlementDeadlineDate}) {
  final timerDate = ref.watch(tickProvider);
  return discountEntitlementDeadlineDate.difference(timerDate);
}

String discountPriceDeadlineCountdownString(Duration diff) {
  final hour = diff.inHours;
  final minute = diff.inMinutes % 60;
  final second = diff.inSeconds % 60;
  return DateTimeFormatter.clock(hour.toInt(), minute.toInt(), second.toInt());
}
