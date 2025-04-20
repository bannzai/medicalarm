import * as jwt from "jsonwebtoken";
import { apnsKeyID, apnsTeamID, iOSAppBundleID } from "../core/env";
import { SecretParam } from "firebase-functions/lib/params/types";
import * as http2 from "http2";

function host(): string {
  // return "api.push.apple.com";
  return "api.sandbox.push.apple.com";
}

function getClient(): http2.ClientHttp2Session {
  const client = http2.connect(`https://${host()}`, {
    // TLS 1.2以上を強制
    minVersion: "TLSv1.2",
    maxVersion: "TLSv1.3",
  });
  return client;
}

// APNsペイロードの型定義を更新
// ref: https://developer.apple.com/documentation/activitykit/starting-and-updating-live-activities-with-activitykit-push-notifications#Mark-a-Live-Activity-as-outdated-by-setting-a-stale-date
// ref: https://apnspush.com/how-to-start-and-update-live-activities-with-broadcast-push-notifications
// timestampは関数内部で定義するので排除。aps: キーも実質トップレベルなので排除。関数内部で定義する
export type APNsLiveActivityPayload =
  | {
      event: "start";
      //  Dynamic data of your live activity content.
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      "content-state": any;
      // attributes: Static data of your live activity content.
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      attributes: any;
      "attributes-type": string;
    }
  | {
      event: "update";
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      "content-state": any;
      // stale-date(optional): UNIX timestamp in seconds represents the time when the system will consider the Live Activity to be stale.
      "stale-date"?: number;
    }
  | {
      event: "end";
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      "content-state": any;
      // The UNIX timestamp when the system will remove the Live Activity from the Lock Screen after it ends.
      // By default, It's four hours after the live activity ends.
      // If the value is in the past, the Live Activity will immediately dismiss after it ends.
      "dismissal-date"?: number;
    };

export async function sendPushNotification(args: {
  apnsAuthKeyBase64: SecretParam;
  pushToken: string;
  payload: APNsLiveActivityPayload & {
    event: "update" | "end";
  };
}): Promise<void> {
  const { apnsAuthKeyBase64, pushToken, payload: _payload } = args;
  const payload = {
    aps: {
      ..._payload,
      timestamp: getUnixTimestamp(),
    },
  };

  const apnsAuthToken = generateApnsAuthToken(apnsAuthKeyBase64);
  const client = getClient();
  return new Promise((resolve, reject) => {
    const request = client.request({
      ":method": "POST",
      ":path": `/3/device/${pushToken}`,
      authorization: `bearer ${apnsAuthToken}`,
      "apns-topic": `${iOSAppBundleID.value()}.push-type.liveactivity`,
      "apns-push-type": "liveactivity",
      "apns-priority": 10,
      "Content-Type": "application/json",
    });

    request.setEncoding("utf8");

    let responseData = "";
    request.on("data", (chunk) => {
      responseData += chunk;
    });
    request.on("end", () => {
      if (responseData.length > 0) {
        try {
          const response = JSON.parse(responseData);
          if (response.reason) {
            reject(new Error(`APNs Error: ${response.reason}`));
          }
        } catch (error) {
          reject(error);
        }
      }
      resolve();
    });
    request.on("error", (error) => {
      reject(error);
    });

    // Send the payload
    request.write(JSON.stringify(payload));
    request.end();
  });
}

export async function startLiveActivity(args: {
  apnsAuthKeyBase64: SecretParam;
  pushToStartToken: string;
  payload: APNsLiveActivityPayload & { event: "start" };
}): Promise<void> {
  const { apnsAuthKeyBase64, pushToStartToken, payload: _payload } = args;
  const payload = {
    aps: {
      ..._payload,
      timestamp: getUnixTimestamp(),
    },
  };

  const apnsAuthToken = generateApnsAuthToken(apnsAuthKeyBase64);
  const client = getClient();

  return new Promise((resolve, reject) => {
    const request = client.request({
      ":method": "POST",
      ":path": `/3/device/${pushToStartToken}`,
      authorization: `bearer ${apnsAuthToken}`,
      "apns-topic": `${iOSAppBundleID.value()}.push-type.liveactivity`,
      "apns-push-type": "liveactivity",
      "apns-priority": 10,
      "Content-Type": "application/json",
    });

    request.setEncoding("utf8");

    let responseData = "";
    request.on("data", (chunk) => {
      responseData += chunk;
    });
    request.on("end", () => {
      if (responseData.length > 0) {
        try {
          const response = JSON.parse(responseData);
          if (response.reason) {
            reject(new Error(`APNs Error: ${response.reason}`));
          }
        } catch (error) {
          reject(error);
        }
      }
      resolve();
    });
    request.on("error", (error) => {
      reject(error);
    });

    // Send the payload
    request.write(JSON.stringify(payload));
    request.end();
  });
}

function getUnixTimestamp(): number {
  return Math.floor(Date.now() / 1000);
}

function generateApnsAuthToken(apnsAuthKeyBase64: SecretParam): string {
  const privateKey = Buffer.from(apnsAuthKeyBase64.value(), "base64").toString(
    "utf-8"
  );
  const teamId = apnsTeamID.value();
  const keyId = apnsKeyID.value();

  const token = jwt.sign({}, privateKey, {
    algorithm: "ES256",
    expiresIn: "1h",
    issuer: teamId,
    header: {
      alg: "ES256",
      kid: keyId,
    },
  });

  return token;
}
