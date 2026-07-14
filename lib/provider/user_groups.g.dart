// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_groups.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userGroupsHash() => r'02ae76f50fcf58e1788d73f0fd5899be57b085aa';

/// 自分が所属する全グループ。memberUserIDs に自分の uid を含むグループを購読する。
///
/// Copied from [userGroups].
@ProviderFor(userGroups)
final userGroupsProvider = AutoDisposeStreamProvider<List<Group>>.internal(
  userGroups,
  name: r'userGroupsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$userGroupsHash,
  dependencies: <ProviderOrFamily>[userDatabaseProvider],
  allTransitiveDependencies: <ProviderOrFamily>{userDatabaseProvider, ...?userDatabaseProvider.allTransitiveDependencies},
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserGroupsRef = AutoDisposeStreamProviderRef<List<Group>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
