// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$diariesForDateTimeRangeHash() => r'2727aaaf807f0aa8132fd9a35ba90a6815860e1e';

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

/// See also [diariesForDateTimeRange].
@ProviderFor(diariesForDateTimeRange)
const diariesForDateTimeRangeProvider = DiariesForDateTimeRangeFamily();

/// See also [diariesForDateTimeRange].
class DiariesForDateTimeRangeFamily extends Family<AsyncValue<List<Diary>>> {
  /// See also [diariesForDateTimeRange].
  const DiariesForDateTimeRangeFamily();

  /// See also [diariesForDateTimeRange].
  DiariesForDateTimeRangeProvider call({
    required DateTimeRange dateTimeRange,
  }) {
    return DiariesForDateTimeRangeProvider(
      dateTimeRange: dateTimeRange,
    );
  }

  @override
  DiariesForDateTimeRangeProvider getProviderOverride(
    covariant DiariesForDateTimeRangeProvider provider,
  ) {
    return call(
      dateTimeRange: provider.dateTimeRange,
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
  String? get name => r'diariesForDateTimeRangeProvider';
}

/// See also [diariesForDateTimeRange].
class DiariesForDateTimeRangeProvider extends AutoDisposeStreamProvider<List<Diary>> {
  /// See also [diariesForDateTimeRange].
  DiariesForDateTimeRangeProvider({
    required DateTimeRange dateTimeRange,
  }) : this._internal(
          (ref) => diariesForDateTimeRange(
            ref as DiariesForDateTimeRangeRef,
            dateTimeRange: dateTimeRange,
          ),
          from: diariesForDateTimeRangeProvider,
          name: r'diariesForDateTimeRangeProvider',
          debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$diariesForDateTimeRangeHash,
          dependencies: DiariesForDateTimeRangeFamily._dependencies,
          allTransitiveDependencies: DiariesForDateTimeRangeFamily._allTransitiveDependencies,
          dateTimeRange: dateTimeRange,
        );

  DiariesForDateTimeRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dateTimeRange,
  }) : super.internal();

  final DateTimeRange dateTimeRange;

  @override
  Override overrideWith(
    Stream<List<Diary>> Function(DiariesForDateTimeRangeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DiariesForDateTimeRangeProvider._internal(
        (ref) => create(ref as DiariesForDateTimeRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dateTimeRange: dateTimeRange,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Diary>> createElement() {
    return _DiariesForDateTimeRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DiariesForDateTimeRangeProvider && other.dateTimeRange == dateTimeRange;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dateTimeRange.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DiariesForDateTimeRangeRef on AutoDisposeStreamProviderRef<List<Diary>> {
  /// The parameter `dateTimeRange` of this provider.
  DateTimeRange get dateTimeRange;
}

class _DiariesForDateTimeRangeProviderElement extends AutoDisposeStreamProviderElement<List<Diary>> with DiariesForDateTimeRangeRef {
  _DiariesForDateTimeRangeProviderElement(super.provider);

  @override
  DateTimeRange get dateTimeRange => (origin as DiariesForDateTimeRangeProvider).dateTimeRange;
}

String _$diaryPostHash() => r'3d0c5e4ddfeb0151c2573816a58253af9ebe136a';

/// See also [diaryPost].
@ProviderFor(diaryPost)
final diaryPostProvider = AutoDisposeProvider<DiaryPost>.internal(
  diaryPost,
  name: r'diaryPostProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$diaryPostHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{userDatabaseProvider, ...?userDatabaseProvider.allTransitiveDependencies},
);

typedef DiaryPostRef = AutoDisposeProviderRef<DiaryPost>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
