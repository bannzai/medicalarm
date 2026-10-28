import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'group.g.dart';
part 'group.freezed.dart';

/// 無料ユーザーがソログループに加えて作成できるグループ数の上限。
/// NOTE: サーバー側(firebase/functions/src/functions/createGroup/function.ts の FREE_ADDITIONAL_GROUP_CREATION_LIMIT)と同じ値を維持すること。
const int freeAdditionalGroupCreationLimit = 1;

/// 服薬管理を共有するグループを表すエンティティ。
///
/// 複数の [AppUser] が所属し、Medicine / DoseReceiver / MedicationHistory / Diary を
/// グループ単位で共有する。1 ユーザーにつき起動時に自動作成されるソログループを 1 つ持ち、
/// 追加で家族・介護向けの共有グループを作成できる。
@freezed
abstract class Group with _$Group {
  const Group._();

  @JsonSerializable(explicitToJson: true)
  const factory Group({
    required String id,

    /// グループに所属するユーザーの AppUser.id の配列。
    required List<String> memberUserIDs,

    /// グループ名。ソログループは null 許容。ユーザー作成グループは必須。
    required String? name,

    /// グループを作成したユーザーの AppUser.id。
    /// NOTE: 既存のグループドキュメントにはこのフィールドが存在しない場合があるため nullable。
    required String? ownerUserID,

    /// グループに紐づくアイコンの識別子。
    /// home / family / hospital / medication / elderly / favorite のいずれか。
    /// 既存ドキュメントにはこのフィールドが存在しないため default で `home` を返す。
    @Default('home') String iconName,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
