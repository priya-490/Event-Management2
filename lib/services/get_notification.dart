import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_services.dart';

class NotificationOnboardingScreen extends StatefulWidget {
  const NotificationOnboardingScreen({super.key});

  @override
  State<NotificationOnboardingScreen> createState() =>
      _NotificationOnboardingScreenState();
}

class _NotificationOnboardingScreenState
    extends State<NotificationOnboardingScreen> {
  bool isNotificationEnabled = false;
  String role = '';
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserRoleAndInitFCM();
  }

  Future<void> fetchUserRoleAndInitFCM() async {
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;

    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final adminDoc = await FirebaseFirestore.instance.collection('AdminEmail').doc(userId).get();
      final clubDoc = await FirebaseFirestore.instance.collection('approved_clubs').doc(userId).get();

      if (userDoc.exists) {
        role = 'student';
      } else if (adminDoc.exists) {
        role = 'admin';
      } else if (clubDoc.exists) {
        role = 'club';
      } else {
        print("User role not found");
        return;
      }

      // Optionally auto-enable notifications here if you want:
      // await NotificationService().initializeFCM(userId!, role);
    }
  }

  Widget imageWidget(String path) {
    if (path.endsWith(".svg")) {
      return SvgPicture.asset(
        path,
        width: 250,
        height: 250,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => const CircularProgressIndicator(),
      );
    } else {
      return Image.asset(
        path,
        width: 250,
        height: 250,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 100, color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFdda15e),
                    Color(0xFFbc6c25),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/sign_in_sign_up');
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          imageWidget("assets/notification1.svg"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Notify any updates in events",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Get notified for various events occurring in campus",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.notifications, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              "Enable Notifications",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: isNotificationEnabled,
                          activeColor: const Color(0xFFc1121f),
                          onChanged: (value) async {
                            setState(() {
                              isNotificationEnabled = value;
                            });

                            if (userId == null || role.isEmpty) return;

                            if (value) {
                              await NotificationService().initializeFCM(userId!, role);
                            } else {
                              await NotificationService().disableFCM(userId!, role);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_in_sign_up');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFc1121f),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Next", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
