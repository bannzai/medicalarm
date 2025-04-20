import { onTaskDispatched } from "firebase-functions/v2/tasks";
import { sendPushNotification } from "../../../utils/apns";
import { database } from "../../../core/database";
import { apnsAuthKeyBase64 } from "../secret";

module.exports = onTaskDispatched(
  {
    retryConfig: {
      maxAttempts: 5,
      minBackoffSeconds: 60,
    },
    secrets: [apnsAuthKeyBase64],
    // NOTE: [CloudTask:Region] "asia-northeast1" を使いたいが、なぜか us-central1 じゃないと動かないため明示的に指定する
    region: "us-central1",
  },
  async (req) => {
    try {
      const { activityID, contentState } = req.data;
      if (!activityID || !contentState) {
        throw new Error("Missing activityId or contentState");
      }

      if (req.auth?.uid == null) {
        throw new Error("auth user is not found");
      }

      const activityDoc = await database
        .collection(`/users/${req.auth.uid}/liveActivities`)
        .doc(activityID)
        .get();
      if (!activityDoc.exists) {
        throw new Error("Activity not found");
      }

      const { pushToken } = activityDoc.data() as { pushToken: string };

      await sendPushNotification({
        apnsAuthKeyBase64,
        pushToken,
        payload: {
          event: "update",
          "content-state": contentState,
        },
      });
    } catch (error) {
      console.error("Error updating live activity:", error);
      throw error;
    }
  }
);
