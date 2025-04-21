// main.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FirebaseOptions/firebase_options.dart';
import 'Authentication/sign_in_screen.dart';
import 'Authentication/sign_up_screen.dart';
import 'Authentication/sign_in_sign_up.dart';
import 'LandingPage/landing_page.dart';
import 'Authentication/forgot_password.dart';
import 'Authentication/email_sent.dart';
import 'services/get_notification.dart';
import 'StudentDashboard/home_screen.dart';
import 'Theme/theme_provider.dart';
import 'AdminDashboard/cur_admin_dashboard.dart';
// import 'Student_Clubs_Dashboard/event_details.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await _initializeNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );

  FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
}


Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    _handleNotificationTap(initialMessage);
  }

  FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  FirebaseMessaging.onMessage.listen(_showForegroundNotification);

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _storeFCMToken(user);
    }
  });
}

void _handleNotificationTap(RemoteMessage message) {
  navigatorKey.currentState?.pushNamed(
    message.data['screen'],
    arguments: {'eventId': message.data['eventId']},
  );
}

Future<void> _showForegroundNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails();

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iosPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: jsonEncode(message.data),
  );
}

Future<void> _storeFCMToken(User user) async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token == null) return;

  // Determine role to update token in the correct collection
  final adminDoc = await FirebaseFirestore.instance
      .collection('AdminEmail')
      .where('Admin_Email', isEqualTo: user.email)
      .get();

  if (adminDoc.docs.isNotEmpty) {
    await FirebaseFirestore.instance
        .collection('AdminEmail')
        .doc(adminDoc.docs.first.id)
        .update({'fcmToken': token});
  } else {
    final clubDoc = await FirebaseFirestore.instance
        .collection('approved_clubs')
        .where('Club Email', isEqualTo: user.email)
        .get();

    if (clubDoc.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('approved_clubs')
          .doc(clubDoc.docs.first.id)
          .update({'fcmToken': token});
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'fcmToken': token});
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Event Management',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: AuthWrapper(),
          routes: {
            '/landing_page': (context) => const OnboardingScreen(),
            '/sign_in_sign_up': (context) => const SigninOrSignupScreen(),
            '/sign_in_screen': (context) => SignInScreen(),
            '/sign_up_screen': (context) => SignUpScreen(),
            '/forgot_password': (context) => ForgotPasswordScreen(),
            '/email_sent': (context) => ResetEmailSentScreen(),
            '/get_notification': (context) => NotificationOnboardingScreen(),
            'home_screen': (context) => HomeScreen(),
            '/cur_admin_dashboard': (context) => AdminDashboard(),
            // '/event_detail': (context) {
              // final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              // return EventDetailsPage();
            // },
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _storeFCMToken(snapshot.data!);
          });

          return FutureBuilder<String>(
            future: _checkUserRole(snapshot.data!),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return roleSnapshot.data == 'admin'
                  ? AdminDashboard()
                  : HomeScreen();
            },
          );
        }
        return const OnboardingScreen();
      },
    );
  }

  Future<String> _checkUserRole(User user) async {
    final adminDoc = await FirebaseFirestore.instance
        .collection('AdminEmail')
        .where('Admin_Email', isEqualTo: user.email)
        .get();
    return adminDoc.docs.isNotEmpty ? 'admin' : 'user';
  }
}
