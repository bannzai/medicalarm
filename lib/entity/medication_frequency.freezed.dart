// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_frequency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
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
  /// Serializes this MedicationFrequency to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is MedicationFrequency);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MedicationFrequency()';
  }
}

/// @nodoc
class $MedicationFrequencyCopyWith<$Res> {
  $MedicationFrequencyCopyWith(MedicationFrequency _, $Res Function(MedicationFrequency) __);
}

/// Adds pattern-matching-related methods to [MedicationFrequency].
extension MedicationFrequencyPatterns on MedicationFrequency {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DailyMedicationFrequency value)? daily,
    TResult Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult Function(CycleMedicationFrequency value)? cycle,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DailyMedicationFrequency() when daily != null:
        return daily(_that);
      case EveryXDaysMedicationFrequency() when everyXDays != null:
        return everyXDays(_that);
      case SpecificWeekdaysMedicationFrequency() when specificWeekdays != null:
        return specificWeekdays(_that);
      case CycleMedicationFrequency() when cycle != null:
        return cycle(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DailyMedicationFrequency value) daily,
    required TResult Function(EveryXDaysMedicationFrequency value) everyXDays,
    required TResult Function(SpecificWeekdaysMedicationFrequency value) specificWeekdays,
    required TResult Function(CycleMedicationFrequency value) cycle,
  }) {
    final _that = this;
    switch (_that) {
      case DailyMedicationFrequency():
        return daily(_that);
      case EveryXDaysMedicationFrequency():
        return everyXDays(_that);
      case SpecificWeekdaysMedicationFrequency():
        return specificWeekdays(_that);
      case CycleMedicationFrequency():
        return cycle(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DailyMedicationFrequency value)? daily,
    TResult? Function(EveryXDaysMedicationFrequency value)? everyXDays,
    TResult? Function(SpecificWeekdaysMedicationFrequency value)? specificWeekdays,
    TResult? Function(CycleMedicationFrequency value)? cycle,
  }) {
    final _that = this;
    switch (_that) {
      case DailyMedicationFrequency() when daily != null:
        return daily(_that);
      case EveryXDaysMedicationFrequency() when everyXDays != null:
        return everyXDays(_that);
      case SpecificWeekdaysMedicationFrequency() when specificWeekdays != null:
        return specificWeekdays(_that);
      case CycleMedicationFrequency() when cycle != null:
        return cycle(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? daily,
    TResult Function(int interval)? everyXDays,
    TResult Function(List<Weekday> weekdays)? specificWeekdays,
    TResult Function(int consecutiveDays, int restDays)? cycle,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case DailyMedicationFrequency() when daily != null:
        return daily();
      case EveryXDaysMedicationFrequency() when everyXDays != null:
        return everyXDays(_that.interval);
      case SpecificWeekdaysMedicationFrequency() when specificWeekdays != null:
        return specificWeekdays(_that.weekdays);
      case CycleMedicationFrequency() when cycle != null:
        return cycle(_that.consecutiveDays, _that.restDays);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() daily,
    required TResult Function(int interval) everyXDays,
    required TResult Function(List<Weekday> weekdays) specificWeekdays,
    required TResult Function(int consecutiveDays, int restDays) cycle,
  }) {
    final _that = this;
    switch (_that) {
      case DailyMedicationFrequency():
        return daily();
      case EveryXDaysMedicationFrequency():
        return everyXDays(_that.interval);
      case SpecificWeekdaysMedicationFrequency():
        return specificWeekdays(_that.weekdays);
      case CycleMedicationFrequency():
        return cycle(_that.consecutiveDays, _that.restDays);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? daily,
    TResult? Function(int interval)? everyXDays,
    TResult? Function(List<Weekday> weekdays)? specificWeekdays,
    TResult? Function(int consecutiveDays, int restDays)? cycle,
  }) {
    final _that = this;
    switch (_that) {
      case DailyMedicationFrequency() when daily != null:
        return daily();
      case EveryXDaysMedicationFrequency() when everyXDays != null:
        return everyXDays(_that.interval);
      case SpecificWeekdaysMedicationFrequency() when specificWeekdays != null:
        return specificWeekdays(_that.weekdays);
      case CycleMedicationFrequency() when cycle != null:
        return cycle(_that.consecutiveDays, _that.restDays);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class DailyMedicationFrequency extends MedicationFrequency {
  const DailyMedicationFrequency({final String? $type})
      : $type = $type ?? 'daily',
        super._();
  factory DailyMedicationFrequency.fromJson(Map<String, dynamic> json) => _$DailyMedicationFrequencyFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$DailyMedicationFrequencyToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is DailyMedicationFrequency);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MedicationFrequency.daily()';
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class EveryXDaysMedicationFrequency extends MedicationFrequency {
  const EveryXDaysMedicationFrequency({required this.interval, final String? $type})
      : $type = $type ?? 'everyXDays',
        super._();
  factory EveryXDaysMedicationFrequency.fromJson(Map<String, dynamic> json) => _$EveryXDaysMedicationFrequencyFromJson(json);

  final int interval;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EveryXDaysMedicationFrequencyCopyWith<EveryXDaysMedicationFrequency> get copyWith =>
      _$EveryXDaysMedicationFrequencyCopyWithImpl<EveryXDaysMedicationFrequency>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EveryXDaysMedicationFrequencyToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EveryXDaysMedicationFrequency &&
            (identical(other.interval, interval) || other.interval == interval));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, interval);

  @override
  String toString() {
    return 'MedicationFrequency.everyXDays(interval: $interval)';
  }
}

/// @nodoc
abstract mixin class $EveryXDaysMedicationFrequencyCopyWith<$Res> implements $MedicationFrequencyCopyWith<$Res> {
  factory $EveryXDaysMedicationFrequencyCopyWith(EveryXDaysMedicationFrequency value, $Res Function(EveryXDaysMedicationFrequency) _then) =
      _$EveryXDaysMedicationFrequencyCopyWithImpl;
  @useResult
  $Res call({int interval});
}

/// @nodoc
class _$EveryXDaysMedicationFrequencyCopyWithImpl<$Res> implements $EveryXDaysMedicationFrequencyCopyWith<$Res> {
  _$EveryXDaysMedicationFrequencyCopyWithImpl(this._self, this._then);

  final EveryXDaysMedicationFrequency _self;
  final $Res Function(EveryXDaysMedicationFrequency) _then;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? interval = null,
  }) {
    return _then(EveryXDaysMedicationFrequency(
      interval: null == interval
          ? _self.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class SpecificWeekdaysMedicationFrequency extends MedicationFrequency {
  const SpecificWeekdaysMedicationFrequency({required final List<Weekday> weekdays, final String? $type})
      : _weekdays = weekdays,
        $type = $type ?? 'specificWeekdays',
        super._();
  factory SpecificWeekdaysMedicationFrequency.fromJson(Map<String, dynamic> json) => _$SpecificWeekdaysMedicationFrequencyFromJson(json);

  final List<Weekday> _weekdays;
  List<Weekday> get weekdays {
    if (_weekdays is EqualUnmodifiableListView) return _weekdays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekdays);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpecificWeekdaysMedicationFrequencyCopyWith<SpecificWeekdaysMedicationFrequency> get copyWith =>
      _$SpecificWeekdaysMedicationFrequencyCopyWithImpl<SpecificWeekdaysMedicationFrequency>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SpecificWeekdaysMedicationFrequencyToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpecificWeekdaysMedicationFrequency &&
            const DeepCollectionEquality().equals(other._weekdays, _weekdays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_weekdays));

  @override
  String toString() {
    return 'MedicationFrequency.specificWeekdays(weekdays: $weekdays)';
  }
}

/// @nodoc
abstract mixin class $SpecificWeekdaysMedicationFrequencyCopyWith<$Res> implements $MedicationFrequencyCopyWith<$Res> {
  factory $SpecificWeekdaysMedicationFrequencyCopyWith(
          SpecificWeekdaysMedicationFrequency value, $Res Function(SpecificWeekdaysMedicationFrequency) _then) =
      _$SpecificWeekdaysMedicationFrequencyCopyWithImpl;
  @useResult
  $Res call({List<Weekday> weekdays});
}

/// @nodoc
class _$SpecificWeekdaysMedicationFrequencyCopyWithImpl<$Res> implements $SpecificWeekdaysMedicationFrequencyCopyWith<$Res> {
  _$SpecificWeekdaysMedicationFrequencyCopyWithImpl(this._self, this._then);

  final SpecificWeekdaysMedicationFrequency _self;
  final $Res Function(SpecificWeekdaysMedicationFrequency) _then;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? weekdays = null,
  }) {
    return _then(SpecificWeekdaysMedicationFrequency(
      weekdays: null == weekdays
          ? _self._weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<Weekday>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class CycleMedicationFrequency extends MedicationFrequency {
  const CycleMedicationFrequency({required this.consecutiveDays, required this.restDays, final String? $type})
      : $type = $type ?? 'cycle',
        super._();
  factory CycleMedicationFrequency.fromJson(Map<String, dynamic> json) => _$CycleMedicationFrequencyFromJson(json);

// 連続服用日数
  final int consecutiveDays;
// 休薬日数
  final int restDays;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CycleMedicationFrequencyCopyWith<CycleMedicationFrequency> get copyWith =>
      _$CycleMedicationFrequencyCopyWithImpl<CycleMedicationFrequency>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CycleMedicationFrequencyToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CycleMedicationFrequency &&
            (identical(other.consecutiveDays, consecutiveDays) || other.consecutiveDays == consecutiveDays) &&
            (identical(other.restDays, restDays) || other.restDays == restDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, consecutiveDays, restDays);

  @override
  String toString() {
    return 'MedicationFrequency.cycle(consecutiveDays: $consecutiveDays, restDays: $restDays)';
  }
}

/// @nodoc
abstract mixin class $CycleMedicationFrequencyCopyWith<$Res> implements $MedicationFrequencyCopyWith<$Res> {
  factory $CycleMedicationFrequencyCopyWith(CycleMedicationFrequency value, $Res Function(CycleMedicationFrequency) _then) =
      _$CycleMedicationFrequencyCopyWithImpl;
  @useResult
  $Res call({int consecutiveDays, int restDays});
}

/// @nodoc
class _$CycleMedicationFrequencyCopyWithImpl<$Res> implements $CycleMedicationFrequencyCopyWith<$Res> {
  _$CycleMedicationFrequencyCopyWithImpl(this._self, this._then);

  final CycleMedicationFrequency _self;
  final $Res Function(CycleMedicationFrequency) _then;

  /// Create a copy of MedicationFrequency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? consecutiveDays = null,
    Object? restDays = null,
  }) {
    return _then(CycleMedicationFrequency(
      consecutiveDays: null == consecutiveDays
          ? _self.consecutiveDays
          : consecutiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      restDays: null == restDays
          ? _self.restDays
          : restDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
