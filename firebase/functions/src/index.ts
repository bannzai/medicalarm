import admin = require("firebase-admin");

console.log("THIS IS NOT TEST ENVIRONMENT");
admin.initializeApp();

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "startPromotion"
) {
  exports.startPromotion = require("./functions/startPromotion/function");
}

if (!process.env.FUNCTION_NAME || process.env.FUNCTION_NAME === "createGroup") {
  exports.createGroup = require("./functions/createGroup/function");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "createGroupInvitation"
) {
  exports.createGroupInvitation = require("./functions/createGroupInvitation/function");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "acceptGroupInvitation"
) {
  exports.acceptGroupInvitation = require("./functions/acceptGroupInvitation/function");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "removeGroupMember"
) {
  exports.removeGroupMember = require("./functions/removeGroupMember/function");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "sendMedicationRecordNotification"
) {
  exports.sendMedicationRecordNotification = require("./functions/sendMedicationRecordNotification/function");
}

// firebase-crashlytics-alert-setup begin (bannzai/castle の skill が管理する区間。手で編集しない)
// eslint の no-var-requires は require(...).x の形を弾くため、TypeScript の import = require 構文で読み込む
import crashlyticsAlert = require("./lib/crashlyticsAlert");
exports.crashlyticsNewFatalIssueToSlack = crashlyticsAlert.crashlyticsNewFatalIssueToSlack;
exports.crashlyticsRegressionToSlack = crashlyticsAlert.crashlyticsRegressionToSlack;
exports.crashlyticsVelocityToSlack = crashlyticsAlert.crashlyticsVelocityToSlack;
// firebase-crashlytics-alert-setup end
