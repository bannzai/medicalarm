// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerInfo)
final customerInfoProvider = CustomerInfoProvider._();

final class CustomerInfoProvider extends $FunctionalProvider<AsyncValue<CustomerInfo>, CustomerInfo, Stream<CustomerInfo>>
    with $FutureModifier<CustomerInfo>, $StreamProvider<CustomerInfo> {
  CustomerInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerInfoProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$customerInfoHash();

  @$internal
  @override
  $StreamProviderElement<CustomerInfo> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<CustomerInfo> create(Ref ref) {
    return customerInfo(ref);
  }
}

String _$customerInfoHash() => r'95362491215a91d0faca817d94b175846b87e9b3';

@ProviderFor(offerings)
final offeringsProvider = OfferingsProvider._();

final class OfferingsProvider extends $FunctionalProvider<AsyncValue<Offerings>, Offerings, FutureOr<Offerings>>
    with $FutureModifier<Offerings>, $FutureProvider<Offerings> {
  OfferingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offeringsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offeringsHash();

  @$internal
  @override
  $FutureProviderElement<Offerings> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Offerings> create(Ref ref) {
    return offerings(ref);
  }
}

String _$offeringsHash() => r'a44517ca66731d95ed64ddb147c72567df8b12c7';

@ProviderFor(currentOfferingPackages)
final currentOfferingPackagesProvider = CurrentOfferingPackagesProvider._();

final class CurrentOfferingPackagesProvider extends $FunctionalProvider<List<Package>, List<Package>, List<Package>> with $Provider<List<Package>> {
  CurrentOfferingPackagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentOfferingPackagesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[customerInfoProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[CurrentOfferingPackagesProvider.$allTransitiveDependencies0],
      );

  static final $allTransitiveDependencies0 = customerInfoProvider;

  @override
  String debugGetCreateSourceHash() => _$currentOfferingPackagesHash();

  @$internal
  @override
  $ProviderElement<List<Package>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<Package> create(Ref ref) {
    return currentOfferingPackages(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Package> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<Package>>(value));
  }
}

String _$currentOfferingPackagesHash() => r'1758bdb951f3fa7d6a58d8f75a05d90a84a2e15c';

@ProviderFor(weeklyPackage)
final weeklyPackageProvider = WeeklyPackageProvider._();

final class WeeklyPackageProvider extends $FunctionalProvider<Package?, Package?, Package?> with $Provider<Package?> {
  WeeklyPackageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyPackageProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentOfferingPackagesProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          WeeklyPackageProvider.$allTransitiveDependencies0,
          WeeklyPackageProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = currentOfferingPackagesProvider;
  static final $allTransitiveDependencies1 = CurrentOfferingPackagesProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$weeklyPackageHash();

  @$internal
  @override
  $ProviderElement<Package?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Package? create(Ref ref) {
    return weeklyPackage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Package? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Package?>(value));
  }
}

String _$weeklyPackageHash() => r'724d6937d5857fac60f391f19dfad0cddf9440cd';

@ProviderFor(monthlyPackage)
final monthlyPackageProvider = MonthlyPackageProvider._();

final class MonthlyPackageProvider extends $FunctionalProvider<Package?, Package?, Package?> with $Provider<Package?> {
  MonthlyPackageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyPackageProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentOfferingPackagesProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          MonthlyPackageProvider.$allTransitiveDependencies0,
          MonthlyPackageProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = currentOfferingPackagesProvider;
  static final $allTransitiveDependencies1 = CurrentOfferingPackagesProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$monthlyPackageHash();

  @$internal
  @override
  $ProviderElement<Package?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Package? create(Ref ref) {
    return monthlyPackage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Package? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Package?>(value));
  }
}

String _$monthlyPackageHash() => r'689e548d5c66c21c5363b412f1518876e2a462a4';

@ProviderFor(sixMonthPackage)
final sixMonthPackageProvider = SixMonthPackageProvider._();

final class SixMonthPackageProvider extends $FunctionalProvider<Package?, Package?, Package?> with $Provider<Package?> {
  SixMonthPackageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sixMonthPackageProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentOfferingPackagesProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          SixMonthPackageProvider.$allTransitiveDependencies0,
          SixMonthPackageProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = currentOfferingPackagesProvider;
  static final $allTransitiveDependencies1 = CurrentOfferingPackagesProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$sixMonthPackageHash();

  @$internal
  @override
  $ProviderElement<Package?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Package? create(Ref ref) {
    return sixMonthPackage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Package? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Package?>(value));
  }
}

String _$sixMonthPackageHash() => r'4d685f0ef38971eeef882d02403e75bc17dc6889';

@ProviderFor(annualPackage)
final annualPackageProvider = AnnualPackageProvider._();

final class AnnualPackageProvider extends $FunctionalProvider<Package?, Package?, Package?> with $Provider<Package?> {
  AnnualPackageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'annualPackageProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentOfferingPackagesProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AnnualPackageProvider.$allTransitiveDependencies0,
          AnnualPackageProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = currentOfferingPackagesProvider;
  static final $allTransitiveDependencies1 = CurrentOfferingPackagesProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$annualPackageHash();

  @$internal
  @override
  $ProviderElement<Package?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Package? create(Ref ref) {
    return annualPackage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Package? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Package?>(value));
  }
}

String _$annualPackageHash() => r'cc12ef1ad61023813ede0e69f76202f15615928b';

@ProviderFor(monthlyPremiumPackage)
final monthlyPremiumPackageProvider = MonthlyPremiumPackageProvider._();

final class MonthlyPremiumPackageProvider extends $FunctionalProvider<Package?, Package?, Package?> with $Provider<Package?> {
  MonthlyPremiumPackageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyPremiumPackageProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyPremiumPackageHash();

  @$internal
  @override
  $ProviderElement<Package?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Package? create(Ref ref) {
    return monthlyPremiumPackage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Package? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Package?>(value));
  }
}

String _$monthlyPremiumPackageHash() => r'1328847b7552df99352df1507d989b1f940c2862';
