// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DiarySetting _$DiarySettingFromJson(Map<String, dynamic> json) {
  return _DiarySetting.fromJson(json);
}

/// @nodoc
mixin _$DiarySetting {
  List<String> get physicalConditions => throw _privateConstructorUsedError;
  @ClientCreatedTimestamp()
  DateTime? get createdDateTime => throw _privateConstructorUsedError;
  @ClientUpdatedTimestamp()
  DateTime? get updatedDateTime => throw _privateConstructorUsedError;
  @ServerCreatedTimestamp()
  DateTime? get serverCreatedDateTime => throw _privateConstructorUsedError;
  @ServerUpdatedTimestamp()
  DateTime? get serverUpdatedDateTime => throw _privateConstructorUsedError;

  /// Serializes this DiarySetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiarySettingCopyWith<DiarySetting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiarySettingCopyWith<$Res> {
  factory $DiarySettingCopyWith(DiarySetting value, $Res Function(DiarySetting) then) = _$DiarySettingCopyWithImpl<$Res, DiarySetting>;
  @useResult
  $Res call(
      {List<String> physicalConditions,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});
}

/// @nodoc
class _$DiarySettingCopyWithImpl<$Res, $Val extends DiarySetting> implements $DiarySettingCopyWith<$Res> {
  _$DiarySettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? physicalConditions = null,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
  }) {
    return _then(_value.copyWith(
      physicalConditions: null == physicalConditions
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
abstract class _$$DiarySettingImplCopyWith<$Res> implements $DiarySettingCopyWith<$Res> {
  factory _$$DiarySettingImplCopyWith(_$DiarySettingImpl value, $Res Function(_$DiarySettingImpl) then) = __$$DiarySettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> physicalConditions,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});
}

/// @nodoc
class __$$DiarySettingImplCopyWithImpl<$Res> extends _$DiarySettingCopyWithImpl<$Res, _$DiarySettingImpl>
    implements _$$DiarySettingImplCopyWith<$Res> {
  __$$DiarySettingImplCopyWithImpl(_$DiarySettingImpl _value, $Res Function(_$DiarySettingImpl) _then) : super(_value, _then);

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? physicalConditions = null,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
  }) {
    return _then(_$DiarySettingImpl(
      physicalConditions: null == physicalConditions
          ? _value._physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
class _$DiarySettingImpl extends _DiarySetting with DiagnosticableTreeMixin {
  const _$DiarySettingImpl(
      {final List<String> physicalConditions = const [],
      @ClientCreatedTimestamp() this.createdDateTime,
      @ClientUpdatedTimestamp() this.updatedDateTime,
      @ServerCreatedTimestamp() this.serverCreatedDateTime,
      @ServerUpdatedTimestamp() this.serverUpdatedDateTime})
      : _physicalConditions = physicalConditions,
        super._();

  factory _$DiarySettingImpl.fromJson(Map<String, dynamic> json) => _$$DiarySettingImplFromJson(json);

  final List<String> _physicalConditions;
  @override
  @JsonKey()
  List<String> get physicalConditions {
    if (_physicalConditions is EqualUnmodifiableListView) return _physicalConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_physicalConditions);
  }

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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DiarySetting(physicalConditions: $physicalConditions, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DiarySetting'))
      ..add(DiagnosticsProperty('physicalConditions', physicalConditions))
      ..add(DiagnosticsProperty('createdDateTime', createdDateTime))
      ..add(DiagnosticsProperty('updatedDateTime', updatedDateTime))
      ..add(DiagnosticsProperty('serverCreatedDateTime', serverCreatedDateTime))
      ..add(DiagnosticsProperty('serverUpdatedDateTime', serverUpdatedDateTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiarySettingImpl &&
            const DeepCollectionEquality().equals(other._physicalConditions, _physicalConditions) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_physicalConditions), createdDateTime, updatedDateTime,
      serverCreatedDateTime, serverUpdatedDateTime);

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiarySettingImplCopyWith<_$DiarySettingImpl> get copyWith => __$$DiarySettingImplCopyWithImpl<_$DiarySettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiarySettingImplToJson(
      this,
    );
  }
}

abstract class _DiarySetting extends DiarySetting {
  const factory _DiarySetting(
      {final List<String> physicalConditions,
      @ClientCreatedTimestamp() final DateTime? createdDateTime,
      @ClientUpdatedTimestamp() final DateTime? updatedDateTime,
      @ServerCreatedTimestamp() final DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() final DateTime? serverUpdatedDateTime}) = _$DiarySettingImpl;
  const _DiarySetting._() : super._();

  factory _DiarySetting.fromJson(Map<String, dynamic> json) = _$DiarySettingImpl.fromJson;

  @override
  List<String> get physicalConditions;
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

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiarySettingImplCopyWith<_$DiarySettingImpl> get copyWith => throw _privateConstructorUsedError;
}
