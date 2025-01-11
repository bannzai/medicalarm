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
  MedicationFrequency get frequency => throw _privateConstructorUsedError;
  List<MedicationSchedule> get schedules => throw _privateConstructorUsedError;
  MedicineNotificationSetting get notificationSetting => throw _privateConstructorUsedError;
  int? get stock => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError; // null の場合は デフォルトdoseReciver(=User,自分)として扱う
  MedicineDoseReceiver? get doseReceiver => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  String get memoImageURL => throw _privateConstructorUsedError;
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
      MedicationFrequency frequency,
      List<MedicationSchedule> schedules,
      MedicineNotificationSetting notificationSetting,
      int? stock,
      String? unit,
      MedicineDoseReceiver? doseReceiver,
      String memo,
      String memoImageURL,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});

  $MedicationFrequencyCopyWith<$Res> get frequency;
  $MedicineNotificationSettingCopyWith<$Res> get notificationSetting;
  $MedicineDoseReceiverCopyWith<$Res>? get doseReceiver;
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
    Object? frequency = null,
    Object? schedules = null,
    Object? notificationSetting = null,
    Object? stock = freezed,
    Object? unit = freezed,
    Object? doseReceiver = freezed,
    Object? memo = null,
    Object? memoImageURL = null,
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
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as MedicationFrequency,
      schedules: null == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<MedicationSchedule>,
      notificationSetting: null == notificationSetting
          ? _value.notificationSetting
          : notificationSetting // ignore: cast_nullable_to_non_nullable
              as MedicineNotificationSetting,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      doseReceiver: freezed == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as MedicineDoseReceiver?,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      memoImageURL: null == memoImageURL
          ? _value.memoImageURL
          : memoImageURL // ignore: cast_nullable_to_non_nullable
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
  $MedicineNotificationSettingCopyWith<$Res> get notificationSetting {
    return $MedicineNotificationSettingCopyWith<$Res>(_value.notificationSetting, (value) {
      return _then(_value.copyWith(notificationSetting: value) as $Val);
    });
  }

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineDoseReceiverCopyWith<$Res>? get doseReceiver {
    if (_value.doseReceiver == null) {
      return null;
    }

    return $MedicineDoseReceiverCopyWith<$Res>(_value.doseReceiver!, (value) {
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
      String name,
      MedicationFrequency frequency,
      List<MedicationSchedule> schedules,
      MedicineNotificationSetting notificationSetting,
      int? stock,
      String? unit,
      MedicineDoseReceiver? doseReceiver,
      String memo,
      String memoImageURL,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});

  @override
  $MedicationFrequencyCopyWith<$Res> get frequency;
  @override
  $MedicineNotificationSettingCopyWith<$Res> get notificationSetting;
  @override
  $MedicineDoseReceiverCopyWith<$Res>? get doseReceiver;
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
    Object? frequency = null,
    Object? schedules = null,
    Object? notificationSetting = null,
    Object? stock = freezed,
    Object? unit = freezed,
    Object? doseReceiver = freezed,
    Object? memo = null,
    Object? memoImageURL = null,
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
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as MedicationFrequency,
      schedules: null == schedules
          ? _value._schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<MedicationSchedule>,
      notificationSetting: null == notificationSetting
          ? _value.notificationSetting
          : notificationSetting // ignore: cast_nullable_to_non_nullable
              as MedicineNotificationSetting,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      doseReceiver: freezed == doseReceiver
          ? _value.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as MedicineDoseReceiver?,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      memoImageURL: null == memoImageURL
          ? _value.memoImageURL
          : memoImageURL // ignore: cast_nullable_to_non_nullable
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
      required this.frequency,
      required final List<MedicationSchedule> schedules,
      required this.notificationSetting,
      required this.stock,
      required this.unit,
      required this.doseReceiver,
      required this.memo,
      required this.memoImageURL,
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
  final MedicineNotificationSetting notificationSetting;
  @override
  final int? stock;
  @override
  final String? unit;
// null の場合は デフォルトdoseReciver(=User,自分)として扱う
  @override
  final MedicineDoseReceiver? doseReceiver;
  @override
  final String memo;
  @override
  final String memoImageURL;
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
    return 'Medicine(id: $id, name: $name, frequency: $frequency, schedules: $schedules, notificationSetting: $notificationSetting, stock: $stock, unit: $unit, doseReceiver: $doseReceiver, memo: $memo, memoImageURL: $memoImageURL, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.frequency, frequency) || other.frequency == frequency) &&
            const DeepCollectionEquality().equals(other._schedules, _schedules) &&
            (identical(other.notificationSetting, notificationSetting) || other.notificationSetting == notificationSetting) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.doseReceiver, doseReceiver) || other.doseReceiver == doseReceiver) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.memoImageURL, memoImageURL) || other.memoImageURL == memoImageURL) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, frequency, const DeepCollectionEquality().hash(_schedules), notificationSetting, stock, unit,
      doseReceiver, memo, memoImageURL, createdDateTime, updatedDateTime, serverCreatedDateTime, serverUpdatedDateTime);

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
      required final MedicationFrequency frequency,
      required final List<MedicationSchedule> schedules,
      required final MedicineNotificationSetting notificationSetting,
      required final int? stock,
      required final String? unit,
      required final MedicineDoseReceiver? doseReceiver,
      required final String memo,
      required final String memoImageURL,
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
  MedicationFrequency get frequency;
  @override
  List<MedicationSchedule> get schedules;
  @override
  MedicineNotificationSetting get notificationSetting;
  @override
  int? get stock;
  @override
  String? get unit; // null の場合は デフォルトdoseReciver(=User,自分)として扱う
  @override
  MedicineDoseReceiver? get doseReceiver;
  @override
  String get memo;
  @override
  String get memoImageURL;
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
  bool get isReminderEnabled => throw _privateConstructorUsedError;
  bool get isFollowupEnabled => throw _privateConstructorUsedError;
  bool get useCriticalAlert => throw _privateConstructorUsedError;

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
  $Res call({bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert});
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
    Object? isReminderEnabled = null,
    Object? isFollowupEnabled = null,
    Object? useCriticalAlert = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicineNotificationSettingImplCopyWith<$Res> implements $MedicineNotificationSettingCopyWith<$Res> {
  factory _$$MedicineNotificationSettingImplCopyWith(_$MedicineNotificationSettingImpl value, $Res Function(_$MedicineNotificationSettingImpl) then) =
      __$$MedicineNotificationSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert});
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
    Object? isReminderEnabled = null,
    Object? isFollowupEnabled = null,
    Object? useCriticalAlert = null,
  }) {
    return _then(_$MedicineNotificationSettingImpl(
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
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicineNotificationSettingImpl extends _MedicineNotificationSetting {
  const _$MedicineNotificationSettingImpl({required this.isReminderEnabled, required this.isFollowupEnabled, required this.useCriticalAlert})
      : super._();

  factory _$MedicineNotificationSettingImpl.fromJson(Map<String, dynamic> json) => _$$MedicineNotificationSettingImplFromJson(json);

  @override
  final bool isReminderEnabled;
  @override
  final bool isFollowupEnabled;
  @override
  final bool useCriticalAlert;

  @override
  String toString() {
    return 'MedicineNotificationSetting(isReminderEnabled: $isReminderEnabled, isFollowupEnabled: $isFollowupEnabled, useCriticalAlert: $useCriticalAlert)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineNotificationSettingImpl &&
            (identical(other.isReminderEnabled, isReminderEnabled) || other.isReminderEnabled == isReminderEnabled) &&
            (identical(other.isFollowupEnabled, isFollowupEnabled) || other.isFollowupEnabled == isFollowupEnabled) &&
            (identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isReminderEnabled, isFollowupEnabled, useCriticalAlert);

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
      {required final bool isReminderEnabled,
      required final bool isFollowupEnabled,
      required final bool useCriticalAlert}) = _$MedicineNotificationSettingImpl;
  const _MedicineNotificationSetting._() : super._();

  factory _MedicineNotificationSetting.fromJson(Map<String, dynamic> json) = _$MedicineNotificationSettingImpl.fromJson;

  @override
  bool get isReminderEnabled;
  @override
  bool get isFollowupEnabled;
  @override
  bool get useCriticalAlert;

  /// Create a copy of MedicineNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineNotificationSettingImplCopyWith<_$MedicineNotificationSettingImpl> get copyWith => throw _privateConstructorUsedError;
}

MedicationSchedule _$MedicationScheduleFromJson(Map<String, dynamic> json) {
  return _MedicationSchedule.fromJson(json);
}

/// @nodoc
mixin _$MedicationSchedule {
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError; // 服用量
  int? get amount => throw _privateConstructorUsedError;

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
  $Res call({int hour, int minute, int? amount});
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
    Object? hour = null,
    Object? minute = null,
    Object? amount = freezed,
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
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicationScheduleImplCopyWith<$Res> implements $MedicationScheduleCopyWith<$Res> {
  factory _$$MedicationScheduleImplCopyWith(_$MedicationScheduleImpl value, $Res Function(_$MedicationScheduleImpl) then) =
      __$$MedicationScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int hour, int minute, int? amount});
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
    Object? hour = null,
    Object? minute = null,
    Object? amount = freezed,
  }) {
    return _then(_$MedicationScheduleImpl(
      hour: null == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicationScheduleImpl extends _MedicationSchedule {
  const _$MedicationScheduleImpl({required this.hour, required this.minute, required this.amount}) : super._();

  factory _$MedicationScheduleImpl.fromJson(Map<String, dynamic> json) => _$$MedicationScheduleImplFromJson(json);

  @override
  final int hour;
  @override
  final int minute;
// 服用量
  @override
  final int? amount;

  @override
  String toString() {
    return 'MedicationSchedule(hour: $hour, minute: $minute, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicationScheduleImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hour, minute, amount);

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
  const factory _MedicationSchedule({required final int hour, required final int minute, required final int? amount}) = _$MedicationScheduleImpl;
  const _MedicationSchedule._() : super._();

  factory _MedicationSchedule.fromJson(Map<String, dynamic> json) = _$MedicationScheduleImpl.fromJson;

  @override
  int get hour;
  @override
  int get minute; // 服用量
  @override
  int? get amount;

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicationScheduleImplCopyWith<_$MedicationScheduleImpl> get copyWith => throw _privateConstructorUsedError;
}

MedicineDoseReceiver _$MedicineDoseReceiverFromJson(Map<String, dynamic> json) {
  return _MedicineDoseReceiver.fromJson(json);
}

/// @nodoc
mixin _$MedicineDoseReceiver {
// lib/entity/DoseReceiver とは同期をとってないので、IDがnot foundの可能性がある
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this MedicineDoseReceiver to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicineDoseReceiver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineDoseReceiverCopyWith<MedicineDoseReceiver> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineDoseReceiverCopyWith<$Res> {
  factory $MedicineDoseReceiverCopyWith(MedicineDoseReceiver value, $Res Function(MedicineDoseReceiver) then) =
      _$MedicineDoseReceiverCopyWithImpl<$Res, MedicineDoseReceiver>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$MedicineDoseReceiverCopyWithImpl<$Res, $Val extends MedicineDoseReceiver> implements $MedicineDoseReceiverCopyWith<$Res> {
  _$MedicineDoseReceiverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineDoseReceiver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicineDoseReceiverImplCopyWith<$Res> implements $MedicineDoseReceiverCopyWith<$Res> {
  factory _$$MedicineDoseReceiverImplCopyWith(_$MedicineDoseReceiverImpl value, $Res Function(_$MedicineDoseReceiverImpl) then) =
      __$$MedicineDoseReceiverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$MedicineDoseReceiverImplCopyWithImpl<$Res> extends _$MedicineDoseReceiverCopyWithImpl<$Res, _$MedicineDoseReceiverImpl>
    implements _$$MedicineDoseReceiverImplCopyWith<$Res> {
  __$$MedicineDoseReceiverImplCopyWithImpl(_$MedicineDoseReceiverImpl _value, $Res Function(_$MedicineDoseReceiverImpl) _then) : super(_value, _then);

  /// Create a copy of MedicineDoseReceiver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$MedicineDoseReceiverImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MedicineDoseReceiverImpl extends _MedicineDoseReceiver {
  const _$MedicineDoseReceiverImpl({required this.id, required this.name}) : super._();

  factory _$MedicineDoseReceiverImpl.fromJson(Map<String, dynamic> json) => _$$MedicineDoseReceiverImplFromJson(json);

// lib/entity/DoseReceiver とは同期をとってないので、IDがnot foundの可能性がある
  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'MedicineDoseReceiver(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineDoseReceiverImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of MedicineDoseReceiver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineDoseReceiverImplCopyWith<_$MedicineDoseReceiverImpl> get copyWith =>
      __$$MedicineDoseReceiverImplCopyWithImpl<_$MedicineDoseReceiverImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineDoseReceiverImplToJson(
      this,
    );
  }
}

abstract class _MedicineDoseReceiver extends MedicineDoseReceiver {
  const factory _MedicineDoseReceiver({required final String id, required final String name}) = _$MedicineDoseReceiverImpl;
  const _MedicineDoseReceiver._() : super._();

  factory _MedicineDoseReceiver.fromJson(Map<String, dynamic> json) = _$MedicineDoseReceiverImpl.fromJson;

// lib/entity/DoseReceiver とは同期をとってないので、IDがnot foundの可能性がある
  @override
  String get id;
  @override
  String get name;

  /// Create a copy of MedicineDoseReceiver
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineDoseReceiverImplCopyWith<_$MedicineDoseReceiverImpl> get copyWith => throw _privateConstructorUsedError;
}
