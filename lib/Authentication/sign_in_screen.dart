import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Add this import


// import '../StudentDashboard/main_screen.dart';

// import '../StudentDashboard/main_screen.dart';
import '../StudentDashboard/bottom_nav_screen.dart';

import '../AdminDashboard/cur_admin_dashboard.dart';
import '../Student_Clubs_Dashboard/club_dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Add this

  bool isLoading = false;

  // Function to store FCM token based on user type
  Future<void> _storeFCMToken(String userId, String userType) async {
    String? token = await _firebaseMessaging.getToken();
    if (token == null) return;

    try {
      if (userType == 'admin') {
        await FirebaseFirestore.instance.collection('AdminEmail')
            .doc(userId)
            .update({'fcmToken': token});
      } 
      else if (userType == 'club') {
        await FirebaseFirestore.instance.collection('approved_clubs')
            .doc(userId)
            .update({'fcmToken': token});
      } 
      else {
        await FirebaseFirestore.instance.collection('users')
            .doc(userId)
            .update({'fcmToken': token});
      }
    } catch (e) {
      debugPrint('Error storing FCM token: $e');
    }
  }

  // Updated checkUserRole function with FCM token storage
  Future<void> checkUserRole(User user) async {
    try {
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('AdminEmail')
          .where('Admin_Email', isEqualTo: user.email)
          .get();

      final clubSnapshot = await FirebaseFirestore.instance
          .collection('approved_clubs')
          .where('Club Email', isEqualTo: user.email)
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
                final AdminId = adminSnapshot.docs.first.id;

        await _storeFCMToken(AdminId, 'admin');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      }
      else if (clubSnapshot.docs.isNotEmpty) {
        final clubId = clubSnapshot.docs.first.id;
        await _storeFCMToken(clubId, 'club');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ClubDashboard()),
        );
      }
      else {
        await _storeFCMToken(user.uid, 'student');
        Navigator.pushReplacement(
          context,
          // MaterialPageRoute(builder: (context) => const MainScreen()),
          MaterialPageRoute(builder: (context) => const BottomNavScreen()),

        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking user role: $e')));
    }
  }

  // Sign-in function remains the same
  Future<void> signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
        final clubSnapshot = await FirebaseFirestore.instance
            .collection('approved_clubs')
            .where('Club Email', isEqualTo: user.email)
            .get();

        if (clubSnapshot.docs.isNotEmpty) {
          final clubId = clubSnapshot.docs.first.id;
          await _storeFCMToken(clubId, 'club');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ClubDashboard()),
          );
        } 
        else if (user != null && user.emailVerified) {
          await checkUserRole(user);
        } 
        else if (user != null && !user.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please verify your email before signing in'),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Image.asset("assets/logo.jpg", height: 100, fit: BoxFit.contain),
              const SizedBox(height: 50),
              Text(
                "Sign In",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => 
                          value!.isEmpty ? 'Enter your email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      validator: (value) => 
                          value!.isEmpty ? 'Enter your password' : null,
                    ),
                    const SizedBox(height: 20),

                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: signIn,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFbc6c25),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Sign in"),
                        ),
                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot_password');
                      },
                      child: const Text('Forgot Password?'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_up_screen');
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(color: Color(0xFFbc6c25)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}