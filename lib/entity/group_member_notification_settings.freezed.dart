// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_member_notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupMemberNotificationSettings {

/// ドキュメント ID。userID と同一。
 String get id; String get groupID; String get userID;/// medicineID -> scheduleID -> 個別通知設定 の 2 段マップ。
 Map<String, Map<String, MemberScheduleNotificationSetting>> get settings;@ClientCreatedTimestamp() DateTime? get createdDateTime;@ClientUpdatedTimestamp() DateTime? get updatedDateTime;@ServerCreatedTimestamp() DateTime? get serverCreatedDateTime;@ServerUpdatedTimestamp() DateTime? get serverUpdatedDateTime;
/// Create a copy of GroupMemberNotificationSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMemberNotificationSettingsCopyWith<GroupMemberNotificationSettings> get copyWith => _$GroupMemberNotificationSettingsCopyWithImpl<GroupMemberNotificationSettings>(this as GroupMemberNotificationSettings, _$identity);

  /// Serializes this GroupMemberNotificationSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GroupMemberNotificationSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMemberNotificationSettings&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.groupID, _this.groupID) || other.groupID == _this.groupID)&&(identical(other.userID, _this.userID) || other.userID == _this.userID)&&const DeepCollectionEquality().equals(other.settings, _this.settings)&&(identical(other.createdDateTime, _this.createdDateTime) || other.createdDateTime == _this.createdDateTime)&&(identical(other.updatedDateTime, _this.updatedDateTime) || other.updatedDateTime == _this.updatedDateTime)&&(identical(other.serverCreatedDateTime, _this.serverCreatedDateTime) || other.serverCreatedDateTime == _this.serverCreatedDateTime)&&(identical(other.serverUpdatedDateTime, _this.serverUpdatedDateTime) || other.serverUpdatedDateTime == _this.serverUpdatedDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GroupMemberNotificationSettings;
  return Object.hash(runtimeType,_this.id,_this.groupID,_this.userID,const DeepCollectionEquality().hash(_this.settings),_this.createdDateTime,_this.updatedDateTime,_this.serverCreatedDateTime,_this.serverUpdatedDateTime);
}

@override
String toString() {
  final _this = this as GroupMemberNotificationSettings;
  return 'GroupMemberNotificationSettings(id: ${_this.id}, groupID: ${_this.groupID}, userID: ${_this.userID}, settings: ${_this.settings}, createdDateTime: ${_this.createdDateTime}, updatedDateTime: ${_this.updatedDateTime}, serverCreatedDateTime: ${_this.serverCreatedDateTime}, serverUpdatedDateTime: ${_this.serverUpdatedDateTime})';
}


}

/// @nodoc
abstract mixin class $GroupMemberNotificationSettingsCopyWith<$Res>  {
  factory $GroupMemberNotificationSettingsCopyWith(GroupMemberNotificationSettings value, $Res Function(GroupMemberNotificationSettings) _then) = _$GroupMemberNotificationSettingsCopyWithImpl;
@useResult
$Res call({
 String id, String groupID, String userID, Map<String, Map<String, MemberScheduleNotificationSetting>> settings,@ClientCreatedTimestamp() DateTime? createdDateTime,@ClientUpdatedTimestamp() DateTime? updatedDateTime,@ServerCreatedTimestamp() DateTime? serverCreatedDateTime,@ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime
});




}
/// @nodoc
class _$GroupMemberNotificationSettingsCopyWithImpl<$Res>
    implements $GroupMemberNotificationSettingsCopyWith<$Res> {
  _$GroupMemberNotificationSettingsCopyWithImpl(this._self, this._then);

  final GroupMemberNotificationSettings _self;
  final $Res Function(GroupMemberNotificationSettings) _then;

/// Create a copy of GroupMemberNotificationSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupID = null,Object? userID = null,Object? settings = null,Object? createdDateTime = freezed,Object? updatedDateTime = freezed,Object? serverCreatedDateTime = freezed,Object? serverUpdatedDateTime = freezed,}) {
  return _then(GroupMemberNotificationSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupID: null == groupID ? _self.groupID : groupID // ignore: cast_nullable_to_non_nullable
as String,userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, MemberScheduleNotificationSetting>>,createdDateTime: freezed == createdDateTime ? _self.createdDateTime : createdDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedDateTime: freezed == updatedDateTime ? _self.updatedDateTime : updatedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,serverCreatedDateTime: freezed == serverCreatedDateTime ? _self.serverCreatedDateTime : serverCreatedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,serverUpdatedDateTime: freezed == serverUpdatedDateTime ? _self.serverUpdatedDateTime : serverUpdatedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupMemberNotificationSettings].
extension GroupMemberNotificationSettingsPatterns on GroupMemberNotificationSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMemberNotificationSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMemberNotificationSettings() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMemberNotificationSettings value)  $default,){
final _that = this;
switch (_that) {
case _GroupMemberNotificationSettings():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMemberNotificationSettings value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMemberNotificationSettings() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupID,  String userID,  Map<String, Map<String, MemberScheduleNotificationSetting>> settings, @ClientCreatedTimestamp()  DateTime? createdDateTime, @ClientUpdatedTimestamp()  DateTime? updatedDateTime, @ServerCreatedTimestamp()  DateTime? serverCreatedDateTime, @ServerUpdatedTimestamp()  DateTime? serverUpdatedDateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupMemberNotificationSettings() when $default != null:
return $default(_that.id,_that.groupID,_that.userID,_that.settings,_that.createdDateTime,_that.updatedDateTime,_that.serverCreatedDateTime,_that.serverUpdatedDateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupID,  String userID,  Map<String, Map<String, MemberScheduleNotificationSetting>> settings, @ClientCreatedTimestamp()  DateTime? createdDateTime, @ClientUpdatedTimestamp()  DateTime? updatedDateTime, @ServerCreatedTimestamp()  DateTime? serverCreatedDateTime, @ServerUpdatedTimestamp()  DateTime? serverUpdatedDateTime)  $default,) {final _that = this;
switch (_that) {
case _GroupMemberNotificationSettings():
return $default(_that.id,_that.groupID,_that.userID,_that.settings,_that.createdDateTime,_that.updatedDateTime,_that.serverCreatedDateTime,_that.serverUpdatedDateTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupID,  String userID,  Map<String, Map<String, MemberScheduleNotificationSetting>> settings, @ClientCreatedTimestamp()  DateTime? createdDateTime, @ClientUpdatedTimestamp()  DateTime? updatedDateTime, @ServerCreatedTimestamp()  DateTime? serverCreatedDateTime, @ServerUpdatedTimestamp()  DateTime? serverUpdatedDateTime)?  $default,) {final _that = this;
switch (_that) {
case _GroupMemberNotificationSettings() when $default != null:
return $default(_that.id,_that.groupID,_that.userID,_that.settings,_that.createdDateTime,_that.updatedDateTime,_that.serverCreatedDateTime,_that.serverUpdatedDateTime);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GroupMemberNotificationSettings extends GroupMemberNotificationSettings {
  const _GroupMemberNotificationSettings({required this.id, required this.groupID, required this.userID,  Map<String, Map<String, MemberScheduleNotificationSetting>> settings = const {}, @ClientCreatedTimestamp() this.createdDateTime, @ClientUpdatedTimestamp() this.updatedDateTime, @ServerCreatedTimestamp() this.serverCreatedDateTime, @ServerUpdatedTimestamp() this.serverUpdatedDateTime}): _settings = settings,super._();
  factory _GroupMemberNotificationSettings.fromJson(Map<String, dynamic> json) => _$GroupMemberNotificationSettingsFromJson(json);

/// ドキュメント ID。userID と同一。
@override final  String id;
@override final  String groupID;
@override final  String userID;
/// medicineID -> scheduleID -> 個別通知設定 の 2 段マップ。
 final  Map<String, Map<String, MemberScheduleNotificationSetting>> _settings;
/// medicineID -> scheduleID -> 個別通知設定 の 2 段マップ。
@override@JsonKey() Map<String, Map<String, MemberScheduleNotificationSetting>> get settings {
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settings);
}

@override@ClientCreatedTimestamp() final  DateTime? createdDateTime;
@override@ClientUpdatedTimestamp() final  DateTime? updatedDateTime;
@override@ServerCreatedTimestamp() final  DateTime? serverCreatedDateTime;
@override@ServerUpdatedTimestamp() final  DateTime? serverUpdatedDateTime;

/// Create a copy of GroupMemberNotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMemberNotificationSettingsCopyWith<_GroupMemberNotificationSettings> get copyWith => __$GroupMemberNotificationSettingsCopyWithImpl<_GroupMemberNotificationSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupMemberNotificationSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMemberNotificationSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.groupID, groupID) || other.groupID == groupID)&&(identical(other.userID, userID) || other.userID == userID)&&const DeepCollectionEquality().equals(other.settings, _settings)&&(identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime)&&(identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime)&&(identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime)&&(identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,groupID,userID,const DeepCollectionEquality().hash(_settings),createdDateTime,updatedDateTime,serverCreatedDateTime,serverUpdatedDateTime);
}

@override
String toString() {
    return 'GroupMemberNotificationSettings(id: $id, groupID: $groupID, userID: $userID, settings: $settings, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
}


}

/// @nodoc
abstract mixin class _$GroupMemberNotificationSettingsCopyWith<$Res> implements $GroupMemberNotificationSettingsCopyWith<$Res> {
  factory _$GroupMemberNotificationSettingsCopyWith(_GroupMemberNotificationSettings value, $Res Function(_GroupMemberNotificationSettings) _then) = __$GroupMemberNotificationSettingsCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupID, String userID, Map<String, Map<String, MemberScheduleNotificationSetting>> settings,@ClientCreatedTimestamp() DateTime? createdDateTime,@ClientUpdatedTimestamp() DateTime? updatedDateTime,@ServerCreatedTimestamp() DateTime? serverCreatedDateTime,@ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime
});




}
/// @nodoc
class __$GroupMemberNotificationSettingsCopyWithImpl<$Res>
    implements _$GroupMemberNotificationSettingsCopyWith<$Res> {
  __$GroupMemberNotificationSettingsCopyWithImpl(this._self, this._then);

  final _GroupMemberNotificationSettings _self;
  final $Res Function(_GroupMemberNotificationSettings) _then;

/// Create a copy of GroupMemberNotificationSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupID = null,Object? userID = null,Object? settings = null,Object? createdDateTime = freezed,Object? updatedDateTime = freezed,Object? serverCreatedDateTime = freezed,Object? serverUpdatedDateTime = freezed,}) {
  return _then(_GroupMemberNotificationSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupID: null == groupID ? _self.groupID : groupID // ignore: cast_nullable_to_non_nullable
as String,userID: null == userID ? _self.userID : userID // ignore: cast_nullable_to_non_nullable
as String,settings: null == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, MemberScheduleNotificationSetting>>,createdDateTime: freezed == createdDateTime ? _self.createdDateTime : createdDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedDateTime: freezed == updatedDateTime ? _self.updatedDateTime : updatedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,serverCreatedDateTime: freezed == serverCreatedDateTime ? _self.serverCreatedDateTime : serverCreatedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,serverUpdatedDateTime: freezed == serverUpdatedDateTime ? _self.serverUpdatedDateTime : serverUpdatedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MemberScheduleNotificationSetting {

 bool get isReminderEnabled; bool get isFollowupEnabled; bool get useCriticalAlert; double get criticalAlertVolume; bool get useAlarmKit;/// Focus 連携も端末個人の設定なので個別部に含める。
 String? get focusConnectScheduleID;
/// Create a copy of MemberScheduleNotificationSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberScheduleNotificationSettingCopyWith<MemberScheduleNotificationSetting> get copyWith => _$MemberScheduleNotificationSettingCopyWithImpl<MemberScheduleNotificationSetting>(this as MemberScheduleNotificationSetting, _$identity);

  /// Serializes this MemberScheduleNotificationSetting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemberScheduleNotificationSetting;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberScheduleNotificationSetting&&(identical(other.isReminderEnabled, _this.isReminderEnabled) || other.isReminderEnabled == _this.isReminderEnabled)&&(identical(other.isFollowupEnabled, _this.isFollowupEnabled) || other.isFollowupEnabled == _this.isFollowupEnabled)&&(identical(other.useCriticalAlert, _this.useCriticalAlert) || other.useCriticalAlert == _this.useCriticalAlert)&&(identical(other.criticalAlertVolume, _this.criticalAlertVolume) || other.criticalAlertVolume == _this.criticalAlertVolume)&&(identical(other.useAlarmKit, _this.useAlarmKit) || other.useAlarmKit == _this.useAlarmKit)&&(identical(other.focusConnectScheduleID, _this.focusConnectScheduleID) || other.focusConnectScheduleID == _this.focusConnectScheduleID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemberScheduleNotificationSetting;
  return Object.hash(runtimeType,_this.isReminderEnabled,_this.isFollowupEnabled,_this.useCriticalAlert,_this.criticalAlertVolume,_this.useAlarmKit,_this.focusConnectScheduleID);
}

@override
String toString() {
  final _this = this as MemberScheduleNotificationSetting;
  return 'MemberScheduleNotificationSetting(isReminderEnabled: ${_this.isReminderEnabled}, isFollowupEnabled: ${_this.isFollowupEnabled}, useCriticalAlert: ${_this.useCriticalAlert}, criticalAlertVolume: ${_this.criticalAlertVolume}, useAlarmKit: ${_this.useAlarmKit}, focusConnectScheduleID: ${_this.focusConnectScheduleID})';
}


}

/// @nodoc
abstract mixin class $MemberScheduleNotificationSettingCopyWith<$Res>  {
  factory $MemberScheduleNotificationSettingCopyWith(MemberScheduleNotificationSetting value, $Res Function(MemberScheduleNotificationSetting) _then) = _$MemberScheduleNotificationSettingCopyWithImpl;
@useResult
$Res call({
 bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert, double criticalAlertVolume, bool useAlarmKit, String? focusConnectScheduleID
});




}
/// @nodoc
class _$MemberScheduleNotificationSettingCopyWithImpl<$Res>
    implements $MemberScheduleNotificationSettingCopyWith<$Res> {
  _$MemberScheduleNotificationSettingCopyWithImpl(this._self, this._then);

  final MemberScheduleNotificationSetting _self;
  final $Res Function(MemberScheduleNotificationSetting) _then;

/// Create a copy of MemberScheduleNotificationSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isReminderEnabled = null,Object? isFollowupEnabled = null,Object? useCriticalAlert = null,Object? criticalAlertVolume = null,Object? useAlarmKit = null,Object? focusConnectScheduleID = freezed,}) {
  return _then(MemberScheduleNotificationSetting(
isReminderEnabled: null == isReminderEnabled ? _self.isReminderEnabled : isReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,isFollowupEnabled: null == isFollowupEnabled ? _self.isFollowupEnabled : isFollowupEnabled // ignore: cast_nullable_to_non_nullable
as bool,useCriticalAlert: null == useCriticalAlert ? _self.useCriticalAlert : useCriticalAlert // ignore: cast_nullable_to_non_nullable
as bool,criticalAlertVolume: null == criticalAlertVolume ? _self.criticalAlertVolume : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
as double,useAlarmKit: null == useAlarmKit ? _self.useAlarmKit : useAlarmKit // ignore: cast_nullable_to_non_nullable
as bool,focusConnectScheduleID: freezed == focusConnectScheduleID ? _self.focusConnectScheduleID : focusConnectScheduleID // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberScheduleNotificationSetting].
extension MemberScheduleNotificationSettingPatterns on MemberScheduleNotificationSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberScheduleNotificationSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberScheduleNotificationSetting() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberScheduleNotificationSetting value)  $default,){
final _that = this;
switch (_that) {
case _MemberScheduleNotificationSetting():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberScheduleNotificationSetting value)?  $default,){
final _that = this;
switch (_that) {
case _MemberScheduleNotificationSetting() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isReminderEnabled,  bool isFollowupEnabled,  bool useCriticalAlert,  double criticalAlertVolume,  bool useAlarmKit,  String? focusConnectScheduleID)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberScheduleNotificationSetting() when $default != null:
return $default(_that.isReminderEnabled,_that.isFollowupEnabled,_that.useCriticalAlert,_that.criticalAlertVolume,_that.useAlarmKit,_that.focusConnectScheduleID);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isReminderEnabled,  bool isFollowupEnabled,  bool useCriticalAlert,  double criticalAlertVolume,  bool useAlarmKit,  String? focusConnectScheduleID)  $default,) {final _that = this;
switch (_that) {
case _MemberScheduleNotificationSetting():
return $default(_that.isReminderEnabled,_that.isFollowupEnabled,_that.useCriticalAlert,_that.criticalAlertVolume,_that.useAlarmKit,_that.focusConnectScheduleID);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isReminderEnabled,  bool isFollowupEnabled,  bool useCriticalAlert,  double criticalAlertVolume,  bool useAlarmKit,  String? focusConnectScheduleID)?  $default,) {final _that = this;
switch (_that) {
case _MemberScheduleNotificationSetting() when $default != null:
return $default(_that.isReminderEnabled,_that.isFollowupEnabled,_that.useCriticalAlert,_that.criticalAlertVolume,_that.useAlarmKit,_that.focusConnectScheduleID);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MemberScheduleNotificationSetting extends MemberScheduleNotificationSetting {
  const _MemberScheduleNotificationSetting({required this.isReminderEnabled, required this.isFollowupEnabled, required this.useCriticalAlert, this.criticalAlertVolume = 0.5, this.useAlarmKit = false, this.focusConnectScheduleID}): super._();
  factory _MemberScheduleNotificationSetting.fromJson(Map<String, dynamic> json) => _$MemberScheduleNotificationSettingFromJson(json);

@override final  bool isReminderEnabled;
@override final  bool isFollowupEnabled;
@override final  bool useCriticalAlert;
@override@JsonKey() final  double criticalAlertVolume;
@override@JsonKey() final  bool useAlarmKit;
/// Focus 連携も端末個人の設定なので個別部に含める。
@override final  String? focusConnectScheduleID;

/// Create a copy of MemberScheduleNotificationSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberScheduleNotificationSettingCopyWith<_MemberScheduleNotificationSetting> get copyWith => __$MemberScheduleNotificationSettingCopyWithImpl<_MemberScheduleNotificationSetting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberScheduleNotificationSettingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberScheduleNotificationSetting&&(identical(other.isReminderEnabled, isReminderEnabled) || other.isReminderEnabled == isReminderEnabled)&&(identical(other.isFollowupEnabled, isFollowupEnabled) || other.isFollowupEnabled == isFollowupEnabled)&&(identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert)&&(identical(other.criticalAlertVolume, criticalAlertVolume) || other.criticalAlertVolume == criticalAlertVolume)&&(identical(other.useAlarmKit, useAlarmKit) || other.useAlarmKit == useAlarmKit)&&(identical(other.focusConnectScheduleID, focusConnectScheduleID) || other.focusConnectScheduleID == focusConnectScheduleID));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,isReminderEnabled,isFollowupEnabled,useCriticalAlert,criticalAlertVolume,useAlarmKit,focusConnectScheduleID);
}

@override
String toString() {
    return 'MemberScheduleNotificationSetting(isReminderEnabled: $isReminderEnabled, isFollowupEnabled: $isFollowupEnabled, useCriticalAlert: $useCriticalAlert, criticalAlertVolume: $criticalAlertVolume, useAlarmKit: $useAlarmKit, focusConnectScheduleID: $focusConnectScheduleID)';
}


}

/// @nodoc
abstract mixin class _$MemberScheduleNotificationSettingCopyWith<$Res> implements $MemberScheduleNotificationSettingCopyWith<$Res> {
  factory _$MemberScheduleNotificationSettingCopyWith(_MemberScheduleNotificationSetting value, $Res Function(_MemberScheduleNotificationSetting) _then) = __$MemberScheduleNotificationSettingCopyWithImpl;
@override @useResult
$Res call({
 bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert, double criticalAlertVolume, bool useAlarmKit, String? focusConnectScheduleID
});




}
/// @nodoc
class __$MemberScheduleNotificationSettingCopyWithImpl<$Res>
    implements _$MemberScheduleNotificationSettingCopyWith<$Res> {
  __$MemberScheduleNotificationSettingCopyWithImpl(this._self, this._then);

  final _MemberScheduleNotificationSetting _self;
  final $Res Function(_MemberScheduleNotificationSetting) _then;

/// Create a copy of MemberScheduleNotificationSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isReminderEnabled = null,Object? isFollowupEnabled = null,Object? useCriticalAlert = null,Object? criticalAlertVolume = null,Object? useAlarmKit = null,Object? focusConnectScheduleID = freezed,}) {
  return _then(_MemberScheduleNotificationSetting(
isReminderEnabled: null == isReminderEnabled ? _self.isReminderEnabled : isReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,isFollowupEnabled: null == isFollowupEnabled ? _self.isFollowupEnabled : isFollowupEnabled // ignore: cast_nullable_to_non_nullable
as bool,useCriticalAlert: null == useCriticalAlert ? _self.useCriticalAlert : useCriticalAlert // ignore: cast_nullable_to_non_nullable
as bool,criticalAlertVolume: null == criticalAlertVolume ? _self.criticalAlertVolume : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
as double,useAlarmKit: null == useAlarmKit ? _self.useAlarmKit : useAlarmKit // ignore: cast_nullable_to_non_nullable
as bool,focusConnectScheduleID: freezed == focusConnectScheduleID ? _self.focusConnectScheduleID : focusConnectScheduleID // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
