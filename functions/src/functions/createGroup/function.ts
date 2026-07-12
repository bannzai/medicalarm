import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import { firestore } from "firebase-admin";
import { database } from "../../core/database";
import { OnCallResponse } from "../../core/response";
import {
  hasPremiumEntitlement,
  revenueCatAPISecretParam,
} from "../utils/premium";
import { groupUserProfileDocumentID } from "../../entity/group_user_profile";

/// 無料ユーザーがソログループに加えて作成できるグループ数の上限。
/// NOTE: クライアント側(lib/entity/group.dart の freeAdditionalGroupCreationLimit)と同じ値を維持すること。
const FREE_ADDITIONAL_GROUP_CREATION_LIMIT = 1;

/// グループ名の最大文字数。
const MAX_GROUP_NAME_LENGTH = 100;

/// Group.iconName で許容するアイコンプリセット。
/// NOTE: クライアント側(lib/entity/group.dart の iconName コメント)と同じ統制値を維持すること。
const ALLOWED_ICON_NAMES = [
  "home",
  "family",
  "hospital",
  "medication",
  "elderly",
  "favorite",
] as const;

/// AppUser ドキュメントのうち本関数で参照するフィールド。
interface AppUserData {
  defaultGroupID?: string | null;
}

/**
 * 認証ユーザーを唯一のメンバー兼オーナーとする新しいグループを作成する。
 *
 * 非冪等: 呼び出しごとに新規 ID を払い出すため、重複作成は上限チェック(同一トランザクション内)と
 * クライアントの二重送信防止で抑止する。
 */
async function createGroupHandler(req: {
  auth?: { uid?: string | null } | null;
  data?: { name?: string | null; setAsDefault?: boolean; iconName?: string };
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

    const name = req.data?.name ?? null;
    const setAsDefault = req.data?.setAsDefault ?? false;
    const iconName = ALLOWED_ICON_NAMES.includes(
      req.data?.iconName as (typeof ALLOWED_ICON_NAMES)[number]
    )
      ? (req.data?.iconName as string)
      : "home";

    const normalizedName = name?.trim() ?? null;
    // eslint-disable-next-line no-control-regex
    if (normalizedName != null && /[\x00-\x1F\x7F]/.test(normalizedName)) {
      return {
        result: "NG",
        statusCode: 400,
        error: { message: "グループ名に使用できない文字が含まれています" },
      };
    }
    if (normalizedName != null && normalizedName.length > MAX_GROUP_NAME_LENGTH) {
      return {
        result: "NG",
        statusCode: 400,
        error: {
          message: `グループ名は${MAX_GROUP_NAME_LENGTH}文字以内で入力してください`,
        },
      };
    }

    const isPremium = await hasPremiumEntitlement(uid);

    const groupRef = database.collection("groups").doc();
    const userRef = database.collection("users").doc(uid);
    const profileRef = database
      .collection(`groups/${groupRef.id}/userProfiles`)
      .doc(groupUserProfileDocumentID({ groupID: groupRef.id, userID: uid }));
    const ownedGroupsQuery = database
      .collection("groups")
      .where("ownerUserID", "==", uid);

    // 上限チェックと作成を同一トランザクションで行い、同時実行による上限すり抜け(レース)を防ぐ。
    // Firestore トランザクションは「全 read → 全 write」の順序が必須のため、上限チェックの read を
    // write より前に置く。上限超過時は write を行わず理由文字列を返してロールバック相当にする。
    const limitErrorMessage = await database.runTransaction(
      async (transaction) => {
        const userSnapshot = await transaction.get(userRef);
        if (!isPremium) {
          const ownedGroupsSnapshot = await transaction.get(ownedGroupsQuery);
          if (
            ownedGroupsSnapshot.size >=
            FREE_ADDITIONAL_GROUP_CREATION_LIMIT + 1
          ) {
            return `無料プランではソログループ+${FREE_ADDITIONAL_GROUP_CREATION_LIMIT}グループまで作成できます。プレミアムにアップグレードすると無制限に作成できます`;
          }
        }

        const userData = userSnapshot.data() as AppUserData | undefined;
        const shouldSetDefault =
          setAsDefault || userData?.defaultGroupID == null;

        transaction.set(
          groupRef,
          {
            id: groupRef.id,
            ownerUserID: uid,
            memberUserIDs: [uid],
            name: normalizedName?.length ? normalizedName : null,
            iconName,
            createdDateTime: firestore.FieldValue.serverTimestamp(),
            updatedDateTime: firestore.FieldValue.serverTimestamp(),
            serverCreatedDateTime: firestore.FieldValue.serverTimestamp(),
            serverUpdatedDateTime: firestore.FieldValue.serverTimestamp(),
          },
          { merge: true }
        );

        transaction.set(
          profileRef,
          {
            id: profileRef.id,
            groupID: groupRef.id,
            userID: uid,
            displayName: null,
            createdDateTime: firestore.FieldValue.serverTimestamp(),
            updatedDateTime: firestore.FieldValue.serverTimestamp(),
            serverCreatedDateTime: firestore.FieldValue.serverTimestamp(),
            serverUpdatedDateTime: firestore.FieldValue.serverTimestamp(),
          },
          { merge: true }
        );

        if (shouldSetDefault) {
          transaction.set(
            userRef,
            {
              defaultGroupID: groupRef.id,
              serverUpdatedDateTime: firestore.FieldValue.serverTimestamp(),
            },
            { merge: true }
          );
        }

        return null;
      }
    );

    if (limitErrorMessage != null) {
      return {
        result: "NG",
        statusCode: 403,
        error: { message: limitErrorMessage },
      };
    }

    logger.info(`Created group ${groupRef.id} by ${uid}`);

    return {
      result: "OK",
      statusCode: 200,
      data: { groupID: groupRef.id },
    };
  } catch (error) {
    logger.error(error);
    return {
      result: "NG",
      statusCode: 500,
      error: {
        message:
          error instanceof Error ? error.message : "グループの作成に失敗しました",
      },
    };
  }
}

module.exports = onCall(
  {
    memory: "1GiB",
    region: "asia-northeast1",
    secrets: [revenueCatAPISecretParam],
  },
  createGroupHandler
);
