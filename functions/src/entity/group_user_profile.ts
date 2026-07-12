/**
 * GroupUserProfile ドキュメントの複合 ID: GroupUserProfile_groups_{groupID}_users_{userID}
 * クライアント側(lib/entity/group_user_profile.dart の GroupUserProfile.documentID)と同じ規則を維持すること。
 */
export function groupUserProfileDocumentID({
  groupID,
  userID,
}: {
  groupID: string;
  userID: string;
}): string {
  return `GroupUserProfile_groups_${groupID}_users_${userID}`;
}
