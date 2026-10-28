// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_promotion.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(startPromotion)
final startPromotionProvider = StartPromotionProvider._();

final class StartPromotionProvider extends $FunctionalProvider<StartPromotion, StartPromotion, StartPromotion> with $Provider<StartPromotion> {
  StartPromotionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startPromotionProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$startPromotionHash();

  @$internal
  @override
  $ProviderElement<StartPromotion> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  StartPromotion create(Ref ref) {
    return startPromotion(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StartPromotion value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<StartPromotion>(value));
  }
}

String _$startPromotionHash() => r'bf2ba7d8fb560d284f11f181956ea97e3e72f71d';
