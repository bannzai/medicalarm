import axios from "axios";
import { env } from "./env";
import { defineString } from "firebase-functions/params";

// default は Emulator 起動時の関数 discovery が未設定 param の対話プロンプトで停止するのを防ぐため(本番 deploy は .env の実値が優先)。
const errorReportSlackURL = defineString("SLACK_URL_ERROR", { default: "https://example.com/dummy" }).value();
export async function report(
  userID: string,
  functionName: string,
  error: Error | string | unknown
): Promise<void> {
  //  if (isTest()) {
  //    return Promise.resolve();
  //  }
  if (errorReportSlackURL == null || errorReportSlackURL.length === 0) {
    return;
  }
  if (typeof error === "string") {
    await axios.post(
      errorReportSlackURL,
      buildErrorParams(error, userID, functionName)
    );
  } else if (error instanceof Error) {
    await axios.post(
      errorReportSlackURL,
      buildErrorParams(error.message, userID, functionName)
    );
  } else {
    await axios.post(
      errorReportSlackURL,
      buildErrorParams(
        `unknown type error ${JSON.stringify({ error })}`,
        userID,
        functionName
      )
    );
  }
}

// default は Emulator 起動時の関数 discovery が未設定 param の対話プロンプトで停止するのを防ぐため(本番 deploy は .env の実値が優先)。
const notificationSlackURL = defineString("SLACK_URL_NOTIFICATION", { default: "https://example.com/dummy" }).value();
export async function notify(message: string): Promise<void> {
  //  if (isTest()) {
  //    return Promise.resolve();
  //  }
  if (notificationSlackURL == null || notificationSlackURL.length === 0) {
    return;
  }
  await axios.post(notificationSlackURL, buildNotifyParams(message, "#49D538"));
}

function buildErrorParams(
  text: string,
  userID: string,
  functionName: string
): unknown {
  return {
    attachments: [
      {
        pretext: `case error on ${env} for ${userID}, in function ${functionName}`,
        color: "#BF1245",
        text: text,
      },
    ],
  };
}

function buildNotifyParams(message: string, color: string): unknown {
  return {
    attachments: [
      {
        pretext: `notify message from ${env}`,
        color: color,
        text: message,
      },
    ],
  };
}
