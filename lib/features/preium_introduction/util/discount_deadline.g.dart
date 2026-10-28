// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_deadline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Tick)
final tickProvider = TickProvider._();

final class TickProvider extends $NotifierProvider<Tick, DateTime> {
  TickProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tickProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tickHash();

  @$internal
  @override
  Tick create() => Tick();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DateTime>(value));
  }
}

String _$tickHash() => r'627ad686315be91a0a2217b100b7a79f091931b9';

abstract class _$Tick extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<DateTime, DateTime>, DateTime, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(isOverDiscountDeadline)
final isOverDiscountDeadlineProvider = IsOverDiscountDeadlineFamily._();

final class IsOverDiscountDeadlineProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  IsOverDiscountDeadlineProvider._({required IsOverDiscountDeadlineFamily super.from, required DateTime? super.argument})
    : super(retry: null, name: r'isOverDiscountDeadlineProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$isOverDiscountDeadlineHash();

  @override
  String toString() {
    return r'isOverDiscountDeadlineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as DateTime?;
    return isOverDiscountDeadline(ref, discountEntitlementDeadlineDate: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is IsOverDiscountDeadlineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isOverDiscountDeadlineHash() => r'f1077ee0cddf37489e05a9d64453f831b9b83ceb';

final class IsOverDiscountDeadlineFamily extends $Family with $FunctionalFamilyOverride<bool, DateTime?> {
  IsOverDiscountDeadlineFamily._()
    : super(retry: null, name: r'isOverDiscountDeadlineProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  IsOverDiscountDeadlineProvider call({required DateTime? discountEntitlementDeadlineDate}) =>
      IsOverDiscountDeadlineProvider._(argument: discountEntitlementDeadlineDate, from: this);

  @override
  String toString() => r'isOverDiscountDeadlineProvider';
}

@ProviderFor(hiddenCountdownDiscountDeadline)
final hiddenCountdownDiscountDeadlineProvider = HiddenCountdownDiscountDeadlineFamily._();

final class HiddenCountdownDiscountDeadlineProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  HiddenCountdownDiscountDeadlineProvider._({required HiddenCountdownDiscountDeadlineFamily super.from, required DateTime? super.argument})
    : super(retry: null, name: r'hiddenCountdownDiscountDeadlineProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  static final $allTransitiveDependencies0 = customerInfoProvider;

  @override
  String debugGetCreateSourceHash() => _$hiddenCountdownDiscountDeadlineHash();

  @override
  String toString() {
    return r'hiddenCountdownDiscountDeadlineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as DateTime?;
    return hiddenCountdownDiscountDeadline(ref, discountEntitlementDeadlineDate: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is HiddenCountdownDiscountDeadlineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiddenCountdownDiscountDeadlineHash() => r'ed3bcf4fcf9e0a2b6310687d7f30fed90e890a83';

final class HiddenCountdownDiscountDeadlineFamily extends $Family with $FunctionalFamilyOverride<bool, DateTime?> {
  HiddenCountdownDiscountDeadlineFamily._()
    : super(
        retry: null,
        name: r'hiddenCountdownDiscountDeadlineProvider',
        dependencies: <ProviderOrFamily>[customerInfoProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[HiddenCountdownDiscountDeadlineProvider.$allTransitiveDependencies0],
        isAutoDispose: true,
      );

  HiddenCountdownDiscountDeadlineProvider call({required DateTime? discountEntitlementDeadlineDate}) =>
      HiddenCountdownDiscountDeadlineProvider._(argument: discountEntitlementDeadlineDate, from: this);

  @override
  String toString() => r'hiddenCountdownDiscountDeadlineProvider';
}

@ProviderFor(durationToDiscountPriceDeadline)
final durationToDiscountPriceDeadlineProvider = DurationToDiscountPriceDeadlineFamily._();

final class DurationToDiscountPriceDeadlineProvider extends $FunctionalProvider<Duration, Duration, Duration> with $Provider<Duration> {
  DurationToDiscountPriceDeadlineProvider._({required DurationToDiscountPriceDeadlineFamily super.from, required DateTime super.argument})
    : super(retry: null, name: r'durationToDiscountPriceDeadlineProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$durationToDiscountPriceDeadlineHash();

  @override
  String toString() {
    return r'durationToDiscountPriceDeadlineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    final argument = this.argument as DateTime;
    return durationToDiscountPriceDeadline(ref, discountEntitlementDeadlineDate: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Duration>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is DurationToDiscountPriceDeadlineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$durationToDiscountPriceDeadlineHash() => r'69af541cac66dc59b8c1e0f61d7b1e55d1758450';

final class DurationToDiscountPriceDeadlineFamily extends $Family with $FunctionalFamilyOverride<Duration, DateTime> {
  DurationToDiscountPriceDeadlineFamily._()
    : super(retry: null, name: r'durationToDiscountPriceDeadlineProvider', dependencies: null, $allTransitiveDependencies: null, isAutoDispose: true);

  DurationToDiscountPriceDeadlineProvider call({required DateTime discountEntitlementDeadlineDate}) =>
      DurationToDiscountPriceDeadlineProvider._(argument: discountEntitlementDeadlineDate, from: this);

  @override
  String toString() => r'durationToDiscountPriceDeadlineProvider';
}
