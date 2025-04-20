import functions = require("firebase-functions");
import { onCall } from "firebase-functions/v2/https";
import { requestContext } from "../../core/context";
import { database } from "../../core/database";
import { OnCallResponse } from "../../core/response";

module.exports = onCall(
  {
    memory: "512MiB",
    region: "asia-northeast1",
  },
  async (req): Promise<OnCallResponse> => {
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
      functionName: "#getFocusConnectApp",
    });
    try {
      const { id } = req.data;
      if (id == null) {
        functions.logger.log("id is not found", ctx.logJsonPayload());
        throw new Error("id is not found");
      }

      const focusConnectAppDocumentRef = database.doc(
        `/focusConnectApps/${id}`
      );
      const focusConnectAppDocument = await focusConnectAppDocumentRef.get();
      const focusConnectApp = focusConnectAppDocument.data();

      return {
        result: "OK",
        statusCode: 200,
        data: {
          ...focusConnectApp,
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
