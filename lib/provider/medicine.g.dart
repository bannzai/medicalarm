// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeMedicines)
final activeMedicinesProvider = ActiveMedicinesProvider._();

final class ActiveMedicinesProvider extends $FunctionalProvider<AsyncValue<List<Medicine>>, List<Medicine>, Stream<List<Medicine>>>
    with $FutureModifier<List<Medicine>>, $StreamProvider<List<Medicine>> {
  ActiveMedicinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMedicinesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[ActiveMedicinesProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$activeMedicinesHash();

  @$internal
  @override
  $StreamProviderElement<List<Medicine>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Medicine>> create(Ref ref) {
    return activeMedicines(ref);
  }
}

String _$activeMedicinesHash() => r'0dac1fd14589cfc64f11f5b9b1c53129b62ac972';

@ProviderFor(medicineAdd)
final medicineAddProvider = MedicineAddProvider._();

final class MedicineAddProvider extends $FunctionalProvider<MedicineAdd, MedicineAdd, MedicineAdd> with $Provider<MedicineAdd> {
  MedicineAddProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineAddProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider, onboardingMedicationPlanStoreProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          MedicineAddProvider.$allTransitiveDependencies0,
          MedicineAddProvider.$allTransitiveDependencies1,
          MedicineAddProvider.$allTransitiveDependencies2,
          MedicineAddProvider.$allTransitiveDependencies3,
          MedicineAddProvider.$allTransitiveDependencies4,
          MedicineAddProvider.$allTransitiveDependencies5,
          MedicineAddProvider.$allTransitiveDependencies6,
        },
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;
  static final $allTransitiveDependencies1 = appUserIDProvider;
  static final $allTransitiveDependencies2 = AppUserIDProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 = AppUserIDProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies4 = AppUserIDProvider.$allTransitiveDependencies2;
  static final $allTransitiveDependencies5 = onboardingMedicationPlanStoreProvider;
  static final $allTransitiveDependencies6 = OnboardingMedicationPlanStoreProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$medicineAddHash();

  @$internal
  @override
  $ProviderElement<MedicineAdd> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MedicineAdd create(Ref ref) {
    return medicineAdd(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicineAdd value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MedicineAdd>(value));
  }
}

String _$medicineAddHash() => r'c7ef3a6187fd8a6160908fd4720cb270fef9abb9';

@ProviderFor(medicineUpdate)
final medicineUpdateProvider = MedicineUpdateProvider._();

final class MedicineUpdateProvider extends $FunctionalProvider<MedicineUpdate, MedicineUpdate, MedicineUpdate> with $Provider<MedicineUpdate> {
  MedicineUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineUpdateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[MedicineUpdateProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$medicineUpdateHash();

  @$internal
  @override
  $ProviderElement<MedicineUpdate> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MedicineUpdate create(Ref ref) {
    return medicineUpdate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicineUpdate value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MedicineUpdate>(value));
  }
}

String _$medicineUpdateHash() => r'ea5f68309c01d3ef11f6aa02a8e071e139a09f05';

@ProviderFor(medicineDelete)
final medicineDeleteProvider = MedicineDeleteProvider._();

final class MedicineDeleteProvider extends $FunctionalProvider<MedicineDelete, MedicineDelete, MedicineDelete> with $Provider<MedicineDelete> {
  MedicineDeleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineDeleteProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[MedicineDeleteProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$medicineDeleteHash();

  @$internal
  @override
  $ProviderElement<MedicineDelete> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MedicineDelete create(Ref ref) {
    return medicineDelete(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicineDelete value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MedicineDelete>(value));
  }
}

String _$medicineDeleteHash() => r'bfb75bd7d014526fde3f4c3b190fcf4854043163';

@ProviderFor(medicineSetPaused)
final medicineSetPausedProvider = MedicineSetPausedProvider._();

final class MedicineSetPausedProvider extends $FunctionalProvider<MedicineSetPaused, MedicineSetPaused, MedicineSetPaused>
    with $Provider<MedicineSetPaused> {
  MedicineSetPausedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicineSetPausedProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[MedicineSetPausedProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$medicineSetPausedHash();

  @$internal
  @override
  $ProviderElement<MedicineSetPaused> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MedicineSetPaused create(Ref ref) {
    return medicineSetPaused(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicineSetPaused value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MedicineSetPaused>(value));
  }
}

String _$medicineSetPausedHash() => r'9466f4a295e9605e69c4230e8c823537593a624e';
