// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_frequency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MedicationFrequency _$MedicationFrequencyFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'daily':
      return DailyMedicationFrequency.fromJson(json);
    case 'everyXDays':
      return EveryXDaysMedicationFrequency.fromJson(json);
    case 'specificWeekdays':
      return SpecificWeekdaysMedicationFrequency.fromJson(json);
    case 'cycle':
      return CycleMedicationFrequency.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'MedicationFrequency', 'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$MedicationFrequency {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() daily,
    required TResult Function(int interval) everyXDays,
    required TResult Function(List<Weekday> weekdays) specificWeekdays,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<Weekday> weekdays)? specificWeekdays,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<Weekday> weekdays)? specificWeekdays,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificWeekdaysMedicationFrequency value) specificWeekdays,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult Function(CycleMedicationFrequency value)? cycle,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MedicationFrequency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationFrequencyCopyWith<$Res> {
  factory $MedicationFrequencyCopyWith(MedicationFrequency value, $Res Function(MedicationFrequency) then) =
      _$MedicationFrequencyCopyWithImpl<$Res, MedicationFrequency>;
}

/// @nodoc
class _$MedicationFrequencyCopyWithImpl<$Res, $Val extends MedicationFrequency> implements $MedicationFrequencyCopyWith<$Res> {
  _$MedicationFrequencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DailyMedicationFrequencyImplCopyWith<$Res> {
  factory _$$DailyMedicationFrequencyImplCopyWith(_$DailyMedicationFrequencyImpl value, $Res Function(_$DailyMedicationFrequencyImpl) then) =
      __$$DailyMedicationFrequencyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DailyMedicationFrequencyImplCopyWithImpl<$Res> extends _$MedicationFrequencyCopyWithImpl<$Res, _$DailyMedicationFrequencyImpl>
    implements _$$DailyMedicationFrequencyImplCopyWith<$Res> {
  __$$DailyMedicationFrequencyImplCopyWithImpl(_$DailyMedicationFrequencyImpl _value, $Res Function(_$DailyMedicationFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$DailyMedicationFrequencyImpl extends DailyMedicationFrequency {
  const _$DailyMedicationFrequencyImpl({final String? $type})
      : $type = $type ?? 'daily',
        super._();

  factory _$DailyMedicationFrequencyImpl.fromJson(Map<String, dynamic> json) => _$$DailyMedicationFrequencyImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.daily()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is _$DailyMedicationFrequencyImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() daily,
    required TResult Function(int interval) everyXDays,
    required TResult Function(List<Weekday> weekdays) specificWeekdays,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return daily();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<Weekday> weekdays)? specificWeekdays,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return daily?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<Weekday> weekdays)? specificWeekdays,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) {
    if (daily != null) {
      return daily();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificWeekdaysMedicationFrequency value) specificWeekdays,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return daily(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return daily?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult Function(CycleMedicationFrequency value)? cycle,
    required TResult orElse(),
  }) {
    if (daily != null) {
      return daily(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyMedicationFrequencyImplToJson(
      this,
    );
  }
}

abstract class DailyMedicationFrequency extends MedicationFrequency {
  const factory DailyMedicationFrequency() = _$DailyMedicationFrequencyImpl;
  const DailyMedicationFrequency._() : super._();

  factory DailyMedicationFrequency.fromJson(Map<String, dynamic> json) = _$DailyMedicationFrequencyImpl.fromJson;
}

/// @nodoc
abstract class _$$EveryXDaysMedicationFrequencyImplCopyWith<$Res> {
  factory _$$EveryXDaysMedicationFrequencyImplCopyWith(
          _$EveryXDaysMedicationFrequencyImpl value, $Res Function(_$EveryXDaysMedicationFrequencyImpl) then) =
      __$$EveryXDaysMedicationFrequencyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int interval});
}

/// @nodoc
class __$$EveryXDaysMedicationFrequencyImplCopyWithImpl<$Res> extends _$MedicationFrequencyCopyWithImpl<$Res, _$EveryXDaysMedicationFrequencyImpl>
    implements _$$EveryXDaysMedicationFrequencyImplCopyWith<$Res> {
  __$$EveryXDaysMedicationFrequencyImplCopyWithImpl(
      _$EveryXDaysMedicationFrequencyImpl _value, $Res Function(_$EveryXDaysMedicationFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interval = null,
  }) {
    return _then(_$EveryXDaysMedicationFrequencyImpl(
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$EveryXDaysMedicationFrequencyImpl extends EveryXDaysMedicationFrequency {
  const _$EveryXDaysMedicationFrequencyImpl({required this.interval, final String? $type})
      : $type = $type ?? 'everyXDays',
        super._();

  factory _$EveryXDaysMedicationFrequencyImpl.fromJson(Map<String, dynamic> json) => _$$EveryXDaysMedicationFrequencyImplFromJson(json);

  @override
  final int interval;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.everyXDays(interval: $interval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EveryXDaysMedicationFrequencyImpl &&
            (identical(other.interval, interval) || other.interval == interval));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, interval);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EveryXDaysMedicationFrequencyImplCopyWith<_$EveryXDaysMedicationFrequencyImpl> get copyWith =>
      __$$EveryXDaysMedicationFrequencyImplCopyWithImpl<_$EveryXDaysMedicationFrequencyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() daily,
    required TResult Function(int interval) everyXDays,
    required TResult Function(List<Weekday> weekdays) specificWeekdays,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return everyXDays(interval);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<Weekday> weekdays)? specificWeekdays,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return everyXDays?.call(interval);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<Weekday> weekdays)? specificWeekdays,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) {
    if (everyXDays != null) {
      return everyXDays(interval);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificWeekdaysMedicationFrequency value) specificWeekdays,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return everyXDays(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return everyXDays?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult Function(CycleMedicationFrequency value)? cycle,
    required TResult orElse(),
  }) {
    if (everyXDays != null) {
      return everyXDays(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EveryXDaysMedicationFrequencyImplToJson(
      this,
    );
  }
}

abstract class EveryXDaysMedicationFrequency extends MedicationFrequency {
  const factory EveryXDaysMedicationFrequency({required final int interval}) = _$EveryXDaysMedicationFrequencyImpl;
  const EveryXDaysMedicationFrequency._() : super._();

  factory EveryXDaysMedicationFrequency.fromJson(Map<String, dynamic> json) = _$EveryXDaysMedicationFrequencyImpl.fromJson;

  int get interval;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EveryXDaysMedicationFrequencyImplCopyWith<_$EveryXDaysMedicationFrequencyImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SpecificWeekdaysMedicationFrequencyImplCopyWith<$Res> {
  factory _$$SpecificWeekdaysMedicationFrequencyImplCopyWith(
          _$SpecificWeekdaysMedicationFrequencyImpl value, $Res Function(_$SpecificWeekdaysMedicationFrequencyImpl) then) =
      __$$SpecificWeekdaysMedicationFrequencyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Weekday> weekdays});
}

/// @nodoc
class __$$SpecificWeekdaysMedicationFrequencyImplCopyWithImpl<$Res>
    extends _$MedicationFrequencyCopyWithImpl<$Res, _$SpecificWeekdaysMedicationFrequencyImpl>
    implements _$$SpecificWeekdaysMedicationFrequencyImplCopyWith<$Res> {
  __$$SpecificWeekdaysMedicationFrequencyImplCopyWithImpl(
      _$SpecificWeekdaysMedicationFrequencyImpl _value, $Res Function(_$SpecificWeekdaysMedicationFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekdays = null,
  }) {
    return _then(_$SpecificWeekdaysMedicationFrequencyImpl(
      weekdays: null == weekdays
          ? _value._weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<Weekday>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SpecificWeekdaysMedicationFrequencyImpl extends SpecificWeekdaysMedicationFrequency {
  const _$SpecificWeekdaysMedicationFrequencyImpl({required final List<Weekday> weekdays, final String? $type})
      : _weekdays = weekdays,
        $type = $type ?? 'specificWeekdays',
        super._();

  factory _$SpecificWeekdaysMedicationFrequencyImpl.fromJson(Map<String, dynamic> json) => _$$SpecificWeekdaysMedicationFrequencyImplFromJson(json);

  final List<Weekday> _weekdays;
  @override
  List<Weekday> get weekdays {
    if (_weekdays is EqualUnmodifiableListView) return _weekdays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekdays);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.specificWeekdays(weekdays: $weekdays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecificWeekdaysMedicationFrequencyImpl &&
            const DeepCollectionEquality().equals(other._weekdays, _weekdays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_weekdays));

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecificWeekdaysMedicationFrequencyImplCopyWith<_$SpecificWeekdaysMedicationFrequencyImpl> get copyWith =>
      __$$SpecificWeekdaysMedicationFrequencyImplCopyWithImpl<_$SpecificWeekdaysMedicationFrequencyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() daily,
    required TResult Function(int interval) everyXDays,
    required TResult Function(List<Weekday> weekdays) specificWeekdays,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return specificWeekdays(weekdays);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<Weekday> weekdays)? specificWeekdays,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return specificWeekdays?.call(weekdays);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<Weekday> weekdays)? specificWeekdays,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) {
    if (specificWeekdays != null) {
      return specificWeekdays(weekdays);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificWeekdaysMedicationFrequency value) specificWeekdays,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return specificWeekdays(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return specificWeekdays?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult Function(CycleMedicationFrequency value)? cycle,
    required TResult orElse(),
  }) {
    if (specificWeekdays != null) {
      return specificWeekdays(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecificWeekdaysMedicationFrequencyImplToJson(
      this,
    );
  }
}

abstract class SpecificWeekdaysMedicationFrequency extends MedicationFrequency {
  const factory SpecificWeekdaysMedicationFrequency({required final List<Weekday> weekdays}) = _$SpecificWeekdaysMedicationFrequencyImpl;
  const SpecificWeekdaysMedicationFrequency._() : super._();

  factory SpecificWeekdaysMedicationFrequency.fromJson(Map<String, dynamic> json) = _$SpecificWeekdaysMedicationFrequencyImpl.fromJson;

  List<Weekday> get weekdays;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecificWeekdaysMedicationFrequencyImplCopyWith<_$SpecificWeekdaysMedicationFrequencyImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CycleMedicationFrequencyImplCopyWith<$Res> {
  factory _$$CycleMedicationFrequencyImplCopyWith(_$CycleMedicationFrequencyImpl value, $Res Function(_$CycleMedicationFrequencyImpl) then) =
      __$$CycleMedicationFrequencyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int consecutiveDays, int restDays});
}

/// @nodoc
class __$$CycleMedicationFrequencyImplCopyWithImpl<$Res> extends _$MedicationFrequencyCopyWithImpl<$Res, _$CycleMedicationFrequencyImpl>
    implements _$$CycleMedicationFrequencyImplCopyWith<$Res> {
  __$$CycleMedicationFrequencyImplCopyWithImpl(_$CycleMedicationFrequencyImpl _value, $Res Function(_$CycleMedicationFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consecutiveDays = null,
    Object? restDays = null,
  }) {
    return _then(_$CycleMedicationFrequencyImpl(
      consecutiveDays: null == consecutiveDays
          ? _value.consecutiveDays
          : consecutiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      restDays: null == restDays
          ? _value.restDays
          : restDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$CycleMedicationFrequencyImpl extends CycleMedicationFrequency {
  const _$CycleMedicationFrequencyImpl({required this.consecutiveDays, required this.restDays, final String? $type})
      : $type = $type ?? 'cycle',
        super._();

  factory _$CycleMedicationFrequencyImpl.fromJson(Map<String, dynamic> json) => _$$CycleMedicationFrequencyImplFromJson(json);

// 連続服用日数
  @override
  final int consecutiveDays;
// 休薬日数
  @override
  final int restDays;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.cycle(consecutiveDays: $consecutiveDays, restDays: $restDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CycleMedicationFrequencyImpl &&
            (identical(other.consecutiveDays, consecutiveDays) || other.consecutiveDays == consecutiveDays) &&
            (identical(other.restDays, restDays) || other.restDays == restDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, consecutiveDays, restDays);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CycleMedicationFrequencyImplCopyWith<_$CycleMedicationFrequencyImpl> get copyWith =>
      __$$CycleMedicationFrequencyImplCopyWithImpl<_$CycleMedicationFrequencyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() daily,
    required TResult Function(int interval) everyXDays,
    required TResult Function(List<Weekday> weekdays) specificWeekdays,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return cycle(consecutiveDays, restDays);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<Weekday> weekdays)? specificWeekdays,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return cycle?.call(consecutiveDays, restDays);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<Weekday> weekdays)? specificWeekdays,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) {
    if (cycle != null) {
      return cycle(consecutiveDays, restDays);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificWeekdaysMedicationFrequency value) specificWeekdays,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return cycle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return cycle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult Function(CycleMedicationFrequency value)? cycle,
    required TResult orElse(),
  }) {
    if (cycle != null) {
      return cycle(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CycleMedicationFrequencyImplToJson(
      this,
    );
  }
}

abstract class CycleMedicationFrequency extends MedicationFrequency {
  const factory CycleMedicationFrequency({required final int consecutiveDays, required final int restDays}) = _$CycleMedicationFrequencyImpl;
  const CycleMedicationFrequency._() : super._();

  factory CycleMedicationFrequency.fromJson(Map<String, dynamic> json) = _$CycleMedicationFrequencyImpl.fromJson;

// 連続服用日数
  int get consecutiveDays; // 休薬日数
  int get restDays;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CycleMedicationFrequencyImplCopyWith<_$CycleMedicationFrequencyImpl> get copyWith => throw _privateConstructorUsedError;
}
