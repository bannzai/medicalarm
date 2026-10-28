import { defineString } from "firebase-functions/params";

// default は Emulator 起動時の関数 discovery が未設定 param の対話プロンプトで停止するのを防ぐため。
// 本番 deploy では .env の実値が優先されるため影響しない。
export const env = defineString("APP_ENV", { default: "development" }).value();
