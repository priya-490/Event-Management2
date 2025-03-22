
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen.dart';
import 'admin_dashboard.dart'; // Import admin dashboard

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  // Function to check user role and navigate accordingly
  Future<void> checkUserRole(User user) async {
    try {
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('AdminEmail')
          .where('Admin_Email', isEqualTo: user.email)
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        // Navigate to Admin Dashboard if user is an admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        // Navigate to Student Dashboard (HomeScreen) if not an admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking user role: $e')),
      );
    }
  }

  // Sign-in function with authentication
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
      if (user != null && user.emailVerified) {
        await checkUserRole(user);
      } else if (user != null && !user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email before signing in'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
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
              Image.asset(
                "assets/logo.jpg",
                height: 100,
                fit: BoxFit.contain,
              ),
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
                      validator:
                          (value) => value!.isEmpty ? 'Enter your email' : null,
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
                      validator:
                          (value) => value!.isEmpty ? 'Enter your password' : null,
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
                          text: "Don’t have an account? ",
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(color: Color(0xFFbc6c25)),
                            ),
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
