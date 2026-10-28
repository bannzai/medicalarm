// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_medication_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingMedicationPlan {
  /// 設定を作成した認証ユーザー。
  String get userID;

  /// 設定を表示するグループ。
  String get groupID;

  /// 設定の対象となるデフォルトの服用者。
  String get doseReceiverID;

  /// 仮設定を始めた日時。
  DateTime get createdDateTime;

  /// 薬の登録を案内する毎日の時刻。
  List<MedicationSchedule> get schedules;

  /// Create a copy of OnboardingMedicationPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OnboardingMedicationPlanCopyWith<OnboardingMedicationPlan> get copyWith =>
      _$OnboardingMedicationPlanCopyWithImpl<OnboardingMedicationPlan>(this as OnboardingMedicationPlan, _$identity);

  /// Serializes this OnboardingMedicationPlan to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OnboardingMedicationPlan &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.groupID, groupID) || other.groupID == groupID) &&
            (identical(other.doseReceiverID, doseReceiverID) || other.doseReceiverID == doseReceiverID) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            const DeepCollectionEquality().equals(other.schedules, schedules));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userID, groupID, doseReceiverID, createdDateTime, const DeepCollectionEquality().hash(schedules));

  @override
  String toString() {
    return 'OnboardingMedicationPlan(userID: $userID, groupID: $groupID, doseReceiverID: $doseReceiverID, createdDateTime: $createdDateTime, schedules: $schedules)';
  }
}

/// @nodoc
abstract mixin class $OnboardingMedicationPlanCopyWith<$Res> {
  factory $OnboardingMedicationPlanCopyWith(OnboardingMedicationPlan value, $Res Function(OnboardingMedicationPlan) _then) =
      _$OnboardingMedicationPlanCopyWithImpl;
  @useResult
  $Res call({String userID, String groupID, String doseReceiverID, DateTime createdDateTime, List<MedicationSchedule> schedules});
}

/// @nodoc
class _$OnboardingMedicationPlanCopyWithImpl<$Res> implements $OnboardingMedicationPlanCopyWith<$Res> {
  _$OnboardingMedicationPlanCopyWithImpl(this._self, this._then);

  final OnboardingMedicationPlan _self;
  final $Res Function(OnboardingMedicationPlan) _then;

  /// Create a copy of OnboardingMedicationPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userID = null,
    Object? groupID = null,
    Object? doseReceiverID = null,
    Object? createdDateTime = null,
    Object? schedules = null,
  }) {
    return _then(_self.copyWith(
      userID: null == userID
          ? _self.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      groupID: null == groupID
          ? _self.groupID
          : groupID // ignore: cast_nullable_to_non_nullable
              as String,
      doseReceiverID: null == doseReceiverID
          ? _self.doseReceiverID
          : doseReceiverID // ignore: cast_nullable_to_non_nullable
              as String,
      createdDateTime: null == createdDateTime
          ? _self.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      schedules: null == schedules
          ? _self.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<MedicationSchedule>,
    ));
  }
}

/// Adds pattern-matching-related methods to [OnboardingMedicationPlan].
extension OnboardingMedicationPlanPatterns on OnboardingMedicationPlan {
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
    TResult Function(_OnboardingMedicationPlan value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingMedicationPlan() when $default != null:
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
    TResult Function(_OnboardingMedicationPlan value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingMedicationPlan():
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
    TResult? Function(_OnboardingMedicationPlan value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingMedicationPlan() when $default != null:
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
    TResult Function(String userID, String groupID, String doseReceiverID, DateTime createdDateTime, List<MedicationSchedule> schedules)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingMedicationPlan() when $default != null:
        return $default(_that.userID, _that.groupID, _that.doseReceiverID, _that.createdDateTime, _that.schedules);
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
    TResult Function(String userID, String groupID, String doseReceiverID, DateTime createdDateTime, List<MedicationSchedule> schedules) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingMedicationPlan():
        return $default(_that.userID, _that.groupID, _that.doseReceiverID, _that.createdDateTime, _that.schedules);
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
    TResult? Function(String userID, String groupID, String doseReceiverID, DateTime createdDateTime, List<MedicationSchedule> schedules)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingMedicationPlan() when $default != null:
        return $default(_that.userID, _that.groupID, _that.doseReceiverID, _that.createdDateTime, _that.schedules);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OnboardingMedicationPlan implements OnboardingMedicationPlan {
  const _OnboardingMedicationPlan(
      {required this.userID,
      required this.groupID,
      required this.doseReceiverID,
      required this.createdDateTime,
      required final List<MedicationSchedule> schedules})
      : _schedules = schedules;
  factory _OnboardingMedicationPlan.fromJson(Map<String, dynamic> json) => _$OnboardingMedicationPlanFromJson(json);

  /// 設定を作成した認証ユーザー。
  @override
  final String userID;

  /// 設定を表示するグループ。
  @override
  final String groupID;

  /// 設定の対象となるデフォルトの服用者。
  @override
  final String doseReceiverID;

  /// 仮設定を始めた日時。
  @override
  final DateTime createdDateTime;

  /// 薬の登録を案内する毎日の時刻。
  final List<MedicationSchedule> _schedules;

  /// 薬の登録を案内する毎日の時刻。
  @override
  List<MedicationSchedule> get schedules {
    if (_schedules is EqualUnmodifiableListView) return _schedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedules);
  }

  /// Create a copy of OnboardingMedicationPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OnboardingMedicationPlanCopyWith<_OnboardingMedicationPlan> get copyWith =>
      __$OnboardingMedicationPlanCopyWithImpl<_OnboardingMedicationPlan>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OnboardingMedicationPlanToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OnboardingMedicationPlan &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.groupID, groupID) || other.groupID == groupID) &&
            (identical(other.doseReceiverID, doseReceiverID) || other.doseReceiverID == doseReceiverID) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            const DeepCollectionEquality().equals(other._schedules, _schedules));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userID, groupID, doseReceiverID, createdDateTime, const DeepCollectionEquality().hash(_schedules));

  @override
  String toString() {
    return 'OnboardingMedicationPlan(userID: $userID, groupID: $groupID, doseReceiverID: $doseReceiverID, createdDateTime: $createdDateTime, schedules: $schedules)';
  }
}

/// @nodoc
abstract mixin class _$OnboardingMedicationPlanCopyWith<$Res> implements $OnboardingMedicationPlanCopyWith<$Res> {
  factory _$OnboardingMedicationPlanCopyWith(_OnboardingMedicationPlan value, $Res Function(_OnboardingMedicationPlan) _then) =
      __$OnboardingMedicationPlanCopyWithImpl;
  @override
  @useResult
  $Res call({String userID, String groupID, String doseReceiverID, DateTime createdDateTime, List<MedicationSchedule> schedules});
}

/// @nodoc
class __$OnboardingMedicationPlanCopyWithImpl<$Res> implements _$OnboardingMedicationPlanCopyWith<$Res> {
  __$OnboardingMedicationPlanCopyWithImpl(this._self, this._then);

  final _OnboardingMedicationPlan _self;
  final $Res Function(_OnboardingMedicationPlan) _then;

  /// Create a copy of OnboardingMedicationPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userID = null,
    Object? groupID = null,
    Object? doseReceiverID = null,
    Object? createdDateTime = null,
    Object? schedules = null,
  }) {
    return _then(_OnboardingMedicationPlan(
      userID: null == userID
          ? _self.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      groupID: null == groupID
          ? _self.groupID
          : groupID // ignore: cast_nullable_to_non_nullable
              as String,
      doseReceiverID: null == doseReceiverID
          ? _self.doseReceiverID
          : doseReceiverID // ignore: cast_nullable_to_non_nullable
              as String,
      createdDateTime: null == createdDateTime
          ? _self.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      schedules: null == schedules
          ? _self._schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<MedicationSchedule>,
    ));
  }
}

// dart format on
