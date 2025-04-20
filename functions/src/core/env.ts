import { defineString } from "firebase-functions/params";

export const env = defineString("FOCUS_APP_ENV").value();

export const apnsTeamID = defineString("APNS_AUTH_TEAM_ID");
export const apnsKeyID = defineString("APNS_AUTH_KEY_ID");
export const iOSAppBundleID = defineString("IOS_APP_BUNDLE_ID");
