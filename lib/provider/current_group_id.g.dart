// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_group_id.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 現在表示中のグループ ID。アプリ全体で 1 つだけ保持する選択状態。
///
/// 既定値(appUser.defaultGroupID)の初期化は CurrentGroupResolver が行う。
/// ここで appUserProvider を読まないのは、appUser の更新ごとに build が再実行され
/// ユーザーの手動グループ切替がリセットされるのを避けるため。

@ProviderFor(CurrentGroupID)
final currentGroupIDProvider = CurrentGroupIDProvider._();

/// 現在表示中のグループ ID。アプリ全体で 1 つだけ保持する選択状態。
///
/// 既定値(appUser.defaultGroupID)の初期化は CurrentGroupResolver が行う。
/// ここで appUserProvider を読まないのは、appUser の更新ごとに build が再実行され
/// ユーザーの手動グループ切替がリセットされるのを避けるため。
final class CurrentGroupIDProvider extends $NotifierProvider<CurrentGroupID, String?> {
  /// 現在表示中のグループ ID。アプリ全体で 1 つだけ保持する選択状態。
  ///
  /// 既定値(appUser.defaultGroupID)の初期化は CurrentGroupResolver が行う。
  /// ここで appUserProvider を読まないのは、appUser の更新ごとに build が再実行され
  /// ユーザーの手動グループ切替がリセットされるのを避けるため。
  CurrentGroupIDProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentGroupIDProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentGroupIDHash();

  @$internal
  @override
  CurrentGroupID create() => CurrentGroupID();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String?>(value));
  }
}

String _$currentGroupIDHash() => r'558298717f956d2ba5099315ddd3240917e47776';

/// 現在表示中のグループ ID。アプリ全体で 1 つだけ保持する選択状態。
///
/// 既定値(appUser.defaultGroupID)の初期化は CurrentGroupResolver が行う。
/// ここで appUserProvider を読まないのは、appUser の更新ごとに build が再実行され
/// ユーザーの手動グループ切替がリセットされるのを避けるため。

abstract class _$CurrentGroupID extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<String?, String?>, String?, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
