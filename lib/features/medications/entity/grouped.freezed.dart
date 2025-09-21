// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationGroup {
  String get id;
  MedicationGroupScheduleTime get scheduleTime;
  DoseReceiver get doseReceiver;
  List<MedicationGroupScheduleRow> get scheduleRows;

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationGroupCopyWith<MedicationGroup> get copyWith => _$MedicationGroupCopyWithImpl<MedicationGroup>(this as MedicationGroup, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationGroup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime) &&
            (identical(other.doseReceiver, doseReceiver) || other.doseReceiver == doseReceiver) &&
            const DeepCollectionEquality().equals(other.scheduleRows, scheduleRows));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, scheduleTime, doseReceiver, const DeepCollectionEquality().hash(scheduleRows));

  @override
  String toString() {
    return 'MedicationGroup(id: $id, scheduleTime: $scheduleTime, doseReceiver: $doseReceiver, scheduleRows: $scheduleRows)';
  }
}

/// @nodoc
abstract mixin class $MedicationGroupCopyWith<$Res> {
  factory $MedicationGroupCopyWith(MedicationGroup value, $Res Function(MedicationGroup) _then) = _$MedicationGroupCopyWithImpl;
  @useResult
  $Res call({String id, MedicationGroupScheduleTime scheduleTime, DoseReceiver doseReceiver, List<MedicationGroupScheduleRow> scheduleRows});

  $MedicationGroupScheduleTimeCopyWith<$Res> get scheduleTime;
  $DoseReceiverCopyWith<$Res> get doseReceiver;
}

/// @nodoc
class _$MedicationGroupCopyWithImpl<$Res> implements $MedicationGroupCopyWith<$Res> {
  _$MedicationGroupCopyWithImpl(this._self, this._then);

  final MedicationGroup _self;
  final $Res Function(MedicationGroup) _then;

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scheduleTime = null,
    Object? doseReceiver = null,
    Object? scheduleRows = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleTime: null == scheduleTime
          ? _self.scheduleTime
          : scheduleTime // ignore: cast_nullable_to_non_nullable
              as MedicationGroupScheduleTime,
      doseReceiver: null == doseReceiver
          ? _self.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      scheduleRows: null == scheduleRows
          ? _self.scheduleRows
          : scheduleRows // ignore: cast_nullable_to_non_nullable
              as List<MedicationGroupScheduleRow>,
    ));
  }

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationGroupScheduleTimeCopyWith<$Res> get scheduleTime {
    return $MedicationGroupScheduleTimeCopyWith<$Res>(_self.scheduleTime, (value) {
      return _then(_self.copyWith(scheduleTime: value));
    });
  }

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DoseReceiverCopyWith<$Res> get doseReceiver {
    return $DoseReceiverCopyWith<$Res>(_self.doseReceiver, (value) {
      return _then(_self.copyWith(doseReceiver: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MedicationGroup].
extension MedicationGroupPatterns on MedicationGroup {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MedicationGroup value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationGroup() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_MedicationGroup value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroup():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MedicationGroup value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroup() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, MedicationGroupScheduleTime scheduleTime, DoseReceiver doseReceiver, List<MedicationGroupScheduleRow> scheduleRows)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationGroup() when $default != null:
        return $default(_that.id, _that.scheduleTime, _that.doseReceiver, _that.scheduleRows);
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
  TResult when<TResult extends Object?>(
    TResult Function(String id, MedicationGroupScheduleTime scheduleTime, DoseReceiver doseReceiver, List<MedicationGroupScheduleRow> scheduleRows)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroup():
        return $default(_that.id, _that.scheduleTime, _that.doseReceiver, _that.scheduleRows);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, MedicationGroupScheduleTime scheduleTime, DoseReceiver doseReceiver, List<MedicationGroupScheduleRow> scheduleRows)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroup() when $default != null:
        return $default(_that.id, _that.scheduleTime, _that.doseReceiver, _that.scheduleRows);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MedicationGroup implements MedicationGroup {
  const _MedicationGroup(
      {required this.id, required this.scheduleTime, required this.doseReceiver, required final List<MedicationGroupScheduleRow> scheduleRows})
      : _scheduleRows = scheduleRows;

  @override
  final String id;
  @override
  final MedicationGroupScheduleTime scheduleTime;
  @override
  final DoseReceiver doseReceiver;
  final List<MedicationGroupScheduleRow> _scheduleRows;
  @override
  List<MedicationGroupScheduleRow> get scheduleRows {
    if (_scheduleRows is EqualUnmodifiableListView) return _scheduleRows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scheduleRows);
  }

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationGroupCopyWith<_MedicationGroup> get copyWith => __$MedicationGroupCopyWithImpl<_MedicationGroup>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationGroup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime) &&
            (identical(other.doseReceiver, doseReceiver) || other.doseReceiver == doseReceiver) &&
            const DeepCollectionEquality().equals(other._scheduleRows, _scheduleRows));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, scheduleTime, doseReceiver, const DeepCollectionEquality().hash(_scheduleRows));

  @override
  String toString() {
    return 'MedicationGroup(id: $id, scheduleTime: $scheduleTime, doseReceiver: $doseReceiver, scheduleRows: $scheduleRows)';
  }
}

/// @nodoc
abstract mixin class _$MedicationGroupCopyWith<$Res> implements $MedicationGroupCopyWith<$Res> {
  factory _$MedicationGroupCopyWith(_MedicationGroup value, $Res Function(_MedicationGroup) _then) = __$MedicationGroupCopyWithImpl;
  @override
  @useResult
  $Res call({String id, MedicationGroupScheduleTime scheduleTime, DoseReceiver doseReceiver, List<MedicationGroupScheduleRow> scheduleRows});

  @override
  $MedicationGroupScheduleTimeCopyWith<$Res> get scheduleTime;
  @override
  $DoseReceiverCopyWith<$Res> get doseReceiver;
}

/// @nodoc
class __$MedicationGroupCopyWithImpl<$Res> implements _$MedicationGroupCopyWith<$Res> {
  __$MedicationGroupCopyWithImpl(this._self, this._then);

  final _MedicationGroup _self;
  final $Res Function(_MedicationGroup) _then;

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? scheduleTime = null,
    Object? doseReceiver = null,
    Object? scheduleRows = null,
  }) {
    return _then(_MedicationGroup(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleTime: null == scheduleTime
          ? _self.scheduleTime
          : scheduleTime // ignore: cast_nullable_to_non_nullable
              as MedicationGroupScheduleTime,
      doseReceiver: null == doseReceiver
          ? _self.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      scheduleRows: null == scheduleRows
          ? _self._scheduleRows
          : scheduleRows // ignore: cast_nullable_to_non_nullable
              as List<MedicationGroupScheduleRow>,
    ));
  }

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationGroupScheduleTimeCopyWith<$Res> get scheduleTime {
    return $MedicationGroupScheduleTimeCopyWith<$Res>(_self.scheduleTime, (value) {
      return _then(_self.copyWith(scheduleTime: value));
    });
  }

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DoseReceiverCopyWith<$Res> get doseReceiver {
    return $DoseReceiverCopyWith<$Res>(_self.doseReceiver, (value) {
      return _then(_self.copyWith(doseReceiver: value));
    });
  }
}

/// @nodoc
mixin _$MedicationGroupScheduleRow {
  String get id;
  MedicationHistory? get medicationHistory;
  Medicine get medicine;
  MedicationSchedule get medicationSchedule;
  String get quantityMemo;
  DateTime get date;

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationGroupScheduleRowCopyWith<MedicationGroupScheduleRow> get copyWith =>
      _$MedicationGroupScheduleRowCopyWithImpl<MedicationGroupScheduleRow>(this as MedicationGroupScheduleRow, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationGroupScheduleRow &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.medicationHistory, medicationHistory) || other.medicationHistory == medicationHistory) &&
            (identical(other.medicine, medicine) || other.medicine == medicine) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule) &&
            (identical(other.quantityMemo, quantityMemo) || other.quantityMemo == quantityMemo) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, medicationHistory, medicine, medicationSchedule, quantityMemo, date);

  @override
  String toString() {
    return 'MedicationGroupScheduleRow(id: $id, medicationHistory: $medicationHistory, medicine: $medicine, medicationSchedule: $medicationSchedule, quantityMemo: $quantityMemo, date: $date)';
  }
}

/// @nodoc
abstract mixin class $MedicationGroupScheduleRowCopyWith<$Res> {
  factory $MedicationGroupScheduleRowCopyWith(MedicationGroupScheduleRow value, $Res Function(MedicationGroupScheduleRow) _then) =
      _$MedicationGroupScheduleRowCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      MedicationHistory? medicationHistory,
      Medicine medicine,
      MedicationSchedule medicationSchedule,
      String quantityMemo,
      DateTime date});

  $MedicationHistoryCopyWith<$Res>? get medicationHistory;
  $MedicineCopyWith<$Res> get medicine;
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class _$MedicationGroupScheduleRowCopyWithImpl<$Res> implements $MedicationGroupScheduleRowCopyWith<$Res> {
  _$MedicationGroupScheduleRowCopyWithImpl(this._self, this._then);

  final MedicationGroupScheduleRow _self;
  final $Res Function(MedicationGroupScheduleRow) _then;

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? medicationHistory = freezed,
    Object? medicine = null,
    Object? medicationSchedule = null,
    Object? quantityMemo = null,
    Object? date = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      medicationHistory: freezed == medicationHistory
          ? _self.medicationHistory
          : medicationHistory // ignore: cast_nullable_to_non_nullable
              as MedicationHistory?,
      medicine: null == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medicine,
      medicationSchedule: null == medicationSchedule
          ? _self.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
      quantityMemo: null == quantityMemo
          ? _self.quantityMemo
          : quantityMemo // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationHistoryCopyWith<$Res>? get medicationHistory {
    if (_self.medicationHistory == null) {
      return null;
    }

    return $MedicationHistoryCopyWith<$Res>(_self.medicationHistory!, (value) {
      return _then(_self.copyWith(medicationHistory: value));
    });
  }

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineCopyWith<$Res> get medicine {
    return $MedicineCopyWith<$Res>(_self.medicine, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationScheduleCopyWith<$Res> get medicationSchedule {
    return $MedicationScheduleCopyWith<$Res>(_self.medicationSchedule, (value) {
      return _then(_self.copyWith(medicationSchedule: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MedicationGroupScheduleRow].
extension MedicationGroupScheduleRowPatterns on MedicationGroupScheduleRow {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MedicationGroupScheduleRow value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleRow() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_MedicationGroupScheduleRow value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleRow():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MedicationGroupScheduleRow value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleRow() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, MedicationHistory? medicationHistory, Medicine medicine, MedicationSchedule medicationSchedule, String quantityMemo,
            DateTime date)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleRow() when $default != null:
        return $default(_that.id, _that.medicationHistory, _that.medicine, _that.medicationSchedule, _that.quantityMemo, _that.date);
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
  TResult when<TResult extends Object?>(
    TResult Function(String id, MedicationHistory? medicationHistory, Medicine medicine, MedicationSchedule medicationSchedule, String quantityMemo,
            DateTime date)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleRow():
        return $default(_that.id, _that.medicationHistory, _that.medicine, _that.medicationSchedule, _that.quantityMemo, _that.date);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, MedicationHistory? medicationHistory, Medicine medicine, MedicationSchedule medicationSchedule, String quantityMemo,
            DateTime date)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleRow() when $default != null:
        return $default(_that.id, _that.medicationHistory, _that.medicine, _that.medicationSchedule, _that.quantityMemo, _that.date);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MedicationGroupScheduleRow extends MedicationGroupScheduleRow {
  const _MedicationGroupScheduleRow(
      {required this.id,
      required this.medicationHistory,
      required this.medicine,
      required this.medicationSchedule,
      required this.quantityMemo,
      required this.date})
      : super._();

  @override
  final String id;
  @override
  final MedicationHistory? medicationHistory;
  @override
  final Medicine medicine;
  @override
  final MedicationSchedule medicationSchedule;
  @override
  final String quantityMemo;
  @override
  final DateTime date;

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationGroupScheduleRowCopyWith<_MedicationGroupScheduleRow> get copyWith =>
      __$MedicationGroupScheduleRowCopyWithImpl<_MedicationGroupScheduleRow>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationGroupScheduleRow &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.medicationHistory, medicationHistory) || other.medicationHistory == medicationHistory) &&
            (identical(other.medicine, medicine) || other.medicine == medicine) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule) &&
            (identical(other.quantityMemo, quantityMemo) || other.quantityMemo == quantityMemo) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, medicationHistory, medicine, medicationSchedule, quantityMemo, date);

  @override
  String toString() {
    return 'MedicationGroupScheduleRow(id: $id, medicationHistory: $medicationHistory, medicine: $medicine, medicationSchedule: $medicationSchedule, quantityMemo: $quantityMemo, date: $date)';
  }
}

/// @nodoc
abstract mixin class _$MedicationGroupScheduleRowCopyWith<$Res> implements $MedicationGroupScheduleRowCopyWith<$Res> {
  factory _$MedicationGroupScheduleRowCopyWith(_MedicationGroupScheduleRow value, $Res Function(_MedicationGroupScheduleRow) _then) =
      __$MedicationGroupScheduleRowCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      MedicationHistory? medicationHistory,
      Medicine medicine,
      MedicationSchedule medicationSchedule,
      String quantityMemo,
      DateTime date});

  @override
  $MedicationHistoryCopyWith<$Res>? get medicationHistory;
  @override
  $MedicineCopyWith<$Res> get medicine;
  @override
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class __$MedicationGroupScheduleRowCopyWithImpl<$Res> implements _$MedicationGroupScheduleRowCopyWith<$Res> {
  __$MedicationGroupScheduleRowCopyWithImpl(this._self, this._then);

  final _MedicationGroupScheduleRow _self;
  final $Res Function(_MedicationGroupScheduleRow) _then;

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? medicationHistory = freezed,
    Object? medicine = null,
    Object? medicationSchedule = null,
    Object? quantityMemo = null,
    Object? date = null,
  }) {
    return _then(_MedicationGroupScheduleRow(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      medicationHistory: freezed == medicationHistory
          ? _self.medicationHistory
          : medicationHistory // ignore: cast_nullable_to_non_nullable
              as MedicationHistory?,
      medicine: null == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medicine,
      medicationSchedule: null == medicationSchedule
          ? _self.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
      quantityMemo: null == quantityMemo
          ? _self.quantityMemo
          : quantityMemo // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationHistoryCopyWith<$Res>? get medicationHistory {
    if (_self.medicationHistory == null) {
      return null;
    }

    return $MedicationHistoryCopyWith<$Res>(_self.medicationHistory!, (value) {
      return _then(_self.copyWith(medicationHistory: value));
    });
  }

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineCopyWith<$Res> get medicine {
    return $MedicineCopyWith<$Res>(_self.medicine, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationScheduleCopyWith<$Res> get medicationSchedule {
    return $MedicationScheduleCopyWith<$Res>(_self.medicationSchedule, (value) {
      return _then(_self.copyWith(medicationSchedule: value));
    });
  }
}

/// @nodoc
mixin _$MedicationGroupScheduleTime {
  int get hour;
  int get minute;

  /// Create a copy of MedicationGroupScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationGroupScheduleTimeCopyWith<MedicationGroupScheduleTime> get copyWith =>
      _$MedicationGroupScheduleTimeCopyWithImpl<MedicationGroupScheduleTime>(this as MedicationGroupScheduleTime, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationGroupScheduleTime &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  @override
  String toString() {
    return 'MedicationGroupScheduleTime(hour: $hour, minute: $minute)';
  }
}

/// @nodoc
abstract mixin class $MedicationGroupScheduleTimeCopyWith<$Res> {
  factory $MedicationGroupScheduleTimeCopyWith(MedicationGroupScheduleTime value, $Res Function(MedicationGroupScheduleTime) _then) =
      _$MedicationGroupScheduleTimeCopyWithImpl;
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class _$MedicationGroupScheduleTimeCopyWithImpl<$Res> implements $MedicationGroupScheduleTimeCopyWith<$Res> {
  _$MedicationGroupScheduleTimeCopyWithImpl(this._self, this._then);

  final MedicationGroupScheduleTime _self;
  final $Res Function(MedicationGroupScheduleTime) _then;

  /// Create a copy of MedicationGroupScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_self.copyWith(
      hour: null == hour
          ? _self.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _self.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicationGroupScheduleTime].
extension MedicationGroupScheduleTimePatterns on MedicationGroupScheduleTime {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MedicationGroupScheduleTime value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleTime() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_MedicationGroupScheduleTime value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleTime():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MedicationGroupScheduleTime value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleTime() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int hour, int minute)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleTime() when $default != null:
        return $default(_that.hour, _that.minute);
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
  TResult when<TResult extends Object?>(
    TResult Function(int hour, int minute) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleTime():
        return $default(_that.hour, _that.minute);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int hour, int minute)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationGroupScheduleTime() when $default != null:
        return $default(_that.hour, _that.minute);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MedicationGroupScheduleTime extends MedicationGroupScheduleTime {
  const _MedicationGroupScheduleTime({required this.hour, required this.minute}) : super._();

  @override
  final int hour;
  @override
  final int minute;

  /// Create a copy of MedicationGroupScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationGroupScheduleTimeCopyWith<_MedicationGroupScheduleTime> get copyWith =>
      __$MedicationGroupScheduleTimeCopyWithImpl<_MedicationGroupScheduleTime>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationGroupScheduleTime &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  @override
  String toString() {
    return 'MedicationGroupScheduleTime(hour: $hour, minute: $minute)';
  }
}

/// @nodoc
abstract mixin class _$MedicationGroupScheduleTimeCopyWith<$Res> implements $MedicationGroupScheduleTimeCopyWith<$Res> {
  factory _$MedicationGroupScheduleTimeCopyWith(_MedicationGroupScheduleTime value, $Res Function(_MedicationGroupScheduleTime) _then) =
      __$MedicationGroupScheduleTimeCopyWithImpl;
  @override
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class __$MedicationGroupScheduleTimeCopyWithImpl<$Res> implements _$MedicationGroupScheduleTimeCopyWith<$Res> {
  __$MedicationGroupScheduleTimeCopyWithImpl(this._self, this._then);

  final _MedicationGroupScheduleTime _self;
  final $Res Function(_MedicationGroupScheduleTime) _then;

  /// Create a copy of MedicationGroupScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_MedicationGroupScheduleTime(
      hour: null == hour
          ? _self.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _self.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
