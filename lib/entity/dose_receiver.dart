import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'dose_receiver.g.dart';
part 'dose_receiver.freezed.dart';

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
}
