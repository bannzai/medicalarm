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
mixin _$MedicationGroup {
  String get id => throw _privateConstructorUsedError;
  MedicationGroupScheduleTime get scheduleTime => throw _privateConstructorUsedError;
  DoseReceiver get doseReceiver => throw _privateConstructorUsedError;
  List<MedicationGroupScheduleRow> get scheduleRows => throw _privateConstructorUsedError;

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicationGroupCopyWith<MedicationGroup> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationGroupCopyWith<$Res> {
  factory $MedicationGroupCopyWith(MedicationGroup value, $Res Function(MedicationGroup) then) = _$MedicationGroupCopyWithImpl<$Res, MedicationGroup>;
  @useResult
  $Res call({String id, MedicationGroupScheduleTime scheduleTime, DoseReceiver doseReceiver, List<MedicationGroupScheduleRow> scheduleRows});

  $MedicationGroupScheduleTimeCopyWith<$Res> get scheduleTime;
  $DoseReceiverCopyWith<$Res> get doseReceiver;
}

/// @nodoc
class _$MedicationGroupCopyWithImpl<$Res, $Val extends MedicationGroup> implements $MedicationGroupCopyWith<$Res> {
  _$MedicationGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleTime: null == scheduleTime
          ? _value.scheduleTime
          : scheduleTime // ignore: cast_nullable_to_non_nullable
              as MedicationGroupScheduleTime,
      doseReceiver: null == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      scheduleRows: null == scheduleRows
          ? _value.scheduleRows
          : scheduleRows // ignore: cast_nullable_to_non_nullable
              as List<MedicationGroupScheduleRow>,
    ) as $Val);
  }

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationGroupScheduleTimeCopyWith<$Res> get scheduleTime {
    return $MedicationGroupScheduleTimeCopyWith<$Res>(_value.scheduleTime, (value) {
      return _then(_value.copyWith(scheduleTime: value) as $Val);
    });
  }

  /// Create a copy of MedicationGroup
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
abstract class _$$MedicationGroupImplCopyWith<$Res> implements $MedicationGroupCopyWith<$Res> {
  factory _$$MedicationGroupImplCopyWith(_$MedicationGroupImpl value, $Res Function(_$MedicationGroupImpl) then) =
      __$$MedicationGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, MedicationGroupScheduleTime scheduleTime, DoseReceiver doseReceiver, List<MedicationGroupScheduleRow> scheduleRows});

  @override
  $MedicationGroupScheduleTimeCopyWith<$Res> get scheduleTime;
  @override
  $DoseReceiverCopyWith<$Res> get doseReceiver;
}

/// @nodoc
class __$$MedicationGroupImplCopyWithImpl<$Res> extends _$MedicationGroupCopyWithImpl<$Res, _$MedicationGroupImpl>
    implements _$$MedicationGroupImplCopyWith<$Res> {
  __$$MedicationGroupImplCopyWithImpl(_$MedicationGroupImpl _value, $Res Function(_$MedicationGroupImpl) _then) : super(_value, _then);

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
    return _then(_$MedicationGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      scheduleTime: null == scheduleTime
          ? _value.scheduleTime
          : scheduleTime // ignore: cast_nullable_to_non_nullable
              as MedicationGroupScheduleTime,
      doseReceiver: null == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      scheduleRows: null == scheduleRows
          ? _value._scheduleRows
          : scheduleRows // ignore: cast_nullable_to_non_nullable
              as List<MedicationGroupScheduleRow>,
    ));
  }
}

/// @nodoc

class _$MedicationGroupImpl implements _MedicationGroup {
  const _$MedicationGroupImpl(
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

  @override
  String toString() {
    return 'MedicationGroup(id: $id, scheduleTime: $scheduleTime, doseReceiver: $doseReceiver, scheduleRows: $scheduleRows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.scheduleTime, scheduleTime) || other.scheduleTime == scheduleTime) &&
            (identical(other.doseReceiver, doseReceiver) || other.doseReceiver == doseReceiver) &&
            const DeepCollectionEquality().equals(other._scheduleRows, _scheduleRows));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, scheduleTime, doseReceiver, const DeepCollectionEquality().hash(_scheduleRows));

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicationGroupImplCopyWith<_$MedicationGroupImpl> get copyWith => __$$MedicationGroupImplCopyWithImpl<_$MedicationGroupImpl>(this, _$identity);
}

abstract class _MedicationGroup implements MedicationGroup {
  const factory _MedicationGroup(
      {required final String id,
      required final MedicationGroupScheduleTime scheduleTime,
      required final DoseReceiver doseReceiver,
      required final List<MedicationGroupScheduleRow> scheduleRows}) = _$MedicationGroupImpl;

  @override
  String get id;
  @override
  MedicationGroupScheduleTime get scheduleTime;
  @override
  DoseReceiver get doseReceiver;
  @override
  List<MedicationGroupScheduleRow> get scheduleRows;

  /// Create a copy of MedicationGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicationGroupImplCopyWith<_$MedicationGroupImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MedicationGroupScheduleRow {
  String get id => throw _privateConstructorUsedError;
  MedicationHistory? get medicationHistory => throw _privateConstructorUsedError;
  Medicine get medicine => throw _privateConstructorUsedError;
  MedicationSchedule get medicationSchedule => throw _privateConstructorUsedError;
  String get quantityMemo => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicationGroupScheduleRowCopyWith<MedicationGroupScheduleRow> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationGroupScheduleRowCopyWith<$Res> {
  factory $MedicationGroupScheduleRowCopyWith(MedicationGroupScheduleRow value, $Res Function(MedicationGroupScheduleRow) then) =
      _$MedicationGroupScheduleRowCopyWithImpl<$Res, MedicationGroupScheduleRow>;
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
class _$MedicationGroupScheduleRowCopyWithImpl<$Res, $Val extends MedicationGroupScheduleRow> implements $MedicationGroupScheduleRowCopyWith<$Res> {
  _$MedicationGroupScheduleRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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

  /// Create a copy of MedicationGroupScheduleRow
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

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineCopyWith<$Res> get medicine {
    return $MedicineCopyWith<$Res>(_value.medicine, (value) {
      return _then(_value.copyWith(medicine: value) as $Val);
    });
  }

  /// Create a copy of MedicationGroupScheduleRow
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
abstract class _$$MedicationGroupScheduleRowImplCopyWith<$Res> implements $MedicationGroupScheduleRowCopyWith<$Res> {
  factory _$$MedicationGroupScheduleRowImplCopyWith(_$MedicationGroupScheduleRowImpl value, $Res Function(_$MedicationGroupScheduleRowImpl) then) =
      __$$MedicationGroupScheduleRowImplCopyWithImpl<$Res>;
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
class __$$MedicationGroupScheduleRowImplCopyWithImpl<$Res> extends _$MedicationGroupScheduleRowCopyWithImpl<$Res, _$MedicationGroupScheduleRowImpl>
    implements _$$MedicationGroupScheduleRowImplCopyWith<$Res> {
  __$$MedicationGroupScheduleRowImplCopyWithImpl(_$MedicationGroupScheduleRowImpl _value, $Res Function(_$MedicationGroupScheduleRowImpl) _then)
      : super(_value, _then);

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
    return _then(_$MedicationGroupScheduleRowImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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

class _$MedicationGroupScheduleRowImpl extends _MedicationGroupScheduleRow {
  const _$MedicationGroupScheduleRowImpl(
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

  @override
  String toString() {
    return 'MedicationGroupScheduleRow(id: $id, medicationHistory: $medicationHistory, medicine: $medicine, medicationSchedule: $medicationSchedule, quantityMemo: $quantityMemo, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationGroupScheduleRowImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.medicationHistory, medicationHistory) || other.medicationHistory == medicationHistory) &&
            (identical(other.medicine, medicine) || other.medicine == medicine) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule) &&
            (identical(other.quantityMemo, quantityMemo) || other.quantityMemo == quantityMemo) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, medicationHistory, medicine, medicationSchedule, quantityMemo, date);

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicationGroupScheduleRowImplCopyWith<_$MedicationGroupScheduleRowImpl> get copyWith =>
      __$$MedicationGroupScheduleRowImplCopyWithImpl<_$MedicationGroupScheduleRowImpl>(this, _$identity);
}

abstract class _MedicationGroupScheduleRow extends MedicationGroupScheduleRow {
  const factory _MedicationGroupScheduleRow(
      {required final String id,
      required final MedicationHistory? medicationHistory,
      required final Medicine medicine,
      required final MedicationSchedule medicationSchedule,
      required final String quantityMemo,
      required final DateTime date}) = _$MedicationGroupScheduleRowImpl;
  const _MedicationGroupScheduleRow._() : super._();

  @override
  String get id;
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

  /// Create a copy of MedicationGroupScheduleRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicationGroupScheduleRowImplCopyWith<_$MedicationGroupScheduleRowImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MedicationGroupScheduleTime {
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;

  /// Create a copy of MedicationGroupScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicationGroupScheduleTimeCopyWith<MedicationGroupScheduleTime> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationGroupScheduleTimeCopyWith<$Res> {
  factory $MedicationGroupScheduleTimeCopyWith(MedicationGroupScheduleTime value, $Res Function(MedicationGroupScheduleTime) then) =
      _$MedicationGroupScheduleTimeCopyWithImpl<$Res, MedicationGroupScheduleTime>;
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class _$MedicationGroupScheduleTimeCopyWithImpl<$Res, $Val extends MedicationGroupScheduleTime>
    implements $MedicationGroupScheduleTimeCopyWith<$Res> {
  _$MedicationGroupScheduleTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicationGroupScheduleTime
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
abstract class _$$MedicationGroupScheduleTimeImplCopyWith<$Res> implements $MedicationGroupScheduleTimeCopyWith<$Res> {
  factory _$$MedicationGroupScheduleTimeImplCopyWith(_$MedicationGroupScheduleTimeImpl value, $Res Function(_$MedicationGroupScheduleTimeImpl) then) =
      __$$MedicationGroupScheduleTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class __$$MedicationGroupScheduleTimeImplCopyWithImpl<$Res> extends _$MedicationGroupScheduleTimeCopyWithImpl<$Res, _$MedicationGroupScheduleTimeImpl>
    implements _$$MedicationGroupScheduleTimeImplCopyWith<$Res> {
  __$$MedicationGroupScheduleTimeImplCopyWithImpl(_$MedicationGroupScheduleTimeImpl _value, $Res Function(_$MedicationGroupScheduleTimeImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationGroupScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_$MedicationGroupScheduleTimeImpl(
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

class _$MedicationGroupScheduleTimeImpl extends _MedicationGroupScheduleTime {
  const _$MedicationGroupScheduleTimeImpl({required this.hour, required this.minute}) : super._();

  @override
  final int hour;
  @override
  final int minute;

  @override
  String toString() {
    return 'MedicationGroupScheduleTime(hour: $hour, minute: $minute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationGroupScheduleTimeImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  /// Create a copy of MedicationGroupScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicationGroupScheduleTimeImplCopyWith<_$MedicationGroupScheduleTimeImpl> get copyWith =>
      __$$MedicationGroupScheduleTimeImplCopyWithImpl<_$MedicationGroupScheduleTimeImpl>(this, _$identity);
}

abstract class _MedicationGroupScheduleTime extends MedicationGroupScheduleTime {
  const factory _MedicationGroupScheduleTime({required final int hour, required final int minute}) = _$MedicationGroupScheduleTimeImpl;
  const _MedicationGroupScheduleTime._() : super._();

  @override
  int get hour;
  @override
  int get minute;

  /// Create a copy of MedicationGroupScheduleTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicationGroupScheduleTimeImplCopyWith<_$MedicationGroupScheduleTimeImpl> get copyWith => throw _privateConstructorUsedError;
}
