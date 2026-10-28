// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_notification_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 表示中グループにおける「自分」のメンバー個別通知設定。未作成の場合は null が流れる。

@ProviderFor(groupMemberNotificationSettings)
final groupMemberNotificationSettingsProvider = GroupMemberNotificationSettingsProvider._();

/// 表示中グループにおける「自分」のメンバー個別通知設定。未作成の場合は null が流れる。

final class GroupMemberNotificationSettingsProvider
    extends
        $FunctionalProvider<AsyncValue<GroupMemberNotificationSettings?>, GroupMemberNotificationSettings?, Stream<GroupMemberNotificationSettings?>>
    with $FutureModifier<GroupMemberNotificationSettings?>, $StreamProvider<GroupMemberNotificationSettings?> {
  /// 表示中グループにおける「自分」のメンバー個別通知設定。未作成の場合は null が流れる。
  GroupMemberNotificationSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupMemberNotificationSettingsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          GroupMemberNotificationSettingsProvider.$allTransitiveDependencies0,
          GroupMemberNotificationSettingsProvider.$allTransitiveDependencies1,
          GroupMemberNotificationSettingsProvider.$allTransitiveDependencies2,
          GroupMemberNotificationSettingsProvider.$allTransitiveDependencies3,
          GroupMemberNotificationSettingsProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;
  static final $allTransitiveDependencies1 = appUserIDProvider;
  static final $allTransitiveDependencies2 = AppUserIDProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 = AppUserIDProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies4 = AppUserIDProvider.$allTransitiveDependencies2;

  @override
  String debugGetCreateSourceHash() => _$groupMemberNotificationSettingsHash();

  @$internal
  @override
  $StreamProviderElement<GroupMemberNotificationSettings?> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<GroupMemberNotificationSettings?> create(Ref ref) {
    return groupMemberNotificationSettings(ref);
  }
}

String _$groupMemberNotificationSettingsHash() => r'61d51b108d8ef25cc04cf6fc693a4763dda064b7';

@ProviderFor(groupMemberNotificationSettingsUpdate)
final groupMemberNotificationSettingsUpdateProvider = GroupMemberNotificationSettingsUpdateProvider._();

final class GroupMemberNotificationSettingsUpdateProvider
    extends $FunctionalProvider<GroupMemberNotificationSettingsUpdate, GroupMemberNotificationSettingsUpdate, GroupMemberNotificationSettingsUpdate>
    with $Provider<GroupMemberNotificationSettingsUpdate> {
  GroupMemberNotificationSettingsUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupMemberNotificationSettingsUpdateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          GroupMemberNotificationSettingsUpdateProvider.$allTransitiveDependencies0,
          GroupMemberNotificationSettingsUpdateProvider.$allTransitiveDependencies1,
          GroupMemberNotificationSettingsUpdateProvider.$allTransitiveDependencies2,
          GroupMemberNotificationSettingsUpdateProvider.$allTransitiveDependencies3,
          GroupMemberNotificationSettingsUpdateProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;
  static final $allTransitiveDependencies1 = appUserIDProvider;
  static final $allTransitiveDependencies2 = AppUserIDProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 = AppUserIDProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies4 = AppUserIDProvider.$allTransitiveDependencies2;

  @override
  String debugGetCreateSourceHash() => _$groupMemberNotificationSettingsUpdateHash();

  @$internal
  @override
  $ProviderElement<GroupMemberNotificationSettingsUpdate> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GroupMemberNotificationSettingsUpdate create(Ref ref) {
    return groupMemberNotificationSettingsUpdate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupMemberNotificationSettingsUpdate value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GroupMemberNotificationSettingsUpdate>(value));
  }
}

String _$groupMemberNotificationSettingsUpdateHash() => r'c829dd8400144104d59e271cccbd7aed6c7982dd';
