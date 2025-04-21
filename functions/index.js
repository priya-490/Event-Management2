const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.notifyAdminOnEventCreate =
     functions.firestore
         .document("events/{eventId}")
         .onCreate(async (snap, context) => {
           const eventData = snap.data();
           const eventName = eventData["Event Name"] || "New Event";

           const adminSnapshot = await admin.firestore()
               .collection("AdminEmail")
               .get();

           const tokens = [];

           adminSnapshot.forEach((doc) => {
             const token = doc.data().fcmToken;
             if (token) tokens.push(token);
           });

           if (tokens.length > 0) {
             const payload = {
               notification: {
                 title: "New Event Created",
                 body: `Event "${eventName}" has been added ` +
                `by a club.`,
               },
             };
             await admin.messaging().sendToDevice(tokens, payload);
           }
         });
