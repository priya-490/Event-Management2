import 'package:flutter/material.dart';
import 'sign_in_screen.dart'; // Import your SignInScreen file
import 'sign_up_screen.dart'; // Import your SignInScreen file
import 'sign_in_sign_up.dart';
import 'landing_page.dart';
import 'forgot_password.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'email_sent.dart';
import 'get_notification.dart';

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
      initialRoute: '/landing_page', // set initial route
      debugShowCheckedModeBanner: false, // Remove debug banner
      routes :  {
        '/landing_page' : (context) => const OnboardingScreen(),
        '/sign_in_sign_up' : (context) => const SigninOrSignupScreen(),
        '/sign_in_screen' : (context) => SignInScreen(),
        '/sign_up_screen' : (context) => SignUpScreen(),
        '/forgot_password' : (context) =>  ForgotPasswordScreen(),
        '/email_sent' : (context) =>  ResetEmailSentScreen(), 
        '/get_notification' : (context) => NotificationOnboardingScreen(),
      },
    );
  }
}
