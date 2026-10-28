// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(onboardingComplete)
final onboardingCompleteProvider = OnboardingCompleteProvider._();

final class OnboardingCompleteProvider extends $FunctionalProvider<OnboardingComplete, OnboardingComplete, OnboardingComplete>
    with $Provider<OnboardingComplete> {
  OnboardingCompleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingCompleteProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[userDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          OnboardingCompleteProvider.$allTransitiveDependencies0,
          OnboardingCompleteProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = userDatabaseProvider;
  static final $allTransitiveDependencies1 = UserDatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$onboardingCompleteHash();

  @$internal
  @override
  $ProviderElement<OnboardingComplete> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  OnboardingComplete create(Ref ref) {
    return onboardingComplete(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingComplete value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<OnboardingComplete>(value));
  }
}

String _$onboardingCompleteHash() => r'04e22bd966b081d502b4331a82adf8481765c22e';
