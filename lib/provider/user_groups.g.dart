// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_groups.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 自分が所属する全グループ。memberUserIDs に自分の uid を含むグループを購読する。

@ProviderFor(userGroups)
final userGroupsProvider = UserGroupsProvider._();

/// 自分が所属する全グループ。memberUserIDs に自分の uid を含むグループを購読する。

final class UserGroupsProvider extends $FunctionalProvider<AsyncValue<List<Group>>, List<Group>, Stream<List<Group>>>
    with $FutureModifier<List<Group>>, $StreamProvider<List<Group>> {
  /// 自分が所属する全グループ。memberUserIDs に自分の uid を含むグループを購読する。
  UserGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userGroupsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[userDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          UserGroupsProvider.$allTransitiveDependencies0,
          UserGroupsProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = userDatabaseProvider;
  static final $allTransitiveDependencies1 = UserDatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$userGroupsHash();

  @$internal
  @override
  $StreamProviderElement<List<Group>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Group>> create(Ref ref) {
    return userGroups(ref);
  }
}

String _$userGroupsHash() => r'02ae76f50fcf58e1788d73f0fd5899be57b085aa';
