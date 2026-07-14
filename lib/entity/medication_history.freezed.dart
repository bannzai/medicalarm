// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationHistory {
  String get id; // 作成者(creator)の userID。グループ共有では記録した本人とは限らないため recordedByUserID を別途持つ。
  String get userID; // この記録を実際に行ったユーザーの uid。旧データには存在しないため nullable。新規記録では userID と同じ値が入る。
  String? get recordedByUserID;
  Medicine get medicine;
  MedicationHistoryActionKind get actionKind;
  MedicationHistoryAction get action;
  String get memo;
  @TimestampConverter()
  DateTime get recordedDateTime; // 2025-01-19の服用予定だったのに、2025-01-20に服用した場合、scheduledRecordedDateは2025-01-20になる
  @TimestampConverter()
  DateTime get scheduledRecordedDate;
  @ClientCreatedTimestamp()
  DateTime? get createdDateTime;
  @ClientUpdatedTimestamp()
  DateTime? get updatedDateTime;
  @ServerCreatedTimestamp()
  DateTime? get serverCreatedDateTime;
  @ServerUpdatedTimestamp()
  DateTime? get serverUpdatedDateTime;
  @NullableTimestampConverter()
  DateTime get ttlExpiresDateTime;

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationHistoryCopyWith<MedicationHistory> get copyWith =>
      _$MedicationHistoryCopyWithImpl<MedicationHistory>(this as MedicationHistory, _$identity);

  /// Serializes this MedicationHistory to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationHistory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.recordedByUserID, recordedByUserID) || other.recordedByUserID == recordedByUserID) &&
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
            (identical(other.ttlExpiresDateTime, ttlExpiresDateTime) || other.ttlExpiresDateTime == ttlExpiresDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userID, recordedByUserID, medicine, actionKind, action, memo, recordedDateTime,
      scheduledRecordedDate, createdDateTime, updatedDateTime, serverCreatedDateTime, serverUpdatedDateTime, ttlExpiresDateTime);

  @override
  String toString() {
    return 'MedicationHistory(id: $id, userID: $userID, recordedByUserID: $recordedByUserID, medicine: $medicine, actionKind: $actionKind, action: $action, memo: $memo, recordedDateTime: $recordedDateTime, scheduledRecordedDate: $scheduledRecordedDate, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime, ttlExpiresDateTime: $ttlExpiresDateTime)';
  }
}

/// @nodoc
abstract mixin class $MedicationHistoryCopyWith<$Res> {
  factory $MedicationHistoryCopyWith(MedicationHistory value, $Res Function(MedicationHistory) _then) = _$MedicationHistoryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userID,
      String? recordedByUserID,
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
      @NullableTimestampConverter() DateTime ttlExpiresDateTime});

  $MedicineCopyWith<$Res> get medicine;
  $MedicationHistoryActionCopyWith<$Res> get action;
}

/// @nodoc
class _$MedicationHistoryCopyWithImpl<$Res> implements $MedicationHistoryCopyWith<$Res> {
  _$MedicationHistoryCopyWithImpl(this._self, this._then);

  final MedicationHistory _self;
  final $Res Function(MedicationHistory) _then;

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userID = null,
    Object? recordedByUserID = freezed,
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
    Object? ttlExpiresDateTime = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userID: null == userID
          ? _self.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      recordedByUserID: freezed == recordedByUserID
          ? _self.recordedByUserID
          : recordedByUserID // ignore: cast_nullable_to_non_nullable
              as String?,
      medicine: null == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medicine,
      actionKind: null == actionKind
          ? _self.actionKind
          : actionKind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryAction,
      memo: null == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      recordedDateTime: null == recordedDateTime
          ? _self.recordedDateTime
          : recordedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledRecordedDate: null == scheduledRecordedDate
          ? _self.scheduledRecordedDate
          : scheduledRecordedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: freezed == createdDateTime
          ? _self.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedDateTime: freezed == updatedDateTime
          ? _self.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverCreatedDateTime: freezed == serverCreatedDateTime
          ? _self.serverCreatedDateTime
          : serverCreatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverUpdatedDateTime: freezed == serverUpdatedDateTime
          ? _self.serverUpdatedDateTime
          : serverUpdatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ttlExpiresDateTime: null == ttlExpiresDateTime
          ? _self.ttlExpiresDateTime
          : ttlExpiresDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineCopyWith<$Res> get medicine {
    return $MedicineCopyWith<$Res>(_self.medicine, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationHistoryActionCopyWith<$Res> get action {
    return $MedicationHistoryActionCopyWith<$Res>(_self.action, (value) {
      return _then(_self.copyWith(action: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MedicationHistory].
extension MedicationHistoryPatterns on MedicationHistory {
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
    TResult Function(_MedicationHistory value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationHistory() when $default != null:
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
    TResult Function(_MedicationHistory value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationHistory():
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
    TResult? Function(_MedicationHistory value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationHistory() when $default != null:
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
    TResult Function(
            String id,
            String userID,
            String? recordedByUserID,
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
            @NullableTimestampConverter() DateTime ttlExpiresDateTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationHistory() when $default != null:
        return $default(
            _that.id,
            _that.userID,
            _that.recordedByUserID,
            _that.medicine,
            _that.actionKind,
            _that.action,
            _that.memo,
            _that.recordedDateTime,
            _that.scheduledRecordedDate,
            _that.createdDateTime,
            _that.updatedDateTime,
            _that.serverCreatedDateTime,
            _that.serverUpdatedDateTime,
            _that.ttlExpiresDateTime);
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
    TResult Function(
            String id,
            String userID,
            String? recordedByUserID,
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
            @NullableTimestampConverter() DateTime ttlExpiresDateTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationHistory():
        return $default(
            _that.id,
            _that.userID,
            _that.recordedByUserID,
            _that.medicine,
            _that.actionKind,
            _that.action,
            _that.memo,
            _that.recordedDateTime,
            _that.scheduledRecordedDate,
            _that.createdDateTime,
            _that.updatedDateTime,
            _that.serverCreatedDateTime,
            _that.serverUpdatedDateTime,
            _that.ttlExpiresDateTime);
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
    TResult? Function(
            String id,
            String userID,
            String? recordedByUserID,
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
            @NullableTimestampConverter() DateTime ttlExpiresDateTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationHistory() when $default != null:
        return $default(
            _that.id,
            _that.userID,
            _that.recordedByUserID,
            _that.medicine,
            _that.actionKind,
            _that.action,
            _that.memo,
            _that.recordedDateTime,
            _that.scheduledRecordedDate,
            _that.createdDateTime,
            _that.updatedDateTime,
            _that.serverCreatedDateTime,
            _that.serverUpdatedDateTime,
            _that.ttlExpiresDateTime);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MedicationHistory extends MedicationHistory {
  const _MedicationHistory(
      {required this.id,
      required this.userID,
      this.recordedByUserID,
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
      @NullableTimestampConverter() required this.ttlExpiresDateTime})
      : super._();
  factory _MedicationHistory.fromJson(Map<String, dynamic> json) => _$MedicationHistoryFromJson(json);

  @override
  final String id;
// 作成者(creator)の userID。グループ共有では記録した本人とは限らないため recordedByUserID を別途持つ。
  @override
  final String userID;
// この記録を実際に行ったユーザーの uid。旧データには存在しないため nullable。新規記録では userID と同じ値が入る。
  @override
  final String? recordedByUserID;
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
  final DateTime ttlExpiresDateTime;

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationHistoryCopyWith<_MedicationHistory> get copyWith => __$MedicationHistoryCopyWithImpl<_MedicationHistory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicationHistoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationHistory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.recordedByUserID, recordedByUserID) || other.recordedByUserID == recordedByUserID) &&
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
            (identical(other.ttlExpiresDateTime, ttlExpiresDateTime) || other.ttlExpiresDateTime == ttlExpiresDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userID, recordedByUserID, medicine, actionKind, action, memo, recordedDateTime,
      scheduledRecordedDate, createdDateTime, updatedDateTime, serverCreatedDateTime, serverUpdatedDateTime, ttlExpiresDateTime);

  @override
  String toString() {
    return 'MedicationHistory(id: $id, userID: $userID, recordedByUserID: $recordedByUserID, medicine: $medicine, actionKind: $actionKind, action: $action, memo: $memo, recordedDateTime: $recordedDateTime, scheduledRecordedDate: $scheduledRecordedDate, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime, ttlExpiresDateTime: $ttlExpiresDateTime)';
  }
}

/// @nodoc
abstract mixin class _$MedicationHistoryCopyWith<$Res> implements $MedicationHistoryCopyWith<$Res> {
  factory _$MedicationHistoryCopyWith(_MedicationHistory value, $Res Function(_MedicationHistory) _then) = __$MedicationHistoryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userID,
      String? recordedByUserID,
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
      @NullableTimestampConverter() DateTime ttlExpiresDateTime});

  @override
  $MedicineCopyWith<$Res> get medicine;
  @override
  $MedicationHistoryActionCopyWith<$Res> get action;
}

/// @nodoc
class __$MedicationHistoryCopyWithImpl<$Res> implements _$MedicationHistoryCopyWith<$Res> {
  __$MedicationHistoryCopyWithImpl(this._self, this._then);

  final _MedicationHistory _self;
  final $Res Function(_MedicationHistory) _then;

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userID = null,
    Object? recordedByUserID = freezed,
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
    Object? ttlExpiresDateTime = null,
  }) {
    return _then(_MedicationHistory(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userID: null == userID
          ? _self.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      recordedByUserID: freezed == recordedByUserID
          ? _self.recordedByUserID
          : recordedByUserID // ignore: cast_nullable_to_non_nullable
              as String?,
      medicine: null == medicine
          ? _self.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as Medicine,
      actionKind: null == actionKind
          ? _self.actionKind
          : actionKind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryAction,
      memo: null == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      recordedDateTime: null == recordedDateTime
          ? _self.recordedDateTime
          : recordedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledRecordedDate: null == scheduledRecordedDate
          ? _self.scheduledRecordedDate
          : scheduledRecordedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: freezed == createdDateTime
          ? _self.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedDateTime: freezed == updatedDateTime
          ? _self.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverCreatedDateTime: freezed == serverCreatedDateTime
          ? _self.serverCreatedDateTime
          : serverCreatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverUpdatedDateTime: freezed == serverUpdatedDateTime
          ? _self.serverUpdatedDateTime
          : serverUpdatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ttlExpiresDateTime: null == ttlExpiresDateTime
          ? _self.ttlExpiresDateTime
          : ttlExpiresDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineCopyWith<$Res> get medicine {
    return $MedicineCopyWith<$Res>(_self.medicine, (value) {
      return _then(_self.copyWith(medicine: value));
    });
  }

  /// Create a copy of MedicationHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationHistoryActionCopyWith<$Res> get action {
    return $MedicationHistoryActionCopyWith<$Res>(_self.action, (value) {
      return _then(_self.copyWith(action: value));
    });
  }
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
  MedicationHistoryActionKind get kind;
  MedicationSchedule get medicationSchedule;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationHistoryActionCopyWith<MedicationHistoryAction> get copyWith =>
      _$MedicationHistoryActionCopyWithImpl<MedicationHistoryAction>(this as MedicationHistoryAction, _$identity);

  /// Serializes this MedicationHistoryAction to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationHistoryAction &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, medicationSchedule);

  @override
  String toString() {
    return 'MedicationHistoryAction(kind: $kind, medicationSchedule: $medicationSchedule)';
  }
}

/// @nodoc
abstract mixin class $MedicationHistoryActionCopyWith<$Res> {
  factory $MedicationHistoryActionCopyWith(MedicationHistoryAction value, $Res Function(MedicationHistoryAction) _then) =
      _$MedicationHistoryActionCopyWithImpl;
  @useResult
  $Res call({MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule});

  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class _$MedicationHistoryActionCopyWithImpl<$Res> implements $MedicationHistoryActionCopyWith<$Res> {
  _$MedicationHistoryActionCopyWithImpl(this._self, this._then);

  final MedicationHistoryAction _self;
  final $Res Function(MedicationHistoryAction) _then;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? medicationSchedule = null,
  }) {
    return _then(_self.copyWith(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      medicationSchedule: null == medicationSchedule
          ? _self.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
    ));
  }

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationScheduleCopyWith<$Res> get medicationSchedule {
    return $MedicationScheduleCopyWith<$Res>(_self.medicationSchedule, (value) {
      return _then(_self.copyWith(medicationSchedule: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MedicationHistoryAction].
extension MedicationHistoryActionPatterns on MedicationHistoryAction {
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
    TResult Function(TakeMedicationHistoryAction value)? take,
    TResult Function(RevertMedicationHistoryAction value)? revert,
    TResult Function(SkipMedicationHistoryAction value)? skip,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TakeMedicationHistoryAction() when take != null:
        return take(_that);
      case RevertMedicationHistoryAction() when revert != null:
        return revert(_that);
      case SkipMedicationHistoryAction() when skip != null:
        return skip(_that);
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
    required TResult Function(TakeMedicationHistoryAction value) take,
    required TResult Function(RevertMedicationHistoryAction value) revert,
    required TResult Function(SkipMedicationHistoryAction value) skip,
  }) {
    final _that = this;
    switch (_that) {
      case TakeMedicationHistoryAction():
        return take(_that);
      case RevertMedicationHistoryAction():
        return revert(_that);
      case SkipMedicationHistoryAction():
        return skip(_that);
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
    TResult? Function(TakeMedicationHistoryAction value)? take,
    TResult? Function(RevertMedicationHistoryAction value)? revert,
    TResult? Function(SkipMedicationHistoryAction value)? skip,
  }) {
    final _that = this;
    switch (_that) {
      case TakeMedicationHistoryAction() when take != null:
        return take(_that);
      case RevertMedicationHistoryAction() when revert != null:
        return revert(_that);
      case SkipMedicationHistoryAction() when skip != null:
        return skip(_that);
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
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TakeMedicationHistoryAction() when take != null:
        return take(_that.kind, _that.medicationSchedule, _that.scheduledRecordedDate);
      case RevertMedicationHistoryAction() when revert != null:
        return revert(_that.kind, _that.takeAction, _that.medicationSchedule);
      case SkipMedicationHistoryAction() when skip != null:
        return skip(_that.kind, _that.medicationSchedule);
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
    required TResult Function(
            MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)
        take,
    required TResult Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule) revert,
    required TResult Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule) skip,
  }) {
    final _that = this;
    switch (_that) {
      case TakeMedicationHistoryAction():
        return take(_that.kind, _that.medicationSchedule, _that.scheduledRecordedDate);
      case RevertMedicationHistoryAction():
        return revert(_that.kind, _that.takeAction, _that.medicationSchedule);
      case SkipMedicationHistoryAction():
        return skip(_that.kind, _that.medicationSchedule);
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
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate)?
        take,
    TResult? Function(MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule)? revert,
    TResult? Function(MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule)? skip,
  }) {
    final _that = this;
    switch (_that) {
      case TakeMedicationHistoryAction() when take != null:
        return take(_that.kind, _that.medicationSchedule, _that.scheduledRecordedDate);
      case RevertMedicationHistoryAction() when revert != null:
        return revert(_that.kind, _that.takeAction, _that.medicationSchedule);
      case SkipMedicationHistoryAction() when skip != null:
        return skip(_that.kind, _that.medicationSchedule);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class TakeMedicationHistoryAction extends MedicationHistoryAction {
  const TakeMedicationHistoryAction(
      {this.kind = MedicationHistoryActionKind.take,
      required this.medicationSchedule,
      @TimestampConverter() required this.scheduledRecordedDate,
      final String? $type})
      : $type = $type ?? 'take',
        super._();
  factory TakeMedicationHistoryAction.fromJson(Map<String, dynamic> json) => _$TakeMedicationHistoryActionFromJson(json);

  @override
  @JsonKey()
  final MedicationHistoryActionKind kind;
  @override
  final MedicationSchedule medicationSchedule;
// 2025-01-19の服用予定だったのに、2025-01-20に服用した場合、scheduledRecordedDateは2025-01-20になる
  @TimestampConverter()
  final DateTime scheduledRecordedDate;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TakeMedicationHistoryActionCopyWith<TakeMedicationHistoryAction> get copyWith =>
      _$TakeMedicationHistoryActionCopyWithImpl<TakeMedicationHistoryAction>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TakeMedicationHistoryActionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TakeMedicationHistoryAction &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule) &&
            (identical(other.scheduledRecordedDate, scheduledRecordedDate) || other.scheduledRecordedDate == scheduledRecordedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, medicationSchedule, scheduledRecordedDate);

  @override
  String toString() {
    return 'MedicationHistoryAction.take(kind: $kind, medicationSchedule: $medicationSchedule, scheduledRecordedDate: $scheduledRecordedDate)';
  }
}

/// @nodoc
abstract mixin class $TakeMedicationHistoryActionCopyWith<$Res> implements $MedicationHistoryActionCopyWith<$Res> {
  factory $TakeMedicationHistoryActionCopyWith(TakeMedicationHistoryAction value, $Res Function(TakeMedicationHistoryAction) _then) =
      _$TakeMedicationHistoryActionCopyWithImpl;
  @override
  @useResult
  $Res call({MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule, @TimestampConverter() DateTime scheduledRecordedDate});

  @override
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class _$TakeMedicationHistoryActionCopyWithImpl<$Res> implements $TakeMedicationHistoryActionCopyWith<$Res> {
  _$TakeMedicationHistoryActionCopyWithImpl(this._self, this._then);

  final TakeMedicationHistoryAction _self;
  final $Res Function(TakeMedicationHistoryAction) _then;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kind = null,
    Object? medicationSchedule = null,
    Object? scheduledRecordedDate = null,
  }) {
    return _then(TakeMedicationHistoryAction(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      medicationSchedule: null == medicationSchedule
          ? _self.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
      scheduledRecordedDate: null == scheduledRecordedDate
          ? _self.scheduledRecordedDate
          : scheduledRecordedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of MedicationHistoryAction
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

@JsonSerializable(explicitToJson: true)
class RevertMedicationHistoryAction extends MedicationHistoryAction {
  const RevertMedicationHistoryAction(
      {this.kind = MedicationHistoryActionKind.revert, required this.takeAction, required this.medicationSchedule, final String? $type})
      : $type = $type ?? 'revert',
        super._();
  factory RevertMedicationHistoryAction.fromJson(Map<String, dynamic> json) => _$RevertMedicationHistoryActionFromJson(json);

  @override
  @JsonKey()
  final MedicationHistoryActionKind kind;
  final MedicationHistory takeAction;
  @override
  final MedicationSchedule medicationSchedule;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RevertMedicationHistoryActionCopyWith<RevertMedicationHistoryAction> get copyWith =>
      _$RevertMedicationHistoryActionCopyWithImpl<RevertMedicationHistoryAction>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RevertMedicationHistoryActionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RevertMedicationHistoryAction &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.takeAction, takeAction) || other.takeAction == takeAction) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, takeAction, medicationSchedule);

  @override
  String toString() {
    return 'MedicationHistoryAction.revert(kind: $kind, takeAction: $takeAction, medicationSchedule: $medicationSchedule)';
  }
}

/// @nodoc
abstract mixin class $RevertMedicationHistoryActionCopyWith<$Res> implements $MedicationHistoryActionCopyWith<$Res> {
  factory $RevertMedicationHistoryActionCopyWith(RevertMedicationHistoryAction value, $Res Function(RevertMedicationHistoryAction) _then) =
      _$RevertMedicationHistoryActionCopyWithImpl;
  @override
  @useResult
  $Res call({MedicationHistoryActionKind kind, MedicationHistory takeAction, MedicationSchedule medicationSchedule});

  $MedicationHistoryCopyWith<$Res> get takeAction;
  @override
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class _$RevertMedicationHistoryActionCopyWithImpl<$Res> implements $RevertMedicationHistoryActionCopyWith<$Res> {
  _$RevertMedicationHistoryActionCopyWithImpl(this._self, this._then);

  final RevertMedicationHistoryAction _self;
  final $Res Function(RevertMedicationHistoryAction) _then;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kind = null,
    Object? takeAction = null,
    Object? medicationSchedule = null,
  }) {
    return _then(RevertMedicationHistoryAction(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      takeAction: null == takeAction
          ? _self.takeAction
          : takeAction // ignore: cast_nullable_to_non_nullable
              as MedicationHistory,
      medicationSchedule: null == medicationSchedule
          ? _self.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
    ));
  }

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationHistoryCopyWith<$Res> get takeAction {
    return $MedicationHistoryCopyWith<$Res>(_self.takeAction, (value) {
      return _then(_self.copyWith(takeAction: value));
    });
  }

  /// Create a copy of MedicationHistoryAction
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

@JsonSerializable(explicitToJson: true)
class SkipMedicationHistoryAction extends MedicationHistoryAction {
  const SkipMedicationHistoryAction({this.kind = MedicationHistoryActionKind.skip, required this.medicationSchedule, final String? $type})
      : $type = $type ?? 'skip',
        super._();
  factory SkipMedicationHistoryAction.fromJson(Map<String, dynamic> json) => _$SkipMedicationHistoryActionFromJson(json);

  @override
  @JsonKey()
  final MedicationHistoryActionKind kind;
  @override
  final MedicationSchedule medicationSchedule;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SkipMedicationHistoryActionCopyWith<SkipMedicationHistoryAction> get copyWith =>
      _$SkipMedicationHistoryActionCopyWithImpl<SkipMedicationHistoryAction>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SkipMedicationHistoryActionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SkipMedicationHistoryAction &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.medicationSchedule, medicationSchedule) || other.medicationSchedule == medicationSchedule));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, kind, medicationSchedule);

  @override
  String toString() {
    return 'MedicationHistoryAction.skip(kind: $kind, medicationSchedule: $medicationSchedule)';
  }
}

/// @nodoc
abstract mixin class $SkipMedicationHistoryActionCopyWith<$Res> implements $MedicationHistoryActionCopyWith<$Res> {
  factory $SkipMedicationHistoryActionCopyWith(SkipMedicationHistoryAction value, $Res Function(SkipMedicationHistoryAction) _then) =
      _$SkipMedicationHistoryActionCopyWithImpl;
  @override
  @useResult
  $Res call({MedicationHistoryActionKind kind, MedicationSchedule medicationSchedule});

  @override
  $MedicationScheduleCopyWith<$Res> get medicationSchedule;
}

/// @nodoc
class _$SkipMedicationHistoryActionCopyWithImpl<$Res> implements $SkipMedicationHistoryActionCopyWith<$Res> {
  _$SkipMedicationHistoryActionCopyWithImpl(this._self, this._then);

  final SkipMedicationHistoryAction _self;
  final $Res Function(SkipMedicationHistoryAction) _then;

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kind = null,
    Object? medicationSchedule = null,
  }) {
    return _then(SkipMedicationHistoryAction(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as MedicationHistoryActionKind,
      medicationSchedule: null == medicationSchedule
          ? _self.medicationSchedule
          : medicationSchedule // ignore: cast_nullable_to_non_nullable
              as MedicationSchedule,
    ));
  }

  /// Create a copy of MedicationHistoryAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationScheduleCopyWith<$Res> get medicationSchedule {
    return $MedicationScheduleCopyWith<$Res>(_self.medicationSchedule, (value) {
      return _then(_self.copyWith(medicationSchedule: value));
    });
  }
}

// dart format on
