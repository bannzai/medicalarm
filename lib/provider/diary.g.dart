// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diariesForDateTimeRange)
final diariesForDateTimeRangeProvider = DiariesForDateTimeRangeFamily._();

final class DiariesForDateTimeRangeProvider extends $FunctionalProvider<AsyncValue<List<Diary>>, List<Diary>, Stream<List<Diary>>>
    with $FutureModifier<List<Diary>>, $StreamProvider<List<Diary>> {
  DiariesForDateTimeRangeProvider._({required DiariesForDateTimeRangeFamily super.from, required DateTimeRange<DateTime> super.argument})
    : super(retry: null, name: r'diariesForDateTimeRangeProvider', isAutoDispose: true, dependencies: null, $allTransitiveDependencies: null);

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;

  @override
  String debugGetCreateSourceHash() => _$diariesForDateTimeRangeHash();

  @override
  String toString() {
    return r'diariesForDateTimeRangeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Diary>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Diary>> create(Ref ref) {
    final argument = this.argument as DateTimeRange<DateTime>;
    return diariesForDateTimeRange(ref, dateTimeRange: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiariesForDateTimeRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diariesForDateTimeRangeHash() => r'cc7ab38b97f376178c8898a6846928d9b85dc229';

final class DiariesForDateTimeRangeFamily extends $Family with $FunctionalFamilyOverride<Stream<List<Diary>>, DateTimeRange<DateTime>> {
  DiariesForDateTimeRangeFamily._()
    : super(
        retry: null,
        name: r'diariesForDateTimeRangeProvider',
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[DiariesForDateTimeRangeProvider.$allTransitiveDependencies0],
        isAutoDispose: true,
      );

  DiariesForDateTimeRangeProvider call({required DateTimeRange<DateTime> dateTimeRange}) =>
      DiariesForDateTimeRangeProvider._(argument: dateTimeRange, from: this);

  @override
  String toString() => r'diariesForDateTimeRangeProvider';
}

@ProviderFor(diaryPost)
final diaryPostProvider = DiaryPostProvider._();

final class DiaryPostProvider extends $FunctionalProvider<DiaryPost, DiaryPost, DiaryPost> with $Provider<DiaryPost> {
  DiaryPostProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryPostProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentGroupDatabaseProvider, appUserIDProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          DiaryPostProvider.$allTransitiveDependencies0,
          DiaryPostProvider.$allTransitiveDependencies1,
          DiaryPostProvider.$allTransitiveDependencies2,
          DiaryPostProvider.$allTransitiveDependencies3,
          DiaryPostProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = currentGroupDatabaseProvider;
  static final $allTransitiveDependencies1 = appUserIDProvider;
  static final $allTransitiveDependencies2 = AppUserIDProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 = AppUserIDProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies4 = AppUserIDProvider.$allTransitiveDependencies2;

  @override
  String debugGetCreateSourceHash() => _$diaryPostHash();

  @$internal
  @override
  $ProviderElement<DiaryPost> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DiaryPost create(Ref ref) {
    return diaryPost(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryPost value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DiaryPost>(value));
  }
}

String _$diaryPostHash() => r'7539089473660c807d769fc28e9deb4012d0c00c';
