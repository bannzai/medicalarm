// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_receiver.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(doseReceivers)
final doseReceiversProvider = DoseReceiversProvider._();

final class DoseReceiversProvider extends $FunctionalProvider<AsyncValue<List<DoseReceiver>>, List<DoseReceiver>, Stream<List<DoseReceiver>>>
    with $FutureModifier<List<DoseReceiver>>, $StreamProvider<List<DoseReceiver>> {
  DoseReceiversProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doseReceiversProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[DoseReceiversProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$doseReceiversHash();

  @$internal
  @override
  $StreamProviderElement<List<DoseReceiver>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<DoseReceiver>> create(Ref ref) {
    return doseReceivers(ref);
  }
}

String _$doseReceiversHash() => r'aa01542c5e8d2c2ab18959569a7bc4cad6c25aba';

@ProviderFor(doseReceiverAdd)
final doseReceiverAddProvider = DoseReceiverAddProvider._();

final class DoseReceiverAddProvider extends $FunctionalProvider<DoseReceiverAdd, DoseReceiverAdd, DoseReceiverAdd> with $Provider<DoseReceiverAdd> {
  DoseReceiverAddProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doseReceiverAddProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          DoseReceiverAddProvider.$allTransitiveDependencies0,
          DoseReceiverAddProvider.$allTransitiveDependencies1,
          DoseReceiverAddProvider.$allTransitiveDependencies2,
          DoseReceiverAddProvider.$allTransitiveDependencies3,
          DoseReceiverAddProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;
  static final $allTransitiveDependencies1 = appUserIDProvider;
  static final $allTransitiveDependencies2 = AppUserIDProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 = AppUserIDProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies4 = AppUserIDProvider.$allTransitiveDependencies2;

  @override
  String debugGetCreateSourceHash() => _$doseReceiverAddHash();

  @$internal
  @override
  $ProviderElement<DoseReceiverAdd> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DoseReceiverAdd create(Ref ref) {
    return doseReceiverAdd(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DoseReceiverAdd value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DoseReceiverAdd>(value));
  }
}

String _$doseReceiverAddHash() => r'20bccde47267782bf9e433849b88dffb148ab673';

@ProviderFor(firstDoseReceiverAdd)
final firstDoseReceiverAddProvider = FirstDoseReceiverAddProvider._();

final class FirstDoseReceiverAddProvider extends $FunctionalProvider<FirstDoseReceiverAdd, FirstDoseReceiverAdd, FirstDoseReceiverAdd>
    with $Provider<FirstDoseReceiverAdd> {
  FirstDoseReceiverAddProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstDoseReceiverAddProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          FirstDoseReceiverAddProvider.$allTransitiveDependencies0,
          FirstDoseReceiverAddProvider.$allTransitiveDependencies1,
          FirstDoseReceiverAddProvider.$allTransitiveDependencies2,
          FirstDoseReceiverAddProvider.$allTransitiveDependencies3,
          FirstDoseReceiverAddProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;
  static final $allTransitiveDependencies1 = appUserIDProvider;
  static final $allTransitiveDependencies2 = AppUserIDProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 = AppUserIDProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies4 = AppUserIDProvider.$allTransitiveDependencies2;

  @override
  String debugGetCreateSourceHash() => _$firstDoseReceiverAddHash();

  @$internal
  @override
  $ProviderElement<FirstDoseReceiverAdd> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  FirstDoseReceiverAdd create(Ref ref) {
    return firstDoseReceiverAdd(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirstDoseReceiverAdd value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<FirstDoseReceiverAdd>(value));
  }
}

String _$firstDoseReceiverAddHash() => r'f2d3dd22c2283fd7d2e7b44674969fdc990ae3cd';

@ProviderFor(doseReceiverUpdate)
final doseReceiverUpdateProvider = DoseReceiverUpdateProvider._();

final class DoseReceiverUpdateProvider extends $FunctionalProvider<DoseReceiverUpdate, DoseReceiverUpdate, DoseReceiverUpdate>
    with $Provider<DoseReceiverUpdate> {
  DoseReceiverUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doseReceiverUpdateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[DoseReceiverUpdateProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$doseReceiverUpdateHash();

  @$internal
  @override
  $ProviderElement<DoseReceiverUpdate> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DoseReceiverUpdate create(Ref ref) {
    return doseReceiverUpdate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DoseReceiverUpdate value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DoseReceiverUpdate>(value));
  }
}

String _$doseReceiverUpdateHash() => r'96d0ca51b3d5f7fa18886d6bbc1ffae7cc2333ac';
