import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../sign_in_screen.dart'; // Replace with your actual sign-in screen file

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sign-out function
  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Get logged-in user info

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, ${user?.email ?? 'User'}!", // Show user email
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => signOut(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
