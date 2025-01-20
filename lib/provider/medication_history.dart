import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:medicalarm/utils/date_time/date_time_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medication_history.g.dart';

@Riverpod(dependencies: [userDatabase])
Stream<List<MedicationHistory>> medicationHistories(MedicationHistoriesRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return database.medicationHistoriesReference().snapshots().map((event) => event.docs.map((doc) => doc.data()).toList());
}

@Riverpod(dependencies: [userDatabase])
Stream<List<MedicationHistory>> medicationHistoriesByDate(MedicationHistoriesRef ref, DateTime date) {
  final database = ref.watch(userDatabaseProvider);
  return database
      .medicationHistoriesReference()
      .where(
        'recordDateTime',
        isGreaterThanOrEqualTo: date.date(),
        isLessThanOrEqualTo: date.date().add(const Duration(days: 1)),
      )
      .snapshots()
      .map((event) => event.docs.map((doc) => doc.data()).toList());
}
