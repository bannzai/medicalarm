import { logger } from "firebase-functions";
import { defineSecret } from "firebase-functions/params";

/// RevenueCat の Secret API Key。Subscribers API の呼び出しに使用する。Secret Manager 経由で取得。
/// NOTE: 既存の startPromotion と同じ Secret 名 "REVENUECAT_API_SECRET" を参照する。
export const revenueCatAPISecretParam = defineSecret("REVENUECAT_API_SECRET");

/// RevenueCat のプレミアム Entitlement 識別子。
export const premiumEntitlementID = "Premium";

/** RevenueCat Subscribers API レスポンスのうちプレミアム判定に必要な部分。 */
interface RevenueCatSubscriberResponse {
  subscriber?: {
    entitlements?: Record<string, { expires_date: string | null }>;
  };
}

/**
 * RevenueCat Subscribers API からプレミアム判定を行う。
 *
 * プレミアム状態の SSOT は RevenueCat であり、ストア課金・Promotional 付与の両方が反映される。
 * GET /v1/subscribers は未登録の subscriber を登録して返すが、繰り返し呼んでも同一状態になるため冪等。
 * 判定に失敗した場合は無料ユーザーとして扱う（fail-closed）。
 */
export async function hasPremiumEntitlement(uid: string): Promise<boolean> {
  try {
    const response = await fetch(
      `https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(uid)}`,
      {
        headers: {
          Authorization: `Bearer ${revenueCatAPISecretParam.value()}`,
          "Content-Type": "application/json",
        },
      }
    );
    if (!response.ok) {
      logger.error("hasPremiumEntitlement: RevenueCat API error", {
        uid,
        status: response.status,
      });
      return false;
    }

    const entitlement = (
      (await response.json()) as RevenueCatSubscriberResponse
    ).subscriber?.entitlements?.[premiumEntitlementID];
    if (!entitlement) {
      return false;
    }
    // expires_date が null は無期限（lifetime）の付与を表す
    return (
      entitlement.expires_date == null ||
      Date.parse(entitlement.expires_date) > Date.now()
    );
  } catch (error) {
    logger.error("hasPremiumEntitlement failed", {
      uid,
      errorName: error instanceof Error ? error.name : "unknown",
    });
    return false;
  }
}
