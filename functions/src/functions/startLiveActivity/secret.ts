import { defineSecret } from "firebase-functions/params";

export const apnsAuthKeyBase64 = defineSecret("APNS_AUTH_KEY_BASE64");
