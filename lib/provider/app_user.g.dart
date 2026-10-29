// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appUserID)
final appUserIDProvider = AppUserIDProvider._();

final class AppUserIDProvider extends $FunctionalProvider<String, String, String> with $Provider<String> {
  AppUserIDProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUserIDProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[appUserProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AppUserIDProvider.$allTransitiveDependencies0,
          AppUserIDProvider.$allTransitiveDependencies1,
          AppUserIDProvider.$allTransitiveDependencies2,
        ],
      );

  static final $allTransitiveDependencies0 = appUserProvider;
  static final $allTransitiveDependencies1 = AppUserProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 = AppUserProvider.$allTransitiveDependencies1;

  @override
  String debugGetCreateSourceHash() => _$appUserIDHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return appUserID(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String>(value));
  }
}

String _$appUserIDHash() => r'4ae2d2fc3bf82fdbeb84d728db3e5758e3cd4099';

@ProviderFor(appUser)
final appUserProvider = AppUserProvider._();

final class AppUserProvider extends $FunctionalProvider<AsyncValue<AppUser>, AppUser, Stream<AppUser>>
    with $FutureModifier<AppUser>, $StreamProvider<AppUser> {
  AppUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUserProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[userDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[AppUserProvider.$allTransitiveDependencies0, AppUserProvider.$allTransitiveDependencies1],
      );

  static final $allTransitiveDependencies0 = userDatabaseProvider;
  static final $allTransitiveDependencies1 = UserDatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$appUserHash();

  @$internal
  @override
  $StreamProviderElement<AppUser> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<AppUser> create(Ref ref) {
    return appUser(ref);
  }
}

String _$appUserHash() => r'ba194a96944f6c3713a705684d24bc1c358fd399';
