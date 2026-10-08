import 'package:medicalarm/provider/medication_history.dart';
import 'package:medicalarm/utils/local_notification/client.dart';
import 'package:mockito/mockito.dart';

// Example:
// class FakeUser extends Mock implements User {
//   FakeUser({
// // ignore: unused_element
//     this.fakeIsPremium = false,
// // ignore: unused_element
//     this.fakeIsTrial = false,
// // ignore: unused_element
//     this.fakeTrialDeadlineDate,
// // ignore: unused_element
//     this.fakeDiscountEntitlementDeadlineDate,
// // ignore: unused_element
//     this.fakeIsExpiredDiscountEntitlements = false,
//   });
//   final DateTime? fakeTrialDeadlineDate;
//   final DateTime? fakeDiscountEntitlementDeadlineDate;
//   final bool fakeIsPremium;
//   final bool fakeIsTrial;
//   final bool fakeIsExpiredDiscountEntitlements;

//   @override
//   bool get isPremium => fakeIsPremium;
//   @override
//   bool get isTrial => fakeIsTrial;
//   @override
//   bool get hasDiscountEntitlement => fakeIsExpiredDiscountEntitlements;
//   @override
//   DateTime? get trialDeadlineDate => fakeTrialDeadlineDate;
//   @override
//   DateTime? get discountEntitlementDeadlineDate => fakeDiscountEntitlementDeadlineDate;

//   @override
//   bool get premiumOrTrial => isPremium || isTrial;
// }

class FakeMedicationHistoryTake extends Mock implements MedicationHistoryTake {}

class FakeMedicationHistoryRevert extends Mock implements MedicationHistoryRevert {}

class FakeRegisterReminderLocalNotification extends Mock implements RegisterReminderLocalNotification {}
