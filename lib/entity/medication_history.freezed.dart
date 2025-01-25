// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MedicationHistory _$MedicationHistoryFromJson(Map<String, dynamic> json) {
  return _MedicationHistory.fromJson(json);
}

/// @nodoc
mixin _$MedicationHistory {
  String get id => throw _privateConstructorUsedError;
  String get userID => throw _privateConstructorUsedError;
  Medicine get medicine => throw _privateConstructorUsedError;
  MedicationHistoryActionKind get actionKind => throw _privateConstructorUsedError;
  MedicationHistoryAction get action => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get recordedDateTime => throw _privateConstructorUsedError; // 2025-01-19の服用予定だったのに、2025-01-20に服用した場合、scheduledRecordedDateは2025-01-20になる
  @TimestampConverter()
  DateTime get scheduledRecordedDate => throw _privateConstructorUsedError;
  @ClientCreatedTimestamp()
  DateTime? get createdDateTime => throw _privateConstructorUsedError;
  @ClientUpdatedTimestamp()
  DateTime? get updatedDateTime => throw _privateConstructorUsedError;
  @ServerCreatedTimestamp()
  DateTime? get serverCreatedDateTime => throw _privateConstructorUsedError;
  @ServerUpdatedTimestamp()
  DateTime? get serverUpdatedDateTime => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime get ttlExpiredDateTime => throw _privateConstructorUsedError;

  /// Serializes this MedicationHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicationHistoryCopyWith<MedicationHistory> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationHistoryCopyWith<$Res> {
  factory $MedicationHistoryCopyWith(MedicationHistory value, $Res Function(MedicationHistory) then) =
      _$MedicationHistoryCopyWithImpl<$Res, MedicationHistory>;
  @useResult
  $Res call(
      {String id,
      String userID,
      Medicine medicine,
      MedicationHistoryActionKind actionKind,
      MedicationHistoryAction action,
      String memo,
      @TimestampConverter() DateTime recordedDateTime,
      @TimestampConverter() DateTime scheduledRecordedDate,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
      @NullableTimestampConverter() DateTime ttlExpiredDateTime});

  $MedicineCopyWith<$Res> get medicine;
  $MedicationHistoryActionCopyWith<$Res> get action;
}

/// @nodoc
class _$MedicationHistoryCopyWithImpl<$Res, $Val extends MedicationHistory> implements $MedicationHistoryCopyWith<$Res> {
  _$MedicationHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userID = null,
    Object? medicine = null,
    Object? actionKind = null,
    Object? action = null,
    Object? memo = null,
    Object? recordedDateTime = null,
    Object? scheduledRecordedDate = null,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
    Object? ttlExpiredDateTime = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      medicine: null == medicine
          ? _value.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medicine,
      actionKind: null == actionKind
          ? _value.actionKind
          : actionKind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryAction,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      recordedDateTime: null == recordedDateTime
          ? _value.recordedDateTime
          : recordedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledRecordedDate: null == scheduledRecordedDate
          ? _value.scheduledRecordedDate
          : scheduledRecordedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: freezed == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedDateTime: freezed == updatedDateTime
          ? _value.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverCreatedDateTime: freezed == serverCreatedDateTime
          ? _value.serverCreatedDateTime
          : serverCreatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverUpdatedDateTime: freezed == serverUpdatedDateTime
          ? _value.serverUpdatedDateTime
          : serverUpdatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ttlExpiredDateTime: null == ttlExpiredDateTime
          ? _value.ttlExpiredDateTime
          : ttlExpiredDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineCopyWith<$Res> get medicine {
    return $MedicineCopyWith<$Res>(_value.medicine, (value) {
      return _then(_value.copyWith(medicine: value) as $Val);
    });
  }

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationHistoryActionCopyWith<$Res> get action {
    return $MedicationHistoryActionCopyWith<$Res>(_value.action, (value) {
      return _then(_value.copyWith(action: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicationHistoryImplCopyWith<$Res> implements $MedicationHistoryCopyWith<$Res> {
  factory _$$MedicationHistoryImplCopyWith(_$MedicationHistoryImpl value, $Res Function(_$MedicationHistoryImpl) then) =
      __$$MedicationHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userID,
      Medicine medicine,
      MedicationHistoryActionKind actionKind,
      MedicationHistoryAction action,
      String memo,
      @TimestampConverter() DateTime recordedDateTime,
      @TimestampConverter() DateTime scheduledRecordedDate,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
      @NullableTimestampConverter() DateTime ttlExpiredDateTime});

  @override
  $MedicineCopyWith<$Res> get medicine;
  @override
  $MedicationHistoryActionCopyWith<$Res> get action;
}

/// @nodoc
class __$$MedicationHistoryImplCopyWithImpl<$Res> extends _$MedicationHistoryCopyWithImpl<$Res, _$MedicationHistoryImpl>
    implements _$$MedicationHistoryImplCopyWith<$Res> {
  __$$MedicationHistoryImplCopyWithImpl(_$MedicationHistoryImpl _value, $Res Function(_$MedicationHistoryImpl) _then) : super(_value, _then);

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userID = null,
    Object? medicine = null,
    Object? actionKind = null,
    Object? action = null,
    Object? memo = null,
    Object? recordedDateTime = null,
    Object? scheduledRecordedDate = null,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
    Object? ttlExpiredDateTime = null,
  }) {
    return _then(_$MedicationHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      medicine: null == medicine
          ? _value.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medicine,
      actionKind: null == actionKind
          ? _value.actionKind
          : actionKind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryAction,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      recordedDateTime: null == recordedDateTime
          ? _value.recordedDateTime
          : recordedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledRecordedDate: null == scheduledRecordedDate
          ? _value.scheduledRecordedDate
          : scheduledRecordedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: freezed == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedDateTime: freezed == updatedDateTime
          ? _value.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverCreatedDateTime: freezed == serverCreatedDateTime
          ? _value.serverCreatedDateTime
          : serverCreatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverUpdatedDateTime: freezed == serverUpdatedDateTime
          ? _value.serverUpdatedDateTime
          : serverUpdatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ttlExpiredDateTime: null == ttlExpiredDateTime
          ? _value.ttlExpiredDateTime
          : ttlExpiredDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicationHistoryImpl extends _MedicationHistory {
  const _$MedicationHistoryImpl(
      {required this.id,
      required this.userID,
      required this.medicine,
      required this.actionKind,
      required this.action,
      required this.memo,
      @TimestampConverter() required this.recordedDateTime,
      @TimestampConverter() required this.scheduledRecordedDate,
      @ClientCreatedTimestamp() this.createdDateTime,
      @ClientUpdatedTimestamp() this.updatedDateTime,
      @ServerCreatedTimestamp() this.serverCreatedDateTime,
      @ServerUpdatedTimestamp() this.serverUpdatedDateTime,
      @NullableTimestampConverter() required this.ttlExpiredDateTime})
      : super._();

  factory _$MedicationHistoryImpl.fromJson(Map<String, dynamic> json) => _$$MedicationHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String userID;
  @override
  final Medicine medicine;
  @override
  final MedicationHistoryActionKind actionKind;
  @override
  final MedicationHistoryAction action;
  @override
  final String memo;
  @override
  @TimestampConverter()
  final DateTime recordedDateTime;
// 2025-01-19の服用予定だったのに、2025-01-20に服用した場合、scheduledRecordedDateは2025-01-20になる
  @override
  @TimestampConverter()
  final DateTime scheduledRecordedDate;
  @override
  @ClientCreatedTimestamp()
  final DateTime? createdDateTime;
  @override
  @ClientUpdatedTimestamp()
  final DateTime? updatedDateTime;
  @override
  @ServerCreatedTimestamp()
  final DateTime? serverCreatedDateTime;
  @override
  @ServerUpdatedTimestamp()
  final DateTime? serverUpdatedDateTime;
  @override
  @NullableTimestampConverter()
  final DateTime ttlExpiredDateTime;

  @override
  String toString() {
    return 'MedicationHistory(id: $id, userID: $userID, medicine: $medicine, actionKind: $actionKind, action: $action, memo: $memo, recordedDateTime: $recordedDateTime, scheduledRecordedDate: $scheduledRecordedDate, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime, ttlExpiredDateTime: $ttlExpiredDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.medicine, medicine) || other.medicine == medicine) &&
            (identical(other.actionKind, actionKind) || other.actionKind == actionKind) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.recordedDateTime, recordedDateTime) || other.recordedDateTime == recordedDateTime) &&
            (identical(other.scheduledRecordedDate, scheduledRecordedDate) || other.scheduledRecordedDate == scheduledRecordedDate) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime) &&
            (identical(other.ttlExpiredDateTime, ttlExpiredDateTime) || other.ttlExpiredDateTime == ttlExpiredDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userID, medicine, actionKind, action, memo, recordedDateTime, scheduledRecordedDate,
      createdDateTime, updatedDateTime, serverCreatedDateTime, serverUpdatedDateTime, ttlExpiredDateTime);

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicationHistoryImplCopyWith<_$MedicationHistoryImpl> get copyWith =>
      __$$MedicationHistoryImplCopyWithImpl<_$MedicationHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicationHistoryImplToJson(
      this,
    );
  }
}

abstract class _MedicationHistory extends MedicationHistory {
  const factory _MedicationHistory(
      {required final String id,
      required final String userID,
      required final Medicine medicine,
      required final MedicationHistoryActionKind actionKind,
      required final MedicationHistoryAction action,
      required final String memo,
      @TimestampConverter() required final DateTime recordedDateTime,
      @TimestampConverter() required final DateTime scheduledRecordedDate,
      @ClientCreatedTimestamp() final DateTime? createdDateTime,
      @ClientUpdatedTimestamp() final DateTime? updatedDateTime,
      @ServerCreatedTimestamp() final DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() final DateTime? serverUpdatedDateTime,
      @NullableTimestampConverter() required final DateTime ttlExpiredDateTime}) = _$MedicationHistoryImpl;
  const _MedicationHistory._() : super._();

  factory _MedicationHistory.fromJson(Map<String, dynamic> json) = _$MedicationHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get userID;
  @override
  Medicine get medicine;
  @override
  MedicationHistoryActionKind get actionKind;
  @override
  MedicationHistoryAction get action;
  @override
  String get memo;
  @override
  @TimestampConverter()
  DateTime get recordedDateTime; // 2025-01-19の服用予定だったのに、2025-01-20に服用した場合、scheduledRecordedDateは2025-01-20になる
  @override
  @TimestampConverter()
  DateTime get scheduledRecordedDate;
  @override
  @ClientCreatedTimestamp()
  DateTime? get createdDateTime;
  @override
  @ClientUpdatedTimestamp()
  DateTime? get updatedDateTime;
  @override
  @ServerCreatedTimestamp()
  DateTime? get serverCreatedDateTime;
  @override
  @ServerUpdatedTimestamp()
  DateTime? get serverUpdatedDateTime;
  @override
  @NullableTimestampConverter()
  DateTime get ttlExpiredDateTime;

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicationHistoryImplCopyWith<_$MedicationHistoryImpl> get copyWith => throw _privateConstructorUsedError;
}

MedicationHistoryAction _$MedicationHistoryActionFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'take':
      return TakeMedicationHistoryAction.fromJson(json);
    case 'revert':
      return RevertMedicationHistoryAction.fromJson(json);
    case 'skip':
      return SkipMedicationHistoryAction.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'MedicationHistoryAction', 'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$MedicationHistoryAction {
  MedicationHistoryActionKind get kind => throw _privateConstructorUsedError;
  MedicationSchedule get medicationSchedule => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)
        take,
    required TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule) revert,
    required TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule) skip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult? Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TakeMedicationHistoryAction value) take,
    required TResult Function(RevertMedicationHistoryAction value) revert,
    required TResult Function(SkipMedicationHistoryAction value) skip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TakeMedicationHistoryAction value)? take,
    TResult? Function(RevertMedicationHistoryAction value)? revert,
    TResult? Function(SkipMedicationHistoryAction value)? skip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TakeMedicationHistoryAction value)? take,
    TResult Function(RevertMedicationHistoryAction value)? revert,
    TResult Function(SkipMedicationHistoryAction value)? skip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MedicationHistoryAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicationHistoryActionCopyWith<MedicationHistoryAction> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationHistoryActionCopyWith<$Res> {
  factory $MedicationHistoryActionCopyWith(MedicationHistoryAction value, $Res Function(MedicationHistoryAction) then) =
      _$MedicationHistoryActionCopyWithImpl<$Res, MedicationHistoryAction>;
  @useResult
  $Res call({MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule});

  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class _$MedicationHistoryActionCopyWithImpl<$Res, $Val extends MedicationHistoryAction> implements $MedicationHistoryActionCopyWith<$Res> {
  _$MedicationHistoryActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? medicationSchedule = null,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      medicationSchedule: null == medicationSchedule
          ? _value.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
    ) as $Val);
  }

  /// Create a copy of MedicationHistoryAction
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
abstract class _$$TakeMedicationHistoryActionImplCopyWith<$Res> implements $MedicationHistoryActionCopyWith<$Res> {
  factory _$$TakeMedicationHistoryActionImplCopyWith(_$TakeMedicationHistoryActionImpl value, $Res Function(_$TakeMedicationHistoryActionImpl) then) =
      __$$TakeMedicationHistoryActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate});

  @override
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class __$$TakeMedicationHistoryActionImplCopyWithImpl<$Res> extends _$MedicationHistoryActionCopyWithImpl<$Res, _$TakeMedicationHistoryActionImpl>
    implements _$$TakeMedicationHistoryActionImplCopyWith<$Res> {
  __$$TakeMedicationHistoryActionImplCopyWithImpl(_$TakeMedicationHistoryActionImpl _value, $Res Function(_$TakeMedicationHistoryActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? medicationSchedule = null,
    Object? scheduledRecordedDate = null,
  }) {
    return _then(_$TakeMedicationHistoryActionImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      medicationSchedule: null == medicationSchedule
          ? _value.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
      scheduledRecordedDate: null == scheduledRecordedDate
          ? _value.scheduledRecordedDate
          : scheduledRecordedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$TakeMedicationHistoryActionImpl extends TakeMedicationHistoryAction {
  const _$TakeMedicationHistoryActionImpl(
      {this.kind = MedicationHistoryActionKind.take,
      required this.medicationSchedule,
      @TimestampConverter() required this.scheduledRecordedDate,
      final String? $type})
      : $type = $type ?? 'take',
        super._();

  factory _$TakeMedicationHistoryActionImpl.fromJson(Map<String, dynamic> json) => _$$TakeMedicationHistoryActionImplFromJson(json);

  @override
  @JsonKey()
  final MedicationHistoryActionKind kind;
  @override
  final MedicationSchedule medicationSchedule;
// 2025-01-19の服用予定だったのに、2025-01-20に服用した場合、scheduledRecordedDateは2025-01-20になる
  @override
  @TimestampConverter()
  final DateTime scheduledRecordedDate;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationHistoryAction.take(kind: $kind, medicationSchedule: $medicationSchedule, scheduledRecordedDate: $scheduledRecordedDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TakeMedicationHistoryActionImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule) &&
            (identical(other.scheduledRecordedDate, scheduledRecordedDate) || other.scheduledRecordedDate == scheduledRecordedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, medicationSchedule, scheduledRecordedDate);

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TakeMedicationHistoryActionImplCopyWith<_$TakeMedicationHistoryActionImpl> get copyWith =>
      __$$TakeMedicationHistoryActionImplCopyWithImpl<_$TakeMedicationHistoryActionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)
        take,
    required TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule) revert,
    required TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule) skip,
  }) {
    return take(kind, medicationSchedule, scheduledRecordedDate);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult? Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
  }) {
    return take?.call(kind, medicationSchedule, scheduledRecordedDate);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
    required TResult orElse(),
  }) {
    if (take != null) {
      return take(kind, medicationSchedule, scheduledRecordedDate);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TakeMedicationHistoryAction value) take,
    required TResult Function(RevertMedicationHistoryAction value) revert,
    required TResult Function(SkipMedicationHistoryAction value) skip,
  }) {
    return take(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TakeMedicationHistoryAction value)? take,
    TResult? Function(RevertMedicationHistoryAction value)? revert,
    TResult? Function(SkipMedicationHistoryAction value)? skip,
  }) {
    return take?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TakeMedicationHistoryAction value)? take,
    TResult Function(RevertMedicationHistoryAction value)? revert,
    TResult Function(SkipMedicationHistoryAction value)? skip,
    required TResult orElse(),
  }) {
    if (take != null) {
      return take(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TakeMedicationHistoryActionImplToJson(
      this,
    );
  }
}

abstract class TakeMedicationHistoryAction extends MedicationHistoryAction {
  const factory TakeMedicationHistoryAction(
      {final MedicationHistoryActionKind kind,
      required final MedicationSchedule medicationSchedule,
      @TimestampConverter() required final DateTime scheduledRecordedDate}) = _$TakeMedicationHistoryActionImpl;
  const TakeMedicationHistoryAction._() : super._();

  factory TakeMedicationHistoryAction.fromJson(Map<String, dynamic> json) = _$TakeMedicationHistoryActionImpl.fromJson;

  @override
  MedicationHistoryActionKind get kind;
  @override
  MedicationSchedule get medicationSchedule; // 2025-01-19の服用予定だったのに、2025-01-20に服用した場合、scheduledRecordedDateは2025-01-20になる
  @TimestampConverter()
  DateTime get scheduledRecordedDate;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TakeMedicationHistoryActionImplCopyWith<_$TakeMedicationHistoryActionImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RevertMedicationHistoryActionImplCopyWith<$Res> implements $MedicationHistoryActionCopyWith<$Res> {
  factory _$$RevertMedicationHistoryActionImplCopyWith(
          _$RevertMedicationHistoryActionImpl value, $Res Function(_$RevertMedicationHistoryActionImpl) then) =
      __$$RevertMedicationHistoryActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule});

  $MedicationHistoryCopyWith<$Res> get takeAction;
  @override
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class __$$RevertMedicationHistoryActionImplCopyWithImpl<$Res> extends _$MedicationHistoryActionCopyWithImpl<$Res, _$RevertMedicationHistoryActionImpl>
    implements _$$RevertMedicationHistoryActionImplCopyWith<$Res> {
  __$$RevertMedicationHistoryActionImplCopyWithImpl(
      _$RevertMedicationHistoryActionImpl _value, $Res Function(_$RevertMedicationHistoryActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? takeAction = null,
    Object? medicationSchedule = null,
  }) {
    return _then(_$RevertMedicationHistoryActionImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      takeAction: null == takeAction
          ? _value.takeAction
          : takeAction // ignore: cast_nullable_to_non_nullable
              as MedicationHistory,
      medicationSchedule: null == medicationSchedule
          ? _value.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
    ));
  }

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationHistoryCopyWith<$Res> get takeAction {
    return $MedicationHistoryCopyWith<$Res>(_value.takeAction, (value) {
      return _then(_value.copyWith(takeAction: value));
    });
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$RevertMedicationHistoryActionImpl extends RevertMedicationHistoryAction {
  const _$RevertMedicationHistoryActionImpl(
      {this.kind = MedicationHistoryActionKind.revert, required this.takeAction, required this.medicationSchedule, final String? $type})
      : $type = $type ?? 'revert',
        super._();

  factory _$RevertMedicationHistoryActionImpl.fromJson(Map<String, dynamic> json) => _$$RevertMedicationHistoryActionImplFromJson(json);

  @override
  @JsonKey()
  final MedicationHistoryActionKind kind;
  @override
  final MedicationHistory takeAction;
  @override
  final MedicationSchedule medicationSchedule;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationHistoryAction.revert(kind: $kind, takeAction: $takeAction, medicationSchedule: $medicationSchedule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevertMedicationHistoryActionImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.takeAction, takeAction) || other.takeAction == takeAction) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, takeAction, medicationSchedule);

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevertMedicationHistoryActionImplCopyWith<_$RevertMedicationHistoryActionImpl> get copyWith =>
      __$$RevertMedicationHistoryActionImplCopyWithImpl<_$RevertMedicationHistoryActionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)
        take,
    required TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule) revert,
    required TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule) skip,
  }) {
    return revert(kind, takeAction, medicationSchedule);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult? Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
  }) {
    return revert?.call(kind, takeAction, medicationSchedule);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
    required TResult orElse(),
  }) {
    if (revert != null) {
      return revert(kind, takeAction, medicationSchedule);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TakeMedicationHistoryAction value) take,
    required TResult Function(RevertMedicationHistoryAction value) revert,
    required TResult Function(SkipMedicationHistoryAction value) skip,
  }) {
    return revert(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TakeMedicationHistoryAction value)? take,
    TResult? Function(RevertMedicationHistoryAction value)? revert,
    TResult? Function(SkipMedicationHistoryAction value)? skip,
  }) {
    return revert?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TakeMedicationHistoryAction value)? take,
    TResult Function(RevertMedicationHistoryAction value)? revert,
    TResult Function(SkipMedicationHistoryAction value)? skip,
    required TResult orElse(),
  }) {
    if (revert != null) {
      return revert(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RevertMedicationHistoryActionImplToJson(
      this,
    );
  }
}

abstract class RevertMedicationHistoryAction extends MedicationHistoryAction {
  const factory RevertMedicationHistoryAction(
      {final MedicationHistoryActionKind kind,
      required final MedicationHistory takeAction,
      required final MedicationSchedule medicationSchedule}) = _$RevertMedicationHistoryActionImpl;
  const RevertMedicationHistoryAction._() : super._();

  factory RevertMedicationHistoryAction.fromJson(Map<String, dynamic> json) = _$RevertMedicationHistoryActionImpl.fromJson;

  @override
  MedicationHistoryActionKind get kind;
  MedicationHistory get takeAction;
  @override
  MedicationSchedule get medicationSchedule;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevertMedicationHistoryActionImplCopyWith<_$RevertMedicationHistoryActionImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SkipMedicationHistoryActionImplCopyWith<$Res> implements $MedicationHistoryActionCopyWith<$Res> {
  factory _$$SkipMedicationHistoryActionImplCopyWith(_$SkipMedicationHistoryActionImpl value, $Res Function(_$SkipMedicationHistoryActionImpl) then) =
      __$$SkipMedicationHistoryActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule});

  @override
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class __$$SkipMedicationHistoryActionImplCopyWithImpl<$Res> extends _$MedicationHistoryActionCopyWithImpl<$Res, _$SkipMedicationHistoryActionImpl>
    implements _$$SkipMedicationHistoryActionImplCopyWith<$Res> {
  __$$SkipMedicationHistoryActionImplCopyWithImpl(_$SkipMedicationHistoryActionImpl _value, $Res Function(_$SkipMedicationHistoryActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? medicationSchedule = null,
  }) {
    return _then(_$SkipMedicationHistoryActionImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      medicationSchedule: null == medicationSchedule
          ? _value.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SkipMedicationHistoryActionImpl extends SkipMedicationHistoryAction {
  const _$SkipMedicationHistoryActionImpl({this.kind = MedicationHistoryActionKind.skip, required this.medicationSchedule, final String? $type})
      : $type = $type ?? 'skip',
        super._();

  factory _$SkipMedicationHistoryActionImpl.fromJson(Map<String, dynamic> json) => _$$SkipMedicationHistoryActionImplFromJson(json);

  @override
  @JsonKey()
  final MedicationHistoryActionKind kind;
  @override
  final MedicationSchedule medicationSchedule;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MedicationHistoryAction.skip(kind: $kind, medicationSchedule: $medicationSchedule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkipMedicationHistoryActionImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, medicationSchedule);

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkipMedicationHistoryActionImplCopyWith<_$SkipMedicationHistoryActionImpl> get copyWith =>
      __$$SkipMedicationHistoryActionImplCopyWithImpl<_$SkipMedicationHistoryActionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)
        take,
    required TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule) revert,
    required TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule) skip,
  }) {
    return skip(kind, medicationSchedule);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult? Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
  }) {
    return skip?.call(kind, medicationSchedule);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
    required TResult orElse(),
  }) {
    if (skip != null) {
      return skip(kind, medicationSchedule);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TakeMedicationHistoryAction value) take,
    required TResult Function(RevertMedicationHistoryAction value) revert,
    required TResult Function(SkipMedicationHistoryAction value) skip,
  }) {
    return skip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TakeMedicationHistoryAction value)? take,
    TResult? Function(RevertMedicationHistoryAction value)? revert,
    TResult? Function(SkipMedicationHistoryAction value)? skip,
  }) {
    return skip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TakeMedicationHistoryAction value)? take,
    TResult Function(RevertMedicationHistoryAction value)? revert,
    TResult Function(SkipMedicationHistoryAction value)? skip,
    required TResult orElse(),
  }) {
    if (skip != null) {
      return skip(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SkipMedicationHistoryActionImplToJson(
      this,
    );
  }
}

abstract class SkipMedicationHistoryAction extends MedicationHistoryAction {
  const factory SkipMedicationHistoryAction({final MedicationHistoryActionKind kind, required final MedicationSchedule medicationSchedule}) =
      _$SkipMedicationHistoryActionImpl;
  const SkipMedicationHistoryAction._() : super._();

  factory SkipMedicationHistoryAction.fromJson(Map<String, dynamic> json) = _$SkipMedicationHistoryActionImpl.fromJson;

  @override
  MedicationHistoryActionKind get kind;
  @override
  MedicationSchedule get medicationSchedule;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkipMedicationHistoryActionImplCopyWith<_$SkipMedicationHistoryActionImpl> get copyWith => throw _privateConstructorUsedError;
}
