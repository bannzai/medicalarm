import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/medicine.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'dose_receiver.g.dart';
part 'dose_receiver.freezed.dart';

// [NOTE:DoseReceiver] DoseReceiver は削除不可にする。Medicine と 紐づいている。一覧表示のGroupBy処理時に DBに存在しない場合のことを考えると条件が大変になるからである
// NOTE: [DoseReceiver:Exist] 必ず 1つ以上のDoseReceiverが存在する。AppEntityPrepareResolverで必ず存在するようにする
@freezed
class DoseReceiver with _$DoseReceiver {
  const DoseReceiver._();
  @JsonSerializable(explicitToJson: true)
  const factory DoseReceiver({
    required String id,
    required String userID,
    required String name,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _DoseReceiver;

  factory DoseReceiver.fromJson(Map<String, dynamic> json) => _$DoseReceiverFromJson(json);

  static DoseReceiver firstUser({required String userID}) => DoseReceiver(
        id: MedicineDoseReceiver.firstUser.id,
        userID: userID,
        name: MedicineDoseReceiver.firstUser.name,
      );
}
