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

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "generateMedicinesFromImage"
) {
  exports.generateMedicinesFromImage = require("./functions/generateMedicinesFromImage/function");
}
