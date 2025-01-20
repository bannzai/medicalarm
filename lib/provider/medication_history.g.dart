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
String _$medicationHistoriesByDateHash() => r'95e06b8fe65d359eb88b08ab12e79f46cc327077';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
