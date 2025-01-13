import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'medication_history.g.dart';

@Riverpod(dependencies: [userDatabase])
Stream<List<MedicationHistory>> medicationHistories(MedicationHistoriesRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return database.medicationHistoriesReference().snapshots().map((event) => event.docs.map((doc) => doc.data()).toList());
}
