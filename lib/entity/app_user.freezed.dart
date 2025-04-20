// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
mixin _$AppUser {
  String? get id => throw _privateConstructorUsedError;
  bool get analyticsDebugIsEnabled => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get trialDeadlineDate => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get promotionStartPageCancelButtonTappedDateTime => throw _privateConstructorUsedError;
  @ClientCreatedTimestamp()
  DateTime? get createdDateTime => throw _privateConstructorUsedError;
  @ClientUpdatedTimestamp()
  DateTime? get updatedDateTime => throw _privateConstructorUsedError;
  @ServerCreatedTimestamp()
  DateTime? get serverCreatedDateTime => throw _privateConstructorUsedError;
  @ServerUpdatedTimestamp()
  DateTime? get serverUpdatedDateTime => throw _privateConstructorUsedError;

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) = _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call(
      {String? id,
      bool analyticsDebugIsEnabled,
      @NullableTimestampConverter() DateTime? trialDeadlineDate,
      @NullableTimestampConverter() DateTime? promotionStartPageCancelButtonTappedDateTime,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser> implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? analyticsDebugIsEnabled = null,
    Object? trialDeadlineDate = freezed,
    Object? promotionStartPageCancelButtonTappedDateTime = freezed,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      analyticsDebugIsEnabled: null == analyticsDebugIsEnabled
          ? _value.analyticsDebugIsEnabled
          : analyticsDebugIsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      trialDeadlineDate: freezed == trialDeadlineDate
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      promotionStartPageCancelButtonTappedDateTime: freezed == promotionStartPageCancelButtonTappedDateTime
          ? _value.promotionStartPageCancelButtonTappedDateTime
          : promotionStartPageCancelButtonTappedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(_$AppUserImpl value, $Res Function(_$AppUserImpl) then) = __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      bool analyticsDebugIsEnabled,
      @NullableTimestampConverter() DateTime? trialDeadlineDate,
      @NullableTimestampConverter() DateTime? promotionStartPageCancelButtonTappedDateTime,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res> extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl> implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(_$AppUserImpl _value, $Res Function(_$AppUserImpl) _then) : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? analyticsDebugIsEnabled = null,
    Object? trialDeadlineDate = freezed,
    Object? promotionStartPageCancelButtonTappedDateTime = freezed,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
  }) {
    return _then(_$AppUserImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      analyticsDebugIsEnabled: null == analyticsDebugIsEnabled
          ? _value.analyticsDebugIsEnabled
          : analyticsDebugIsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      trialDeadlineDate: freezed == trialDeadlineDate
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      promotionStartPageCancelButtonTappedDateTime: freezed == promotionStartPageCancelButtonTappedDateTime
          ? _value.promotionStartPageCancelButtonTappedDateTime
          : promotionStartPageCancelButtonTappedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$AppUserImpl extends _AppUser {
  const _$AppUserImpl(
      {this.id,
      this.analyticsDebugIsEnabled = false,
      @NullableTimestampConverter() this.trialDeadlineDate,
      @NullableTimestampConverter() this.promotionStartPageCancelButtonTappedDateTime,
      @ClientCreatedTimestamp() this.createdDateTime,
      @ClientUpdatedTimestamp() this.updatedDateTime,
      @ServerCreatedTimestamp() this.serverCreatedDateTime,
      @ServerUpdatedTimestamp() this.serverUpdatedDateTime})
      : super._();

  factory _$AppUserImpl.fromJson(Map<String, dynamic> json) => _$$AppUserImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey()
  final bool analyticsDebugIsEnabled;
  @override
  @NullableTimestampConverter()
  final DateTime? trialDeadlineDate;
  @override
  @NullableTimestampConverter()
  final DateTime? promotionStartPageCancelButtonTappedDateTime;
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
    return 'AppUser(id: $id, analyticsDebugIsEnabled: $analyticsDebugIsEnabled, trialDeadlineDate: $trialDeadlineDate, promotionStartPageCancelButtonTappedDateTime: $promotionStartPageCancelButtonTappedDateTime, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.analyticsDebugIsEnabled, analyticsDebugIsEnabled) || other.analyticsDebugIsEnabled == analyticsDebugIsEnabled) &&
            (identical(other.trialDeadlineDate, trialDeadlineDate) || other.trialDeadlineDate == trialDeadlineDate) &&
            (identical(other.promotionStartPageCancelButtonTappedDateTime, promotionStartPageCancelButtonTappedDateTime) ||
                other.promotionStartPageCancelButtonTappedDateTime == promotionStartPageCancelButtonTappedDateTime) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, analyticsDebugIsEnabled, trialDeadlineDate, promotionStartPageCancelButtonTappedDateTime,
      createdDateTime, updatedDateTime, serverCreatedDateTime, serverUpdatedDateTime);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith => __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserImplToJson(
      this,
    );
  }
}

abstract class _AppUser extends AppUser {
  const factory _AppUser(
      {final String? id,
      final bool analyticsDebugIsEnabled,
      @NullableTimestampConverter() final DateTime? trialDeadlineDate,
      @NullableTimestampConverter() final DateTime? promotionStartPageCancelButtonTappedDateTime,
      @ClientCreatedTimestamp() final DateTime? createdDateTime,
      @ClientUpdatedTimestamp() final DateTime? updatedDateTime,
      @ServerCreatedTimestamp() final DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() final DateTime? serverUpdatedDateTime}) = _$AppUserImpl;
  const _AppUser._() : super._();

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$AppUserImpl.fromJson;

  @override
  String? get id;
  @override
  bool get analyticsDebugIsEnabled;
  @override
  @NullableTimestampConverter()
  DateTime? get trialDeadlineDate;
  @override
  @NullableTimestampConverter()
  DateTime? get promotionStartPageCancelButtonTappedDateTime;
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

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith => throw _privateConstructorUsedError;
}
