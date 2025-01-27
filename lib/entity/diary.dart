import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'diary.freezed.dart';
part 'diary.g.dart';

abstract class DiaryFirestoreKey {
  static const String date = 'date';
}

@freezed
class Diary with _$Diary {
  @JsonSerializable(explicitToJson: true)
  factory Diary({
    required String id,
    required String userID,
// [DiarySetting:WIP] 服用者ごとのタグをどういう風に管理するのが良いかわかなかったのでファーストリリースから外す
    // required List<String> tags,
// [DiaryMemo:WIP] 服用者ごとのメモをどういう風に管理するのが良いかわかなかったのでファーストリリースから外す
    // required List<DiaryMemo> memos,
    required String memo,
    @TimestampConverter() required DateTime diaryDate,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _Diary;
  const Diary._();

  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
}

// [DiaryMemo:WIP] 服用者ごとのメモをどういう風に管理するのが良いかわかなかったのでファーストリリースから外す
// @freezed
// class DiaryMemo with _$DiaryMemo {
//   @JsonSerializable(explicitToJson: true)
//   factory DiaryMemo({
//     required MedicationHistory medicationHistory,
//     required String memo,
//     required DoseReceiver doseReceiver,
//   }) = _DiaryMemo;
//   const DiaryMemo._();

//   factory DiaryMemo.fromJson(Map<String, dynamic> json) => _$DiaryMemoFromJson(json);
// }
