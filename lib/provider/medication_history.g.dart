// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medicationHistoriesHash() => r'338ece3194d2e01ae05cfc105daa688834ecab0a';

/// See also [medicationHistories].
@ProviderFor(medicationHistories)
final medicationHistoriesProvider = AutoDisposeStreamProvider<List<MedicationHistory>>.internal(
  medicationHistories,
  name: r'medicationHistoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoriesHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{userDatabaseProvider, ...?userDatabaseProvider.allTransitiveDependencies},
);

typedef MedicationHistoriesRef = AutoDisposeStreamProviderRef<List<MedicationHistory>>;
String _$medicationHistoriesByDateHash() => r'c893ab970a22ef6b19bbed7b0cc909a2a732d1d4';

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

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[userDatabaseProvider];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies = <ProviderOrFamily>{
    userDatabaseProvider,
    ...?userDatabaseProvider.allTransitiveDependencies
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

mixin MedicationHistoriesByDateRef on AutoDisposeStreamProviderRef<List<MedicationHistory>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _MedicationHistoriesByDateProviderElement extends AutoDisposeStreamProviderElement<List<MedicationHistory>> with MedicationHistoriesByDateRef {
  _MedicationHistoriesByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as MedicationHistoriesByDateProvider).date;
}

String _$medicationHistoriesByDateRangeHash() => r'9ce446becc31a9466aee2f17023bfd0888aaecb4';

/// See also [medicationHistoriesByDateRange].
@ProviderFor(medicationHistoriesByDateRange)
const medicationHistoriesByDateRangeProvider = MedicationHistoriesByDateRangeFamily();

/// See also [medicationHistoriesByDateRange].
class MedicationHistoriesByDateRangeFamily extends Family<AsyncValue<List<MedicationHistory>>> {
  /// See also [medicationHistoriesByDateRange].
  const MedicationHistoriesByDateRangeFamily();

  /// See also [medicationHistoriesByDateRange].
  MedicationHistoriesByDateRangeProvider call(
    DateTimeRange dateRange,
  ) {
    return MedicationHistoriesByDateRangeProvider(
      dateRange,
    );
  }

  @override
  MedicationHistoriesByDateRangeProvider getProviderOverride(
    covariant MedicationHistoriesByDateRangeProvider provider,
  ) {
    return call(
      provider.dateRange,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[userDatabaseProvider];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies = <ProviderOrFamily>{
    userDatabaseProvider,
    ...?userDatabaseProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'medicationHistoriesByDateRangeProvider';
}

/// See also [medicationHistoriesByDateRange].
class MedicationHistoriesByDateRangeProvider extends AutoDisposeStreamProvider<List<MedicationHistory>> {
  /// See also [medicationHistoriesByDateRange].
  MedicationHistoriesByDateRangeProvider(
    DateTimeRange dateRange,
  ) : this._internal(
          (ref) => medicationHistoriesByDateRange(
            ref as MedicationHistoriesByDateRangeRef,
            dateRange,
          ),
          from: medicationHistoriesByDateRangeProvider,
          name: r'medicationHistoriesByDateRangeProvider',
          debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoriesByDateRangeHash,
          dependencies: MedicationHistoriesByDateRangeFamily._dependencies,
          allTransitiveDependencies: MedicationHistoriesByDateRangeFamily._allTransitiveDependencies,
          dateRange: dateRange,
        );

  MedicationHistoriesByDateRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dateRange,
  }) : super.internal();

  final DateTimeRange dateRange;

  @override
  Override overrideWith(
    Stream<List<MedicationHistory>> Function(MedicationHistoriesByDateRangeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MedicationHistoriesByDateRangeProvider._internal(
        (ref) => create(ref as MedicationHistoriesByDateRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dateRange: dateRange,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MedicationHistory>> createElement() {
    return _MedicationHistoriesByDateRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationHistoriesByDateRangeProvider && other.dateRange == dateRange;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dateRange.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MedicationHistoriesByDateRangeRef on AutoDisposeStreamProviderRef<List<MedicationHistory>> {
  /// The parameter `dateRange` of this provider.
  DateTimeRange get dateRange;
}

class _MedicationHistoriesByDateRangeProviderElement extends AutoDisposeStreamProviderElement<List<MedicationHistory>>
    with MedicationHistoriesByDateRangeRef {
  _MedicationHistoriesByDateRangeProviderElement(super.provider);

  @override
  DateTimeRange get dateRange => (origin as MedicationHistoriesByDateRangeProvider).dateRange;
}

String _$medicationHistoryTakeHash() => r'1875448b498368c05b7c415da62bcf0ca7a7a7a1';

/// See also [medicationHistoryTake].
@ProviderFor(medicationHistoryTake)
final medicationHistoryTakeProvider = AutoDisposeProvider<MedicationHistoryTake>.internal(
  medicationHistoryTake,
  name: r'medicationHistoryTakeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoryTakeHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{userDatabaseProvider, ...?userDatabaseProvider.allTransitiveDependencies},
);

typedef MedicationHistoryTakeRef = AutoDisposeProviderRef<MedicationHistoryTake>;
String _$medicationHistoryDeleteHash() => r'd25eda5bb38097e3a1d3efad69fc21e23ae2f900';

/// See also [medicationHistoryDelete].
@ProviderFor(medicationHistoryDelete)
final medicationHistoryDeleteProvider = AutoDisposeProvider<MedicationHistoryDelete>.internal(
  medicationHistoryDelete,
  name: r'medicationHistoryDeleteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoryDeleteHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{userDatabaseProvider, ...?userDatabaseProvider.allTransitiveDependencies},
);

typedef MedicationHistoryDeleteRef = AutoDisposeProviderRef<MedicationHistoryDelete>;
String _$medicationHistoryMemoUpdateHash() => r'd21f6cce07538559bad771235fcec4a45e7c92ce';

/// See also [medicationHistoryMemoUpdate].
@ProviderFor(medicationHistoryMemoUpdate)
final medicationHistoryMemoUpdateProvider = AutoDisposeProvider<MedicationHistoryMemoUpdate>.internal(
  medicationHistoryMemoUpdate,
  name: r'medicationHistoryMemoUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$medicationHistoryMemoUpdateHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{userDatabaseProvider, ...?userDatabaseProvider.allTransitiveDependencies},
);

typedef MedicationHistoryMemoUpdateRef = AutoDisposeProviderRef<MedicationHistoryMemoUpdate>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
