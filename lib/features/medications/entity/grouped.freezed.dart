// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MedicineTileValue {
  ScheduleTime get scheduleTime => throw _privateConstructorUsedError;
  DoseReceiver get doseReceiver => throw _privateConstructorUsedError;
  List<MedicineDosingRowValue> get dosingRows => throw _privateConstructorUsedError;

  /// Create a copy of MedicineTileValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineTileValueCopyWith<MedicineTileValue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineTileValueCopyWith<$Res> {
  factory $MedicineTileValueCopyWith(MedicineTileValue value, $Res Function(MedicineTileValue) then) =
      _$MedicineTileValueCopyWithImpl<$Res, MedicineTileValue>;
  @useResult
  $Res call({ScheduleTime scheduleTime, DoseReceiver doseReceiver, List<MedicineDosingRowValue> dosingRows});

  $ScheduleTimeCopyWith<$Res> get scheduleTime;
  $DoseReceiverCopyWith<$Res> get doseReceiver;
}

/// @nodoc
class _$MedicineTileValueCopyWithImpl<$Res, $Val extends MedicineTileValue> implements $MedicineTileValueCopyWith<$Res> {
  _$MedicineTileValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineTileValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleTime = null,
    Object? doseReceiver = null,
    Object? dosingRows = null,
  }) {
    return _then(_value.copyWith(
      scheduleTime: null == scheduleTime
          ? _value.scheduleTime
          : scheduleTime // ignore: cast_nullable_to_non_nullable
              as ScheduleTime,
      doseReceiver: null == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      dosingRows: null == dosingRows
          ? _value.dosingRows
          : dosingRows // ignore: cast_nullable_to_non_nullable
              as List<MedicineDosingRowValue>,
    ) as $Val);
  }

  /// Create a copy of MedicineTileValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScheduleTimeCopyWith<$Res> get scheduleTime {
    return $ScheduleTimeCopyWith<$Res>(_value.scheduleTime, (value) {
      return _then(_value.copyWith(scheduleTime: value) as $Val);
    });
  }

  /// Create a copy of MedicineTileValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DoseReceiverCopyWith<$Res> get doseReceiver {
    return $DoseReceiverCopyWith<$Res>(_value.doseReceiver, (value) {
      return _then(_value.copyWith(doseReceiver: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicineTileValueImplCopyWith<$Res> implements $MedicineTileValueCopyWith<$Res> {
  factory _$$MedicineTileValueImplCopyWith(_$MedicineTileValueImpl value, $Res Function(_$MedicineTileValueImpl) then) =
      __$$MedicineTileValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ScheduleTime scheduleTime, DoseReceiver doseReceiver, List<MedicineDosingRowValue> dosingRows});

  @override
  $ScheduleTimeCopyWith<$Res> get scheduleTime;
  @override
  $DoseReceiverCopyWith<$Res> get doseReceiver;
}

/// @nodoc
class __$$MedicineTileValueImplCopyWithImpl<$Res> extends _$MedicineTileValueCopyWithImpl<$Res, _$MedicineTileValueImpl>
    implements _$$MedicineTileValueImplCopyWith<$Res> {
  __$$MedicineTileValueImplCopyWithImpl(_$MedicineTileValueImpl _value, $Res Function(_$MedicineTileValueImpl) _then) : super(_value, _then);

  /// Create a copy of MedicineTileValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleTime = null,
    Object? doseReceiver = null,
    Object? dosingRows = null,
  }) {
    return _then(_$MedicineTileValueImpl(
      scheduleTime: null == scheduleTime
          ? _value.scheduleTime
          : scheduleTime // ignore: cast_nullable_to_non_nullable
              as ScheduleTime,
      doseReceiver: null == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      dosingRows: null == dosingRows
          ? _value._dosingRows
          : dosingRows // ignore: cast_nullable_to_non_nullable
              as List<MedicineDosingRowValue>,
    ));
  }
}

/// @nodoc

class _$MedicineTileValueImpl implements _MedicineTileValue {
  const _$MedicineTileValueImpl({required this.scheduleTime, required this.doseReceiver, required final List<MedicineDosingRowValue> dosingRows})
      : _dosingRows = dosingRows;

  @override
  final ScheduleTime scheduleTime;
  @override
  final DoseReceiver doseReceiver;
  final List<MedicineDosingRowValue> _dosingRows;
  @override
  List<MedicineDosingRowValue> get dosingRows {
    if (_dosingRows is EqualUnmodifiableListView) return _dosingRows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dosingRows);
  }

  @override
  String toString() {
    return 'MedicineTileValue(scheduleTime: $scheduleTime, doseReceiver: $doseReceiver, dosingRows: $dosingRows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineTileValueImpl &&
            (identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime) &&
            (identical(other.doseReceiver, doseReceiver) || other.doseReceiver == doseReceiver) &&
            const DeepCollectionEquality().equals(other._dosingRows, _dosingRows));
  }

  @override
  int get hashCode => Object.hash(runtimeType, scheduleTime, doseReceiver, const DeepCollectionEquality().hash(_dosingRows));

  /// Create a copy of MedicineTileValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineTileValueImplCopyWith<_$MedicineTileValueImpl> get copyWith =>
      __$$MedicineTileValueImplCopyWithImpl<_$MedicineTileValueImpl>(this, _$identity);
}

abstract class _MedicineTileValue implements MedicineTileValue {
  const factory _MedicineTileValue(
      {required final ScheduleTime scheduleTime,
      required final DoseReceiver doseReceiver,
      required final List<MedicineDosingRowValue> dosingRows}) = _$MedicineTileValueImpl;

  @override
  ScheduleTime get scheduleTime;
  @override
  DoseReceiver get doseReceiver;
  @override
  List<MedicineDosingRowValue> get dosingRows;

  /// Create a copy of MedicineTileValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineTileValueImplCopyWith<_$MedicineTileValueImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MedicineDosingRowValue {
  MedicationHistory? get medicationHistory => throw _privateConstructorUsedError;
  Medicine get medicine => throw _privateConstructorUsedError;
  MedicationSchedule get medicationSchedule => throw _privateConstructorUsedError;
  String get quantityMemo => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  /// Create a copy of MedicineDosingRowValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineDosingRowValueCopyWith<MedicineDosingRowValue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineDosingRowValueCopyWith<$Res> {
  factory $MedicineDosingRowValueCopyWith(MedicineDosingRowValue value, $Res Function(MedicineDosingRowValue) then) =
      _$MedicineDosingRowValueCopyWithImpl<$Res, MedicineDosingRowValue>;
  @useResult
  $Res call({MedicationHistory? medicationHistory, Medicine medicine, MedicationSchedule medicationSchedule, String quantityMemo, DateTime date});

  $MedicationHistoryCopyWith<$Res>? get medicationHistory;
  $MedicineCopyWith<$Res> get medicine;
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class _$MedicineDosingRowValueCopyWithImpl<$Res, $Val extends MedicineDosingRowValue> implements $MedicineDosingRowValueCopyWith<$Res> {
  _$MedicineDosingRowValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineDosingRowValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicationHistory = freezed,
    Object? medicine = null,
    Object? medicationSchedule = null,
    Object? quantityMemo = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      medicationHistory: freezed == medicationHistory
          ? _value.medicationHistory
          : medicationHistory // ignore: cast_nullable_to_non_nullable
              as MedicationHistory?,
      medicine: null == medicine
          ? _value.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medicine,
      medicationSchedule: null == medicationSchedule
          ? _value.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
      quantityMemo: null == quantityMemo
          ? _value.quantityMemo
          : quantityMemo // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of MedicineDosingRowValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationHistoryCopyWith<$Res>? get medicationHistory {
    if (_value.medicationHistory == null) {
      return null;
    }

    return $MedicationHistoryCopyWith<$Res>(_value.medicationHistory!, (value) {
      return _then(_value.copyWith(medicationHistory: value) as $Val);
    });
  }

  /// Create a copy of MedicineDosingRowValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineCopyWith<$Res> get medicine {
    return $MedicineCopyWith<$Res>(_value.medicine, (value) {
      return _then(_value.copyWith(medicine: value) as $Val);
    });
  }

  /// Create a copy of MedicineDosingRowValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationScheduleCopyWith<$Res> get medicationSchedule {
    return $MedicationScheduleCopyWith<$Res>(_value.medicationSchedule, (value) {
      return _then(_value.copyWith(medicationSchedule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicineDosingRowValueImplCopyWith<$Res> implements $MedicineDosingRowValueCopyWith<$Res> {
  factory _$$MedicineDosingRowValueImplCopyWith(_$MedicineDosingRowValueImpl value, $Res Function(_$MedicineDosingRowValueImpl) then) =
      __$$MedicineDosingRowValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MedicationHistory? medicationHistory, Medicine medicine, MedicationSchedule medicationSchedule, String quantityMemo, DateTime date});

  @override
  $MedicationHistoryCopyWith<$Res>? get medicationHistory;
  @override
  $MedicineCopyWith<$Res> get medicine;
  @override
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class __$$MedicineDosingRowValueImplCopyWithImpl<$Res> extends _$MedicineDosingRowValueCopyWithImpl<$Res, _$MedicineDosingRowValueImpl>
    implements _$$MedicineDosingRowValueImplCopyWith<$Res> {
  __$$MedicineDosingRowValueImplCopyWithImpl(_$MedicineDosingRowValueImpl _value, $Res Function(_$MedicineDosingRowValueImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineDosingRowValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicationHistory = freezed,
    Object? medicine = null,
    Object? medicationSchedule = null,
    Object? quantityMemo = null,
    Object? date = null,
  }) {
    return _then(_$MedicineDosingRowValueImpl(
      medicationHistory: freezed == medicationHistory
          ? _value.medicationHistory
          : medicationHistory // ignore: cast_nullable_to_non_nullable
              as MedicationHistory?,
      medicine: null == medicine
          ? _value.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medicine,
      medicationSchedule: null == medicationSchedule
          ? _value.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
      quantityMemo: null == quantityMemo
          ? _value.quantityMemo
          : quantityMemo // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$MedicineDosingRowValueImpl extends _MedicineDosingRowValue {
  const _$MedicineDosingRowValueImpl(
      {required this.medicationHistory, required this.medicine, required this.medicationSchedule, required this.quantityMemo, required this.date})
      : super._();

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

  @override
  String toString() {
    return 'MedicineDosingRowValue(medicationHistory: $medicationHistory, medicine: $medicine, medicationSchedule: $medicationSchedule, quantityMemo: $quantityMemo, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineDosingRowValueImpl &&
            (identical(other.medicationHistory, medicationHistory) || other.medicationHistory == medicationHistory) &&
            (identical(other.medicine, medicine) || other.medicine == medicine) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule) &&
            (identical(other.quantityMemo, quantityMemo) || other.quantityMemo == quantityMemo) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, medicationHistory, medicine, medicationSchedule, quantityMemo, date);

  /// Create a copy of MedicineDosingRowValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineDosingRowValueImplCopyWith<_$MedicineDosingRowValueImpl> get copyWith =>
      __$$MedicineDosingRowValueImplCopyWithImpl<_$MedicineDosingRowValueImpl>(this, _$identity);
}

abstract class _MedicineDosingRowValue extends MedicineDosingRowValue {
  const factory _MedicineDosingRowValue(
      {required final MedicationHistory? medicationHistory,
      required final Medicine medicine,
      required final MedicationSchedule medicationSchedule,
      required final String quantityMemo,
      required final DateTime date}) = _$MedicineDosingRowValueImpl;
  const _MedicineDosingRowValue._() : super._();

  @override
  MedicationHistory? get medicationHistory;
  @override
  Medicine get medicine;
  @override
  MedicationSchedule get medicationSchedule;
  @override
  String get quantityMemo;
  @override
  DateTime get date;

  /// Create a copy of MedicineDosingRowValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineDosingRowValueImplCopyWith<_$MedicineDosingRowValueImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScheduleTime {
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleTimeCopyWith<ScheduleTime> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleTimeCopyWith<$Res> {
  factory $ScheduleTimeCopyWith(ScheduleTime value, $Res Function(ScheduleTime) then) = _$ScheduleTimeCopyWithImpl<$Res, ScheduleTime>;
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class _$ScheduleTimeCopyWithImpl<$Res, $Val extends ScheduleTime> implements $ScheduleTimeCopyWith<$Res> {
  _$ScheduleTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_value.copyWith(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleTimeImplCopyWith<$Res> implements $ScheduleTimeCopyWith<$Res> {
  factory _$$ScheduleTimeImplCopyWith(_$ScheduleTimeImpl value, $Res Function(_$ScheduleTimeImpl) then) = __$$ScheduleTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class __$$ScheduleTimeImplCopyWithImpl<$Res> extends _$ScheduleTimeCopyWithImpl<$Res, _$ScheduleTimeImpl>
    implements _$$ScheduleTimeImplCopyWith<$Res> {
  __$$ScheduleTimeImplCopyWithImpl(_$ScheduleTimeImpl _value, $Res Function(_$ScheduleTimeImpl) _then) : super(_value, _then);

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_$ScheduleTimeImpl(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ScheduleTimeImpl extends _ScheduleTime {
  const _$ScheduleTimeImpl({required this.hour, required this.minute}) : super._();

  @override
  final int hour;
  @override
  final int minute;

  @override
  String toString() {
    return 'ScheduleTime(hour: $hour, minute: $minute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleTimeImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleTimeImplCopyWith<_$ScheduleTimeImpl> get copyWith => __$$ScheduleTimeImplCopyWithImpl<_$ScheduleTimeImpl>(this, _$identity);
}

abstract class _ScheduleTime extends ScheduleTime {
  const factory _ScheduleTime({required final int hour, required final int minute}) = _$ScheduleTimeImpl;
  const _ScheduleTime._() : super._();

  @override
  int get hour;
  @override
  int get minute;

  /// Create a copy of ScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleTimeImplCopyWith<_$ScheduleTimeImpl> get copyWith => throw _privateConstructorUsedError;
}
