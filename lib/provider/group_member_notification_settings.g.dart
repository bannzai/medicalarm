// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_notification_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupMemberNotificationSettingsHash() => r'61d51b108d8ef25cc04cf6fc693a4763dda064b7';

/// 表示中グループにおける「自分」のメンバー個別通知設定。未作成の場合は null が流れる。
///
/// Copied from [groupMemberNotificationSettings].
@ProviderFor(groupMemberNotificationSettings)
final groupMemberNotificationSettingsProvider = AutoDisposeStreamProvider<GroupMemberNotificationSettings?>.internal(
  groupMemberNotificationSettings,
  name: r'groupMemberNotificationSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$groupMemberNotificationSettingsHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    currentGroupDatabaseProvider,
    ...?currentGroupDatabaseProvider.allTransitiveDependencies,
    appUserIDProvider,
    ...?appUserIDProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupMemberNotificationSettingsRef = AutoDisposeStreamProviderRef<GroupMemberNotificationSettings?>;
String _$groupMemberNotificationSettingsUpdateHash() => r'c829dd8400144104d59e271cccbd7aed6c7982dd';

/// See also [groupMemberNotificationSettingsUpdate].
@ProviderFor(groupMemberNotificationSettingsUpdate)
final groupMemberNotificationSettingsUpdateProvider = AutoDisposeProvider<GroupMemberNotificationSettingsUpdate>.internal(
  groupMemberNotificationSettingsUpdate,
  name: r'groupMemberNotificationSettingsUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$groupMemberNotificationSettingsUpdateHash,
  dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    currentGroupDatabaseProvider,
    ...?currentGroupDatabaseProvider.allTransitiveDependencies,
    appUserIDProvider,
    ...?appUserIDProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupMemberNotificationSettingsUpdateRef = AutoDisposeProviderRef<GroupMemberNotificationSettingsUpdate>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
