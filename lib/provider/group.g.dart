// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 指定グループの購読。グループ設定画面など特定グループを名指しする用途で使う。

@ProviderFor(group)
final groupProvider = GroupFamily._();

/// 指定グループの購読。グループ設定画面など特定グループを名指しする用途で使う。

final class GroupProvider extends $FunctionalProvider<AsyncValue<Group>, Group, Stream<Group>> with $FutureModifier<Group>, $StreamProvider<Group> {
  /// 指定グループの購読。グループ設定画面など特定グループを名指しする用途で使う。
  GroupProvider._({required GroupFamily super.from, required String super.argument})
    : super(retry: null, name: r'groupProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  static final $allTransitiveDependencies0 = groupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$groupHash();

  @override
  String toString() {
    return r'groupProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Group> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<Group> create(Ref ref) {
    final argument = this.argument as String;
    return group(ref, groupID: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupHash() => r'00db553ddde7bb5b274e9eb9932fa26c9f18296a';

/// 指定グループの購読。グループ設定画面など特定グループを名指しする用途で使う。

final class GroupFamily extends $Family with $FunctionalFamilyOverride<Stream<Group>, String> {
  GroupFamily._()
    : super(
        retry: null,
        name: r'groupProvider',
        dependencies: <ProviderOrFamily>[groupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[GroupProvider.$allTransitiveDependencies0],
        isAutoDispose: true,
      );

  /// 指定グループの購読。グループ設定画面など特定グループを名指しする用途で使う。

  GroupProvider call({required String groupID}) => GroupProvider._(argument: groupID, from: this);

  @override
  String toString() => r'groupProvider';
}

@ProviderFor(groupNameUpdate)
final groupNameUpdateProvider = GroupNameUpdateFamily._();

final class GroupNameUpdateProvider extends $FunctionalProvider<GroupNameUpdate, GroupNameUpdate, GroupNameUpdate> with $Provider<GroupNameUpdate> {
  GroupNameUpdateProvider._({required GroupNameUpdateFamily super.from, required String super.argument})
    : super(retry: null, name: r'groupNameUpdateProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  static final $allTransitiveDependencies0 = groupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$groupNameUpdateHash();

  @override
  String toString() {
    return r'groupNameUpdateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<GroupNameUpdate> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GroupNameUpdate create(Ref ref) {
    final argument = this.argument as String;
    return groupNameUpdate(ref, groupID: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupNameUpdate value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GroupNameUpdate>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is GroupNameUpdateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupNameUpdateHash() => r'95520c0bf769819d98a7d3d3a0a055708d7466ee';

final class GroupNameUpdateFamily extends $Family with $FunctionalFamilyOverride<GroupNameUpdate, String> {
  GroupNameUpdateFamily._()
    : super(
        retry: null,
        name: r'groupNameUpdateProvider',
        dependencies: <ProviderOrFamily>[groupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[GroupNameUpdateProvider.$allTransitiveDependencies0],
        isAutoDispose: true,
      );

  GroupNameUpdateProvider call({required String groupID}) => GroupNameUpdateProvider._(argument: groupID, from: this);

  @override
  String toString() => r'groupNameUpdateProvider';
}
