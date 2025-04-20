import functions = require("firebase-functions");
import { onCall } from "firebase-functions/v2/https";
import { OnCallResponse } from "../../core/response";
import { database } from "../../core/database";

module.exports = onCall(
  {
    memory: "1GiB",
    region: "asia-northeast1",
  },
  async (req): Promise<OnCallResponse> => {
    const { pushToken } = req.data;

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

      await database.doc(`/users/${req.auth.uid}`).set(
        {
          pushToken,
        },
        { merge: true }
      );

      return {
        result: "OK",
        statusCode: 200,
        data: {
          pushToken,
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
