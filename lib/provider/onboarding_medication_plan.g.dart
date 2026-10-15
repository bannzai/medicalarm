// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_medication_plan.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasRegisteredMedicinesHash() => r'3ede91041b29267c59d0b095f678c453b01f624e';

/// アーカイブ済みを含め、薬が登録されたことを検知する。
///
/// Copied from [hasRegisteredMedicines].
@ProviderFor(hasRegisteredMedicines)
final hasRegisteredMedicinesProvider = AutoDisposeStreamProvider<bool>.internal(
  hasRegisteredMedicines,
  name: r'hasRegisteredMedicinesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$hasRegisteredMedicinesHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{currentGroupDatabaseProvider, ...?currentGroupDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasRegisteredMedicinesRef = AutoDisposeStreamProviderRef<bool>;
String _$onboardingMedicationPlanStoreHash() => r'1ede60d2d5acfdab44dd6fe0df18510d8a7248a9';

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

abstract class _$OnboardingMedicationPlanStore extends BuildlessNotifier<OnboardingMedicationPlan?> {
  late final String userID;
  late final String groupID;

  OnboardingMedicationPlan? build({
    required String userID,
    required String groupID,
  });
}

/// アカウントとグループを境界に仮設定の保存・解除を管理する。
///
/// Copied from [OnboardingMedicationPlanStore].
@ProviderFor(OnboardingMedicationPlanStore)
const onboardingMedicationPlanStoreProvider = OnboardingMedicationPlanStoreFamily();

/// アカウントとグループを境界に仮設定の保存・解除を管理する。
///
/// Copied from [OnboardingMedicationPlanStore].
class OnboardingMedicationPlanStoreFamily extends Family<OnboardingMedicationPlan?> {
  /// アカウントとグループを境界に仮設定の保存・解除を管理する。
  ///
  /// Copied from [OnboardingMedicationPlanStore].
  const OnboardingMedicationPlanStoreFamily();

  /// アカウントとグループを境界に仮設定の保存・解除を管理する。
  ///
  /// Copied from [OnboardingMedicationPlanStore].
  OnboardingMedicationPlanStoreProvider call({
    required String userID,
    required String groupID,
  }) {
    return OnboardingMedicationPlanStoreProvider(
      userID: userID,
      groupID: groupID,
    );
  }

  @override
  OnboardingMedicationPlanStoreProvider getProviderOverride(
    covariant OnboardingMedicationPlanStoreProvider provider,
  ) {
    return call(
      userID: provider.userID,
      groupID: provider.groupID,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[sharedPreferencesProvider];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies = <ProviderOrFamily>{
    sharedPreferencesProvider,
    ...?sharedPreferencesProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'onboardingMedicationPlanStoreProvider';
}

/// アカウントとグループを境界に仮設定の保存・解除を管理する。
///
/// Copied from [OnboardingMedicationPlanStore].
class OnboardingMedicationPlanStoreProvider extends NotifierProviderImpl<OnboardingMedicationPlanStore, OnboardingMedicationPlan?> {
  /// アカウントとグループを境界に仮設定の保存・解除を管理する。
  ///
  /// Copied from [OnboardingMedicationPlanStore].
  OnboardingMedicationPlanStoreProvider({
    required String userID,
    required String groupID,
  }) : this._internal(
          () => OnboardingMedicationPlanStore()
            ..userID = userID
            ..groupID = groupID,
          from: onboardingMedicationPlanStoreProvider,
          name: r'onboardingMedicationPlanStoreProvider',
          debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$onboardingMedicationPlanStoreHash,
          dependencies: OnboardingMedicationPlanStoreFamily._dependencies,
          allTransitiveDependencies: OnboardingMedicationPlanStoreFamily._allTransitiveDependencies,
          userID: userID,
          groupID: groupID,
        );

  OnboardingMedicationPlanStoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userID,
    required this.groupID,
  }) : super.internal();

  final String userID;
  final String groupID;

  @override
  OnboardingMedicationPlan? runNotifierBuild(
    covariant OnboardingMedicationPlanStore notifier,
  ) {
    return notifier.build(
      userID: userID,
      groupID: groupID,
    );
  }

  @override
  Override overrideWith(OnboardingMedicationPlanStore Function() create) {
    return ProviderOverride(
      origin: this,
      override: OnboardingMedicationPlanStoreProvider._internal(
        () => create()
          ..userID = userID
          ..groupID = groupID,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userID: userID,
        groupID: groupID,
      ),
    );
  }

  @override
  NotifierProviderElement<OnboardingMedicationPlanStore, OnboardingMedicationPlan?> createElement() {
    return _OnboardingMedicationPlanStoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OnboardingMedicationPlanStoreProvider && other.userID == userID && other.groupID == groupID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userID.hashCode);
    hash = _SystemHash.combine(hash, groupID.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OnboardingMedicationPlanStoreRef on NotifierProviderRef<OnboardingMedicationPlan?> {
  /// The parameter `userID` of this provider.
  String get userID;

  /// The parameter `groupID` of this provider.
  String get groupID;
}

class _OnboardingMedicationPlanStoreProviderElement extends NotifierProviderElement<OnboardingMedicationPlanStore, OnboardingMedicationPlan?>
    with OnboardingMedicationPlanStoreRef {
  _OnboardingMedicationPlanStoreProviderElement(super.provider);

  @override
  String get userID => (origin as OnboardingMedicationPlanStoreProvider).userID;
  @override
  String get groupID => (origin as OnboardingMedicationPlanStoreProvider).groupID;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
