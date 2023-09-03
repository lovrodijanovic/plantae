const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationOnTimerZero = functions.database
  .ref("/plants/{plantId}")
  .onUpdate((change, context) => {
    const newValue = change.after.val();
    const previousValue = change.before.val();

    if (newValue.countdown === 0 && previousValue.countdown !== 0) {
      const payload = {
        notification: {
          title: "Plant Timer Expired",
          body: `It's time to water ${newValue.name}!`,
        },
      };

      return admin.messaging().sendToTopic("plant", payload);
    } else {
      return null;
    }
  });
