import functions = require("firebase-functions");
import { onCall } from "firebase-functions/v2/https";
import { OnCallResponse } from "../../core/response";
import { database } from "../../core/database";
import { getFunctions } from "firebase-admin/functions";
import { getFunctionURL } from "../../utils/functionURL";
import { startLiveActivity } from "../../utils/apns";
import { firestoreConverter } from "../../entity/converter";
import { AppUserSchema } from "../../entity/user";
import { apnsAuthKeyBase64 } from "./secret";

// ref: https://claude.ai/chat/688cabe2-c8ac-438d-930a-3e55dc2b1727
module.exports = onCall(
  {
    memory: "1GiB",
    region: "asia-northeast1",
    secrets: [apnsAuthKeyBase64],
  },
  async (req): Promise<OnCallResponse> => {
    functions.logger.log("Start live activity");
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

      const data = req.data as LiveActivityRequest;
      const activityDoc = database
        .collection(`/users/${req.auth.uid}/liveActivities`)
        .doc();
      const activityID = activityDoc.id;
      await activityDoc.set(
        {
          activityID,
          ...data,
        },
        { merge: true }
      );

      const userDoc = await database
        .doc(`/users/${req.auth.uid}`)
        .withConverter(firestoreConverter(AppUserSchema))
        .get();
      if (!userDoc.exists) {
        return {
          result: "OK",
          statusCode: 200,
          data: {
            activityID: null,
          },
        };
      }
      const user = userDoc.data();

      if (user?.pushToStartToken == null) {
        return {
          result: "OK",
          statusCode: 200,
          data: {
            activityID: null,
          },
        };
      }

      await startLiveActivity({
        apnsAuthKeyBase64,
        pushToStartToken: user.pushToStartToken,
        payload: {
          event: "start",
          attributes: data.start.attributes,
          "attributes-type": data.start.attributesType,
          "content-state": data.start.contentState,
        },
      });
      functions.logger.log("Live activity started");

      for (const update of data.updates) {
        const updateLiveActivityQueue = getFunctions().taskQueue(
          "updateLiveActivityTask"
        );
        const updateLiveActivityFunctionURL = await getFunctionURL(
          "updateLiveActivityTask"
        );
        await updateLiveActivityQueue.enqueue(
          {
            activityID,
            contentState: update.contentState,
            update,
          },
          {
            uri: updateLiveActivityFunctionURL,
            scheduleTime: new Date(update.timestamp * 1000),
          }
        );
        functions.logger.log(
          `Queued update time: ${new Date(update.timestamp * 1000)}`
        );
      }

      const endLiveActivityQueue = getFunctions().taskQueue(
        "endLiveActivityTask"
      );
      const endLiveActivityFunctionURL = await getFunctionURL(
        "endLiveActivityTask"
      );
      await endLiveActivityQueue.enqueue(
        {
          activityID,
          contentState: data.end.contentState,
          end: data.end,
        },
        {
          uri: endLiveActivityFunctionURL,
          scheduleTime: new Date(data.end.timestamp * 1000),
        }
      );
      functions.logger.log(
        `Queued end time: ${new Date(data.end.timestamp * 1000)}`
      );

      return {
        result: "OK",
        statusCode: 200,
        data: {
          activityID,
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

interface LiveActivityRequest {
  start: {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    attributes: any;
    attributesType: string;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    contentState: any;
  };
  updates: {
    timestamp: number;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    contentState: any;
  }[];
  end: {
    timestamp: number;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    contentState: any;
  };
}
