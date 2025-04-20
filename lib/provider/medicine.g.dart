// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeMedicinesHash() => r'315c7e74899fb23742e2942a6fcc5962c6eb40e7';

/// See also [activeMedicines].
@ProviderFor(activeMedicines)
final activeMedicinesProvider =
    AutoDisposeStreamProvider<List<Medicine>>.internal(
  activeMedicines,
  name: r'activeMedicinesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeMedicinesHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    userDatabaseProvider,
    ...?userDatabaseProvider.allTransitiveDependencies
  },
);

typedef ActiveMedicinesRef = AutoDisposeStreamProviderRef<List<Medicine>>;
String _$medicineAddHash() => r'fe3d4590db89f60df78f4df5944c9e27076c4652';

/// See also [medicineAdd].
@ProviderFor(medicineAdd)
final medicineAddProvider = AutoDisposeProvider<MedicineAdd>.internal(
  medicineAdd,
  name: r'medicineAddProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$medicineAddHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    userDatabaseProvider,
    ...?userDatabaseProvider.allTransitiveDependencies
  },
);

typedef MedicineAddRef = AutoDisposeProviderRef<MedicineAdd>;
String _$medicineUpdateHash() => r'329a6604eb930e04d81feec5806abb2edaf8f8a3';

/// See also [medicineUpdate].
@ProviderFor(medicineUpdate)
final medicineUpdateProvider = AutoDisposeProvider<MedicineUpdate>.internal(
  medicineUpdate,
  name: r'medicineUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicineUpdateHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    userDatabaseProvider,
    ...?userDatabaseProvider.allTransitiveDependencies
  },
);

typedef MedicineUpdateRef = AutoDisposeProviderRef<MedicineUpdate>;
String _$medicineDeleteHash() => r'fd5f83d72536a0410345765209fcfe9aa1b0080e';

/// See also [medicineDelete].
@ProviderFor(medicineDelete)
final medicineDeleteProvider = AutoDisposeProvider<MedicineDelete>.internal(
  medicineDelete,
  name: r'medicineDeleteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicineDeleteHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    userDatabaseProvider,
    ...?userDatabaseProvider.allTransitiveDependencies
  },
);

typedef MedicineDeleteRef = AutoDisposeProviderRef<MedicineDelete>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
