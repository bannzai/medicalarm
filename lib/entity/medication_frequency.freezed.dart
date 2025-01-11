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
    case 'specificDayOfWeek':
      return SpecificDayOfWeekMedicationFrequency.fromJson(json);
    case 'specificDayOfMonth':
      return SpecificDayOfMonthMedicationFrequency.fromJson(json);
    case 'oddOrEvenDay':
      return OddOrEvenDayMedicationFrequency.fromJson(json);
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
    required TResult Function(List<int> daysOfWeek) specificDayOfWeek,
    required TResult Function(List<int> daysOfMonth) specificDayOfMonth,
    required TResult Function(bool isOddDay) oddOrEvenDay,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult? Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult? Function(bool isOddDay)? oddOrEvenDay,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult Function(bool isOddDay)? oddOrEvenDay,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificDayOfWeekMedicationFrequency value) specificDayOfWeek,
    required TResult Function(SpecificDayOfMonthMedicationFrequency value) specificDayOfMonth,
    required TResult Function(OddOrEvenDayMedicationFrequency value) oddOrEvenDay,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult? Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult? Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
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
    required TResult Function(List<int> daysOfWeek) specificDayOfWeek,
    required TResult Function(List<int> daysOfMonth) specificDayOfMonth,
    required TResult Function(bool isOddDay) oddOrEvenDay,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return daily();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult? Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult? Function(bool isOddDay)? oddOrEvenDay,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return daily?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult Function(bool isOddDay)? oddOrEvenDay,
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
    required TResult Function(SpecificDayOfWeekMedicationFrequency value) specificDayOfWeek,
    required TResult Function(SpecificDayOfMonthMedicationFrequency value) specificDayOfMonth,
    required TResult Function(OddOrEvenDayMedicationFrequency value) oddOrEvenDay,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return daily(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult? Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult? Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return daily?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
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
    required TResult Function(List<int> daysOfWeek) specificDayOfWeek,
    required TResult Function(List<int> daysOfMonth) specificDayOfMonth,
    required TResult Function(bool isOddDay) oddOrEvenDay,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return everyXDays(interval);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult? Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult? Function(bool isOddDay)? oddOrEvenDay,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return everyXDays?.call(interval);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult Function(bool isOddDay)? oddOrEvenDay,
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
    required TResult Function(SpecificDayOfWeekMedicationFrequency value) specificDayOfWeek,
    required TResult Function(SpecificDayOfMonthMedicationFrequency value) specificDayOfMonth,
    required TResult Function(OddOrEvenDayMedicationFrequency value) oddOrEvenDay,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return everyXDays(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult? Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult? Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return everyXDays?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
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
abstract class _$$SpecificDayOfWeekMedicationFrequencyImplCopyWith<$Res> {
  factory _$$SpecificDayOfWeekMedicationFrequencyImplCopyWith(
          _$SpecificDayOfWeekMedicationFrequencyImpl value, $Res Function(_$SpecificDayOfWeekMedicationFrequencyImpl) then) =
      __$$SpecificDayOfWeekMedicationFrequencyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> daysOfWeek});
}

/// @nodoc
class __$$SpecificDayOfWeekMedicationFrequencyImplCopyWithImpl<$Res>
    extends _$MedicationFrequencyCopyWithImpl<$Res, _$SpecificDayOfWeekMedicationFrequencyImpl>
    implements _$$SpecificDayOfWeekMedicationFrequencyImplCopyWith<$Res> {
  __$$SpecificDayOfWeekMedicationFrequencyImplCopyWithImpl(
      _$SpecificDayOfWeekMedicationFrequencyImpl _value, $Res Function(_$SpecificDayOfWeekMedicationFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daysOfWeek = null,
  }) {
    return _then(_$SpecificDayOfWeekMedicationFrequencyImpl(
      daysOfWeek: null == daysOfWeek
          ? _value._daysOfWeek
          : daysOfWeek // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SpecificDayOfWeekMedicationFrequencyImpl extends SpecificDayOfWeekMedicationFrequency {
  const _$SpecificDayOfWeekMedicationFrequencyImpl({required final List<int> daysOfWeek, final String? $type})
      : _daysOfWeek = daysOfWeek,
        $type = $type ?? 'specificDayOfWeek',
        super._();

  factory _$SpecificDayOfWeekMedicationFrequencyImpl.fromJson(Map<String, dynamic> json) => _$$SpecificDayOfWeekMedicationFrequencyImplFromJson(json);

  final List<int> _daysOfWeek;
  @override
  List<int> get daysOfWeek {
    if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daysOfWeek);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.specificDayOfWeek(daysOfWeek: $daysOfWeek)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecificDayOfWeekMedicationFrequencyImpl &&
            const DeepCollectionEquality().equals(other._daysOfWeek, _daysOfWeek));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_daysOfWeek));

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecificDayOfWeekMedicationFrequencyImplCopyWith<_$SpecificDayOfWeekMedicationFrequencyImpl> get copyWith =>
      __$$SpecificDayOfWeekMedicationFrequencyImplCopyWithImpl<_$SpecificDayOfWeekMedicationFrequencyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() daily,
    required TResult Function(int interval) everyXDays,
    required TResult Function(List<int> daysOfWeek) specificDayOfWeek,
    required TResult Function(List<int> daysOfMonth) specificDayOfMonth,
    required TResult Function(bool isOddDay) oddOrEvenDay,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return specificDayOfWeek(daysOfWeek);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult? Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult? Function(bool isOddDay)? oddOrEvenDay,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return specificDayOfWeek?.call(daysOfWeek);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult Function(bool isOddDay)? oddOrEvenDay,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) {
    if (specificDayOfWeek != null) {
      return specificDayOfWeek(daysOfWeek);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificDayOfWeekMedicationFrequency value) specificDayOfWeek,
    required TResult Function(SpecificDayOfMonthMedicationFrequency value) specificDayOfMonth,
    required TResult Function(OddOrEvenDayMedicationFrequency value) oddOrEvenDay,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return specificDayOfWeek(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult? Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult? Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return specificDayOfWeek?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult Function(CycleMedicationFrequency value)? cycle,
    required TResult orElse(),
  }) {
    if (specificDayOfWeek != null) {
      return specificDayOfWeek(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecificDayOfWeekMedicationFrequencyImplToJson(
      this,
    );
  }
}

abstract class SpecificDayOfWeekMedicationFrequency extends MedicationFrequency {
  const factory SpecificDayOfWeekMedicationFrequency({required final List<int> daysOfWeek}) = _$SpecificDayOfWeekMedicationFrequencyImpl;
  const SpecificDayOfWeekMedicationFrequency._() : super._();

  factory SpecificDayOfWeekMedicationFrequency.fromJson(Map<String, dynamic> json) = _$SpecificDayOfWeekMedicationFrequencyImpl.fromJson;

  List<int> get daysOfWeek;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecificDayOfWeekMedicationFrequencyImplCopyWith<_$SpecificDayOfWeekMedicationFrequencyImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SpecificDayOfMonthMedicationFrequencyImplCopyWith<$Res> {
  factory _$$SpecificDayOfMonthMedicationFrequencyImplCopyWith(
          _$SpecificDayOfMonthMedicationFrequencyImpl value, $Res Function(_$SpecificDayOfMonthMedicationFrequencyImpl) then) =
      __$$SpecificDayOfMonthMedicationFrequencyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> daysOfMonth});
}

/// @nodoc
class __$$SpecificDayOfMonthMedicationFrequencyImplCopyWithImpl<$Res>
    extends _$MedicationFrequencyCopyWithImpl<$Res, _$SpecificDayOfMonthMedicationFrequencyImpl>
    implements _$$SpecificDayOfMonthMedicationFrequencyImplCopyWith<$Res> {
  __$$SpecificDayOfMonthMedicationFrequencyImplCopyWithImpl(
      _$SpecificDayOfMonthMedicationFrequencyImpl _value, $Res Function(_$SpecificDayOfMonthMedicationFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daysOfMonth = null,
  }) {
    return _then(_$SpecificDayOfMonthMedicationFrequencyImpl(
      daysOfMonth: null == daysOfMonth
          ? _value._daysOfMonth
          : daysOfMonth // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SpecificDayOfMonthMedicationFrequencyImpl extends SpecificDayOfMonthMedicationFrequency {
  const _$SpecificDayOfMonthMedicationFrequencyImpl({required final List<int> daysOfMonth, final String? $type})
      : _daysOfMonth = daysOfMonth,
        $type = $type ?? 'specificDayOfMonth',
        super._();

  factory _$SpecificDayOfMonthMedicationFrequencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecificDayOfMonthMedicationFrequencyImplFromJson(json);

  final List<int> _daysOfMonth;
  @override
  List<int> get daysOfMonth {
    if (_daysOfMonth is EqualUnmodifiableListView) return _daysOfMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daysOfMonth);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.specificDayOfMonth(daysOfMonth: $daysOfMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecificDayOfMonthMedicationFrequencyImpl &&
            const DeepCollectionEquality().equals(other._daysOfMonth, _daysOfMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_daysOfMonth));

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecificDayOfMonthMedicationFrequencyImplCopyWith<_$SpecificDayOfMonthMedicationFrequencyImpl> get copyWith =>
      __$$SpecificDayOfMonthMedicationFrequencyImplCopyWithImpl<_$SpecificDayOfMonthMedicationFrequencyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() daily,
    required TResult Function(int interval) everyXDays,
    required TResult Function(List<int> daysOfWeek) specificDayOfWeek,
    required TResult Function(List<int> daysOfMonth) specificDayOfMonth,
    required TResult Function(bool isOddDay) oddOrEvenDay,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return specificDayOfMonth(daysOfMonth);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult? Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult? Function(bool isOddDay)? oddOrEvenDay,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return specificDayOfMonth?.call(daysOfMonth);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult Function(bool isOddDay)? oddOrEvenDay,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) {
    if (specificDayOfMonth != null) {
      return specificDayOfMonth(daysOfMonth);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificDayOfWeekMedicationFrequency value) specificDayOfWeek,
    required TResult Function(SpecificDayOfMonthMedicationFrequency value) specificDayOfMonth,
    required TResult Function(OddOrEvenDayMedicationFrequency value) oddOrEvenDay,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return specificDayOfMonth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult? Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult? Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return specificDayOfMonth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult Function(CycleMedicationFrequency value)? cycle,
    required TResult orElse(),
  }) {
    if (specificDayOfMonth != null) {
      return specificDayOfMonth(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecificDayOfMonthMedicationFrequencyImplToJson(
      this,
    );
  }
}

abstract class SpecificDayOfMonthMedicationFrequency extends MedicationFrequency {
  const factory SpecificDayOfMonthMedicationFrequency({required final List<int> daysOfMonth}) = _$SpecificDayOfMonthMedicationFrequencyImpl;
  const SpecificDayOfMonthMedicationFrequency._() : super._();

  factory SpecificDayOfMonthMedicationFrequency.fromJson(Map<String, dynamic> json) = _$SpecificDayOfMonthMedicationFrequencyImpl.fromJson;

  List<int> get daysOfMonth;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecificDayOfMonthMedicationFrequencyImplCopyWith<_$SpecificDayOfMonthMedicationFrequencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OddOrEvenDayMedicationFrequencyImplCopyWith<$Res> {
  factory _$$OddOrEvenDayMedicationFrequencyImplCopyWith(
          _$OddOrEvenDayMedicationFrequencyImpl value, $Res Function(_$OddOrEvenDayMedicationFrequencyImpl) then) =
      __$$OddOrEvenDayMedicationFrequencyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isOddDay});
}

/// @nodoc
class __$$OddOrEvenDayMedicationFrequencyImplCopyWithImpl<$Res> extends _$MedicationFrequencyCopyWithImpl<$Res, _$OddOrEvenDayMedicationFrequencyImpl>
    implements _$$OddOrEvenDayMedicationFrequencyImplCopyWith<$Res> {
  __$$OddOrEvenDayMedicationFrequencyImplCopyWithImpl(
      _$OddOrEvenDayMedicationFrequencyImpl _value, $Res Function(_$OddOrEvenDayMedicationFrequencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOddDay = null,
  }) {
    return _then(_$OddOrEvenDayMedicationFrequencyImpl(
      isOddDay: null == isOddDay
          ? _value.isOddDay
          : isOddDay // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$OddOrEvenDayMedicationFrequencyImpl extends OddOrEvenDayMedicationFrequency {
  const _$OddOrEvenDayMedicationFrequencyImpl({required this.isOddDay, final String? $type})
      : $type = $type ?? 'oddOrEvenDay',
        super._();

  factory _$OddOrEvenDayMedicationFrequencyImpl.fromJson(Map<String, dynamic> json) => _$$OddOrEvenDayMedicationFrequencyImplFromJson(json);

  @override
  final bool isOddDay;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationFrequency.oddOrEvenDay(isOddDay: $isOddDay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OddOrEvenDayMedicationFrequencyImpl &&
            (identical(other.isOddDay, isOddDay) || other.isOddDay == isOddDay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isOddDay);

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OddOrEvenDayMedicationFrequencyImplCopyWith<_$OddOrEvenDayMedicationFrequencyImpl> get copyWith =>
      __$$OddOrEvenDayMedicationFrequencyImplCopyWithImpl<_$OddOrEvenDayMedicationFrequencyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() daily,
    required TResult Function(int interval) everyXDays,
    required TResult Function(List<int> daysOfWeek) specificDayOfWeek,
    required TResult Function(List<int> daysOfMonth) specificDayOfMonth,
    required TResult Function(bool isOddDay) oddOrEvenDay,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return oddOrEvenDay(isOddDay);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult? Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult? Function(bool isOddDay)? oddOrEvenDay,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return oddOrEvenDay?.call(isOddDay);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult Function(bool isOddDay)? oddOrEvenDay,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) {
    if (oddOrEvenDay != null) {
      return oddOrEvenDay(isOddDay);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificDayOfWeekMedicationFrequency value) specificDayOfWeek,
    required TResult Function(SpecificDayOfMonthMedicationFrequency value) specificDayOfMonth,
    required TResult Function(OddOrEvenDayMedicationFrequency value) oddOrEvenDay,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return oddOrEvenDay(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult? Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult? Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return oddOrEvenDay?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult Function(CycleMedicationFrequency value)? cycle,
    required TResult orElse(),
  }) {
    if (oddOrEvenDay != null) {
      return oddOrEvenDay(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OddOrEvenDayMedicationFrequencyImplToJson(
      this,
    );
  }
}

abstract class OddOrEvenDayMedicationFrequency extends MedicationFrequency {
  const factory OddOrEvenDayMedicationFrequency({required final bool isOddDay}) = _$OddOrEvenDayMedicationFrequencyImpl;
  const OddOrEvenDayMedicationFrequency._() : super._();

  factory OddOrEvenDayMedicationFrequency.fromJson(Map<String, dynamic> json) = _$OddOrEvenDayMedicationFrequencyImpl.fromJson;

  bool get isOddDay;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OddOrEvenDayMedicationFrequencyImplCopyWith<_$OddOrEvenDayMedicationFrequencyImpl> get copyWith => throw _privateConstructorUsedError;
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
    required TResult Function(List<int> daysOfWeek) specificDayOfWeek,
    required TResult Function(List<int> daysOfMonth) specificDayOfMonth,
    required TResult Function(bool isOddDay) oddOrEvenDay,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    return cycle(consecutiveDays, restDays);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult? Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult? Function(bool isOddDay)? oddOrEvenDay,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    return cycle?.call(consecutiveDays, restDays);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<int> daysOfWeek)? specificDayOfWeek,
    TResult Function(List<int> daysOfMonth)? specificDayOfMonth,
    TResult Function(bool isOddDay)? oddOrEvenDay,
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
    required TResult Function(SpecificDayOfWeekMedicationFrequency value) specificDayOfWeek,
    required TResult Function(SpecificDayOfMonthMedicationFrequency value) specificDayOfMonth,
    required TResult Function(OddOrEvenDayMedicationFrequency value) oddOrEvenDay,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    return cycle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult? Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult? Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    return cycle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificDayOfWeekMedicationFrequency value)? specificDayOfWeek,
    TResult Function(SpecificDayOfMonthMedicationFrequency value)? specificDayOfMonth,
    TResult Function(OddOrEvenDayMedicationFrequency value)? oddOrEvenDay,
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
