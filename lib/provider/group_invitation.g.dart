// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_invitation.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(createGroupInvitation)
final createGroupInvitationProvider = CreateGroupInvitationProvider._();

final class CreateGroupInvitationProvider extends $FunctionalProvider<CreateGroupInvitation, CreateGroupInvitation, CreateGroupInvitation>
    with $Provider<CreateGroupInvitation> {
  CreateGroupInvitationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createGroupInvitationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createGroupInvitationHash();

  @$internal
  @override
  $ProviderElement<CreateGroupInvitation> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  CreateGroupInvitation create(Ref ref) {
    return createGroupInvitation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateGroupInvitation value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CreateGroupInvitation>(value));
  }
}

String _$createGroupInvitationHash() => r'd3a9136e65f68bc810f4895e771ee2dd50d6a361';

@ProviderFor(acceptGroupInvitation)
final acceptGroupInvitationProvider = AcceptGroupInvitationProvider._();

final class AcceptGroupInvitationProvider extends $FunctionalProvider<AcceptGroupInvitation, AcceptGroupInvitation, AcceptGroupInvitation>
    with $Provider<AcceptGroupInvitation> {
  AcceptGroupInvitationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceptGroupInvitationProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[userDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AcceptGroupInvitationProvider.$allTransitiveDependencies0,
          AcceptGroupInvitationProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = userDatabaseProvider;
  static final $allTransitiveDependencies1 = UserDatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$acceptGroupInvitationHash();

  @$internal
  @override
  $ProviderElement<AcceptGroupInvitation> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AcceptGroupInvitation create(Ref ref) {
    return acceptGroupInvitation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceptGroupInvitation value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AcceptGroupInvitation>(value));
  }
}

String _$acceptGroupInvitationHash() => r'bf63f948c8773b832b2c064d2d6157ef1dfaa271';
