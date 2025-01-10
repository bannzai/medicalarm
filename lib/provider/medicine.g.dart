// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medicinesHash() => r'ef417556b761f4645c552a628096cf4fead1e57a';

/// See also [medicines].
@ProviderFor(medicines)
final medicinesProvider = AutoDisposeStreamProvider<Medicine>.internal(
  medicines,
  name: r'medicinesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicinesHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{userDatabaseProvider, ...?userDatabaseProvider.allTransitiveDependencies},
);

typedef MedicinesRef = AutoDisposeStreamProviderRef<Medicine>;
String _$medicineAddHash() => r'fe3d4590db89f60df78f4df5944c9e27076c4652';

/// See also [medicineAdd].
@ProviderFor(medicineAdd)
final medicineAddProvider = AutoDisposeProvider<MedicineAdd>.internal(
  medicineAdd,
  name: r'medicineAddProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicineAddHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{userDatabaseProvider, ...?userDatabaseProvider.allTransitiveDependencies},
);

typedef MedicineAddRef = AutoDisposeProviderRef<MedicineAdd>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
