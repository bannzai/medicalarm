import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import * as crypto from "crypto";
import { database } from "../../core/database";
import { OnCallResponse } from "../../core/response";
import { day } from "../../core/foundation";

/// 紛らわしい文字(O,0,I,1,L,2,U,Z)を除外した 28 文字のアルファベット。
const ALPHABET = "ABCDEFGHJKMNPQRSTVWXY3456789";
const CODE_LENGTH = 8;
const INVITATION_EXPIRY_DAYS = 7;

/**
 * 招待コードを生成する。
 *
 * crypto.randomBytes によるリジェクションサンプリングで、ALPHABET の文字数(28)で割り切れない
 * バイト値の範囲(limit 以上)を捨てることで、文字ごとの出現確率のバイアスを排除する。
 */
function generateInvitationCode(): string {
  let code = "";
  const alphabetLength = ALPHABET.length;
  const limit = 256 - (256 % alphabetLength);
  while (code.length < CODE_LENGTH) {
    const randomByte = crypto.randomBytes(1)[0];
    if (randomByte < limit) {
      code += ALPHABET[randomByte % alphabetLength];
    }
  }
  return code;
}

/**
 * グループへの招待コードを発行する。呼び出し者はグループのメンバーである必要がある。
 * 冪等ではない: 呼び出しごとに新しい招待コードを払い出す。
 */
async function createGroupInvitationHandler(req: {
  auth?: { uid?: string | null } | null;
  data?: { groupID?: string };
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
    if (groupID == null) {
      return {
        result: "NG",
        statusCode: 400,
        error: { message: "groupID が指定されていません" },
      };
    }

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

    // コード重複チェック付きで招待コードを生成
    let invitationCode = "";
    let attempts = 0;
    const maxAttempts = 10;
    do {
      invitationCode = generateInvitationCode();
      const existing = await database
        .collection("groupInvitations")
        .where("invitationCode", "==", invitationCode)
        .limit(1)
        .get();
      if (existing.empty) break;
      attempts++;
    } while (attempts < maxAttempts);

    if (attempts >= maxAttempts) {
      return {
        result: "NG",
        statusCode: 500,
        error: { message: "招待コードの生成に失敗しました。再度お試しください" },
      };
    }

    const expiresDateTime = Timestamp.fromMillis(
      Timestamp.now().toMillis() + day * INVITATION_EXPIRY_DAYS
    );

    const invitationRef = database.collection("groupInvitations").doc();
    await invitationRef.set({
      id: invitationRef.id,
      groupID,
      inviterUserID: uid,
      invitationCode,
      status: "pending",
      expiresDateTime,
      createdDateTime: FieldValue.serverTimestamp(),
      updatedDateTime: FieldValue.serverTimestamp(),
      serverCreatedDateTime: FieldValue.serverTimestamp(),
      serverUpdatedDateTime: FieldValue.serverTimestamp(),
    });

    logger.info(
      `Created invitation for group ${groupID}: code=${invitationCode}`
    );

    return {
      result: "OK",
      statusCode: 200,
      data: {
        invitationCode,
        // 招待コードの有効期限を ISO8601 文字列で返す。クライアントで DateTime.parse して残り時間表示に使う。
        expiresDateTime: expiresDateTime.toDate().toISOString(),
      },
    };
  } catch (error) {
    logger.error(error);
    return {
      result: "NG",
      statusCode: 500,
      error: {
        message: error instanceof Error ? error.message : "招待の作成に失敗しました",
      },
    };
  }
}

module.exports = onCall(
  {
    memory: "1GiB",
    region: "asia-northeast1",
  },
  createGroupInvitationHandler
);
