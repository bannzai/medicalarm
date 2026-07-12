import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import { firestore, messaging } from "firebase-admin";
import { database } from "../../core/database";
import { OnCallResponse } from "../../core/response";
import { groupUserProfileDocumentID } from "../../entity/group_user_profile";

/// FCM トークンのプレースホルダ。Simulator など push を受け取れない環境が登録するダミー値のため送信対象から除外する。
const DEBUG_MODE_TOKEN = "debug_mode";

/**
 * 服薬記録を追加した際に、同じグループの他メンバーへ FCM push 通知を送る。
 * 呼び出し者はグループのメンバーである必要がある。送信対象は自分以外の全メンバー。
 * 記録自体は成功済みの前提で fire-and-forget 的に呼ばれるため、送信失敗は counts で返して例外にしない。
 */
async function sendMedicationRecordNotificationHandler(req: {
  auth?: { uid?: string | null } | null;
  data?: {
    groupID?: string;
    medicineID?: string;
    medicineName?: string;
    doseReceiverName?: string;
  };
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
    const medicineID = req.data?.medicineID;
    if (groupID == null || medicineID == null) {
      return {
        result: "NG",
        statusCode: 400,
        error: { message: "groupID または medicineID が指定されていません" },
      };
    }
    const medicineName = req.data?.medicineName ?? "";
    const doseReceiverName = req.data?.doseReceiverName ?? "";

    const groupDoc = await database.collection("groups").doc(groupID).get();
    if (!groupDoc.exists) {
      return {
        result: "NG",
        statusCode: 404,
        error: { message: "グループが見つかりません" },
      };
    }
    const memberUserIDs: string[] = groupDoc.data()?.memberUserIDs ?? [];
    if (!memberUserIDs.includes(uid)) {
      return {
        result: "NG",
        statusCode: 403,
        error: { message: "グループのメンバーではありません" },
      };
    }

    // 送信者の表示名を userProfiles からサーバ側で解決する
    const senderProfileDoc = await database
      .collection("groups")
      .doc(groupID)
      .collection("userProfiles")
      .doc(groupUserProfileDocumentID({ groupID, userID: uid }))
      .get();
    const senderName: string = senderProfileDoc.data()?.displayName ?? "メンバー";

    // 対象 = 自分以外の全メンバー。各メンバーの privates/{userID}.fcmTokens を並列取得する
    const targetUserIDs = memberUserIDs.filter((id) => id !== uid);
    const privateDocs = await Promise.all(
      targetUserIDs.map((targetUserID) =>
        database
          .collection("users")
          .doc(targetUserID)
          .collection("privates")
          .doc(targetUserID)
          .get()
      )
    );

    const allTokens: string[] = [];
    const tokenToUserID = new Map<string, string>();
    privateDocs.forEach((privateDoc, index) => {
      if (!privateDoc.exists) return;
      const tokens: string[] = privateDoc.data()?.fcmTokens ?? [];
      for (const token of tokens) {
        if (token === DEBUG_MODE_TOKEN) continue;
        allTokens.push(token);
        tokenToUserID.set(token, targetUserIDs[index]);
      }
    });

    if (allTokens.length === 0) {
      return {
        result: "OK",
        statusCode: 200,
        data: { successCount: 0, failureCount: 0 },
      };
    }

    const message: messaging.MulticastMessage = {
      tokens: allTokens,
      notification: {
        title: `${senderName}さんが服薬を記録しました`,
        body: doseReceiverName.length
          ? `${doseReceiverName}の「${medicineName.length ? medicineName : "お薬"}」を記録しました`
          : `「${medicineName.length ? medicineName : "お薬"}」を記録しました`,
      },
      data: {
        groupID,
        medicineID,
        type: "medicationRecord",
      },
    };

    const response = await messaging().sendEachForMulticast(message);

    // 無効トークンをユーザーごとに集約してクリーンアップ
    const invalidTokensByUser = new Map<string, string[]>();
    response.responses.forEach((resp, index) => {
      if (
        !resp.success &&
        resp.error &&
        (resp.error.code === "messaging/invalid-registration-token" ||
          resp.error.code === "messaging/registration-token-not-registered")
      ) {
        const token = allTokens[index];
        const userID = tokenToUserID.get(token);
        if (userID) {
          invalidTokensByUser.set(userID, [
            ...(invalidTokensByUser.get(userID) ?? []),
            token,
          ]);
        }
      }
    });

    // 無効トークンを並列削除(個別の失敗は無視して継続)
    const cleanupResults = await Promise.allSettled(
      Array.from(invalidTokensByUser.entries()).map(([userID, tokens]) => {
        logger.info(
          `Queued removal of ${tokens.length} invalid FCM tokens for user ${userID}`
        );
        return database
          .collection("users")
          .doc(userID)
          .collection("privates")
          .doc(userID)
          .update({
            fcmTokens: firestore.FieldValue.arrayRemove(...tokens),
            updatedDateTime: firestore.FieldValue.serverTimestamp(),
            serverUpdatedDateTime: firestore.FieldValue.serverTimestamp(),
          });
      })
    );
    for (const result of cleanupResults) {
      if (result.status === "rejected") {
        logger.warn(`Failed to cleanup invalid tokens: ${result.reason}`);
      }
    }

    logger.info(
      `Sent notifications for group ${groupID}: success=${response.successCount}, failure=${response.failureCount}`
    );

    return {
      result: "OK",
      statusCode: 200,
      data: {
        successCount: response.successCount,
        failureCount: response.failureCount,
      },
    };
  } catch (error) {
    logger.error(error);
    return {
      result: "NG",
      statusCode: 500,
      error: {
        message: error instanceof Error ? error.message : "通知の送信に失敗しました",
      },
    };
  }
}

module.exports = onCall(
  {
    memory: "1GiB",
    region: "asia-northeast1",
  },
  sendMedicationRecordNotificationHandler
);
