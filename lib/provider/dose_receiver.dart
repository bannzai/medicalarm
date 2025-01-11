import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/dose_receiver.dart';
import 'package:medicalarm/features/resolver/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dose_receiver.g.dart';

@Riverpod(dependencies: [userDatabase])
Stream<List<DoseReceiver>> doseReceivers(DoseReceiversRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return database.doseReceiversReference().snapshots().map((event) => event.docs.map((doc) => doc.data()).toList());
}

class DoseReceiverAdd {
  final UserDatabase database;

  DoseReceiverAdd({required this.database});

  Future<DoseReceiver> call({
    required String name,
  }) async {
    final collectionRef = database.doseReceiversReference();
    final docRef = collectionRef.doc();
    final doseReceiver = DoseReceiver(
      id: docRef.id,
      name: name,
    );
    await database.doseReceiversReference().add(doseReceiver);
    return doseReceiver;
  }
}

@Riverpod(dependencies: [userDatabase])
DoseReceiverAdd doseReceiverAdd(DoseReceiverAddRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return DoseReceiverAdd(database: database);
}

class DoseReceiverUpdate {
  final UserDatabase database;

  DoseReceiverUpdate({required this.database});

  Future<DoseReceiver> call({
    required DoseReceiver doseReceiver,
    required String name,
  }) async {
    final collectionRef = database.doseReceiversReference();
    final docRef = collectionRef.doc(doseReceiver.id);
    final newDoseReceiver = doseReceiver.copyWith(name: name);
    await docRef.set(newDoseReceiver, SetOptions(merge: true));
    return newDoseReceiver;
  }
}

@Riverpod(dependencies: [userDatabase])
DoseReceiverUpdate doseReceiverUpdate(DoseReceiverUpdateRef ref) {
  final database = ref.watch(userDatabaseProvider);
  return DoseReceiverUpdate(database: database);
}
