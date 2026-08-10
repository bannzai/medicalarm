// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medicationHistoriesHash() => r'5e9765b4b3b4409d5a148413658a8fd393ed6986';

/// See also [medicationHistories].
@ProviderFor(medicationHistories)
final medicationHistoriesProvider = AutoDisposeStreamProvider<List<MedicationHistory>>.internal(
  medicationHistories,
  name: r'medicationHistoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoriesHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicationHistoriesRef = AutoDisposeStreamProviderRef<List<MedicationHistory>>;
String _$medicationHistoriesByDateHash() => r'17562d970bdc529035aa77d51aea754bee47a4a8';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [medicationHistoriesByDate].
@ProviderFor(medicationHistoriesByDate)
const medicationHistoriesByDateProvider = MedicationHistoriesByDateFamily();

/// See also [medicationHistoriesByDate].
class MedicationHistoriesByDateFamily extends Family<AsyncValue<List<MedicationHistory>>> {
  /// See also [medicationHistoriesByDate].
  const MedicationHistoriesByDateFamily();

  /// See also [medicationHistoriesByDate].
  MedicationHistoriesByDateProvider call(
    DateTime date,
  ) {
    return MedicationHistoriesByDateProvider(
      date,
    );
  }

  @override
  MedicationHistoriesByDateProvider getProviderOverride(
    covariant MedicationHistoriesByDateProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[currentGroupDatabaseProvider];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies = <ProviderOrFamily>{
    currentGroupDatabaseProvider,
    ...?currentGroupDatabaseProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'medicationHistoriesByDateProvider';
}

/// See also [medicationHistoriesByDate].
class MedicationHistoriesByDateProvider extends AutoDisposeStreamProvider<List<MedicationHistory>> {
  /// See also [medicationHistoriesByDate].
  MedicationHistoriesByDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => medicationHistoriesByDate(
            ref as MedicationHistoriesByDateRef,
            date,
          ),
          from: medicationHistoriesByDateProvider,
          name: r'medicationHistoriesByDateProvider',
          debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoriesByDateHash,
          dependencies: MedicationHistoriesByDateFamily._dependencies,
          allTransitiveDependencies: MedicationHistoriesByDateFamily._allTransitiveDependencies,
          date: date,
        );

  MedicationHistoriesByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<MedicationHistory>> Function(MedicationHistoriesByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MedicationHistoriesByDateProvider._internal(
        (ref) => create(ref as MedicationHistoriesByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MedicationHistory>> createElement() {
    return _MedicationHistoriesByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationHistoriesByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MedicationHistoriesByDateRef on AutoDisposeStreamProviderRef<List<MedicationHistory>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _MedicationHistoriesByDateProviderElement extends AutoDisposeStreamProviderElement<List<MedicationHistory>> with MedicationHistoriesByDateRef {
  _MedicationHistoriesByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as MedicationHistoriesByDateProvider).date;
}

String _$recentMedicationHistoriesFetchHash() => r'b00de1e6cdca7d7a3ba9662f5a00fef31f6a40b3';

/// See also [recentMedicationHistoriesFetch].
@ProviderFor(recentMedicationHistoriesFetch)
final recentMedicationHistoriesFetchProvider = AutoDisposeProvider<RecentMedicationHistoriesFetch>.internal(
  recentMedicationHistoriesFetch,
  name: r'recentMedicationHistoriesFetchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$recentMedicationHistoriesFetchHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentMedicationHistoriesFetchRef = AutoDisposeProviderRef<RecentMedicationHistoriesFetch>;
String _$medicationHistoryTakeHash() => r'ada635b681520377dfddf2c595dd910346c5d406';

/// See also [medicationHistoryTake].
@ProviderFor(medicationHistoryTake)
final medicationHistoryTakeProvider = AutoDisposeProvider<MedicationHistoryTake>.internal(
  medicationHistoryTake,
  name: r'medicationHistoryTakeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoryTakeHash,
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
typedef MedicationHistoryTakeRef = AutoDisposeProviderRef<MedicationHistoryTake>;
String _$medicationHistoryRevertHash() => r'6a5e8d3043d28bd3fb9733fc6fb8aa09e5a4d48c';

/// See also [medicationHistoryRevert].
@ProviderFor(medicationHistoryRevert)
final medicationHistoryRevertProvider = AutoDisposeProvider<MedicationHistoryRevert>.internal(
  medicationHistoryRevert,
  name: r'medicationHistoryRevertProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoryRevertHash,
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
typedef MedicationHistoryRevertRef = AutoDisposeProviderRef<MedicationHistoryRevert>;
String _$medicationHistoryUndoRevertHash() => r'4828f6f0d2bf42c57668c1b848a5e70d20679742';

/// See also [medicationHistoryUndoRevert].
@ProviderFor(medicationHistoryUndoRevert)
final medicationHistoryUndoRevertProvider = AutoDisposeProvider<MedicationHistoryUndoRevert>.internal(
  medicationHistoryUndoRevert,
  name: r'medicationHistoryUndoRevertProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoryUndoRevertHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicationHistoryUndoRevertRef = AutoDisposeProviderRef<MedicationHistoryUndoRevert>;
String _$medicationHistoryMemoUpdateHash() => r'0c32208f61f5215d1ed56b415717aec94bbb3509';

/// See also [medicationHistoryMemoUpdate].
@ProviderFor(medicationHistoryMemoUpdate)
final medicationHistoryMemoUpdateProvider = AutoDisposeProvider<MedicationHistoryMemoUpdate>.internal(
  medicationHistoryMemoUpdate,
  name: r'medicationHistoryMemoUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoryMemoUpdateHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicationHistoryMemoUpdateRef = AutoDisposeProviderRef<MedicationHistoryMemoUpdate>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
