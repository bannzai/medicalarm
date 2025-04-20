// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RemoteConfigParameter _$RemoteConfigParameterFromJson(Map<String, dynamic> json) {
  return _RemoteConfigParameter.fromJson(json);
}

/// @nodoc
mixin _$RemoteConfigParameter {
  String get minimumAppVersion => throw _privateConstructorUsedError;
  int get promotionDayCount => throw _privateConstructorUsedError;

  /// Serializes this RemoteConfigParameter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RemoteConfigParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemoteConfigParameterCopyWith<RemoteConfigParameter> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteConfigParameterCopyWith<$Res> {
  factory $RemoteConfigParameterCopyWith(RemoteConfigParameter value, $Res Function(RemoteConfigParameter) then) =
      _$RemoteConfigParameterCopyWithImpl<$Res, RemoteConfigParameter>;
  @useResult
  $Res call({String minimumAppVersion, int promotionDayCount});
}

/// @nodoc
class _$RemoteConfigParameterCopyWithImpl<$Res, $Val extends RemoteConfigParameter> implements $RemoteConfigParameterCopyWith<$Res> {
  _$RemoteConfigParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemoteConfigParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumAppVersion = null,
    Object? promotionDayCount = null,
  }) {
    return _then(_value.copyWith(
      minimumAppVersion: null == minimumAppVersion
          ? _value.minimumAppVersion
          : minimumAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
      promotionDayCount: null == promotionDayCount
          ? _value.promotionDayCount
          : promotionDayCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RemoteConfigParameterImplCopyWith<$Res> implements $RemoteConfigParameterCopyWith<$Res> {
  factory _$$RemoteConfigParameterImplCopyWith(_$RemoteConfigParameterImpl value, $Res Function(_$RemoteConfigParameterImpl) then) =
      __$$RemoteConfigParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String minimumAppVersion, int promotionDayCount});
}

/// @nodoc
class __$$RemoteConfigParameterImplCopyWithImpl<$Res> extends _$RemoteConfigParameterCopyWithImpl<$Res, _$RemoteConfigParameterImpl>
    implements _$$RemoteConfigParameterImplCopyWith<$Res> {
  __$$RemoteConfigParameterImplCopyWithImpl(_$RemoteConfigParameterImpl _value, $Res Function(_$RemoteConfigParameterImpl) _then)
      : super(_value, _then);

  /// Create a copy of RemoteConfigParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumAppVersion = null,
    Object? promotionDayCount = null,
  }) {
    return _then(_$RemoteConfigParameterImpl(
      minimumAppVersion: null == minimumAppVersion
          ? _value.minimumAppVersion
          : minimumAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
      promotionDayCount: null == promotionDayCount
          ? _value.promotionDayCount
          : promotionDayCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteConfigParameterImpl extends _RemoteConfigParameter {
  _$RemoteConfigParameterImpl(
      {this.minimumAppVersion = RemoteConfigParameterDefaultValues.minimumAppVersion,
      this.promotionDayCount = RemoteConfigParameterDefaultValues.promotionDayCount})
      : super._();

  factory _$RemoteConfigParameterImpl.fromJson(Map<String, dynamic> json) => _$$RemoteConfigParameterImplFromJson(json);

  @override
  @JsonKey()
  final String minimumAppVersion;
  @override
  @JsonKey()
  final int promotionDayCount;

  @override
  String toString() {
    return 'RemoteConfigParameter(minimumAppVersion: $minimumAppVersion, promotionDayCount: $promotionDayCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteConfigParameterImpl &&
            (identical(other.minimumAppVersion, minimumAppVersion) || other.minimumAppVersion == minimumAppVersion) &&
            (identical(other.promotionDayCount, promotionDayCount) || other.promotionDayCount == promotionDayCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, minimumAppVersion, promotionDayCount);

  /// Create a copy of RemoteConfigParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteConfigParameterImplCopyWith<_$RemoteConfigParameterImpl> get copyWith =>
      __$$RemoteConfigParameterImplCopyWithImpl<_$RemoteConfigParameterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteConfigParameterImplToJson(
      this,
    );
  }
}

abstract class _RemoteConfigParameter extends RemoteConfigParameter {
  factory _RemoteConfigParameter({final String minimumAppVersion, final int promotionDayCount}) = _$RemoteConfigParameterImpl;
  _RemoteConfigParameter._() : super._();

  factory _RemoteConfigParameter.fromJson(Map<String, dynamic> json) = _$RemoteConfigParameterImpl.fromJson;

  @override
  String get minimumAppVersion;
  @override
  int get promotionDayCount;

  /// Create a copy of RemoteConfigParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoteConfigParameterImplCopyWith<_$RemoteConfigParameterImpl> get copyWith => throw _privateConstructorUsedError;
}
