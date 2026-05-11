import functions = require("firebase-functions");
import { onCall } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import axios from "axios";
import { z } from "zod";
import { OnCallResponse } from "../../core/response";
import { report } from "../../core/slack";

/** 機能要望通知用 Slack Incoming Webhook の URL。チャンネルは URL 側で固定されるため Channel ID は不要。 */
const slackWebhookUrlSecret = defineSecret("SLACK_FEATURE_REQUEST_WEBHOOK_URL");

/** クライアントから送られてくる機能要望リクエスト。 */
const RequestSchema = z.object({
  content: z.string().min(1).max(5000),
  emailAddress: z
    .string()
    .email()
    .optional()
    .or(z.literal("").transform(() => undefined)),
  appVersion: z.string().max(50).optional(),
  platform: z.enum(["iOS", "Android"]).optional(),
});

module.exports = onCall(
  {
    memory: "256MiB",
    region: "asia-northeast1",
    secrets: [slackWebhookUrlSecret],
  },
  async (req): Promise<OnCallResponse> => {
    const userID = req.auth?.uid;
    if (userID == null) {
      functions.logger.warn("auth user is not found");
      return {
        result: "NG",
        statusCode: 401,
        error: { message: "auth user is not found" },
      };
    }

    const parsed = RequestSchema.safeParse(req.data);
    if (!parsed.success) {
      functions.logger.warn("invalid feature request payload", parsed.error.flatten());
      return {
        result: "NG",
        statusCode: 400,
        error: { message: parsed.error.message },
      };
    }
    const { content, emailAddress, appVersion, platform } = parsed.data;

    const lines: string[] = ["💡 新規機能要望", "", `[UserID] ${userID}`];
    if (emailAddress) lines.push(`[Email] ${emailAddress}`);
    if (appVersion) lines.push(`[AppVersion] ${appVersion}`);
    if (platform) lines.push(`[Platform] ${platform}`);
    lines.push("━━━━━━━━━━━━━━━━━━━━", "内容:", content, "━━━━━━━━━━━━━━━━━━━━");

    try {
      await axios.post(slackWebhookUrlSecret.value(), { text: lines.join("\n") });
      functions.logger.info("feature request notified", { userID });
      return { result: "OK", statusCode: 200, data: { ok: true } };
    } catch (error) {
      functions.logger.error("slack post failed", error);
      await report(userID, "submitFeatureRequest", error);
      return {
        result: "NG",
        statusCode: 500,
        error: {
          message: error instanceof Error ? error.message : String(error),
        },
      };
    }
  }
);
