import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { database } from "../../core/database";
import { OnCallResponse } from "../../core/response";
import { groupUserProfileDocumentID } from "../../entity/group_user_profile";

/// Group ドキュメントのうち本関数で参照するフィールド。
interface GroupData {
  memberUserIDs?: string[];
  ownerUserID?: string | null;
  createdDateTime?: Timestamp;
}

/**
 * 対象ユーザーがメンバーである最古(createdDateTime 昇順)のグループ ID を返す。
 * 除外対象(現在離脱するグループ)以外に所属グループが無ければ null を返す。
 *
 * NOTE: 「memberUserIDs array-contains + createdDateTime orderBy」は複合インデックスを要求するため、
 * array-contains のみでクエリしてメモリ上で昇順ソートする(1 ユーザーの所属グループ数は少数のため許容)。
 */
function oldestMemberGroupID({
  memberGroupDocs,
  excludeGroupID,
}: {
  memberGroupDocs: FirebaseFirestore.QueryDocumentSnapshot[];
  excludeGroupID: string;
}): string | null {
  const sorted = memberGroupDocs
    .filter((doc) => doc.id !== excludeGroupID)
    .sort((a, b) => {
      const aMillis =
        (a.data() as GroupData).createdDateTime?.toMillis() ??
        Number.MAX_SAFE_INTEGER;
      const bMillis =
        (b.data() as GroupData).createdDateTime?.toMillis() ??
        Number.MAX_SAFE_INTEGER;
      return aMillis - bMillis;
    });
  return sorted.length > 0 ? sorted[0].id : null;
}

/**
 * グループからメンバーを削除する。オーナーのみが実行でき、オーナー自身は削除できない。
 * 冪等: 対象が既にメンバーでなければ何もしない。
 */
async function removeGroupMemberHandler(req: {
  auth?: { uid?: string | null } | null;
  data?: { groupID?: string; targetUserID?: string };
}): Promise<OnCallResponse> {
  try {
    const uid = req.auth?.uid;
    if (uid == null) {
      return {
        result: "NG",
        statusCode: 401,
        error: { message: "認証されていません" },
      };
    }

    const groupID = req.data?.groupID;
    const targetUserID = req.data?.targetUserID;
    if (groupID == null || targetUserID == null) {
      return {
        result: "NG",
        statusCode: 400,
        error: { message: "groupID または targetUserID が指定されていません" },
      };
    }

    const groupRef = database.collection("groups").doc(groupID);
    const groupDoc = await groupRef.get();
    if (!groupDoc.exists) {
      return {
        result: "NG",
        statusCode: 404,
        error: { message: "グループが見つかりません" },
      };
    }

    const ownerUserID = (groupDoc.data() as GroupData | undefined)?.ownerUserID ?? null;
    if (ownerUserID === null) {
      return {
        result: "NG",
        statusCode: 403,
        error: { message: "オーナーが設定されていないグループでは操作できません" },
      };
    }
    if (ownerUserID !== uid) {
      return {
        result: "NG",
        statusCode: 403,
        error: { message: "グループのオーナーのみがメンバーを削除できます" },
      };
    }
    if (targetUserID === uid) {
      return {
        result: "NG",
        statusCode: 400,
        error: { message: "オーナー自身を削除することはできません" },
      };
    }

    await database.runTransaction(async (transaction) => {
      const groupSnapshot = await transaction.get(groupRef);
      const memberUserIDs: string[] =
        (groupSnapshot.data() as GroupData | undefined)?.memberUserIDs ?? [];

      // 冪等性: 既にメンバーでなければそのまま終了
      if (!memberUserIDs.includes(targetUserID)) {
        return;
      }

      // Firestore トランザクションは全ての read を全ての write より前に実行する必要があるため、
      // defaultGroupID 判定に使う対象ユーザーと、その付け替え先候補(対象ユーザーが所属する他グループ)の
      // read を書き込みより先に済ませる。
      const userRef = database.collection("users").doc(targetUserID);
      const userDoc = await transaction.get(userRef);
      const shouldReassignDefault =
        userDoc.exists && userDoc.data()?.defaultGroupID === groupID;
      let reassignedGroupID: string | null = null;
      if (shouldReassignDefault) {
        const memberGroupsSnapshot = await transaction.get(
          database
            .collection("groups")
            .where("memberUserIDs", "array-contains", targetUserID)
        );
        reassignedGroupID = oldestMemberGroupID({
          memberGroupDocs: memberGroupsSnapshot.docs,
          excludeGroupID: groupID,
        });
      }

      transaction.update(groupRef, {
        memberUserIDs: FieldValue.arrayRemove(targetUserID),
        updatedDateTime: FieldValue.serverTimestamp(),
        serverUpdatedDateTime: FieldValue.serverTimestamp(),
      });

      // 対象ユーザーのプロフィールを削除
      transaction.delete(
        groupRef
          .collection("userProfiles")
          .doc(groupUserProfileDocumentID({ groupID, userID: targetUserID }))
      );

      // 対象ユーザーの個別通知設定 (docID = memberUserID) を削除。
      // 残置するとグループから外れた後も設定が read 可能なまま露出するため。
      transaction.delete(
        groupRef.collection("memberNotificationSettings").doc(targetUserID)
      );

      // 対象ユーザーの defaultGroupID が当該グループなら、対象ユーザーが所有する最古のグループに付け替える(無ければ null)
      if (shouldReassignDefault) {
        transaction.update(userRef, {
          defaultGroupID: reassignedGroupID,
          updatedDateTime: FieldValue.serverTimestamp(),
          serverUpdatedDateTime: FieldValue.serverTimestamp(),
        });
      }
    });

    logger.info(`User ${targetUserID} removed from group ${groupID} by ${uid}`);

    return {
      result: "OK",
      statusCode: 200,
      data: {},
    };
  } catch (error) {
    logger.error(error);
    return {
      result: "NG",
      statusCode: 500,
      error: {
        message:
          error instanceof Error ? error.message : "メンバーの削除に失敗しました",
      },
    };
  }
}

module.exports = onCall(
  {
    memory: "1GiB",
    region: "asia-northeast1",
  },
  removeGroupMemberHandler
);
