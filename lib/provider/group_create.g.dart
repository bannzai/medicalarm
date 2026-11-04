// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_create.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(createGroup)
final createGroupProvider = CreateGroupProvider._();

final class CreateGroupProvider extends $FunctionalProvider<CreateGroup, CreateGroup, CreateGroup> with $Provider<CreateGroup> {
  CreateGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createGroupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createGroupHash();

  @$internal
  @override
  $ProviderElement<CreateGroup> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  CreateGroup create(Ref ref) {
    return createGroup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateGroup value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CreateGroup>(value));
  }
}

String _$createGroupHash() => r'fedd5b6118bab3c242ba0ce29bad36f0b71b412a';

/// 現在のユーザーの [SoloGroupPrepare] を返す。

@ProviderFor(soloGroupPrepare)
final soloGroupPrepareProvider = SoloGroupPrepareProvider._();

/// 現在のユーザーの [SoloGroupPrepare] を返す。

final class SoloGroupPrepareProvider extends $FunctionalProvider<SoloGroupPrepare, SoloGroupPrepare, SoloGroupPrepare>
    with $Provider<SoloGroupPrepare> {
  /// 現在のユーザーの [SoloGroupPrepare] を返す。
  SoloGroupPrepareProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soloGroupPrepareProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[userDatabaseProvider, serverUserGroupsFetchProvider, defaultGroupUpdateProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          SoloGroupPrepareProvider.$allTransitiveDependencies0,
          SoloGroupPrepareProvider.$allTransitiveDependencies1,
          SoloGroupPrepareProvider.$allTransitiveDependencies2,
          SoloGroupPrepareProvider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = userDatabaseProvider;
  static final $allTransitiveDependencies1 = UserDatabaseProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 = serverUserGroupsFetchProvider;
  static final $allTransitiveDependencies3 = defaultGroupUpdateProvider;

  @override
  String debugGetCreateSourceHash() => _$soloGroupPrepareHash();

  @$internal
  @override
  $ProviderElement<SoloGroupPrepare> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SoloGroupPrepare create(Ref ref) {
    return soloGroupPrepare(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoloGroupPrepare value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SoloGroupPrepare>(value));
  }
}

String _$soloGroupPrepareHash() => r'26f0f368af8d77e85023c17f7c72a78411222681';
