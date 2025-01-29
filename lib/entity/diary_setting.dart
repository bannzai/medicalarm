// import 'package:flutter/foundation.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:medicalarm/entity/timestamp.dart';

// part 'diary_setting.g.dart';
// part 'diary_setting.freezed.dart';

// [DiarySetting:WIP] 服用者ごとのタグをどういう風に管理するのが良いかわかなかったのでファーストリリースから外す
// @freezed
// class DiarySetting with _$DiarySetting {
//   @JsonSerializable(explicitToJson: true)
//   const factory DiarySetting({
//     @Default([]) List<String> tags,
//     @ClientCreatedTimestamp() DateTime? createdDateTime,
//     @ClientUpdatedTimestamp() DateTime? updatedDateTime,
//     @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
//     @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
//   }) = _DiarySetting;

//   factory DiarySetting.fromJson(Map<String, dynamic> json) => _$DiarySettingFromJson(json);
//   const DiarySetting._();

//   static List<String> get defaultTags => [
//         L.headache,
//         L.stomachache,
//         L.nausea,
//         L.anemia,
//         L.diarrhea,
//         L.constipation,
//         L.hotFlash,
//         L.drowsiness,
//         L.backPain,
//         L.palpitation,
//         L.abnormalBleeding,
//         L.lossOfAppetite,
//         L.chestTightness,
//         L.insomnia,
//       ];
// }
