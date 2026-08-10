// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Medicine {
  String get id; // 作成者(creator)の userID。グループ共有では他メンバーが閲覧・記録することもあるため所有者ではなく作成者を表す。
  String get userID;
  String get name;
  MedicationFrequency get frequency;
  List<MedicationSchedule> get schedules;
  DoseReceiver get doseReceiver;
  String get memo;
  String get memoImageURL; // 前回の服用から最低限空ける時間(時間単位)。null は間隔設定なし。
// 間隔が空いていない場合でも記録・通知は無効化せず、注意の表示だけを行う (#81)
  int? get minimumDoseIntervalHours;
  @NullableTimestampConverter()
  DateTime? get archivedDateTime;
  @NullableTimestampConverter()
  DateTime? get pausedDateTime;
  @TimestampConverter()
  DateTime get beganDateTime;
  @ClientCreatedTimestamp()
  DateTime? get createdDateTime;
  @ClientUpdatedTimestamp()
  DateTime? get updatedDateTime;
  @ServerCreatedTimestamp()
  DateTime? get serverCreatedDateTime;
  @ServerUpdatedTimestamp()
  DateTime? get serverUpdatedDateTime;

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicineCopyWith<Medicine> get copyWith => _$MedicineCopyWithImpl<Medicine>(this as Medicine, _$identity);

  /// Serializes this Medicine to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Medicine &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.frequency, frequency) || other.frequency == frequency) &&
            const DeepCollectionEquality().equals(other.schedules, schedules) &&
            (identical(other.doseReceiver, doseReceiver) || other.doseReceiver == doseReceiver) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.memoImageURL, memoImageURL) || other.memoImageURL == memoImageURL) &&
            (identical(other.minimumDoseIntervalHours, minimumDoseIntervalHours) || other.minimumDoseIntervalHours == minimumDoseIntervalHours) &&
            (identical(other.archivedDateTime, archivedDateTime) || other.archivedDateTime == archivedDateTime) &&
            (identical(other.pausedDateTime, pausedDateTime) || other.pausedDateTime == pausedDateTime) &&
            (identical(other.beganDateTime, beganDateTime) || other.beganDateTime == beganDateTime) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userID,
      name,
      frequency,
      const DeepCollectionEquality().hash(schedules),
      doseReceiver,
      memo,
      memoImageURL,
      minimumDoseIntervalHours,
      archivedDateTime,
      pausedDateTime,
      beganDateTime,
      createdDateTime,
      updatedDateTime,
      serverCreatedDateTime,
      serverUpdatedDateTime);

  @override
  String toString() {
    return 'Medicine(id: $id, userID: $userID, name: $name, frequency: $frequency, schedules: $schedules, doseReceiver: $doseReceiver, memo: $memo, memoImageURL: $memoImageURL, minimumDoseIntervalHours: $minimumDoseIntervalHours, archivedDateTime: $archivedDateTime, pausedDateTime: $pausedDateTime, beganDateTime: $beganDateTime, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
  }
}

/// @nodoc
abstract mixin class $MedicineCopyWith<$Res> {
  factory $MedicineCopyWith(Medicine value, $Res Function(Medicine) _then) = _$MedicineCopyWithImpl;
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
      int? minimumDoseIntervalHours,
      @NullableTimestampConverter() DateTime? archivedDateTime,
      @NullableTimestampConverter() DateTime? pausedDateTime,
      @TimestampConverter() DateTime beganDateTime,
      @ClientCreatedTimestamp() DateTime? createdDateTime,
      @ClientUpdatedTimestamp() DateTime? updatedDateTime,
      @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
      @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime});

  $MedicationFrequencyCopyWith<$Res> get frequency;
  $DoseReceiverCopyWith<$Res> get doseReceiver;
}

/// @nodoc
class _$MedicineCopyWithImpl<$Res> implements $MedicineCopyWith<$Res> {
  _$MedicineCopyWithImpl(this._self, this._then);

  final Medicine _self;
  final $Res Function(Medicine) _then;

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
    Object? minimumDoseIntervalHours = freezed,
    Object? archivedDateTime = freezed,
    Object? pausedDateTime = freezed,
    Object? beganDateTime = null,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userID: null == userID
          ? _self.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _self.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as MedicationFrequency,
      schedules: null == schedules
          ? _self.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<MedicationSchedule>,
      doseReceiver: null == doseReceiver
          ? _self.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      memo: null == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      memoImageURL: null == memoImageURL
          ? _self.memoImageURL
          : memoImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      minimumDoseIntervalHours: freezed == minimumDoseIntervalHours
          ? _self.minimumDoseIntervalHours
          : minimumDoseIntervalHours // ignore: cast_nullable_to_non_nullable
              as int?,
      archivedDateTime: freezed == archivedDateTime
          ? _self.archivedDateTime
          : archivedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pausedDateTime: freezed == pausedDateTime
          ? _self.pausedDateTime
          : pausedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      beganDateTime: null == beganDateTime
          ? _self.beganDateTime
          : beganDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: freezed == createdDateTime
          ? _self.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedDateTime: freezed == updatedDateTime
          ? _self.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverCreatedDateTime: freezed == serverCreatedDateTime
          ? _self.serverCreatedDateTime
          : serverCreatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverUpdatedDateTime: freezed == serverUpdatedDateTime
          ? _self.serverUpdatedDateTime
          : serverUpdatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationFrequencyCopyWith<$Res> get frequency {
    return $MedicationFrequencyCopyWith<$Res>(_self.frequency, (value) {
      return _then(_self.copyWith(frequency: value));
    });
  }

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DoseReceiverCopyWith<$Res> get doseReceiver {
    return $DoseReceiverCopyWith<$Res>(_self.doseReceiver, (value) {
      return _then(_self.copyWith(doseReceiver: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Medicine].
extension MedicinePatterns on Medicine {
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
    TResult Function(_Medicine value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Medicine() when $default != null:
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
    TResult Function(_Medicine value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Medicine():
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
    TResult? Function(_Medicine value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Medicine() when $default != null:
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
    TResult Function(
            String id,
            String userID,
            String name,
            MedicationFrequency frequency,
            List<MedicationSchedule> schedules,
            DoseReceiver doseReceiver,
            String memo,
            String memoImageURL,
            int? minimumDoseIntervalHours,
            @NullableTimestampConverter() DateTime? archivedDateTime,
            @NullableTimestampConverter() DateTime? pausedDateTime,
            @TimestampConverter() DateTime beganDateTime,
            @ClientCreatedTimestamp() DateTime? createdDateTime,
            @ClientUpdatedTimestamp() DateTime? updatedDateTime,
            @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
            @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Medicine() when $default != null:
        return $default(
            _that.id,
            _that.userID,
            _that.name,
            _that.frequency,
            _that.schedules,
            _that.doseReceiver,
            _that.memo,
            _that.memoImageURL,
            _that.minimumDoseIntervalHours,
            _that.archivedDateTime,
            _that.pausedDateTime,
            _that.beganDateTime,
            _that.createdDateTime,
            _that.updatedDateTime,
            _that.serverCreatedDateTime,
            _that.serverUpdatedDateTime);
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
    TResult Function(
            String id,
            String userID,
            String name,
            MedicationFrequency frequency,
            List<MedicationSchedule> schedules,
            DoseReceiver doseReceiver,
            String memo,
            String memoImageURL,
            int? minimumDoseIntervalHours,
            @NullableTimestampConverter() DateTime? archivedDateTime,
            @NullableTimestampConverter() DateTime? pausedDateTime,
            @TimestampConverter() DateTime beganDateTime,
            @ClientCreatedTimestamp() DateTime? createdDateTime,
            @ClientUpdatedTimestamp() DateTime? updatedDateTime,
            @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
            @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Medicine():
        return $default(
            _that.id,
            _that.userID,
            _that.name,
            _that.frequency,
            _that.schedules,
            _that.doseReceiver,
            _that.memo,
            _that.memoImageURL,
            _that.minimumDoseIntervalHours,
            _that.archivedDateTime,
            _that.pausedDateTime,
            _that.beganDateTime,
            _that.createdDateTime,
            _that.updatedDateTime,
            _that.serverCreatedDateTime,
            _that.serverUpdatedDateTime);
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
    TResult? Function(
            String id,
            String userID,
            String name,
            MedicationFrequency frequency,
            List<MedicationSchedule> schedules,
            DoseReceiver doseReceiver,
            String memo,
            String memoImageURL,
            int? minimumDoseIntervalHours,
            @NullableTimestampConverter() DateTime? archivedDateTime,
            @NullableTimestampConverter() DateTime? pausedDateTime,
            @TimestampConverter() DateTime beganDateTime,
            @ClientCreatedTimestamp() DateTime? createdDateTime,
            @ClientUpdatedTimestamp() DateTime? updatedDateTime,
            @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
            @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Medicine() when $default != null:
        return $default(
            _that.id,
            _that.userID,
            _that.name,
            _that.frequency,
            _that.schedules,
            _that.doseReceiver,
            _that.memo,
            _that.memoImageURL,
            _that.minimumDoseIntervalHours,
            _that.archivedDateTime,
            _that.pausedDateTime,
            _that.beganDateTime,
            _that.createdDateTime,
            _that.updatedDateTime,
            _that.serverCreatedDateTime,
            _that.serverUpdatedDateTime);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Medicine extends Medicine {
  const _Medicine(
      {required this.id,
      required this.userID,
      required this.name,
      required this.frequency,
      required final List<MedicationSchedule> schedules,
      required this.doseReceiver,
      required this.memo,
      required this.memoImageURL,
      required this.minimumDoseIntervalHours,
      @NullableTimestampConverter() this.archivedDateTime,
      @NullableTimestampConverter() this.pausedDateTime,
      @TimestampConverter() required this.beganDateTime,
      @ClientCreatedTimestamp() this.createdDateTime,
      @ClientUpdatedTimestamp() this.updatedDateTime,
      @ServerCreatedTimestamp() this.serverCreatedDateTime,
      @ServerUpdatedTimestamp() this.serverUpdatedDateTime})
      : _schedules = schedules,
        super._();
  factory _Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);

  @override
  final String id;
// 作成者(creator)の userID。グループ共有では他メンバーが閲覧・記録することもあるため所有者ではなく作成者を表す。
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
// 前回の服用から最低限空ける時間(時間単位)。null は間隔設定なし。
// 間隔が空いていない場合でも記録・通知は無効化せず、注意の表示だけを行う (#81)
  @override
  final int? minimumDoseIntervalHours;
  @override
  @NullableTimestampConverter()
  final DateTime? archivedDateTime;
  @override
  @NullableTimestampConverter()
  final DateTime? pausedDateTime;
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

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicineCopyWith<_Medicine> get copyWith => __$MedicineCopyWithImpl<_Medicine>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicineToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Medicine &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.frequency, frequency) || other.frequency == frequency) &&
            const DeepCollectionEquality().equals(other._schedules, _schedules) &&
            (identical(other.doseReceiver, doseReceiver) || other.doseReceiver == doseReceiver) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.memoImageURL, memoImageURL) || other.memoImageURL == memoImageURL) &&
            (identical(other.minimumDoseIntervalHours, minimumDoseIntervalHours) || other.minimumDoseIntervalHours == minimumDoseIntervalHours) &&
            (identical(other.archivedDateTime, archivedDateTime) || other.archivedDateTime == archivedDateTime) &&
            (identical(other.pausedDateTime, pausedDateTime) || other.pausedDateTime == pausedDateTime) &&
            (identical(other.beganDateTime, beganDateTime) || other.beganDateTime == beganDateTime) &&
            (identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime) &&
            (identical(other.updatedDateTime, updatedDateTime) || other.updatedDateTime == updatedDateTime) &&
            (identical(other.serverCreatedDateTime, serverCreatedDateTime) || other.serverCreatedDateTime == serverCreatedDateTime) &&
            (identical(other.serverUpdatedDateTime, serverUpdatedDateTime) || other.serverUpdatedDateTime == serverUpdatedDateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userID,
      name,
      frequency,
      const DeepCollectionEquality().hash(_schedules),
      doseReceiver,
      memo,
      memoImageURL,
      minimumDoseIntervalHours,
      archivedDateTime,
      pausedDateTime,
      beganDateTime,
      createdDateTime,
      updatedDateTime,
      serverCreatedDateTime,
      serverUpdatedDateTime);

  @override
  String toString() {
    return 'Medicine(id: $id, userID: $userID, name: $name, frequency: $frequency, schedules: $schedules, doseReceiver: $doseReceiver, memo: $memo, memoImageURL: $memoImageURL, minimumDoseIntervalHours: $minimumDoseIntervalHours, archivedDateTime: $archivedDateTime, pausedDateTime: $pausedDateTime, beganDateTime: $beganDateTime, createdDateTime: $createdDateTime, updatedDateTime: $updatedDateTime, serverCreatedDateTime: $serverCreatedDateTime, serverUpdatedDateTime: $serverUpdatedDateTime)';
  }
}

/// @nodoc
abstract mixin class _$MedicineCopyWith<$Res> implements $MedicineCopyWith<$Res> {
  factory _$MedicineCopyWith(_Medicine value, $Res Function(_Medicine) _then) = __$MedicineCopyWithImpl;
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
      int? minimumDoseIntervalHours,
      @NullableTimestampConverter() DateTime? archivedDateTime,
      @NullableTimestampConverter() DateTime? pausedDateTime,
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
class __$MedicineCopyWithImpl<$Res> implements _$MedicineCopyWith<$Res> {
  __$MedicineCopyWithImpl(this._self, this._then);

  final _Medicine _self;
  final $Res Function(_Medicine) _then;

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userID = null,
    Object? name = null,
    Object? frequency = null,
    Object? schedules = null,
    Object? doseReceiver = null,
    Object? memo = null,
    Object? memoImageURL = null,
    Object? minimumDoseIntervalHours = freezed,
    Object? archivedDateTime = freezed,
    Object? pausedDateTime = freezed,
    Object? beganDateTime = null,
    Object? createdDateTime = freezed,
    Object? updatedDateTime = freezed,
    Object? serverCreatedDateTime = freezed,
    Object? serverUpdatedDateTime = freezed,
  }) {
    return _then(_Medicine(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userID: null == userID
          ? _self.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _self.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as MedicationFrequency,
      schedules: null == schedules
          ? _self._schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<MedicationSchedule>,
      doseReceiver: null == doseReceiver
          ? _self.doseReceiver
          : doseReceiver // ignore: cast_nullable_to_non_nullable
              as DoseReceiver,
      memo: null == memo
          ? _self.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      memoImageURL: null == memoImageURL
          ? _self.memoImageURL
          : memoImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      minimumDoseIntervalHours: freezed == minimumDoseIntervalHours
          ? _self.minimumDoseIntervalHours
          : minimumDoseIntervalHours // ignore: cast_nullable_to_non_nullable
              as int?,
      archivedDateTime: freezed == archivedDateTime
          ? _self.archivedDateTime
          : archivedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pausedDateTime: freezed == pausedDateTime
          ? _self.pausedDateTime
          : pausedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      beganDateTime: null == beganDateTime
          ? _self.beganDateTime
          : beganDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: freezed == createdDateTime
          ? _self.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedDateTime: freezed == updatedDateTime
          ? _self.updatedDateTime
          : updatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverCreatedDateTime: freezed == serverCreatedDateTime
          ? _self.serverCreatedDateTime
          : serverCreatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serverUpdatedDateTime: freezed == serverUpdatedDateTime
          ? _self.serverUpdatedDateTime
          : serverUpdatedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicationFrequencyCopyWith<$Res> get frequency {
    return $MedicationFrequencyCopyWith<$Res>(_self.frequency, (value) {
      return _then(_self.copyWith(frequency: value));
    });
  }

  /// Create a copy of Medicine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DoseReceiverCopyWith<$Res> get doseReceiver {
    return $DoseReceiverCopyWith<$Res>(_self.doseReceiver, (value) {
      return _then(_self.copyWith(doseReceiver: value));
    });
  }
}

/// @nodoc
mixin _$MedicineScheduleNotificationSetting {
  bool get isReminderEnabled;
  bool get isFollowupEnabled;
  bool get useCriticalAlert;
  double get criticalAlertVolume;
  bool get useAlarmKit;

  /// Create a copy of MedicineScheduleNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicineScheduleNotificationSettingCopyWith<MedicineScheduleNotificationSetting> get copyWith =>
      _$MedicineScheduleNotificationSettingCopyWithImpl<MedicineScheduleNotificationSetting>(this as MedicineScheduleNotificationSetting, _$identity);

  /// Serializes this MedicineScheduleNotificationSetting to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicineScheduleNotificationSetting &&
            (identical(other.isReminderEnabled, isReminderEnabled) || other.isReminderEnabled == isReminderEnabled) &&
            (identical(other.isFollowupEnabled, isFollowupEnabled) || other.isFollowupEnabled == isFollowupEnabled) &&
            (identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert) &&
            (identical(other.criticalAlertVolume, criticalAlertVolume) || other.criticalAlertVolume == criticalAlertVolume) &&
            (identical(other.useAlarmKit, useAlarmKit) || other.useAlarmKit == useAlarmKit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isReminderEnabled, isFollowupEnabled, useCriticalAlert, criticalAlertVolume, useAlarmKit);

  @override
  String toString() {
    return 'MedicineScheduleNotificationSetting(isReminderEnabled: $isReminderEnabled, isFollowupEnabled: $isFollowupEnabled, useCriticalAlert: $useCriticalAlert, criticalAlertVolume: $criticalAlertVolume, useAlarmKit: $useAlarmKit)';
  }
}

/// @nodoc
abstract mixin class $MedicineScheduleNotificationSettingCopyWith<$Res> {
  factory $MedicineScheduleNotificationSettingCopyWith(
          MedicineScheduleNotificationSetting value, $Res Function(MedicineScheduleNotificationSetting) _then) =
      _$MedicineScheduleNotificationSettingCopyWithImpl;
  @useResult
  $Res call({bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert, double criticalAlertVolume, bool useAlarmKit});
}

/// @nodoc
class _$MedicineScheduleNotificationSettingCopyWithImpl<$Res> implements $MedicineScheduleNotificationSettingCopyWith<$Res> {
  _$MedicineScheduleNotificationSettingCopyWithImpl(this._self, this._then);

  final MedicineScheduleNotificationSetting _self;
  final $Res Function(MedicineScheduleNotificationSetting) _then;

  /// Create a copy of MedicineScheduleNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isReminderEnabled = null,
    Object? isFollowupEnabled = null,
    Object? useCriticalAlert = null,
    Object? criticalAlertVolume = null,
    Object? useAlarmKit = null,
  }) {
    return _then(_self.copyWith(
      isReminderEnabled: null == isReminderEnabled
          ? _self.isReminderEnabled
          : isReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isFollowupEnabled: null == isFollowupEnabled
          ? _self.isFollowupEnabled
          : isFollowupEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      useCriticalAlert: null == useCriticalAlert
          ? _self.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      criticalAlertVolume: null == criticalAlertVolume
          ? _self.criticalAlertVolume
          : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
              as double,
      useAlarmKit: null == useAlarmKit
          ? _self.useAlarmKit
          : useAlarmKit // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicineScheduleNotificationSetting].
extension MedicineScheduleNotificationSettingPatterns on MedicineScheduleNotificationSetting {
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
    TResult Function(_MedicineScheduleNotificationSetting value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleNotificationSetting() when $default != null:
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
    TResult Function(_MedicineScheduleNotificationSetting value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleNotificationSetting():
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
    TResult? Function(_MedicineScheduleNotificationSetting value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleNotificationSetting() when $default != null:
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
    TResult Function(bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert, double criticalAlertVolume, bool useAlarmKit)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleNotificationSetting() when $default != null:
        return $default(_that.isReminderEnabled, _that.isFollowupEnabled, _that.useCriticalAlert, _that.criticalAlertVolume, _that.useAlarmKit);
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
    TResult Function(bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert, double criticalAlertVolume, bool useAlarmKit) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleNotificationSetting():
        return $default(_that.isReminderEnabled, _that.isFollowupEnabled, _that.useCriticalAlert, _that.criticalAlertVolume, _that.useAlarmKit);
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
    TResult? Function(bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert, double criticalAlertVolume, bool useAlarmKit)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleNotificationSetting() when $default != null:
        return $default(_that.isReminderEnabled, _that.isFollowupEnabled, _that.useCriticalAlert, _that.criticalAlertVolume, _that.useAlarmKit);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MedicineScheduleNotificationSetting extends MedicineScheduleNotificationSetting {
  const _MedicineScheduleNotificationSetting(
      {required this.isReminderEnabled,
      required this.isFollowupEnabled,
      required this.useCriticalAlert,
      this.criticalAlertVolume = 0.5,
      this.useAlarmKit = false})
      : super._();
  factory _MedicineScheduleNotificationSetting.fromJson(Map<String, dynamic> json) => _$MedicineScheduleNotificationSettingFromJson(json);

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
  @JsonKey()
  final bool useAlarmKit;

  /// Create a copy of MedicineScheduleNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicineScheduleNotificationSettingCopyWith<_MedicineScheduleNotificationSetting> get copyWith =>
      __$MedicineScheduleNotificationSettingCopyWithImpl<_MedicineScheduleNotificationSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicineScheduleNotificationSettingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicineScheduleNotificationSetting &&
            (identical(other.isReminderEnabled, isReminderEnabled) || other.isReminderEnabled == isReminderEnabled) &&
            (identical(other.isFollowupEnabled, isFollowupEnabled) || other.isFollowupEnabled == isFollowupEnabled) &&
            (identical(other.useCriticalAlert, useCriticalAlert) || other.useCriticalAlert == useCriticalAlert) &&
            (identical(other.criticalAlertVolume, criticalAlertVolume) || other.criticalAlertVolume == criticalAlertVolume) &&
            (identical(other.useAlarmKit, useAlarmKit) || other.useAlarmKit == useAlarmKit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isReminderEnabled, isFollowupEnabled, useCriticalAlert, criticalAlertVolume, useAlarmKit);

  @override
  String toString() {
    return 'MedicineScheduleNotificationSetting(isReminderEnabled: $isReminderEnabled, isFollowupEnabled: $isFollowupEnabled, useCriticalAlert: $useCriticalAlert, criticalAlertVolume: $criticalAlertVolume, useAlarmKit: $useAlarmKit)';
  }
}

/// @nodoc
abstract mixin class _$MedicineScheduleNotificationSettingCopyWith<$Res> implements $MedicineScheduleNotificationSettingCopyWith<$Res> {
  factory _$MedicineScheduleNotificationSettingCopyWith(
          _MedicineScheduleNotificationSetting value, $Res Function(_MedicineScheduleNotificationSetting) _then) =
      __$MedicineScheduleNotificationSettingCopyWithImpl;
  @override
  @useResult
  $Res call({bool isReminderEnabled, bool isFollowupEnabled, bool useCriticalAlert, double criticalAlertVolume, bool useAlarmKit});
}

/// @nodoc
class __$MedicineScheduleNotificationSettingCopyWithImpl<$Res> implements _$MedicineScheduleNotificationSettingCopyWith<$Res> {
  __$MedicineScheduleNotificationSettingCopyWithImpl(this._self, this._then);

  final _MedicineScheduleNotificationSetting _self;
  final $Res Function(_MedicineScheduleNotificationSetting) _then;

  /// Create a copy of MedicineScheduleNotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isReminderEnabled = null,
    Object? isFollowupEnabled = null,
    Object? useCriticalAlert = null,
    Object? criticalAlertVolume = null,
    Object? useAlarmKit = null,
  }) {
    return _then(_MedicineScheduleNotificationSetting(
      isReminderEnabled: null == isReminderEnabled
          ? _self.isReminderEnabled
          : isReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isFollowupEnabled: null == isFollowupEnabled
          ? _self.isFollowupEnabled
          : isFollowupEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      useCriticalAlert: null == useCriticalAlert
          ? _self.useCriticalAlert
          : useCriticalAlert // ignore: cast_nullable_to_non_nullable
              as bool,
      criticalAlertVolume: null == criticalAlertVolume
          ? _self.criticalAlertVolume
          : criticalAlertVolume // ignore: cast_nullable_to_non_nullable
              as double,
      useAlarmKit: null == useAlarmKit
          ? _self.useAlarmKit
          : useAlarmKit // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$MedicineScheduleFocusConnectSetting {
  String? get focusConnectScheduleID;

  /// Create a copy of MedicineScheduleFocusConnectSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicineScheduleFocusConnectSettingCopyWith<MedicineScheduleFocusConnectSetting> get copyWith =>
      _$MedicineScheduleFocusConnectSettingCopyWithImpl<MedicineScheduleFocusConnectSetting>(this as MedicineScheduleFocusConnectSetting, _$identity);

  /// Serializes this MedicineScheduleFocusConnectSetting to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicineScheduleFocusConnectSetting &&
            (identical(other.focusConnectScheduleID, focusConnectScheduleID) || other.focusConnectScheduleID == focusConnectScheduleID));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, focusConnectScheduleID);

  @override
  String toString() {
    return 'MedicineScheduleFocusConnectSetting(focusConnectScheduleID: $focusConnectScheduleID)';
  }
}

/// @nodoc
abstract mixin class $MedicineScheduleFocusConnectSettingCopyWith<$Res> {
  factory $MedicineScheduleFocusConnectSettingCopyWith(
          MedicineScheduleFocusConnectSetting value, $Res Function(MedicineScheduleFocusConnectSetting) _then) =
      _$MedicineScheduleFocusConnectSettingCopyWithImpl;
  @useResult
  $Res call({String? focusConnectScheduleID});
}

/// @nodoc
class _$MedicineScheduleFocusConnectSettingCopyWithImpl<$Res> implements $MedicineScheduleFocusConnectSettingCopyWith<$Res> {
  _$MedicineScheduleFocusConnectSettingCopyWithImpl(this._self, this._then);

  final MedicineScheduleFocusConnectSetting _self;
  final $Res Function(MedicineScheduleFocusConnectSetting) _then;

  /// Create a copy of MedicineScheduleFocusConnectSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? focusConnectScheduleID = freezed,
  }) {
    return _then(_self.copyWith(
      focusConnectScheduleID: freezed == focusConnectScheduleID
          ? _self.focusConnectScheduleID
          : focusConnectScheduleID // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MedicineScheduleFocusConnectSetting].
extension MedicineScheduleFocusConnectSettingPatterns on MedicineScheduleFocusConnectSetting {
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
    TResult Function(_MedicineScheduleFocusConnectSetting value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleFocusConnectSetting() when $default != null:
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
    TResult Function(_MedicineScheduleFocusConnectSetting value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleFocusConnectSetting():
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
    TResult? Function(_MedicineScheduleFocusConnectSetting value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleFocusConnectSetting() when $default != null:
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
    TResult Function(String? focusConnectScheduleID)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleFocusConnectSetting() when $default != null:
        return $default(_that.focusConnectScheduleID);
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
    TResult Function(String? focusConnectScheduleID) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleFocusConnectSetting():
        return $default(_that.focusConnectScheduleID);
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
    TResult? Function(String? focusConnectScheduleID)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicineScheduleFocusConnectSetting() when $default != null:
        return $default(_that.focusConnectScheduleID);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MedicineScheduleFocusConnectSetting extends MedicineScheduleFocusConnectSetting {
  const _MedicineScheduleFocusConnectSetting({this.focusConnectScheduleID}) : super._();
  factory _MedicineScheduleFocusConnectSetting.fromJson(Map<String, dynamic> json) => _$MedicineScheduleFocusConnectSettingFromJson(json);

  @override
  final String? focusConnectScheduleID;

  /// Create a copy of MedicineScheduleFocusConnectSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicineScheduleFocusConnectSettingCopyWith<_MedicineScheduleFocusConnectSetting> get copyWith =>
      __$MedicineScheduleFocusConnectSettingCopyWithImpl<_MedicineScheduleFocusConnectSetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicineScheduleFocusConnectSettingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicineScheduleFocusConnectSetting &&
            (identical(other.focusConnectScheduleID, focusConnectScheduleID) || other.focusConnectScheduleID == focusConnectScheduleID));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, focusConnectScheduleID);

  @override
  String toString() {
    return 'MedicineScheduleFocusConnectSetting(focusConnectScheduleID: $focusConnectScheduleID)';
  }
}

/// @nodoc
abstract mixin class _$MedicineScheduleFocusConnectSettingCopyWith<$Res> implements $MedicineScheduleFocusConnectSettingCopyWith<$Res> {
  factory _$MedicineScheduleFocusConnectSettingCopyWith(
          _MedicineScheduleFocusConnectSetting value, $Res Function(_MedicineScheduleFocusConnectSetting) _then) =
      __$MedicineScheduleFocusConnectSettingCopyWithImpl;
  @override
  @useResult
  $Res call({String? focusConnectScheduleID});
}

/// @nodoc
class __$MedicineScheduleFocusConnectSettingCopyWithImpl<$Res> implements _$MedicineScheduleFocusConnectSettingCopyWith<$Res> {
  __$MedicineScheduleFocusConnectSettingCopyWithImpl(this._self, this._then);

  final _MedicineScheduleFocusConnectSetting _self;
  final $Res Function(_MedicineScheduleFocusConnectSetting) _then;

  /// Create a copy of MedicineScheduleFocusConnectSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? focusConnectScheduleID = freezed,
  }) {
    return _then(_MedicineScheduleFocusConnectSetting(
      focusConnectScheduleID: freezed == focusConnectScheduleID
          ? _self.focusConnectScheduleID
          : focusConnectScheduleID // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$MedicationSchedule {
  String get id;
  int get hour;
  int get minute;
  String get quantityMemo;
  MedicineScheduleNotificationSetting get notificationSetting;
  MedicineScheduleFocusConnectSetting? get focusConnectSetting;

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MedicationScheduleCopyWith<MedicationSchedule> get copyWith =>
      _$MedicationScheduleCopyWithImpl<MedicationSchedule>(this as MedicationSchedule, _$identity);

  /// Serializes this MedicationSchedule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MedicationSchedule &&
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

  @override
  String toString() {
    return 'MedicationSchedule(id: $id, hour: $hour, minute: $minute, quantityMemo: $quantityMemo, notificationSetting: $notificationSetting, focusConnectSetting: $focusConnectSetting)';
  }
}

/// @nodoc
abstract mixin class $MedicationScheduleCopyWith<$Res> {
  factory $MedicationScheduleCopyWith(MedicationSchedule value, $Res Function(MedicationSchedule) _then) = _$MedicationScheduleCopyWithImpl;
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
class _$MedicationScheduleCopyWithImpl<$Res> implements $MedicationScheduleCopyWith<$Res> {
  _$MedicationScheduleCopyWithImpl(this._self, this._then);

  final MedicationSchedule _self;
  final $Res Function(MedicationSchedule) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hour: null == hour
          ? _self.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _self.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
      quantityMemo: null == quantityMemo
          ? _self.quantityMemo
          : quantityMemo // ignore: cast_nullable_to_non_nullable
              as String,
      notificationSetting: null == notificationSetting
          ? _self.notificationSetting
          : notificationSetting // ignore: cast_nullable_to_non_nullable
              as MedicineScheduleNotificationSetting,
      focusConnectSetting: freezed == focusConnectSetting
          ? _self.focusConnectSetting
          : focusConnectSetting // ignore: cast_nullable_to_non_nullable
              as MedicineScheduleFocusConnectSetting?,
    ));
  }

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineScheduleNotificationSettingCopyWith<$Res> get notificationSetting {
    return $MedicineScheduleNotificationSettingCopyWith<$Res>(_self.notificationSetting, (value) {
      return _then(_self.copyWith(notificationSetting: value));
    });
  }

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineScheduleFocusConnectSettingCopyWith<$Res>? get focusConnectSetting {
    if (_self.focusConnectSetting == null) {
      return null;
    }

    return $MedicineScheduleFocusConnectSettingCopyWith<$Res>(_self.focusConnectSetting!, (value) {
      return _then(_self.copyWith(focusConnectSetting: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MedicationSchedule].
extension MedicationSchedulePatterns on MedicationSchedule {
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
    TResult Function(_MedicationSchedule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationSchedule() when $default != null:
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
    TResult Function(_MedicationSchedule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationSchedule():
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
    TResult? Function(_MedicationSchedule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationSchedule() when $default != null:
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
    TResult Function(String id, int hour, int minute, String quantityMemo, MedicineScheduleNotificationSetting notificationSetting,
            MedicineScheduleFocusConnectSetting? focusConnectSetting)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MedicationSchedule() when $default != null:
        return $default(_that.id, _that.hour, _that.minute, _that.quantityMemo, _that.notificationSetting, _that.focusConnectSetting);
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
    TResult Function(String id, int hour, int minute, String quantityMemo, MedicineScheduleNotificationSetting notificationSetting,
            MedicineScheduleFocusConnectSetting? focusConnectSetting)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationSchedule():
        return $default(_that.id, _that.hour, _that.minute, _that.quantityMemo, _that.notificationSetting, _that.focusConnectSetting);
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
    TResult? Function(String id, int hour, int minute, String quantityMemo, MedicineScheduleNotificationSetting notificationSetting,
            MedicineScheduleFocusConnectSetting? focusConnectSetting)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MedicationSchedule() when $default != null:
        return $default(_that.id, _that.hour, _that.minute, _that.quantityMemo, _that.notificationSetting, _that.focusConnectSetting);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MedicationSchedule extends MedicationSchedule {
  const _MedicationSchedule(
      {required this.id,
      required this.hour,
      required this.minute,
      required this.quantityMemo,
      required this.notificationSetting,
      required this.focusConnectSetting})
      : super._();
  factory _MedicationSchedule.fromJson(Map<String, dynamic> json) => _$MedicationScheduleFromJson(json);

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

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MedicationScheduleCopyWith<_MedicationSchedule> get copyWith => __$MedicationScheduleCopyWithImpl<_MedicationSchedule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MedicationScheduleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MedicationSchedule &&
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

  @override
  String toString() {
    return 'MedicationSchedule(id: $id, hour: $hour, minute: $minute, quantityMemo: $quantityMemo, notificationSetting: $notificationSetting, focusConnectSetting: $focusConnectSetting)';
  }
}

/// @nodoc
abstract mixin class _$MedicationScheduleCopyWith<$Res> implements $MedicationScheduleCopyWith<$Res> {
  factory _$MedicationScheduleCopyWith(_MedicationSchedule value, $Res Function(_MedicationSchedule) _then) = __$MedicationScheduleCopyWithImpl;
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
class __$MedicationScheduleCopyWithImpl<$Res> implements _$MedicationScheduleCopyWith<$Res> {
  __$MedicationScheduleCopyWithImpl(this._self, this._then);

  final _MedicationSchedule _self;
  final $Res Function(_MedicationSchedule) _then;

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? hour = null,
    Object? minute = null,
    Object? quantityMemo = null,
    Object? notificationSetting = null,
    Object? focusConnectSetting = freezed,
  }) {
    return _then(_MedicationSchedule(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hour: null == hour
          ? _self.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int,
      minute: null == minute
          ? _self.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int,
      quantityMemo: null == quantityMemo
          ? _self.quantityMemo
          : quantityMemo // ignore: cast_nullable_to_non_nullable
              as String,
      notificationSetting: null == notificationSetting
          ? _self.notificationSetting
          : notificationSetting // ignore: cast_nullable_to_non_nullable
              as MedicineScheduleNotificationSetting,
      focusConnectSetting: freezed == focusConnectSetting
          ? _self.focusConnectSetting
          : focusConnectSetting // ignore: cast_nullable_to_non_nullable
              as MedicineScheduleFocusConnectSetting?,
    ));
  }

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineScheduleNotificationSettingCopyWith<$Res> get notificationSetting {
    return $MedicineScheduleNotificationSettingCopyWith<$Res>(_self.notificationSetting, (value) {
      return _then(_self.copyWith(notificationSetting: value));
    });
  }

  /// Create a copy of MedicationSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MedicineScheduleFocusConnectSettingCopyWith<$Res>? get focusConnectSetting {
    if (_self.focusConnectSetting == null) {
      return null;
    }

    return $MedicineScheduleFocusConnectSettingCopyWith<$Res>(_self.focusConnectSetting!, (value) {
      return _then(_self.copyWith(focusConnectSetting: value));
    });
  }
}

// dart format on
