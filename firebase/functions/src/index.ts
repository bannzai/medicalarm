import admin = require("firebase-admin");

console.log("THIS IS NOT TEST ENVIRONMENT");
admin.initializeApp();

if (
  !process.env.FUNCTION_NAME ||
  process.env.FUNCTION_NAME === "startPromotion"
) {
  exports.startPromotion = require("./functions/startPromotion/function");
}
