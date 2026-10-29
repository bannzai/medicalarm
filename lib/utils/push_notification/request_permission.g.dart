// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_permission.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(registerRemotePushNotificationToken)
final registerRemotePushNotificationTokenProvider = RegisterRemotePushNotificationTokenProvider._();

final class RegisterRemotePushNotificationTokenProvider
    extends $FunctionalProvider<RegisterRemotePushNotificationToken, RegisterRemotePushNotificationToken, RegisterRemotePushNotificationToken>
    with $Provider<RegisterRemotePushNotificationToken> {
  RegisterRemotePushNotificationTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerRemotePushNotificationTokenProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[userDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          RegisterRemotePushNotificationTokenProvider.$allTransitiveDependencies0,
          RegisterRemotePushNotificationTokenProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = userDatabaseProvider;
  static final $allTransitiveDependencies1 = UserDatabaseProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$registerRemotePushNotificationTokenHash();

  @$internal
  @override
  $ProviderElement<RegisterRemotePushNotificationToken> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  RegisterRemotePushNotificationToken create(Ref ref) {
    return registerRemotePushNotificationToken(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterRemotePushNotificationToken value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<RegisterRemotePushNotificationToken>(value));
  }
}

String _$registerRemotePushNotificationTokenHash() => r'4d192b1a0861bdb57a4a3ccbba5fd594b0375fbf';
