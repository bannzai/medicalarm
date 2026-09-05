// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeMedicinesHash() => r'8c00733aff10b2503a1be7007a69a9148670fd79';

/// See also [activeMedicines].
@ProviderFor(activeMedicines)
final activeMedicinesProvider = AutoDisposeStreamProvider<List<Medicine>>.internal(
  activeMedicines,
  name: r'activeMedicinesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$activeMedicinesHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveMedicinesRef = AutoDisposeStreamProviderRef<List<Medicine>>;
String _$allMedicinesHash() => r'f2140ce224f138abc290c7a1a32d873aa3e342b5';

/// アーカイブ済みも含む薬の全件 (#278)。
/// 過去日の達成集計は、その日に予定されていた薬がその後アーカイブされていても予定として数える必要があるため、
/// [activeMedicines] と違い archivedDateTime でフィルタしない
///
/// Copied from [allMedicines].
@ProviderFor(allMedicines)
final allMedicinesProvider = AutoDisposeStreamProvider<List<Medicine>>.internal(
  allMedicines,
  name: r'allMedicinesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$allMedicinesHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllMedicinesRef = AutoDisposeStreamProviderRef<List<Medicine>>;
String _$medicineAddHash() => r'adc9e6b19acfe85d2b2ef5c70f2c6a2ab483c341';

/// See also [medicineAdd].
@ProviderFor(medicineAdd)
final medicineAddProvider = AutoDisposeProvider<MedicineAdd>.internal(
  medicineAdd,
  name: r'medicineAddProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicineAddHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    currentGroupDatabaseProvider,
    ...?currentGroupDatabaseProvider.allTransitiveDependencies,
    appUserIDProvider,
    ...?appUserIDProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicineAddRef = AutoDisposeProviderRef<MedicineAdd>;
String _$medicineUpdateHash() => r'ea5f68309c01d3ef11f6aa02a8e071e139a09f05';

/// See also [medicineUpdate].
@ProviderFor(medicineUpdate)
final medicineUpdateProvider = AutoDisposeProvider<MedicineUpdate>.internal(
  medicineUpdate,
  name: r'medicineUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicineUpdateHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicineUpdateRef = AutoDisposeProviderRef<MedicineUpdate>;
String _$medicineDeleteHash() => r'bfb75bd7d014526fde3f4c3b190fcf4854043163';

/// See also [medicineDelete].
@ProviderFor(medicineDelete)
final medicineDeleteProvider = AutoDisposeProvider<MedicineDelete>.internal(
  medicineDelete,
  name: r'medicineDeleteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicineDeleteHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicineDeleteRef = AutoDisposeProviderRef<MedicineDelete>;
String _$medicineSetPausedHash() => r'9466f4a295e9605e69c4230e8c823537593a624e';

/// See also [medicineSetPaused].
@ProviderFor(medicineSetPaused)
final medicineSetPausedProvider = AutoDisposeProvider<MedicineSetPaused>.internal(
  medicineSetPaused,
  name: r'medicineSetPausedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicineSetPausedHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicineSetPausedRef = AutoDisposeProviderRef<MedicineSetPaused>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
