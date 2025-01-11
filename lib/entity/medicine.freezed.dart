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
  List<MedicineNotificationSetting> get notificationSettings => throw _privateConstructorUsedError;
  int? get stock => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
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
      List<MedicineNotificationSetting> notificationSettings,
      int? stock,
      String unit,
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
    Object? notificationSettings = null,
    Object? stock = freezed,
    Object? unit = null,
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
      notificationSettings: null == notificationSettings
          ? _value.notificationSettings
          : notificationSettings // ignore: cast_nullable_to_non_nullable
              as List<MedicineNotificationSetting>,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MedicineImplCopyWith<$Res> implements $MedicineCopyWith<$Res> {
  factory _$$MedicineImplCopyWith(_$MedicineImpl value, $Res Function(_$MedicineImpl) then) = __$$MedicineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String memo,
      String memoImageURL,
      List<MedicineNotificationSetting> notificationSettings,
      int? stock,
      String unit,
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
    Object? notificationSettings = null,
    Object? stock = freezed,
    Object? unit = null,
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
      notificationSettings: null == notificationSettings
          ? _value._notificationSettings
          : notificationSettings // ignore: cast_nullable_to_non_nullable
              as List<MedicineNotificationSetting>,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
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
class _$MedicineImpl extends _Medicine {
  const _$MedicineImpl(
      {required this.id,
      required this.name,
      required this.memo,
      required this.memoImageURL,
      required final List<MedicineNotificationSetting> notificationSettings,
      required this.stock,
      required this.unit,
      @ClientCreatedTimestamp() this.createdDateTime,
      @ClientUpdatedTimestamp() this.updatedDateTime,
      @ServerCreatedTimestamp() this.serverCreatedDateTime,
      @ServerUpdatedTimestamp() this.serverUpdatedDateTime})
      : _notificationSettings = notificationSettings,
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
  final List<MedicineNotificationSetting> _notificationSettings;
  @override
  List<MedicineNotificationSetting> get notificationSettings {
    if (_notificationSettings is EqualUnmodifiableListView) return _notificationSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notificationSettings);
  }

  @override
  final int? stock;
  @override
  final String unit;
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
    return 'Medicine(id: $id, name: $name, memo: $memo, memoImageURL: $memoImageURL, notificationSettings: $notificationSettings, stock: $stock, unit: $unit, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
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
            const DeepCollectionEquality().equals(other._notificationSettings, _notificationSettings) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, memo, memoImageURL, const DeepCollectionEquality().hash(_notificationSettings), stock, unit,
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
      required final List<MedicineNotificationSetting> notificationSettings,
      required final int? stock,
      required final String unit,
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
  List<MedicineNotificationSetting> get notificationSettings;
  @override
  int? get stock;
  @override
  String get unit;
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

MedicineNotificationSetting _$MedicineNotificationSettingFromJson(Map<String, dynamic> json) {
  return _MedicineNotificationSetting.fromJson(json);
}

/// @nodoc
mixin _$MedicineNotificationSetting {
  int get dosingCount => throw _privateConstructorUsedError;
  MedicineNotificationSettingReminderTime get reminderTime => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  bool get useCriticalAlert => throw _privateConstructorUsedError;
  String? get doserName => throw _privateConstructorUsedError;

  /// Serializes this MedicineNotificationSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicineNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineNotificationSettingCopyWith<MedicineNotificationSetting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineNotificationSettingCopyWith<$Res> {
  factory $MedicineNotificationSettingCopyWith(MedicineNotificationSetting value, $Res Function(MedicineNotificationSetting) then) =
      _$MedicineNotificationSettingCopyWithImpl<$Res, MedicineNotificationSetting>;
  @useResult
  $Res call({int dosingCount, MedicineNotificationSettingReminderTime reminderTime, bool isEnabled, bool useCriticalAlert, String? doserName});

  $MedicineNotificationSettingReminderTimeCopyWith<$Res> get reminderTime;
}

/// @nodoc
class _$MedicineNotificationSettingCopyWithImpl<$Res, $Val extends MedicineNotificationSetting>
    implements $MedicineNotificationSettingCopyWith<$Res> {
  _$MedicineNotificationSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dosingCount = null,
    Object? reminderTime = null,
    Object? isEnabled = null,
    Object? useCriticalAlert = null,
    Object? doserName = freezed,
  }) {
    return _then(_value.copyWith(
      dosingCount: null == dosingCount
          ? _value.dosingCount
          : dosingCount // ignore: cast_nullable_to_non_nullable
              as int,
      reminderTime: null == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as MedicineNotificationSettingReminderTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      useCriticalAlert: null == useCriticalAlert
          ? _value.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      doserName: freezed == doserName
          ? _value.doserName
          : doserName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of MedicineNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineNotificationSettingReminderTimeCopyWith<$Res> get reminderTime {
    return $MedicineNotificationSettingReminderTimeCopyWith<$Res>(_value.reminderTime, (value) {
      return _then(_value.copyWith(reminderTime: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicineNotificationSettingImplCopyWith<$Res> implements $MedicineNotificationSettingCopyWith<$Res> {
  factory _$$MedicineNotificationSettingImplCopyWith(_$MedicineNotificationSettingImpl value, $Res Function(_$MedicineNotificationSettingImpl) then) =
      __$$MedicineNotificationSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int dosingCount, MedicineNotificationSettingReminderTime reminderTime, bool isEnabled, bool useCriticalAlert, String? doserName});

  @override
  $MedicineNotificationSettingReminderTimeCopyWith<$Res> get reminderTime;
}

/// @nodoc
class __$$MedicineNotificationSettingImplCopyWithImpl<$Res> extends _$MedicineNotificationSettingCopyWithImpl<$Res, _$MedicineNotificationSettingImpl>
    implements _$$MedicineNotificationSettingImplCopyWith<$Res> {
  __$$MedicineNotificationSettingImplCopyWithImpl(_$MedicineNotificationSettingImpl _value, $Res Function(_$MedicineNotificationSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dosingCount = null,
    Object? reminderTime = null,
    Object? isEnabled = null,
    Object? useCriticalAlert = null,
    Object? doserName = freezed,
  }) {
    return _then(_$MedicineNotificationSettingImpl(
      dosingCount: null == dosingCount
          ? _value.dosingCount
          : dosingCount // ignore: cast_nullable_to_non_nullable
              as int,
      reminderTime: null == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as MedicineNotificationSettingReminderTime,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      useCriticalAlert: null == useCriticalAlert
          ? _value.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      doserName: freezed == doserName
          ? _value.doserName
          : doserName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicineNotificationSettingImpl extends _MedicineNotificationSetting {
  const _$MedicineNotificationSettingImpl(
      {required this.dosingCount, required this.reminderTime, required this.isEnabled, required this.useCriticalAlert, required this.doserName})
      : super._();

  factory _$MedicineNotificationSettingImpl.fromJson(Map<String, dynamic> json) => _$$MedicineNotificationSettingImplFromJson(json);

  @override
  final int dosingCount;
  @override
  final MedicineNotificationSettingReminderTime reminderTime;
  @override
  final bool isEnabled;
  @override
  final bool useCriticalAlert;
  @override
  final String? doserName;

  @override
  String toString() {
    return 'MedicineNotificationSetting(dosingCount: $dosingCount, reminderTime: $reminderTime, isEnabled: $isEnabled, useCriticalAlert: $useCriticalAlert, doserName: $doserName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineNotificationSettingImpl &&
            (identical(other.dosingCount, dosingCount) || other.dosingCount == dosingCount) &&
            (identical(other.reminderTime, reminderTime) || other.reminderTime == reminderTime) &&
            (identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled) &&
            (identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert) &&
            (identical(other.doserName, doserName) || other.doserName == doserName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dosingCount, reminderTime, isEnabled, useCriticalAlert, doserName);

  /// Create a copy of MedicineNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineNotificationSettingImplCopyWith<_$MedicineNotificationSettingImpl> get copyWith =>
      __$$MedicineNotificationSettingImplCopyWithImpl<_$MedicineNotificationSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineNotificationSettingImplToJson(
      this,
    );
  }
}

abstract class _MedicineNotificationSetting extends MedicineNotificationSetting {
  const factory _MedicineNotificationSetting(
      {required final int dosingCount,
      required final MedicineNotificationSettingReminderTime reminderTime,
      required final bool isEnabled,
      required final bool useCriticalAlert,
      required final String? doserName}) = _$MedicineNotificationSettingImpl;
  const _MedicineNotificationSetting._() : super._();

  factory _MedicineNotificationSetting.fromJson(Map<String, dynamic> json) = _$MedicineNotificationSettingImpl.fromJson;

  @override
  int get dosingCount;
  @override
  MedicineNotificationSettingReminderTime get reminderTime;
  @override
  bool get isEnabled;
  @override
  bool get useCriticalAlert;
  @override
  String? get doserName;

  /// Create a copy of MedicineNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineNotificationSettingImplCopyWith<_$MedicineNotificationSettingImpl> get copyWith => throw _privateConstructorUsedError;
}

MedicineNotificationSettingReminderTime _$MedicineNotificationSettingReminderTimeFromJson(Map<String, dynamic> json) {
  return _MedicineNotificationSettingReminderTime.fromJson(json);
}

/// @nodoc
mixin _$MedicineNotificationSettingReminderTime {
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;

  /// Serializes this MedicineNotificationSettingReminderTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicineNotificationSettingReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineNotificationSettingReminderTimeCopyWith<MedicineNotificationSettingReminderTime> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineNotificationSettingReminderTimeCopyWith<$Res> {
  factory $MedicineNotificationSettingReminderTimeCopyWith(
          MedicineNotificationSettingReminderTime value, $Res Function(MedicineNotificationSettingReminderTime) then) =
      _$MedicineNotificationSettingReminderTimeCopyWithImpl<$Res, MedicineNotificationSettingReminderTime>;
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class _$MedicineNotificationSettingReminderTimeCopyWithImpl<$Res, $Val extends MedicineNotificationSettingReminderTime>
    implements $MedicineNotificationSettingReminderTimeCopyWith<$Res> {
  _$MedicineNotificationSettingReminderTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineNotificationSettingReminderTime
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
abstract class _$$MedicineNotificationSettingReminderTimeImplCopyWith<$Res> implements $MedicineNotificationSettingReminderTimeCopyWith<$Res> {
  factory _$$MedicineNotificationSettingReminderTimeImplCopyWith(
          _$MedicineNotificationSettingReminderTimeImpl value, $Res Function(_$MedicineNotificationSettingReminderTimeImpl) then) =
      __$$MedicineNotificationSettingReminderTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minute});
}

/// @nodoc
class __$$MedicineNotificationSettingReminderTimeImplCopyWithImpl<$Res>
    extends _$MedicineNotificationSettingReminderTimeCopyWithImpl<$Res, _$MedicineNotificationSettingReminderTimeImpl>
    implements _$$MedicineNotificationSettingReminderTimeImplCopyWith<$Res> {
  __$$MedicineNotificationSettingReminderTimeImplCopyWithImpl(
      _$MedicineNotificationSettingReminderTimeImpl _value, $Res Function(_$MedicineNotificationSettingReminderTimeImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineNotificationSettingReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? minute = null,
  }) {
    return _then(_$MedicineNotificationSettingReminderTimeImpl(
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
class _$MedicineNotificationSettingReminderTimeImpl extends _MedicineNotificationSettingReminderTime {
  const _$MedicineNotificationSettingReminderTimeImpl({required this.hour, required this.minute}) : super._();

  factory _$MedicineNotificationSettingReminderTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicineNotificationSettingReminderTimeImplFromJson(json);

  @override
  final int hour;
  @override
  final int minute;

  @override
  String toString() {
    return 'MedicineNotificationSettingReminderTime(hour: $hour, minute: $minute)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineNotificationSettingReminderTimeImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hour, minute);

  /// Create a copy of MedicineNotificationSettingReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineNotificationSettingReminderTimeImplCopyWith<_$MedicineNotificationSettingReminderTimeImpl> get copyWith =>
      __$$MedicineNotificationSettingReminderTimeImplCopyWithImpl<_$MedicineNotificationSettingReminderTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineNotificationSettingReminderTimeImplToJson(
      this,
    );
  }
}

abstract class _MedicineNotificationSettingReminderTime extends MedicineNotificationSettingReminderTime {
  const factory _MedicineNotificationSettingReminderTime({required final int hour, required final int minute}) =
      _$MedicineNotificationSettingReminderTimeImpl;
  const _MedicineNotificationSettingReminderTime._() : super._();

  factory _MedicineNotificationSettingReminderTime.fromJson(Map<String, dynamic> json) = _$MedicineNotificationSettingReminderTimeImpl.fromJson;

  @override
  int get hour;
  @override
  int get minute;

  /// Create a copy of MedicineNotificationSettingReminderTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineNotificationSettingReminderTimeImplCopyWith<_$MedicineNotificationSettingReminderTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
