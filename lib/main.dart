import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // ✅ Import Provider for theme management
import 'firebase_options.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'sign_in_sign_up.dart';
import 'landing_page.dart';
import 'forgot_password.dart';
import 'email_sent.dart';
import 'get_notification.dart';
import 'home_screen.dart';
import 'theme_provider.dart'; // ✅ Import ThemeProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // ✅ Provide theme state
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Event Management',
          theme: ThemeData.light(), // ✅ Light theme
          darkTheme: ThemeData.dark(), // ✅ Dark theme
          themeMode:
              themeProvider.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light, // ✅ Apply dynamic theme
          debugShowCheckedModeBanner: false,
          home: AuthWrapper(), // ✅ Handles user authentication state
          routes: {
            '/landing_page': (context) => const OnboardingScreen(),
            '/sign_in_sign_up': (context) => const SigninOrSignupScreen(),
            '/sign_in_screen': (context) => SignInScreen(),
            '/sign_up_screen': (context) => SignUpScreen(),
            '/forgot_password': (context) => ForgotPasswordScreen(),
            '/email_sent': (context) => ResetEmailSentScreen(),
            '/get_notification': (context) => NotificationOnboardingScreen(),
            '/home_screen': (context) => HomeScreen(), // ✅ Fixed route name
          },
        );
      },
    );
  }
}

// 🔹 This widget decides whether to show SignInScreen or HomeScreen
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return HomeScreen(); // ✅ User is signed in, go to HomeScreen
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }

        return const OnboardingScreen(); // ✅ User is not signed in, go to Sign-In/Sign-Up page
      },
    );
  }
}
