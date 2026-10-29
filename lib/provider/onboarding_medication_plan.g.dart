// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_medication_plan.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アーカイブ済みを含め、薬が登録されたことを検知する。

@ProviderFor(hasRegisteredMedicines)
final hasRegisteredMedicinesProvider = HasRegisteredMedicinesProvider._();

/// アーカイブ済みを含め、薬が登録されたことを検知する。

final class HasRegisteredMedicinesProvider extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// アーカイブ済みを含め、薬が登録されたことを検知する。
  HasRegisteredMedicinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasRegisteredMedicinesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[HasRegisteredMedicinesProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$hasRegisteredMedicinesHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return hasRegisteredMedicines(ref);
  }
}

String _$hasRegisteredMedicinesHash() => r'3ede91041b29267c59d0b095f678c453b01f624e';

/// アカウントとグループを境界に仮設定の保存・解除を管理する。

@ProviderFor(OnboardingMedicationPlanStore)
final onboardingMedicationPlanStoreProvider = OnboardingMedicationPlanStoreFamily._();

/// アカウントとグループを境界に仮設定の保存・解除を管理する。
final class OnboardingMedicationPlanStoreProvider extends $NotifierProvider<OnboardingMedicationPlanStore, OnboardingMedicationPlan?> {
  /// アカウントとグループを境界に仮設定の保存・解除を管理する。
  OnboardingMedicationPlanStoreProvider._({
    required OnboardingMedicationPlanStoreFamily super.from,
    required ({String userID, String groupID}) super.argument,
  }) : super(retry: null, name: r'onboardingMedicationPlanStoreProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  static final $allTransitiveDependencies0 = sharedPreferencesProvider;

  @override
  String debugGetCreateSourceHash() => _$onboardingMedicationPlanStoreHash();

  @override
  String toString() {
    return r'onboardingMedicationPlanStoreProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  OnboardingMedicationPlanStore create() => OnboardingMedicationPlanStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingMedicationPlan? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<OnboardingMedicationPlan?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is OnboardingMedicationPlanStoreProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$onboardingMedicationPlanStoreHash() => r'1ede60d2d5acfdab44dd6fe0df18510d8a7248a9';

/// アカウントとグループを境界に仮設定の保存・解除を管理する。

final class OnboardingMedicationPlanStoreFamily extends $Family
    with
        $ClassFamilyOverride<
          OnboardingMedicationPlanStore,
          OnboardingMedicationPlan?,
          OnboardingMedicationPlan?,
          OnboardingMedicationPlan?,
          ({String userID, String groupID})
        > {
  OnboardingMedicationPlanStoreFamily._()
    : super(
        retry: null,
        name: r'onboardingMedicationPlanStoreProvider',
        dependencies: <ProviderOrFamily>[sharedPreferencesProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[OnboardingMedicationPlanStoreProvider.$allTransitiveDependencies0],
        isAutoDispose: false,
      );

  /// アカウントとグループを境界に仮設定の保存・解除を管理する。

  OnboardingMedicationPlanStoreProvider call({required String userID, required String groupID}) =>
      OnboardingMedicationPlanStoreProvider._(argument: (userID: userID, groupID: groupID), from: this);

  @override
  String toString() => r'onboardingMedicationPlanStoreProvider';
}

/// アカウントとグループを境界に仮設定の保存・解除を管理する。

abstract class _$OnboardingMedicationPlanStore extends $Notifier<OnboardingMedicationPlan?> {
  late final _$args = ref.$arg as ({String userID, String groupID});
  String get userID => _$args.userID;
  String get groupID => _$args.groupID;

  OnboardingMedicationPlan? build({required String userID, required String groupID});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OnboardingMedicationPlan?, OnboardingMedicationPlan?>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<OnboardingMedicationPlan?, OnboardingMedicationPlan?>, OnboardingMedicationPlan?, Object?, Object?>;
    return element.handleCreate(ref, () => build(userID: _$args.userID, groupID: _$args.groupID));
  }
}
