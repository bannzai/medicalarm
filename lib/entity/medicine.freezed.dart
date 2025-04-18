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
  String get userID => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  MedicationFrequency get frequency => throw _privateConstructorUsedError;
  List<MedicationSchedule> get schedules => throw _privateConstructorUsedError;
  DoseReceiver get doseReceiver => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  String get memoImageURL => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get archivedDateTime => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get beganDateTime => throw _privateConstructorUsedError;
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
      String userID,
      String name,
      MedicationFrequency frequency,
      List<MedicationSchedule> schedules,
      DoseReceiver doseReceiver,
      String memo,
      String memoImageURL,
      @NullableTimestampConverter() DateTime? archivedDateTime,
      @TimestampConverter() DateTime beganDateTime,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});

  $MedicationFrequencyCopyWith<$Res> get frequency;
  $DoseReceiverCopyWith<$Res> get doseReceiver;
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
    Object? userID = null,
    Object? name = null,
    Object? frequency = null,
    Object? schedules = null,
    Object? doseReceiver = null,
    Object? memo = null,
    Object? memoImageURL = null,
    Object? archivedDateTime = freezed,
    Object? beganDateTime = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as MedicationFrequency,
      schedules: null == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<MedicationSchedule>,
      doseReceiver: null == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      memoImageURL: null == memoImageURL
          ? _value.memoImageURL
          : memoImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      archivedDateTime: freezed == archivedDateTime
          ? _value.archivedDateTime
          : archivedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      beganDateTime: null == beganDateTime
          ? _value.beganDateTime
          : beganDateTime // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationFrequencyCopyWith<$Res> get frequency {
    return $MedicationFrequencyCopyWith<$Res>(_value.frequency, (value) {
      return _then(_value.copyWith(frequency: value) as $Val);
    });
  }

  /// Create a copy of Medicine
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
abstract class _$$MedicineImplCopyWith<$Res> implements $MedicineCopyWith<$Res> {
  factory _$$MedicineImplCopyWith(_$MedicineImpl value, $Res Function(_$MedicineImpl) then) = __$$MedicineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userID,
      String name,
      MedicationFrequency frequency,
      List<MedicationSchedule> schedules,
      DoseReceiver doseReceiver,
      String memo,
      String memoImageURL,
      @NullableTimestampConverter() DateTime? archivedDateTime,
      @TimestampConverter() DateTime beganDateTime,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});

  @override
  $MedicationFrequencyCopyWith<$Res> get frequency;
  @override
  $DoseReceiverCopyWith<$Res> get doseReceiver;
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
    Object? userID = null,
    Object? name = null,
    Object? frequency = null,
    Object? schedules = null,
    Object? doseReceiver = null,
    Object? memo = null,
    Object? memoImageURL = null,
    Object? archivedDateTime = freezed,
    Object? beganDateTime = null,
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
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as MedicationFrequency,
      schedules: null == schedules
          ? _value._schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<MedicationSchedule>,
      doseReceiver: null == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      memoImageURL: null == memoImageURL
          ? _value.memoImageURL
          : memoImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      archivedDateTime: freezed == archivedDateTime
          ? _value.archivedDateTime
          : archivedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      beganDateTime: null == beganDateTime
          ? _value.beganDateTime
          : beganDateTime // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicineImpl extends _Medicine {
  const _$MedicineImpl(
      {required this.id,
      required this.userID,
      required this.name,
      required this.frequency,
      required final List<MedicationSchedule> schedules,
      required this.doseReceiver,
      required this.memo,
      required this.memoImageURL,
      @NullableTimestampConverter() this.archivedDateTime,
      @TimestampConverter() required this.beganDateTime,
      @ClientCreatedTimestamp() this.createdDateTime,
      @ClientUpdatedTimestamp() this.updatedDateTime,
      @ServerCreatedTimestamp() this.serverCreatedDateTime,
      @ServerUpdatedTimestamp() this.serverUpdatedDateTime})
      : _schedules = schedules,
        super._();

  factory _$MedicineImpl.fromJson(Map<String, dynamic> json) => _$$MedicineImplFromJson(json);

  @override
  final String id;
  @override
  final String userID;
  @override
  final String name;
  @override
  final MedicationFrequency frequency;
  final List<MedicationSchedule> _schedules;
  @override
  List<MedicationSchedule> get schedules {
    if (_schedules is EqualUnmodifiableListView) return _schedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedules);
  }

  @override
  final DoseReceiver doseReceiver;
  @override
  final String memo;
  @override
  final String memoImageURL;
  @override
  @NullableTimestampConverter()
  final DateTime? archivedDateTime;
  @override
  @TimestampConverter()
  final DateTime beganDateTime;
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
    return 'Medicine(id: $id, userID: $userID, name: $name, frequency: $frequency, schedules: $schedules, doseReceiver: $doseReceiver, memo: $memo, memoImageURL: $memoImageURL, archivedDateTime: $archivedDateTime, beganDateTime: $beganDateTime, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.frequency, frequency) || other.frequency == frequency) &&
            const DeepCollectionEquality().equals(other._schedules, _schedules) &&
            (identical(other.doseReceiver, doseReceiver) || other.doseReceiver == doseReceiver) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.memoImageURL, memoImageURL) || other.memoImageURL == memoImageURL) &&
            (identical(other.archivedDateTime, archivedDateTime) || other.archivedDateTime == archivedDateTime) &&
            (identical(other.beganDateTime, beganDateTime) || other.beganDateTime == beganDateTime) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userID, name, frequency, const DeepCollectionEquality().hash(_schedules), doseReceiver, memo,
      memoImageURL, archivedDateTime, beganDateTime, createdDateTime, updatedDateTime, serverCreatedDateTime, serverUpdatedDateTime);

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
      required final String userID,
      required final String name,
      required final MedicationFrequency frequency,
      required final List<MedicationSchedule> schedules,
      required final DoseReceiver doseReceiver,
      required final String memo,
      required final String memoImageURL,
      @NullableTimestampConverter() final DateTime? archivedDateTime,
      @TimestampConverter() required final DateTime beganDateTime,
      @ClientCreatedTimestamp() final DateTime? createdDateTime,
      @ClientUpdatedTimestamp() final DateTime? updatedDateTime,
      @ServerCreatedTimestamp() final DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() final DateTime? serverUpdatedDateTime}) = _$MedicineImpl;
  const _Medicine._() : super._();

  factory _Medicine.fromJson(Map<String, dynamic> json) = _$MedicineImpl.fromJson;

  @override
  String get id;
  @override
  String get userID;
  @override
  String get name;
  @override
  MedicationFrequency get frequency;
  @override
  List<MedicationSchedule> get schedules;
  @override
  DoseReceiver get doseReceiver;
  @override
  String get memo;
  @override
  String get memoImageURL;
  @override
  @NullableTimestampConverter()
  DateTime? get archivedDateTime;
  @override
  @TimestampConverter()
  DateTime get beganDateTime;
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

MedicineScheduleNotificationSetting _$MedicineScheduleNotificationSettingFromJson(Map<String, dynamic> json) {
  return _MedicineScheduleNotificationSetting.fromJson(json);
}

/// @nodoc
mixin _$MedicineScheduleNotificationSetting {
  bool get isReminderEnabled => throw _privateConstructorUsedError;
  bool get isFollowupEnabled => throw _privateConstructorUsedError;
  bool get useCriticalAlert => throw _privateConstructorUsedError;
  double get criticalAlertVolume => throw _privateConstructorUsedError;

  /// Serializes this MedicineScheduleNotificationSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicineScheduleNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineScheduleNotificationSettingCopyWith<MedicineScheduleNotificationSetting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineScheduleNotificationSettingCopyWith<$Res> {
  factory $MedicineScheduleNotificationSettingCopyWith(
          MedicineScheduleNotificationSetting value, $Res Function(MedicineScheduleNotificationSetting) then) =
      _$MedicineScheduleNotificationSettingCopyWithImpl<$Res, MedicineScheduleNotificationSetting>;
  @useResult
  $Res call({bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert, double criticalAlertVolume});
}

/// @nodoc
class _$MedicineScheduleNotificationSettingCopyWithImpl<$Res, $Val extends MedicineScheduleNotificationSetting>
    implements $MedicineScheduleNotificationSettingCopyWith<$Res> {
  _$MedicineScheduleNotificationSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineScheduleNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isReminderEnabled = null,
    Object? isFollowupEnabled = null,
    Object? useCriticalAlert = null,
    Object? criticalAlertVolume = null,
  }) {
    return _then(_value.copyWith(
      isReminderEnabled: null == isReminderEnabled
          ? _value.isReminderEnabled
          : isReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isFollowupEnabled: null == isFollowupEnabled
          ? _value.isFollowupEnabled
          : isFollowupEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      useCriticalAlert: null == useCriticalAlert
          ? _value.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      criticalAlertVolume: null == criticalAlertVolume
          ? _value.criticalAlertVolume
          : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicineScheduleNotificationSettingImplCopyWith<$Res> implements $MedicineScheduleNotificationSettingCopyWith<$Res> {
  factory _$$MedicineScheduleNotificationSettingImplCopyWith(
          _$MedicineScheduleNotificationSettingImpl value, $Res Function(_$MedicineScheduleNotificationSettingImpl) then) =
      __$$MedicineScheduleNotificationSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert, double criticalAlertVolume});
}

/// @nodoc
class __$$MedicineScheduleNotificationSettingImplCopyWithImpl<$Res>
    extends _$MedicineScheduleNotificationSettingCopyWithImpl<$Res, _$MedicineScheduleNotificationSettingImpl>
    implements _$$MedicineScheduleNotificationSettingImplCopyWith<$Res> {
  __$$MedicineScheduleNotificationSettingImplCopyWithImpl(
      _$MedicineScheduleNotificationSettingImpl _value, $Res Function(_$MedicineScheduleNotificationSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineScheduleNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isReminderEnabled = null,
    Object? isFollowupEnabled = null,
    Object? useCriticalAlert = null,
    Object? criticalAlertVolume = null,
  }) {
    return _then(_$MedicineScheduleNotificationSettingImpl(
      isReminderEnabled: null == isReminderEnabled
          ? _value.isReminderEnabled
          : isReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isFollowupEnabled: null == isFollowupEnabled
          ? _value.isFollowupEnabled
          : isFollowupEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      useCriticalAlert: null == useCriticalAlert
          ? _value.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      criticalAlertVolume: null == criticalAlertVolume
          ? _value.criticalAlertVolume
          : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicineScheduleNotificationSettingImpl extends _MedicineScheduleNotificationSetting {
  const _$MedicineScheduleNotificationSettingImpl(
      {required this.isReminderEnabled, required this.isFollowupEnabled, required this.useCriticalAlert, required this.criticalAlertVolume = 0.5})
      : super._();

  factory _$MedicineScheduleNotificationSettingImpl.fromJson(Map<String, dynamic> json) => _$$MedicineScheduleNotificationSettingImplFromJson(json);

  @override
  final bool isReminderEnabled;
  @override
  final bool isFollowupEnabled;
  @override
  final bool useCriticalAlert;
  @override
  @JsonKey()
  final double criticalAlertVolume;

  @override
  String toString() {
    return 'MedicineScheduleNotificationSetting(isReminderEnabled: $isReminderEnabled, isFollowupEnabled: $isFollowupEnabled, useCriticalAlert: $useCriticalAlert, criticalAlertVolume: $criticalAlertVolume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineScheduleNotificationSettingImpl &&
            (identical(other.isReminderEnabled, isReminderEnabled) || other.isReminderEnabled == isReminderEnabled) &&
            (identical(other.isFollowupEnabled, isFollowupEnabled) || other.isFollowupEnabled == isFollowupEnabled) &&
            (identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert) &&
            (identical(other.criticalAlertVolume, criticalAlertVolume) || other.criticalAlertVolume == criticalAlertVolume));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isReminderEnabled, isFollowupEnabled, useCriticalAlert, criticalAlertVolume);

  /// Create a copy of MedicineScheduleNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineScheduleNotificationSettingImplCopyWith<_$MedicineScheduleNotificationSettingImpl> get copyWith =>
      __$$MedicineScheduleNotificationSettingImplCopyWithImpl<_$MedicineScheduleNotificationSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineScheduleNotificationSettingImplToJson(
      this,
    );
  }
}

abstract class _MedicineScheduleNotificationSetting extends MedicineScheduleNotificationSetting {
  const factory _MedicineScheduleNotificationSetting(
      {required final bool isReminderEnabled,
      required final bool isFollowupEnabled,
      required final bool useCriticalAlert,
      required final double criticalAlertVolume}) = _$MedicineScheduleNotificationSettingImpl;
  const _MedicineScheduleNotificationSetting._() : super._();

  factory _MedicineScheduleNotificationSetting.fromJson(Map<String, dynamic> json) = _$MedicineScheduleNotificationSettingImpl.fromJson;

  @override
  bool get isReminderEnabled;
  @override
  bool get isFollowupEnabled;
  @override
  bool get useCriticalAlert;
  @override
  double get criticalAlertVolume;

  /// Create a copy of MedicineScheduleNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineScheduleNotificationSettingImplCopyWith<_$MedicineScheduleNotificationSettingImpl> get copyWith => throw _privateConstructorUsedError;
}

MedicineScheduleFocusConnectSetting _$MedicineScheduleFocusConnectSettingFromJson(Map<String, dynamic> json) {
  return _MedicineScheduleFocusConnectSetting.fromJson(json);
}

/// @nodoc
mixin _$MedicineScheduleFocusConnectSetting {
  String? get focusConnectScheduleID => throw _privateConstructorUsedError;

  /// Serializes this MedicineScheduleFocusConnectSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicineScheduleFocusConnectSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineScheduleFocusConnectSettingCopyWith<MedicineScheduleFocusConnectSetting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineScheduleFocusConnectSettingCopyWith<$Res> {
  factory $MedicineScheduleFocusConnectSettingCopyWith(
          MedicineScheduleFocusConnectSetting value, $Res Function(MedicineScheduleFocusConnectSetting) then) =
      _$MedicineScheduleFocusConnectSettingCopyWithImpl<$Res, MedicineScheduleFocusConnectSetting>;
  @useResult
  $Res call({String? focusConnectScheduleID});
}

/// @nodoc
class _$MedicineScheduleFocusConnectSettingCopyWithImpl<$Res, $Val extends MedicineScheduleFocusConnectSetting>
    implements $MedicineScheduleFocusConnectSettingCopyWith<$Res> {
  _$MedicineScheduleFocusConnectSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineScheduleFocusConnectSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? focusConnectScheduleID = freezed,
  }) {
    return _then(_value.copyWith(
      focusConnectScheduleID: freezed == focusConnectScheduleID
          ? _value.focusConnectScheduleID
          : focusConnectScheduleID // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicineScheduleFocusConnectSettingImplCopyWith<$Res> implements $MedicineScheduleFocusConnectSettingCopyWith<$Res> {
  factory _$$MedicineScheduleFocusConnectSettingImplCopyWith(
          _$MedicineScheduleFocusConnectSettingImpl value, $Res Function(_$MedicineScheduleFocusConnectSettingImpl) then) =
      __$$MedicineScheduleFocusConnectSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? focusConnectScheduleID});
}

/// @nodoc
class __$$MedicineScheduleFocusConnectSettingImplCopyWithImpl<$Res>
    extends _$MedicineScheduleFocusConnectSettingCopyWithImpl<$Res, _$MedicineScheduleFocusConnectSettingImpl>
    implements _$$MedicineScheduleFocusConnectSettingImplCopyWith<$Res> {
  __$$MedicineScheduleFocusConnectSettingImplCopyWithImpl(
      _$MedicineScheduleFocusConnectSettingImpl _value, $Res Function(_$MedicineScheduleFocusConnectSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineScheduleFocusConnectSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? focusConnectScheduleID = freezed,
  }) {
    return _then(_$MedicineScheduleFocusConnectSettingImpl(
      focusConnectScheduleID: freezed == focusConnectScheduleID
          ? _value.focusConnectScheduleID
          : focusConnectScheduleID // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicineScheduleFocusConnectSettingImpl extends _MedicineScheduleFocusConnectSetting {
  const _$MedicineScheduleFocusConnectSettingImpl({this.focusConnectScheduleID}) : super._();

  factory _$MedicineScheduleFocusConnectSettingImpl.fromJson(Map<String, dynamic> json) => _$$MedicineScheduleFocusConnectSettingImplFromJson(json);

  @override
  final String? focusConnectScheduleID;

  @override
  String toString() {
    return 'MedicineScheduleFocusConnectSetting(focusConnectScheduleID: $focusConnectScheduleID)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineScheduleFocusConnectSettingImpl &&
            (identical(other.focusConnectScheduleID, focusConnectScheduleID) || other.focusConnectScheduleID == focusConnectScheduleID));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, focusConnectScheduleID);

  /// Create a copy of MedicineScheduleFocusConnectSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineScheduleFocusConnectSettingImplCopyWith<_$MedicineScheduleFocusConnectSettingImpl> get copyWith =>
      __$$MedicineScheduleFocusConnectSettingImplCopyWithImpl<_$MedicineScheduleFocusConnectSettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineScheduleFocusConnectSettingImplToJson(
      this,
    );
  }
}

abstract class _MedicineScheduleFocusConnectSetting extends MedicineScheduleFocusConnectSetting {
  const factory _MedicineScheduleFocusConnectSetting({final String? focusConnectScheduleID}) = _$MedicineScheduleFocusConnectSettingImpl;
  const _MedicineScheduleFocusConnectSetting._() : super._();

  factory _MedicineScheduleFocusConnectSetting.fromJson(Map<String, dynamic> json) = _$MedicineScheduleFocusConnectSettingImpl.fromJson;

  @override
  String? get focusConnectScheduleID;

  /// Create a copy of MedicineScheduleFocusConnectSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineScheduleFocusConnectSettingImplCopyWith<_$MedicineScheduleFocusConnectSettingImpl> get copyWith => throw _privateConstructorUsedError;
}

MedicationSchedule _$MedicationScheduleFromJson(Map<String, dynamic> json) {
  return _MedicationSchedule.fromJson(json);
}

/// @nodoc
mixin _$MedicationSchedule {
  String get id => throw _privateConstructorUsedError;
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;
  String get quantityMemo => throw _privateConstructorUsedError;
  MedicineScheduleNotificationSetting get notificationSetting => throw _privateConstructorUsedError;
  MedicineScheduleFocusConnectSetting? get focusConnectSetting => throw _privateConstructorUsedError;

  /// Serializes this MedicationSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicationScheduleCopyWith<MedicationSchedule> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicationScheduleCopyWith<$Res> {
  factory $MedicationScheduleCopyWith(MedicationSchedule value, $Res Function(MedicationSchedule) then) =
      _$MedicationScheduleCopyWithImpl<$Res, MedicationSchedule>;
  @useResult
  $Res call(
      {String id,
      int hour,
      int minute,
      String quantityMemo,
      MedicineScheduleNotificationSetting notificationSetting,
      MedicineScheduleFocusConnectSetting? focusConnectSetting});

  $MedicineScheduleNotificationSettingCopyWith<$Res> get notificationSetting;
  $MedicineScheduleFocusConnectSettingCopyWith<$Res>? get focusConnectSetting;
}

/// @nodoc
class _$MedicationScheduleCopyWithImpl<$Res, $Val extends MedicationSchedule> implements $MedicationScheduleCopyWith<$Res> {
  _$MedicationScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hour = null,
    Object? minute = null,
    Object? quantityMemo = null,
    Object? notificationSetting = null,
    Object? focusConnectSetting = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
      quantityMemo: null == quantityMemo
          ? _value.quantityMemo
          : quantityMemo // ignore: cast_nullable_to_non_nullable
              as String,
      notificationSetting: null == notificationSetting
          ? _value.notificationSetting
          : notificationSetting // ignore: cast_nullable_to_non_nullable
              as MedicineScheduleNotificationSetting,
      focusConnectSetting: freezed == focusConnectSetting
          ? _value.focusConnectSetting
          : focusConnectSetting // ignore: cast_nullable_to_non_nullable
              as MedicineScheduleFocusConnectSetting?,
    ) as $Val);
  }

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineScheduleNotificationSettingCopyWith<$Res> get notificationSetting {
    return $MedicineScheduleNotificationSettingCopyWith<$Res>(_value.notificationSetting, (value) {
      return _then(_value.copyWith(notificationSetting: value) as $Val);
    });
  }

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineScheduleFocusConnectSettingCopyWith<$Res>? get focusConnectSetting {
    if (_value.focusConnectSetting == null) {
      return null;
    }

    return $MedicineScheduleFocusConnectSettingCopyWith<$Res>(_value.focusConnectSetting!, (value) {
      return _then(_value.copyWith(focusConnectSetting: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MedicationScheduleImplCopyWith<$Res> implements $MedicationScheduleCopyWith<$Res> {
  factory _$$MedicationScheduleImplCopyWith(_$MedicationScheduleImpl value, $Res Function(_$MedicationScheduleImpl) then) =
      __$$MedicationScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int hour,
      int minute,
      String quantityMemo,
      MedicineScheduleNotificationSetting notificationSetting,
      MedicineScheduleFocusConnectSetting? focusConnectSetting});

  @override
  $MedicineScheduleNotificationSettingCopyWith<$Res> get notificationSetting;
  @override
  $MedicineScheduleFocusConnectSettingCopyWith<$Res>? get focusConnectSetting;
}

/// @nodoc
class __$$MedicationScheduleImplCopyWithImpl<$Res> extends _$MedicationScheduleCopyWithImpl<$Res, _$MedicationScheduleImpl>
    implements _$$MedicationScheduleImplCopyWith<$Res> {
  __$$MedicationScheduleImplCopyWithImpl(_$MedicationScheduleImpl _value, $Res Function(_$MedicationScheduleImpl) _then) : super(_value, _then);

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hour = null,
    Object? minute = null,
    Object? quantityMemo = null,
    Object? notificationSetting = null,
    Object? focusConnectSetting = freezed,
  }) {
    return _then(_$MedicationScheduleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
      quantityMemo: null == quantityMemo
          ? _value.quantityMemo
          : quantityMemo // ignore: cast_nullable_to_non_nullable
              as String,
      notificationSetting: null == notificationSetting
          ? _value.notificationSetting
          : notificationSetting // ignore: cast_nullable_to_non_nullable
              as MedicineScheduleNotificationSetting,
      focusConnectSetting: freezed == focusConnectSetting
          ? _value.focusConnectSetting
          : focusConnectSetting // ignore: cast_nullable_to_non_nullable
              as MedicineScheduleFocusConnectSetting?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicationScheduleImpl extends _MedicationSchedule {
  const _$MedicationScheduleImpl(
      {required this.id,
      required this.hour,
      required this.minute,
      required this.quantityMemo,
      required this.notificationSetting,
      required this.focusConnectSetting})
      : super._();

  factory _$MedicationScheduleImpl.fromJson(Map<String, dynamic> json) => _$$MedicationScheduleImplFromJson(json);

  @override
  final String id;
  @override
  final int hour;
  @override
  final int minute;
  @override
  final String quantityMemo;
  @override
  final MedicineScheduleNotificationSetting notificationSetting;
  @override
  final MedicineScheduleFocusConnectSetting? focusConnectSetting;

  @override
  String toString() {
    return 'MedicationSchedule(id: $id, hour: $hour, minute: $minute, quantityMemo: $quantityMemo, notificationSetting: $notificationSetting, focusConnectSetting: $focusConnectSetting)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute) &&
            (identical(other.quantityMemo, quantityMemo) || other.quantityMemo == quantityMemo) &&
            (identical(other.notificationSetting, notificationSetting) || other.notificationSetting == notificationSetting) &&
            (identical(other.focusConnectSetting, focusConnectSetting) || other.focusConnectSetting == focusConnectSetting));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, hour, minute, quantityMemo, notificationSetting, focusConnectSetting);

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicationScheduleImplCopyWith<_$MedicationScheduleImpl> get copyWith =>
      __$$MedicationScheduleImplCopyWithImpl<_$MedicationScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicationScheduleImplToJson(
      this,
    );
  }
}

abstract class _MedicationSchedule extends MedicationSchedule {
  const factory _MedicationSchedule(
      {required final String id,
      required final int hour,
      required final int minute,
      required final String quantityMemo,
      required final MedicineScheduleNotificationSetting notificationSetting,
      required final MedicineScheduleFocusConnectSetting? focusConnectSetting}) = _$MedicationScheduleImpl;
  const _MedicationSchedule._() : super._();

  factory _MedicationSchedule.fromJson(Map<String, dynamic> json) = _$MedicationScheduleImpl.fromJson;

  @override
  String get id;
  @override
  int get hour;
  @override
  int get minute;
  @override
  String get quantityMemo;
  @override
  MedicineScheduleNotificationSetting get notificationSetting;
  @override
  MedicineScheduleFocusConnectSetting? get focusConnectSetting;

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicationScheduleImplCopyWith<_$MedicationScheduleImpl> get copyWith => throw _privateConstructorUsedError;
}
