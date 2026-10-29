// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_request.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(featureRequestSubmit)
final featureRequestSubmitProvider = FeatureRequestSubmitProvider._();

final class FeatureRequestSubmitProvider extends $FunctionalProvider<FeatureRequestSubmit, FeatureRequestSubmit, FeatureRequestSubmit>
    with $Provider<FeatureRequestSubmit> {
  FeatureRequestSubmitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureRequestSubmitProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$featureRequestSubmitHash();

  @$internal
  @override
  $ProviderElement<FeatureRequestSubmit> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  FeatureRequestSubmit create(Ref ref) {
    return featureRequestSubmit(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeatureRequestSubmit value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<FeatureRequestSubmit>(value));
  }
}

String _$featureRequestSubmitHash() => r'107c224848f86a344b481b9fc81cb5547ba8dad6';
