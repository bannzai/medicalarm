// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_create.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appUserCreate)
final appUserCreateProvider = AppUserCreateProvider._();

final class AppUserCreateProvider extends $FunctionalProvider<AppUserCreate, AppUserCreate, AppUserCreate> with $Provider<AppUserCreate> {
  AppUserCreateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUserCreateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[userDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AppUserCreateProvider.$allTransitiveDependencies0,
          AppUserCreateProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = userDatabaseProvider;
  static final $allTransitiveDependencies1 = UserDatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$appUserCreateHash();

  @$internal
  @override
  $ProviderElement<AppUserCreate> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AppUserCreate create(Ref ref) {
    return appUserCreate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUserCreate value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AppUserCreate>(value));
  }
}

String _$appUserCreateHash() => r'09c30e638b90b9fa8dacccfba2c9c2b5ea149c26';
