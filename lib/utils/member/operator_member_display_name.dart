import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:medicalarm/entity/medication_history.dart';
import 'package:medicalarm/features/localization/l.dart';
import 'package:medicalarm/provider/app_user.dart';
import 'package:medicalarm/provider/current_group_id.dart';
import 'package:medicalarm/provider/group_user_profile.dart';

/// 服薬記録の操作者(記録者・取消者)が「自分以外のメンバー」の場合に表示名を返す。
/// displayName が未登録・プロフィール不在でもフォールバック文言([L.memberFallbackName])を返し、操作者表示を必ず出す。
/// 操作者が自分・不明の場合は null を返し、操作者表示を出さない。
String? operatorMemberDisplayName({required WidgetRef ref, required MedicationHistory history}) {
  final recordedByUserID = history.recordedByUserID;
  if (recordedByUserID == null || recordedByUserID == ref.watch(appUserIDProvider)) {
    return null;
  }
  final currentGroupID = ref.watch(currentGroupIDProvider);
  final displayName = currentGroupID == null
      ? null
      : ref
          .watch(groupUserProfilesProvider(groupID: currentGroupID))
          .valueOrNull
          ?.firstWhereOrNull((profile) => profile.userID == recordedByUserID)
          ?.displayName;
  return (displayName?.isNotEmpty ?? false) ? displayName : L.memberFallbackName;
}
