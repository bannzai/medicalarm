// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_group_update.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(defaultGroupUpdate)
final defaultGroupUpdateProvider = DefaultGroupUpdateProvider._();

final class DefaultGroupUpdateProvider extends $FunctionalProvider<DefaultGroupUpdate, DefaultGroupUpdate, DefaultGroupUpdate>
    with $Provider<DefaultGroupUpdate> {
  DefaultGroupUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultGroupUpdateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[userDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DefaultGroupUpdateProvider.$allTransitiveDependencies0,
          DefaultGroupUpdateProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = userDatabaseProvider;
  static final $allTransitiveDependencies1 = UserDatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$defaultGroupUpdateHash();

  @$internal
  @override
  $ProviderElement<DefaultGroupUpdate> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DefaultGroupUpdate create(Ref ref) {
    return defaultGroupUpdate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DefaultGroupUpdate value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DefaultGroupUpdate>(value));
  }
}

String _$defaultGroupUpdateHash() => r'14dc7bb6ee08c6921daf4c795fa16abe52ba8396';

/// 現在のユーザーの [DebugDefaultGroupClear] を返す。

@ProviderFor(debugDefaultGroupClear)
final debugDefaultGroupClearProvider = DebugDefaultGroupClearProvider._();

/// 現在のユーザーの [DebugDefaultGroupClear] を返す。

final class DebugDefaultGroupClearProvider extends $FunctionalProvider<DebugDefaultGroupClear, DebugDefaultGroupClear, DebugDefaultGroupClear>
    with $Provider<DebugDefaultGroupClear> {
  /// 現在のユーザーの [DebugDefaultGroupClear] を返す。
  DebugDefaultGroupClearProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugDefaultGroupClearProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[userDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DebugDefaultGroupClearProvider.$allTransitiveDependencies0,
          DebugDefaultGroupClearProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = userDatabaseProvider;
  static final $allTransitiveDependencies1 = UserDatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$debugDefaultGroupClearHash();

  @$internal
  @override
  $ProviderElement<DebugDefaultGroupClear> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DebugDefaultGroupClear create(Ref ref) {
    return debugDefaultGroupClear(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebugDefaultGroupClear value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DebugDefaultGroupClear>(value));
  }
}

String _$debugDefaultGroupClearHash() => r'ba5500316c429999566ce6a1e86844add469e360';
