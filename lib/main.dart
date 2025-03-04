import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'sign_in_sign_up.dart';
import 'landing_page.dart';
import 'forgot_password.dart';
import 'email_sent.dart';
import 'get_notification.dart';
import 'home_screen.dart'; // Import HomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: AuthWrapper(), // ✅ Handles user authentication state
      routes: {
        '/landing_page': (context) => const OnboardingScreen(),
        '/sign_in_sign_up': (context) => const SigninOrSignupScreen(),
        '/sign_in_screen': (context) => SignInScreen(),
        '/sign_up_screen': (context) => SignUpScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
        '/email_sent': (context) => ResetEmailSentScreen(),
        '/get_notification': (context) => NotificationOnboardingScreen(),
        '/home_screen.dart': (context) => HomeScreen(),
      },
    );
  }
}

// 🔹 This widget decides whether to show SignInScreen or HomeScreen
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listens for auth changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading
        }
        if (snapshot.hasData) {
          return HomeScreen(); // ✅ User is signed in, go to HomeScreen
        }
        return const OnboardingScreen(); // ✅ User is not signed in, go to Sign-In/Sign-Up page
      },
    );
  }
}
