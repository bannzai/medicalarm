// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Diary _$DiaryFromJson(Map<String, dynamic> json) {
  return _Diary.fromJson(json);
}

/// @nodoc
mixin _$Diary {
  String get id => throw _privateConstructorUsedError;
  String get userID => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<DiaryMemo> get memos => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  @ClientCreatedTimestamp()
  DateTime? get createdDateTime => throw _privateConstructorUsedError;
  @ClientUpdatedTimestamp()
  DateTime? get updatedDateTime => throw _privateConstructorUsedError;
  @ServerCreatedTimestamp()
  DateTime? get serverCreatedDateTime => throw _privateConstructorUsedError;
  @ServerUpdatedTimestamp()
  DateTime? get serverUpdatedDateTime => throw _privateConstructorUsedError;

  /// Serializes this Diary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiaryCopyWith<Diary> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryCopyWith<$Res> {
  factory $DiaryCopyWith(Diary value, $Res Function(Diary) then) = _$DiaryCopyWithImpl<$Res, Diary>;
  @useResult
  $Res call(
      {String id,
      String userID,
      List<String> tags,
      List<DiaryMemo> memos,
      String memo,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});
}

/// @nodoc
class _$DiaryCopyWithImpl<$Res, $Val extends Diary> implements $DiaryCopyWith<$Res> {
  _$DiaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userID = null,
    Object? tags = null,
    Object? memos = null,
    Object? memo = null,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
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
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      memos: null == memos
          ? _value.memos
          : memos // ignore: cast_nullable_to_non_nullable
              as List<DiaryMemo>,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DiaryImplCopyWith<$Res> implements $DiaryCopyWith<$Res> {
  factory _$$DiaryImplCopyWith(_$DiaryImpl value, $Res Function(_$DiaryImpl) then) = __$$DiaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userID,
      List<String> tags,
      List<DiaryMemo> memos,
      String memo,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});
}

/// @nodoc
class __$$DiaryImplCopyWithImpl<$Res> extends _$DiaryCopyWithImpl<$Res, _$DiaryImpl> implements _$$DiaryImplCopyWith<$Res> {
  __$$DiaryImplCopyWithImpl(_$DiaryImpl _value, $Res Function(_$DiaryImpl) _then) : super(_value, _then);

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userID = null,
    Object? tags = null,
    Object? memos = null,
    Object? memo = null,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
  }) {
    return _then(_$DiaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      memos: null == memos
          ? _value._memos
          : memos // ignore: cast_nullable_to_non_nullable
              as List<DiaryMemo>,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$DiaryImpl extends _Diary {
  _$DiaryImpl(
      {required this.id,
      required this.userID,
      required final List<String> tags,
      required final List<DiaryMemo> memos,
      required this.memo,
      @ClientCreatedTimestamp() this.createdDateTime,
      @ClientUpdatedTimestamp() this.updatedDateTime,
      @ServerCreatedTimestamp() this.serverCreatedDateTime,
      @ServerUpdatedTimestamp() this.serverUpdatedDateTime})
      : _tags = tags,
        _memos = memos,
        super._();

  factory _$DiaryImpl.fromJson(Map<String, dynamic> json) => _$$DiaryImplFromJson(json);

  @override
  final String id;
  @override
  final String userID;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<DiaryMemo> _memos;
  @override
  List<DiaryMemo> get memos {
    if (_memos is EqualUnmodifiableListView) return _memos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memos);
  }

  @override
  final String memo;
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
  String toString() {
    return 'Diary(id: $id, userID: $userID, tags: $tags, memos: $memos, memo: $memo, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userID, userID) || other.userID == userID) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._memos, _memos) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userID, const DeepCollectionEquality().hash(_tags), const DeepCollectionEquality().hash(_memos),
      memo, createdDateTime, updatedDateTime, serverCreatedDateTime, serverUpdatedDateTime);

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiaryImplCopyWith<_$DiaryImpl> get copyWith => __$$DiaryImplCopyWithImpl<_$DiaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiaryImplToJson(
      this,
    );
  }
}

abstract class _Diary extends Diary {
  factory _Diary(
      {required final String id,
      required final String userID,
      required final List<String> tags,
      required final List<DiaryMemo> memos,
      required final String memo,
      @ClientCreatedTimestamp() final DateTime? createdDateTime,
      @ClientUpdatedTimestamp() final DateTime? updatedDateTime,
      @ServerCreatedTimestamp() final DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() final DateTime? serverUpdatedDateTime}) = _$DiaryImpl;
  _Diary._() : super._();

  factory _Diary.fromJson(Map<String, dynamic> json) = _$DiaryImpl.fromJson;

  @override
  String get id;
  @override
  String get userID;
  @override
  List<String> get tags;
  @override
  List<DiaryMemo> get memos;
  @override
  String get memo;
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

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiaryImplCopyWith<_$DiaryImpl> get copyWith => throw _privateConstructorUsedError;
}

DiaryMemo _$DiaryMemoFromJson(Map<String, dynamic> json) {
  return _DiaryMemo.fromJson(json);
}

/// @nodoc
mixin _$DiaryMemo {
  MedicationHistory get medicationHistory => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  DoseReceiver get doseReceiver => throw _privateConstructorUsedError;

  /// Serializes this DiaryMemo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiaryMemo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiaryMemoCopyWith<DiaryMemo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryMemoCopyWith<$Res> {
  factory $DiaryMemoCopyWith(DiaryMemo value, $Res Function(DiaryMemo) then) = _$DiaryMemoCopyWithImpl<$Res, DiaryMemo>;
  @useResult
  $Res call({MedicationHistory medicationHistory, String memo, DoseReceiver doseReceiver});

  $MedicationHistoryCopyWith<$Res> get medicationHistory;
  $DoseReceiverCopyWith<$Res> get doseReceiver;
}

/// @nodoc
class _$DiaryMemoCopyWithImpl<$Res, $Val extends DiaryMemo> implements $DiaryMemoCopyWith<$Res> {
  _$DiaryMemoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiaryMemo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicationHistory = null,
    Object? memo = null,
    Object? doseReceiver = null,
  }) {
    return _then(_value.copyWith(
      medicationHistory: null == medicationHistory
          ? _value.medicationHistory
          : medicationHistory // ignore: cast_nullable_to_non_nullable
              as MedicationHistory,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      doseReceiver: null == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
    ) as $Val);
  }

  /// Create a copy of DiaryMemo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationHistoryCopyWith<$Res> get medicationHistory {
    return $MedicationHistoryCopyWith<$Res>(_value.medicationHistory, (value) {
      return _then(_value.copyWith(medicationHistory: value) as $Val);
    });
  }

  /// Create a copy of DiaryMemo
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
abstract class _$$DiaryMemoImplCopyWith<$Res> implements $DiaryMemoCopyWith<$Res> {
  factory _$$DiaryMemoImplCopyWith(_$DiaryMemoImpl value, $Res Function(_$DiaryMemoImpl) then) = __$$DiaryMemoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MedicationHistory medicationHistory, String memo, DoseReceiver doseReceiver});

  @override
  $MedicationHistoryCopyWith<$Res> get medicationHistory;
  @override
  $DoseReceiverCopyWith<$Res> get doseReceiver;
}

/// @nodoc
class __$$DiaryMemoImplCopyWithImpl<$Res> extends _$DiaryMemoCopyWithImpl<$Res, _$DiaryMemoImpl> implements _$$DiaryMemoImplCopyWith<$Res> {
  __$$DiaryMemoImplCopyWithImpl(_$DiaryMemoImpl _value, $Res Function(_$DiaryMemoImpl) _then) : super(_value, _then);

  /// Create a copy of DiaryMemo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicationHistory = null,
    Object? memo = null,
    Object? doseReceiver = null,
  }) {
    return _then(_$DiaryMemoImpl(
      medicationHistory: null == medicationHistory
          ? _value.medicationHistory
          : medicationHistory // ignore: cast_nullable_to_non_nullable
              as MedicationHistory,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      doseReceiver: null == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$DiaryMemoImpl extends _DiaryMemo {
  _$DiaryMemoImpl({required this.medicationHistory, required this.memo, required this.doseReceiver}) : super._();

  factory _$DiaryMemoImpl.fromJson(Map<String, dynamic> json) => _$$DiaryMemoImplFromJson(json);

  @override
  final MedicationHistory medicationHistory;
  @override
  final String memo;
  @override
  final DoseReceiver doseReceiver;

  @override
  String toString() {
    return 'DiaryMemo(medicationHistory: $medicationHistory, memo: $memo, doseReceiver: $doseReceiver)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiaryMemoImpl &&
            (identical(other.medicationHistory, medicationHistory) || other.medicationHistory == medicationHistory) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.doseReceiver, doseReceiver) || other.doseReceiver == doseReceiver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, medicationHistory, memo, doseReceiver);

  /// Create a copy of DiaryMemo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiaryMemoImplCopyWith<_$DiaryMemoImpl> get copyWith => __$$DiaryMemoImplCopyWithImpl<_$DiaryMemoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiaryMemoImplToJson(
      this,
    );
  }
}

abstract class _DiaryMemo extends DiaryMemo {
  factory _DiaryMemo({required final MedicationHistory medicationHistory, required final String memo, required final DoseReceiver doseReceiver}) =
      _$DiaryMemoImpl;
  _DiaryMemo._() : super._();

  factory _DiaryMemo.fromJson(Map<String, dynamic> json) = _$DiaryMemoImpl.fromJson;

  @override
  MedicationHistory get medicationHistory;
  @override
  String get memo;
  @override
  DoseReceiver get doseReceiver;

  /// Create a copy of DiaryMemo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiaryMemoImplCopyWith<_$DiaryMemoImpl> get copyWith => throw _privateConstructorUsedError;
}
