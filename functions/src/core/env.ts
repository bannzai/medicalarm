import { defineString } from "firebase-functions/params";

export const env = defineString("APP_ENV").value();
