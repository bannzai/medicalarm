import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'group_invitation.g.dart';
part 'group_invitation.freezed.dart';

/// [GroupInvitation] のステータス。
enum GroupInvitationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('expired')
  expired,
}

/// [Group] へのユーザー招待を管理するエンティティ。
///
/// 招待者が招待コードを発行し、被招待者がそのコードを入力してグループに参加する。
/// 招待には有効期限があり、期限切れは [GroupInvitationStatus.expired] となる。
/// クライアントからは直接 read/write せず、Cloud Functions 経由でのみ操作する。
@freezed
abstract class GroupInvitation with _$GroupInvitation {
  const GroupInvitation._();

  @JsonSerializable(explicitToJson: true)
  const factory GroupInvitation({
    required String id,
    required String groupID,

    /// 招待コードを発行したユーザーの AppUser.id。
    required String inviterUserID,

    /// 被招待者が入力する招待コード。
    required String invitationCode,
    required GroupInvitationStatus status,

    /// 招待コードの有効期限。
    @NullableTimestampConverter() DateTime? expiresDateTime,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _GroupInvitation;

  factory GroupInvitation.fromJson(Map<String, dynamic> json) => _$GroupInvitationFromJson(json);
}
