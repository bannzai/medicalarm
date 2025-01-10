// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Medicine _$MedicineFromJson(Map<String, dynamic> json) {
  return _Medicine.fromJson(json);
}

/// @nodoc
mixin _$Medicine {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  String get memoImageURL => throw _privateConstructorUsedError;
  List<MedicineNotification> get notifications => throw _privateConstructorUsedError;
  int? get stock => throw _privateConstructorUsedError;
  @ClientCreatedTimestamp()
  DateTime? get createdDateTime => throw _privateConstructorUsedError;
  @ClientUpdatedTimestamp()
  DateTime? get updatedDateTime => throw _privateConstructorUsedError;
  @ServerCreatedTimestamp()
  DateTime? get serverCreatedDateTime => throw _privateConstructorUsedError;
  @ServerUpdatedTimestamp()
  DateTime? get serverUpdatedDateTime => throw _privateConstructorUsedError;

  /// Serializes this Medicine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineCopyWith<Medicine> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineCopyWith<$Res> {
  factory $MedicineCopyWith(Medicine value, $Res Function(Medicine) then) = _$MedicineCopyWithImpl<$Res, Medicine>;
  @useResult
  $Res call(
      {String id,
      String name,
      String memo,
      String memoImageURL,
      List<MedicineNotification> notifications,
      int? stock,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});
}

/// @nodoc
class _$MedicineCopyWithImpl<$Res, $Val extends Medicine> implements $MedicineCopyWith<$Res> {
  _$MedicineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? memo = null,
    Object? memoImageURL = null,
    Object? notifications = null,
    Object? stock = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      memoImageURL: null == memoImageURL
          ? _value.memoImageURL
          : memoImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<MedicineNotification>,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$MedicineImplCopyWith<$Res> implements $MedicineCopyWith<$Res> {
  factory _$$MedicineImplCopyWith(_$MedicineImpl value, $Res Function(_$MedicineImpl) then) = __$$MedicineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String memo,
      String memoImageURL,
      List<MedicineNotification> notifications,
      int? stock,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});
}

/// @nodoc
class __$$MedicineImplCopyWithImpl<$Res> extends _$MedicineCopyWithImpl<$Res, _$MedicineImpl> implements _$$MedicineImplCopyWith<$Res> {
  __$$MedicineImplCopyWithImpl(_$MedicineImpl _value, $Res Function(_$MedicineImpl) _then) : super(_value, _then);

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? memo = null,
    Object? memoImageURL = null,
    Object? notifications = null,
    Object? stock = freezed,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
  }) {
    return _then(_$MedicineImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      memoImageURL: null == memoImageURL
          ? _value.memoImageURL
          : memoImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      notifications: null == notifications
          ? _value._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<MedicineNotification>,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$MedicineImpl extends _Medicine {
  const _$MedicineImpl(
      {required this.id,
      required this.name,
      required this.memo,
      required this.memoImageURL,
      required final List<MedicineNotification> notifications,
      required this.stock,
      @ClientCreatedTimestamp() this.createdDateTime,
      @ClientUpdatedTimestamp() this.updatedDateTime,
      @ServerCreatedTimestamp() this.serverCreatedDateTime,
      @ServerUpdatedTimestamp() this.serverUpdatedDateTime})
      : _notifications = notifications,
        super._();

  factory _$MedicineImpl.fromJson(Map<String, dynamic> json) => _$$MedicineImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String memo;
  @override
  final String memoImageURL;
  final List<MedicineNotification> _notifications;
  @override
  List<MedicineNotification> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  final int? stock;
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
    return 'Medicine(id: $id, name: $name, memo: $memo, memoImageURL: $memoImageURL, notifications: $notifications, stock: $stock, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.memoImageURL, memoImageURL) || other.memoImageURL == memoImageURL) &&
            const DeepCollectionEquality().equals(other._notifications, _notifications) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, memo, memoImageURL, const DeepCollectionEquality().hash(_notifications), stock,
      createdDateTime, updatedDateTime, serverCreatedDateTime, serverUpdatedDateTime);

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineImplCopyWith<_$MedicineImpl> get copyWith => __$$MedicineImplCopyWithImpl<_$MedicineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineImplToJson(
      this,
    );
  }
}

abstract class _Medicine extends Medicine {
  const factory _Medicine(
      {required final String id,
      required final String name,
      required final String memo,
      required final String memoImageURL,
      required final List<MedicineNotification> notifications,
      required final int? stock,
      @ClientCreatedTimestamp() final DateTime? createdDateTime,
      @ClientUpdatedTimestamp() final DateTime? updatedDateTime,
      @ServerCreatedTimestamp() final DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() final DateTime? serverUpdatedDateTime}) = _$MedicineImpl;
  const _Medicine._() : super._();

  factory _Medicine.fromJson(Map<String, dynamic> json) = _$MedicineImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get memo;
  @override
  String get memoImageURL;
  @override
  List<MedicineNotification> get notifications;
  @override
  int? get stock;
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

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineImplCopyWith<_$MedicineImpl> get copyWith => throw _privateConstructorUsedError;
}

MedicineNotification _$MedicineNotificationFromJson(Map<String, dynamic> json) {
  return _MedicineNotification.fromJson(json);
}

/// @nodoc
mixin _$MedicineNotification {
  int get dosingCount => throw _privateConstructorUsedError;
  MedicineNotificationReminderTime get reminderTime => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  bool get useCriticalAlert => throw _privateConstructorUsedError;

  /// Serializes this MedicineNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicineNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineNotificationCopyWith<MedicineNotification> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineNotificationCopyWith<$Res> {
  factory $MedicineNotificationCopyWith(MedicineNotification value, $Res Function(MedicineNotification) then) =
      _$MedicineNotificationCopyWithImpl<$Res, MedicineNotification>;
  @useResult
  $Res call({int dosingCount, MedicineNotificationReminderTime reminderTime, bool isEnabled, bool useCriticalAlert});

  $MedicineNotificationReminderTimeCopyWith<$Res> get reminderTime;
}

/// @nodoc
class _$MedicineNotificationCopyWithImpl<$Res, $Val extends MedicineNotification> implements $MedicineNotificationCopyWith<$Res> {
  _$MedicineNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dosingCount = null,
    Object? reminderTime = null,
    Object? isEnabled = null,
    Object? useCriticalAlert = null,
  }) {
    return _then(_value.copyWith(
      dosingCount: null == dosingCount
          ? _value.dosingCount
          : dosingCount // ignore: cast_nullable_to_non_nullable
              as int,
      reminderTime: null == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as MedicineNotificationReminderTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      useCriticalAlert: null == useCriticalAlert
          ? _value.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of MedicineNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineNotificationReminderTimeCopyWith<$Res> get reminderTime {
    return $MedicineNotificationReminderTimeCopyWith<$Res>(_value.reminderTime, (value) {
      return _then(_value.copyWith(reminderTime: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicineNotificationImplCopyWith<$Res> implements $MedicineNotificationCopyWith<$Res> {
  factory _$$MedicineNotificationImplCopyWith(_$MedicineNotificationImpl value, $Res Function(_$MedicineNotificationImpl) then) =
      __$$MedicineNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int dosingCount, MedicineNotificationReminderTime reminderTime, bool isEnabled, bool useCriticalAlert});

  @override
  $MedicineNotificationReminderTimeCopyWith<$Res> get reminderTime;
}

/// @nodoc
class __$$MedicineNotificationImplCopyWithImpl<$Res> extends _$MedicineNotificationCopyWithImpl<$Res, _$MedicineNotificationImpl>
    implements _$$MedicineNotificationImplCopyWith<$Res> {
  __$$MedicineNotificationImplCopyWithImpl(_$MedicineNotificationImpl _value, $Res Function(_$MedicineNotificationImpl) _then) : super(_value, _then);

  /// Create a copy of MedicineNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dosingCount = null,
    Object? reminderTime = null,
    Object? isEnabled = null,
    Object? useCriticalAlert = null,
  }) {
    return _then(_$MedicineNotificationImpl(
      dosingCount: null == dosingCount
          ? _value.dosingCount
          : dosingCount // ignore: cast_nullable_to_non_nullable
              as int,
      reminderTime: null == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as MedicineNotificationReminderTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      useCriticalAlert: null == useCriticalAlert
          ? _value.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicineNotificationImpl extends _MedicineNotification {
  const _$MedicineNotificationImpl({required this.dosingCount, required this.reminderTime, required this.isEnabled, required this.useCriticalAlert})
      : super._();

  factory _$MedicineNotificationImpl.fromJson(Map<String, dynamic> json) => _$$MedicineNotificationImplFromJson(json);

  @override
  final int dosingCount;
  @override
  final MedicineNotificationReminderTime reminderTime;
  @override
  final bool isEnabled;
  @override
  final bool useCriticalAlert;

  @override
  String toString() {
    return 'MedicineNotification(dosingCount: $dosingCount, reminderTime: $reminderTime, isEnabled: $isEnabled, useCriticalAlert: $useCriticalAlert)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineNotificationImpl &&
            (identical(other.dosingCount, dosingCount) || other.dosingCount == dosingCount) &&
            (identical(other.reminderTime, reminderTime) || other.reminderTime == reminderTime) &&
            (identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled) &&
            (identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dosingCount, reminderTime, isEnabled, useCriticalAlert);

  /// Create a copy of MedicineNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineNotificationImplCopyWith<_$MedicineNotificationImpl> get copyWith =>
      __$$MedicineNotificationImplCopyWithImpl<_$MedicineNotificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineNotificationImplToJson(
      this,
    );
  }
}

abstract class _MedicineNotification extends MedicineNotification {
  const factory _MedicineNotification(
      {required final int dosingCount,
      required final MedicineNotificationReminderTime reminderTime,
      required final bool isEnabled,
      required final bool useCriticalAlert}) = _$MedicineNotificationImpl;
  const _MedicineNotification._() : super._();

  factory _MedicineNotification.fromJson(Map<String, dynamic> json) = _$MedicineNotificationImpl.fromJson;

  @override
  int get dosingCount;
  @override
  MedicineNotificationReminderTime get reminderTime;
  @override
  bool get isEnabled;
  @override
  bool get useCriticalAlert;

  /// Create a copy of MedicineNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineNotificationImplCopyWith<_$MedicineNotificationImpl> get copyWith => throw _privateConstructorUsedError;
}

MedicineNotificationReminderTime _$MedicineNotificationReminderTimeFromJson(Map<String, dynamic> json) {
  return _MedicineNotificationReminderTime.fromJson(json);
}

/// @nodoc
mixin _$MedicineNotificationReminderTime {
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;

  /// Serializes this MedicineNotificationReminderTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicineNotificationReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineNotificationReminderTimeCopyWith<MedicineNotificationReminderTime> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineNotificationReminderTimeCopyWith<$Res> {
  factory $MedicineNotificationReminderTimeCopyWith(MedicineNotificationReminderTime value, $Res Function(MedicineNotificationReminderTime) then) =
      _$MedicineNotificationReminderTimeCopyWithImpl<$Res, MedicineNotificationReminderTime>;
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class _$MedicineNotificationReminderTimeCopyWithImpl<$Res, $Val extends MedicineNotificationReminderTime>
    implements $MedicineNotificationReminderTimeCopyWith<$Res> {
  _$MedicineNotificationReminderTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineNotificationReminderTime
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
abstract class _$$MedicineNotificationReminderTimeImplCopyWith<$Res> implements $MedicineNotificationReminderTimeCopyWith<$Res> {
  factory _$$MedicineNotificationReminderTimeImplCopyWith(
          _$MedicineNotificationReminderTimeImpl value, $Res Function(_$MedicineNotificationReminderTimeImpl) then) =
      __$$MedicineNotificationReminderTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class __$$MedicineNotificationReminderTimeImplCopyWithImpl<$Res>
    extends _$MedicineNotificationReminderTimeCopyWithImpl<$Res, _$MedicineNotificationReminderTimeImpl>
    implements _$$MedicineNotificationReminderTimeImplCopyWith<$Res> {
  __$$MedicineNotificationReminderTimeImplCopyWithImpl(
      _$MedicineNotificationReminderTimeImpl _value, $Res Function(_$MedicineNotificationReminderTimeImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineNotificationReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_$MedicineNotificationReminderTimeImpl(
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

@JsonSerializable(explicitToJson: true)
class _$MedicineNotificationReminderTimeImpl extends _MedicineNotificationReminderTime {
  const _$MedicineNotificationReminderTimeImpl({required this.hour, required this.minute}) : super._();

  factory _$MedicineNotificationReminderTimeImpl.fromJson(Map<String, dynamic> json) => _$$MedicineNotificationReminderTimeImplFromJson(json);

  @override
  final int hour;
  @override
  final int minute;

  @override
  String toString() {
    return 'MedicineNotificationReminderTime(hour: $hour, minute: $minute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineNotificationReminderTimeImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  /// Create a copy of MedicineNotificationReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineNotificationReminderTimeImplCopyWith<_$MedicineNotificationReminderTimeImpl> get copyWith =>
      __$$MedicineNotificationReminderTimeImplCopyWithImpl<_$MedicineNotificationReminderTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineNotificationReminderTimeImplToJson(
      this,
    );
  }
}

abstract class _MedicineNotificationReminderTime extends MedicineNotificationReminderTime {
  const factory _MedicineNotificationReminderTime({required final int hour, required final int minute}) = _$MedicineNotificationReminderTimeImpl;
  const _MedicineNotificationReminderTime._() : super._();

  factory _MedicineNotificationReminderTime.fromJson(Map<String, dynamic> json) = _$MedicineNotificationReminderTimeImpl.fromJson;

  @override
  int get hour;
  @override
  int get minute;

  /// Create a copy of MedicineNotificationReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineNotificationReminderTimeImplCopyWith<_$MedicineNotificationReminderTimeImpl> get copyWith => throw _privateConstructorUsedError;
}
