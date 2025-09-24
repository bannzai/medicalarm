// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemoteConfigParameter {
  String get minimumAppVersion;
  int get promotionDayCount;
  String get releasedVersion;

  /// Create a copy of RemoteConfigParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RemoteConfigParameterCopyWith<RemoteConfigParameter> get copyWith =>
      _$RemoteConfigParameterCopyWithImpl<RemoteConfigParameter>(this as RemoteConfigParameter, _$identity);

  /// Serializes this RemoteConfigParameter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RemoteConfigParameter &&
            (identical(other.minimumAppVersion, minimumAppVersion) || other.minimumAppVersion == minimumAppVersion) &&
            (identical(other.promotionDayCount, promotionDayCount) || other.promotionDayCount == promotionDayCount) &&
            (identical(other.releasedVersion, releasedVersion) || other.releasedVersion == releasedVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, minimumAppVersion, promotionDayCount, releasedVersion);

  @override
  String toString() {
    return 'RemoteConfigParameter(minimumAppVersion: $minimumAppVersion, promotionDayCount: $promotionDayCount, releasedVersion: $releasedVersion)';
  }
}

/// @nodoc
abstract mixin class $RemoteConfigParameterCopyWith<$Res> {
  factory $RemoteConfigParameterCopyWith(RemoteConfigParameter value, $Res Function(RemoteConfigParameter) _then) =
      _$RemoteConfigParameterCopyWithImpl;
  @useResult
  $Res call({String minimumAppVersion, int promotionDayCount, String releasedVersion});
}

/// @nodoc
class _$RemoteConfigParameterCopyWithImpl<$Res> implements $RemoteConfigParameterCopyWith<$Res> {
  _$RemoteConfigParameterCopyWithImpl(this._self, this._then);

  final RemoteConfigParameter _self;
  final $Res Function(RemoteConfigParameter) _then;

  /// Create a copy of RemoteConfigParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumAppVersion = null,
    Object? promotionDayCount = null,
    Object? releasedVersion = null,
  }) {
    return _then(_self.copyWith(
      minimumAppVersion: null == minimumAppVersion
          ? _self.minimumAppVersion
          : minimumAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
      promotionDayCount: null == promotionDayCount
          ? _self.promotionDayCount
          : promotionDayCount // ignore: cast_nullable_to_non_nullable
              as int,
      releasedVersion: null == releasedVersion
          ? _self.releasedVersion
          : releasedVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [RemoteConfigParameter].
extension RemoteConfigParameterPatterns on RemoteConfigParameter {
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
    TResult Function(_RemoteConfigParameter value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RemoteConfigParameter() when $default != null:
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
    TResult Function(_RemoteConfigParameter value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RemoteConfigParameter():
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
    TResult? Function(_RemoteConfigParameter value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RemoteConfigParameter() when $default != null:
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
    TResult Function(String minimumAppVersion, int promotionDayCount, String releasedVersion)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RemoteConfigParameter() when $default != null:
        return $default(_that.minimumAppVersion, _that.promotionDayCount, _that.releasedVersion);
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
    TResult Function(String minimumAppVersion, int promotionDayCount, String releasedVersion) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RemoteConfigParameter():
        return $default(_that.minimumAppVersion, _that.promotionDayCount, _that.releasedVersion);
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
    TResult? Function(String minimumAppVersion, int promotionDayCount, String releasedVersion)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RemoteConfigParameter() when $default != null:
        return $default(_that.minimumAppVersion, _that.promotionDayCount, _that.releasedVersion);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RemoteConfigParameter extends RemoteConfigParameter {
  const _RemoteConfigParameter(
      {this.minimumAppVersion = RemoteConfigParameterDefaultValues.minimumAppVersion,
      this.promotionDayCount = RemoteConfigParameterDefaultValues.promotionDayCount,
      this.releasedVersion = RemoteConfigParameterDefaultValues.releasedVersion})
      : super._();
  factory _RemoteConfigParameter.fromJson(Map<String, dynamic> json) => _$RemoteConfigParameterFromJson(json);

  @override
  @JsonKey()
  final String minimumAppVersion;
  @override
  @JsonKey()
  final int promotionDayCount;
  @override
  @JsonKey()
  final String releasedVersion;

  /// Create a copy of RemoteConfigParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RemoteConfigParameterCopyWith<_RemoteConfigParameter> get copyWith =>
      __$RemoteConfigParameterCopyWithImpl<_RemoteConfigParameter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RemoteConfigParameterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RemoteConfigParameter &&
            (identical(other.minimumAppVersion, minimumAppVersion) || other.minimumAppVersion == minimumAppVersion) &&
            (identical(other.promotionDayCount, promotionDayCount) || other.promotionDayCount == promotionDayCount) &&
            (identical(other.releasedVersion, releasedVersion) || other.releasedVersion == releasedVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, minimumAppVersion, promotionDayCount, releasedVersion);

  @override
  String toString() {
    return 'RemoteConfigParameter(minimumAppVersion: $minimumAppVersion, promotionDayCount: $promotionDayCount, releasedVersion: $releasedVersion)';
  }
}

/// @nodoc
abstract mixin class _$RemoteConfigParameterCopyWith<$Res> implements $RemoteConfigParameterCopyWith<$Res> {
  factory _$RemoteConfigParameterCopyWith(_RemoteConfigParameter value, $Res Function(_RemoteConfigParameter) _then) =
      __$RemoteConfigParameterCopyWithImpl;
  @override
  @useResult
  $Res call({String minimumAppVersion, int promotionDayCount, String releasedVersion});
}

/// @nodoc
class __$RemoteConfigParameterCopyWithImpl<$Res> implements _$RemoteConfigParameterCopyWith<$Res> {
  __$RemoteConfigParameterCopyWithImpl(this._self, this._then);

  final _RemoteConfigParameter _self;
  final $Res Function(_RemoteConfigParameter) _then;

  /// Create a copy of RemoteConfigParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? minimumAppVersion = null,
    Object? promotionDayCount = null,
    Object? releasedVersion = null,
  }) {
    return _then(_RemoteConfigParameter(
      minimumAppVersion: null == minimumAppVersion
          ? _self.minimumAppVersion
          : minimumAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
      promotionDayCount: null == promotionDayCount
          ? _self.promotionDayCount
          : promotionDayCount // ignore: cast_nullable_to_non_nullable
              as int,
      releasedVersion: null == releasedVersion
          ? _self.releasedVersion
          : releasedVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
