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
