// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(medicationHistories)
final medicationHistoriesProvider = MedicationHistoriesProvider._();

final class MedicationHistoriesProvider
    extends $FunctionalProvider<AsyncValue<List<MedicationHistory>>, List<MedicationHistory>, Stream<List<MedicationHistory>>>
    with $FutureModifier<List<MedicationHistory>>, $StreamProvider<List<MedicationHistory>> {
  MedicationHistoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationHistoriesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[MedicationHistoriesProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$medicationHistoriesHash();

  @$internal
  @override
  $StreamProviderElement<List<MedicationHistory>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<MedicationHistory>> create(Ref ref) {
    return medicationHistories(ref);
  }
}

String _$medicationHistoriesHash() => r'b95c693a63b3c05deedbe86c75a2022e98d31d1b';

@ProviderFor(medicationHistoriesByDate)
final medicationHistoriesByDateProvider = MedicationHistoriesByDateFamily._();

final class MedicationHistoriesByDateProvider
    extends $FunctionalProvider<AsyncValue<List<MedicationHistory>>, List<MedicationHistory>, Stream<List<MedicationHistory>>>
    with $FutureModifier<List<MedicationHistory>>, $StreamProvider<List<MedicationHistory>> {
  MedicationHistoriesByDateProvider._({required MedicationHistoriesByDateFamily super.from, required DateTime super.argument})
    : super(retry: null, name: r'medicationHistoriesByDateProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$medicationHistoriesByDateHash();

  @override
  String toString() {
    return r'medicationHistoriesByDateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MedicationHistory>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<MedicationHistory>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return medicationHistoriesByDate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationHistoriesByDateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicationHistoriesByDateHash() => r'3556294ac88e3f365ba3d948764b547f79f7a373';

final class MedicationHistoriesByDateFamily extends $Family with $FunctionalFamilyOverride<Stream<List<MedicationHistory>>, DateTime> {
  MedicationHistoriesByDateFamily._()
    : super(
        retry: null,
        name: r'medicationHistoriesByDateProvider',
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[MedicationHistoriesByDateProvider.$allTransitiveDependencies0],
        isAutoDispose: true,
      );

  MedicationHistoriesByDateProvider call(DateTime date) => MedicationHistoriesByDateProvider._(argument: date, from: this);

  @override
  String toString() => r'medicationHistoriesByDateProvider';
}

@ProviderFor(recentMedicationHistoriesFetch)
final recentMedicationHistoriesFetchProvider = RecentMedicationHistoriesFetchProvider._();

final class RecentMedicationHistoriesFetchProvider
    extends $FunctionalProvider<RecentMedicationHistoriesFetch, RecentMedicationHistoriesFetch, RecentMedicationHistoriesFetch>
    with $Provider<RecentMedicationHistoriesFetch> {
  RecentMedicationHistoriesFetchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentMedicationHistoriesFetchProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[RecentMedicationHistoriesFetchProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$recentMedicationHistoriesFetchHash();

  @$internal
  @override
  $ProviderElement<RecentMedicationHistoriesFetch> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  RecentMedicationHistoriesFetch create(Ref ref) {
    return recentMedicationHistoriesFetch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecentMedicationHistoriesFetch value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<RecentMedicationHistoriesFetch>(value));
  }
}

String _$recentMedicationHistoriesFetchHash() => r'816b783afae6d0bd7bde5b0efc115b50f80d3e88';

@ProviderFor(medicationHistoryTake)
final medicationHistoryTakeProvider = MedicationHistoryTakeProvider._();

final class MedicationHistoryTakeProvider extends $FunctionalProvider<MedicationHistoryTake, MedicationHistoryTake, MedicationHistoryTake>
    with $Provider<MedicationHistoryTake> {
  MedicationHistoryTakeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationHistoryTakeProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          MedicationHistoryTakeProvider.$allTransitiveDependencies0,
          MedicationHistoryTakeProvider.$allTransitiveDependencies1,
          MedicationHistoryTakeProvider.$allTransitiveDependencies2,
          MedicationHistoryTakeProvider.$allTransitiveDependencies3,
          MedicationHistoryTakeProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;
  static final $allTransitiveDependencies1 = appUserIDProvider;
  static final $allTransitiveDependencies2 = AppUserIDProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 = AppUserIDProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies4 = AppUserIDProvider.$allTransitiveDependencies2;

  @override
  String debugGetCreateSourceHash() => _$medicationHistoryTakeHash();

  @$internal
  @override
  $ProviderElement<MedicationHistoryTake> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MedicationHistoryTake create(Ref ref) {
    return medicationHistoryTake(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicationHistoryTake value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MedicationHistoryTake>(value));
  }
}

String _$medicationHistoryTakeHash() => r'976567a1d7d3e441030c572a0ccf18f2657fdf25';

@ProviderFor(medicationHistoryRevert)
final medicationHistoryRevertProvider = MedicationHistoryRevertProvider._();

final class MedicationHistoryRevertProvider extends $FunctionalProvider<MedicationHistoryRevert, MedicationHistoryRevert, MedicationHistoryRevert>
    with $Provider<MedicationHistoryRevert> {
  MedicationHistoryRevertProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationHistoryRevertProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          MedicationHistoryRevertProvider.$allTransitiveDependencies0,
          MedicationHistoryRevertProvider.$allTransitiveDependencies1,
          MedicationHistoryRevertProvider.$allTransitiveDependencies2,
          MedicationHistoryRevertProvider.$allTransitiveDependencies3,
          MedicationHistoryRevertProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;
  static final $allTransitiveDependencies1 = appUserIDProvider;
  static final $allTransitiveDependencies2 = AppUserIDProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 = AppUserIDProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies4 = AppUserIDProvider.$allTransitiveDependencies2;

  @override
  String debugGetCreateSourceHash() => _$medicationHistoryRevertHash();

  @$internal
  @override
  $ProviderElement<MedicationHistoryRevert> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MedicationHistoryRevert create(Ref ref) {
    return medicationHistoryRevert(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicationHistoryRevert value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MedicationHistoryRevert>(value));
  }
}

String _$medicationHistoryRevertHash() => r'98f2dfb4f37f453972f45158882663c813026ab6';

@ProviderFor(medicationHistoryMemoUpdate)
final medicationHistoryMemoUpdateProvider = MedicationHistoryMemoUpdateProvider._();

final class MedicationHistoryMemoUpdateProvider
    extends $FunctionalProvider<MedicationHistoryMemoUpdate, MedicationHistoryMemoUpdate, MedicationHistoryMemoUpdate>
    with $Provider<MedicationHistoryMemoUpdate> {
  MedicationHistoryMemoUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationHistoryMemoUpdateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[MedicationHistoryMemoUpdateProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$medicationHistoryMemoUpdateHash();

  @$internal
  @override
  $ProviderElement<MedicationHistoryMemoUpdate> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  MedicationHistoryMemoUpdate create(Ref ref) {
    return medicationHistoryMemoUpdate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MedicationHistoryMemoUpdate value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MedicationHistoryMemoUpdate>(value));
  }
}

String _$medicationHistoryMemoUpdateHash() => r'05ea876636a609af42728f90fb2ec12dae9ce2e4';
