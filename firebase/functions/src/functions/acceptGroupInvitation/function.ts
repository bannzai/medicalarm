import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import { FieldValue } from "firebase-admin/firestore";
import { database } from "../../core/database";
import { OnCallResponse } from "../../core/response";
import { groupUserProfileDocumentID } from "../../entity/group_user_profile";

/**
 * 招待コードを受け入れてグループに参加する。
 *
 * 冪等: 既にメンバーの場合はグループ ID を返して何もしない。
 * グループへの参加と招待ステータスの更新はトランザクションでアトミックに行う。
 */
async function acceptGroupInvitationHandler(req: {
  auth?: { uid?: string | null } | null;
  data?: { invitationCode?: string };
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

    const invitationCode = req.data?.invitationCode;
    if (invitationCode == null) {
      return {
        result: "NG",
        statusCode: 400,
        error: { message: "invitationCode が指定されていません" },
      };
    }

    // invitationCode のみで招待を検索 (status フィルタは付けない)。
    // クライアントのリトライで defaultGroupID の切替が未完のまま再送された場合でも、
    // accepted 済みの招待を拾って「既にメンバーなら成功」と判定できるようにするため。
    const invitationSnapshot = await database
      .collection("groupInvitations")
      .where("invitationCode", "==", invitationCode)
      .limit(1)
      .get();

    if (invitationSnapshot.empty) {
      return {
        result: "NG",
        statusCode: 404,
        error: { message: "有効な招待が見つかりません" },
      };
    }

    const invitationDoc = invitationSnapshot.docs[0];
    const invitationData = invitationDoc.data();

    // 期限切れチェック
    const expiresDateTime = invitationData.expiresDateTime?.toDate();
    if (expiresDateTime && expiresDateTime < new Date()) {
      await invitationDoc.ref.update({
        status: "expired",
        updatedDateTime: FieldValue.serverTimestamp(),
        serverUpdatedDateTime: FieldValue.serverTimestamp(),
      });
      return {
        result: "NG",
        statusCode: 410,
        error: { message: "招待の有効期限が切れています" },
      };
    }

    const groupID = invitationData.groupID;
    const groupRef = database.collection("groups").doc(groupID);

    // トランザクションでグループへの参加と招待ステータスの更新をアトミックに行う。
    // 招待ドキュメントもトランザクション内で再読み込みし、同時利用によるレースコンディションを防ぐ。
    const joined = await database.runTransaction(async (transaction) => {
      const [groupDoc, invitationDocSnapshot] = await Promise.all([
        transaction.get(groupRef),
        transaction.get(invitationDoc.ref),
      ]);

      if (!groupDoc.exists) {
        throw new Error("グループが見つかりません");
      }

      // トランザクション内で招待を再読み込みする(同時利用によるレースコンディション対策)
      const currentInvitationData = invitationDocSnapshot.data();
      if (!currentInvitationData) {
        throw new Error("この招待コードは既に使用されています");
      }

      const memberUserIDs: string[] = groupDoc.data()?.memberUserIDs ?? [];

      // 冪等性: 既にメンバーなら何もしない(accepted 済みのリトライでも成功として groupID を返す)
      if (memberUserIDs.includes(uid)) {
        return false;
      }

      // 呼び出し者が未参加なのに招待が pending でないなら、別ユーザーが使用済み
      if (currentInvitationData.status !== "pending") {
        throw new Error("この招待コードは既に使用されています");
      }

      // 招待者が現在もグループのメンバーであることを検証(発行後に除名されたメンバーの招待を無効化)
      if (!memberUserIDs.includes(currentInvitationData.inviterUserID)) {
        throw new Error("この招待コードは無効です");
      }

      transaction.update(groupRef, {
        memberUserIDs: FieldValue.arrayUnion(uid),
        updatedDateTime: FieldValue.serverTimestamp(),
        serverUpdatedDateTime: FieldValue.serverTimestamp(),
      });
      transaction.update(invitationDoc.ref, {
        status: "accepted",
        updatedDateTime: FieldValue.serverTimestamp(),
        serverUpdatedDateTime: FieldValue.serverTimestamp(),
      });

      // 参加ユーザーのプロフィールを作成。displayName はグループ設定 UI で本人が編集する。
      const profileID = groupUserProfileDocumentID({ groupID, userID: uid });
      transaction.set(groupRef.collection("userProfiles").doc(profileID), {
        id: profileID,
        groupID,
        userID: uid,
        displayName: null,
        createdDateTime: FieldValue.serverTimestamp(),
        updatedDateTime: FieldValue.serverTimestamp(),
        serverCreatedDateTime: FieldValue.serverTimestamp(),
        serverUpdatedDateTime: FieldValue.serverTimestamp(),
      });

      return true;
    });

    if (joined) {
      logger.info(`User ${uid} joined group ${groupID} via invitation`);
    } else {
      logger.info(
        `User ${uid} is already a member of group ${groupID}. Skipping.`
      );
    }

    return {
      result: "OK",
      statusCode: 200,
      data: { groupID },
    };
  } catch (error) {
    logger.error(error);
    return {
      result: "NG",
      statusCode: 500,
      error: {
        message:
          error instanceof Error ? error.message : "招待の受け入れに失敗しました",
      },
    };
  }
}

module.exports = onCall(
  {
    memory: "1GiB",
    region: "asia-northeast1",
  },
  acceptGroupInvitationHandler
);
