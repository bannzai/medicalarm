import admin = require("firebase-admin");

console.log("THIS IS NOT TEST ENVIRONMENT");
admin.initializeApp();

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "startPromotion"
) {
  exports.startPromotion = require("./functions/startPromotion/function");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "rewardPremiumTrial"
) {
  exports.rewardPremiumTrial = require("./functions/rewardPremiumTrial/function");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "startLiveActivity"
) {
  exports.startLiveActivity = require("./functions/startLiveActivity/function");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "updateLiveActivityTask"
) {
  exports.updateLiveActivityTask = require("./functions/startLiveActivity/tasks/updateLiveActivityTask");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "endLiveActivityTask"
) {
  exports.endLiveActivityTask = require("./functions/startLiveActivity/tasks/endLiveActivityTask");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "upsertLiveActivityPushToStartToken"
) {
  exports.upsertLiveActivityPushToStartToken = require("./functions/upsertLiveActivityPushToStartToken/function");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "upsertLiveActivityPushToken"
) {
  exports.upsertLiveActivityPushToken = require("./functions/upsertLiveActivityPushToken/function");
}

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "getFocusConnectApp"
) {
  exports.getFocusConnectApp = require("./functions/getFocusConnectApp/function");
}
