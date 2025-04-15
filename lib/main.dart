<<<<<<< HEAD
import 'package:event_manage/home_page.dart';
=======
// event category is pending, approved , rejected
// when the admin approves the event, the status of the event will be changes to approved

>>>>>>> ee2c434861c688169b84622b9a04f621d533bb86
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // ✅ Import Provider for theme management
import 'FirebaseOptions/firebase_options.dart';
import 'home_page.dart';


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

import 'Authentication/sign_in_screen.dart';
import 'Authentication/sign_up_screen.dart';
import 'Authentication/sign_in_sign_up.dart';
import 'LandingPage/landing_page.dart';
import 'Authentication/forgot_password.dart';
import 'Authentication/email_sent.dart';
import 'services/get_notification.dart';
import 'StudentDashboard/home_screen.dart';
import 'Theme/theme_provider.dart'; // ✅ Import ThemeProvider
<<<<<<< HEAD
import 'AdminDashboard/admin_dashboard.dart';
import 'StudentDashboard/user_dashboard.dart';

=======
// import 'Student_Clubs_Dashboard/admin_dashboard.dart';
import 'AdminDashboard/cur_admin_dashboard.dart';
>>>>>>> ee2c434861c688169b84622b9a04f621d533bb86

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
<<<<<<< HEAD
            '/home_screen': (context) => HomeScreen(), // ✅ Fixed route name
            '/admin_dashboard': (context) => AdminDashboard(), // ✅ Fixed route name
            '/user_dashboard' : (context) => UserDashboardScreen() ,
            
=======
            'home_screen': (context) => HomeScreen(), // ✅ Fixed route name
            // '/admin_dashboard': (context) => AdminDashboard(), // ✅ Fixed route name
            '/cur_admin_dashboard': (context) => AdminDashboard(), // ✅ Fixed route name

>>>>>>> ee2c434861c688169b84622b9a04f621d533bb86
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
          // return AdminDashboard(); // ✅ User is signed in, go to HomeScreen
          // return AdminDashboard(); // ✅ User is signed in, go to HomeScreen
        return const OnboardingScreen(); // ✅ User is not signed in, go to Sign-In/Sign-Up page

        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }

        return const OnboardingScreen(); // ✅ User is not signed in, go to Sign-In/Sign-Up page
<<<<<<< HEAD

    
=======
          // return AdminDashboard(); // ✅ User is signed in, go to HomeScreen

>>>>>>> ee2c434861c688169b84622b9a04f621d533bb86
      },
    );
  }
}
