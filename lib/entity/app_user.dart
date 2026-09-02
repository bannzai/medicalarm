import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'app_user.g.dart';
part 'app_user.freezed.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();
  @JsonSerializable(explicitToJson: true)
  const factory AppUser({
    String? id,
    // 起動時に表示・書き込み対象とするグループの ID。アプリ開始時点では未作成のため nullable。
    // 初回はグループ移行(GroupMigrationResolver)がソログループを作成してセットする。
    String? defaultGroupID,
    // グループ移行の完了マーカー。defaultGroupID とは別に持つことで、
    // 「グループは作成済みだがデータコピー途中で失敗」した状態を次回起動時に検知しリカバリできる。
    @NullableTimestampConverter() DateTime? groupMigratedDateTime,
    @Default(false) bool analyticsDebugIsEnabled,
    @NullableTimestampConverter() DateTime? maybeTrialDeadlineDate,
    @NullableTimestampConverter() DateTime? promotionStartPageCancelButtonTappedDateTime,
    // 初回起動のオンボーディング (features/onboarding) を完了 (ペイウォールを閉じた) した日時。null なら未完了
    @NullableTimestampConverter() DateTime? onboardingCompletedDateTime,
    @ClientCreatedTimestamp() DateTime? createdDateTime,
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
