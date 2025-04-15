import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


// main method to enable notifications
  Future<void> initializeFCM(String userId, String role) async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        // await FirebaseFirestore.instance.collection('users').doc(userId).update({'fcmToken' : token,
        // });
        final docRef = _getUserDocRef(userId, role);
        if (docRef != null) {
          await docRef.update({'fcmToken': token});
        }
      }
    }
  }

// main method to diable notifications
  Future<void> disableFCM(String userId, String role) async {
    await FirebaseMessaging.instance.deleteToken();
    // await FirebaseFirestore.instance.collection('users').doc(userId).update({
      // 'fcmToken': FieldValue.delete(),
    // });
    final docRef = _getUserDocRef(userId, role);
    if(docRef != null){
      await docRef.update({'fcmToken' : FieldValue.delete()});
    }
  }

// utility to reoslve document reference based on role
DocumentReference? _getUserDocRef(String userId, String role){
  switch (role){
    case 'student':
    return FirebaseFirestore.instance.collection('users').doc(userId);
     case 'admin':
        return FirebaseFirestore.instance.collection('AdminEmail').doc(userId);
      case 'club':
        return FirebaseFirestore.instance.collection('approved_clubs').doc(userId);
         default:
        print('Invalid role: $role');
        return null;

  }
}
 
  // for foreground notifications
  void setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Foreground notification : ${message.notification!.title}');
      }
    });
  }
}
