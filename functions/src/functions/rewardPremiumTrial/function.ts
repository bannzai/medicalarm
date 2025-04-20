import admin = require("firebase-admin");
import functions = require("firebase-functions");
import { onCall } from "firebase-functions/v2/https";
import { requestContext } from "../../core/context";
import { defineSecret } from "firebase-functions/params";
import { database } from "../../core/database";
import { firestore } from "firebase-admin";
import { OnCallResponse } from "../../core/response";
import { day } from "../../core/foundation";
import { firestoreConverter } from "../../entity/converter";
import { AppUserSchema } from "../../entity/user";

const revenueCatAPISecretParam = defineSecret("REVENUECAT_API_SECRET");
const premiumEntitlementID = "Premium";

// ref: https://www.revenuecat.com/reference/grant-a-promotional-entitlement
module.exports = onCall(
  {
    memory: "1GiB",
    region: "asia-northeast1",
    secrets: [revenueCatAPISecretParam],
  },
  async (req): Promise<OnCallResponse> => {
    const revenueCatAPISecret = revenueCatAPISecretParam.value();
    try {
      if (req.auth?.uid == null) {
        functions.logger.log("auth user is not found");
        return {
          result: "NG",
          statusCode: 401,
          error: {
            message: "auth user is not found",
          },
        };
      }
      const ctx = requestContext({
        requestID: req.auth.uid,
        functionName: "#rewardPremiumTrial",
      });

      const promotionDayCount = 7;
      const userDoc = await database
        .collection("users")
        .doc(req.auth.uid)
        .withConverter(firestoreConverter(AppUserSchema))
        .get();
      const user = userDoc.data();

      if (
        user == null ||
        user.startPromotionDateTime == null ||
        user.maybeTrialDeadlineDate == null
      ) {
        functions.logger.warn("first trial is not start", ctx.logJsonPayload());

        return {
          result: "OK",
          statusCode: 302,
          data: {
            failure: {
              code: "firstTrialIsNotStart",
            },
          },
        };
      }

      const maybeTrialDeadlineDateTimestamp = new admin.firestore.Timestamp(
        user.maybeTrialDeadlineDate.seconds,
        user.maybeTrialDeadlineDate.nanoseconds
      );
      if (maybeTrialDeadlineDateTimestamp.toDate().getTime() > Date.now()) {
        functions.logger.warn("already in trial", ctx.logJsonPayload());

        return {
          result: "OK",
          statusCode: 302,
          data: {
            failure: {
              code: "alreadyInTrial",
            },
          },
        };
      }

      const url = `https://api.revenuecat.com/v1/subscribers/${req.auth.uid}/entitlements/${premiumEntitlementID}/promotional`;
      const trialDeadlineDateOffsetMilliSecond = promotionDayCount * day;
      const appliedShareRewardPremiumTrialCount =
        (user.appliedShareRewardPremiumTrialCount ?? 0) + 1;
      const maybeTrialDeadlineDate = firestore.Timestamp.fromDate(
        new Date(Date.now() + trialDeadlineDateOffsetMilliSecond)
      );
      const response = await fetch(url, {
        method: "POST",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
          Authorization: `Bearer ${revenueCatAPISecret}`,
        },
        body: JSON.stringify({
          end_time_ms: maybeTrialDeadlineDate.toDate().getTime(),
        }),
      });

      functions.logger.log(`Success: ${response.json()}`, ctx.logJsonPayload());

      const startPromotionDateTime = firestore.Timestamp.now();
      await database.collection("users").doc(req.auth.uid).set(
        {
          startPromotionDateTime,
          maybeTrialDeadlineDate,
          appliedShareRewardPremiumTrialCount,
        },
        { merge: true }
      );

      return {
        result: "OK",
        statusCode: 200,
        data: {
          startPromotionDateTime,
          maybeTrialDeadlineDate,
          appliedShareRewardPremiumTrialCount,
          failure: null,
        },
      };
    } catch (error) {
      functions.logger.error(`Error: ${error}`);

      return {
        result: "NG",
        statusCode: 500,
        error: {
          message: `Error: ${error instanceof Error ? error.message : error}`,
        },
      };
    }
  }
);
