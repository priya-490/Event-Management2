// const {onDocumentCreated} = require("firebase-functions/v2/firestore");
// // const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// admin.initializeApp();

// exports.notifyAdminOnEventCreate = onDocumentCreated("events/{eventId}", async (event) => {
//   const snap = event.data;
//   if (!snap) return;

//   const eventData = snap.data();
//   const eventName = eventData["Event Name"] || "New Event";

//   // Fetch all admin FCM tokens
//   const adminSnapshot = await admin.firestore().collection("AdminEmail").get();
//   const tokens = [];

//   adminSnapshot.forEach((doc) => {
//     const token = doc.data().fcmToken;
//     if (token) tokens.push(token);
//   });

//   if (tokens.length > 0) {
//     const payload = {
//       notification: {
//         title: "New Event Created",
//         body: `Event "${eventName}" has been added by a club.`,
//       },
//     };
//     await admin.messaging().sendToDevice(tokens, payload);
//   }
// });


const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Send notification to admin when new event is created
exports.notifyAdminNewEvent = functions.firestore
    .document('events/{eventId}')
    .onCreate(async (snapshot, context) => {
        const eventData = snapshot.data();
        
        // Get admin FCM token from AdminEmail collection
        const adminDoc = await admin.firestore().collection('AdminEmail').doc('60QdryRKQumucPx0GUED').get();
        const adminToken = adminDoc.data().fcmToken;
        
        if (!adminToken) return null;
        
        // Notification payload
        const payload = {
            notification: {
                title: 'New Event Awaiting Approval',
                body: `${eventData.clubName} has created a new event: ${eventData.title}`,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            },
            data: {
                type: 'new_event',
                eventId: context.params.eventId,
                screen: '/pending_events'
            }
        };
        
        // Send notification
        return admin.messaging().sendToDevice(adminToken, payload);
    });

// Send notification when event status changes
exports.notifyEventStatusChange = functions.firestore
    .document('events/{eventId}')
    .onUpdate(async (change, context) => {
        const beforeData = change.before.data();
        const afterData = change.after.data();
        
        // Only trigger if status changed
        if (beforeData.status === afterData.status) return null;
        
        // Get club rep's FCM token from Clubs collection
        const clubRepDoc = await admin.firestore().collection('approved_clubs').doc(afterData.clubId).get();
        const clubRepToken = clubRepDoc.data().fcmToken;
        
        // Notification to Club Rep
        if (clubRepToken) {
            const repPayload = {
                notification: {
                    title: 'Event Status Updated',
                    body: `Your event "${afterData.title}" has been ${afterData.status}`,
                    click_action: 'FLUTTER_NOTIFICATION_CLICK'
                },
                data: {
                    type: 'event_status',
                    eventId: context.params.eventId,
                    screen: '/club_events'
                }
            };
            await admin.messaging().sendToDevice(clubRepToken, repPayload);
        }
        
        // If approved, notify all students
        if (afterData.status === 'approved') {
            // Get all student tokens (you might want to paginate this for large user bases)
            const usersSnapshot = await admin.firestore().collection('users').get();
            const tokens = [];
            
            usersSnapshot.forEach(doc => {
                if (doc.data().fcmToken) {
                    tokens.push(doc.data().fcmToken);
                }
            });
            
            if (tokens.length > 0) {
                const studentPayload = {
                    notification: {
                        title: 'New Event Available',
                        body: `New event: ${afterData.title} by ${afterData.clubName}`,
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    },
                    data: {
                        type: 'new_approved_event',
                        eventId: context.params.eventId,
                        screen: '/events'
                    }
                };
                return admin.messaging().sendToDevice(tokens, studentPayload);
            }
        }
        
        return null;
    });