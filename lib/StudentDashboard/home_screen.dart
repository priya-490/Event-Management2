import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'event_box.dart';
import '../LandingPage/landing_page.dart'; // Import the Landing Page for redirection
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
        backgroundColor: const Color(0XFFbc6c25),
        actions: [
          // 🔹 Toggle Theme Button
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),

          // 🔹 Sign Out Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                // Navigate to Landing Page after Sign Out
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            tooltip: "Sign Out",
          ),
        ],
      ),

      // Fetch Events from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events')
        .where('status' , isEqualTo: 'approved')
        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No events available."));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final eventData = events[index].data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EventBox(
                  title: eventData["Event Name"] ?? "No Title",
                  // date: eventData["Start Date"] ?? "No Date",
                  // date: (eventData['Start Date'] as Timestamp).toDate(), // ✅ Convert here
                  date:
                      eventData['Start Date'] is Timestamp
                          ? (eventData['Start Date'] as Timestamp).toDate()
                          : DateTime.tryParse(
                                eventData['Start Date'].toString(),
                              ) ??
                              DateTime.now(),

                  // attendees: eventData["attendees"] ?? "Unknown",
                  attendees:
                      (eventData["ParticipantsId"] is List)
                          ? (eventData["ParticipantsId"] as List).length
                          : 0,

                  image: eventData["image"] ?? "assets/default.jpg",
                  venue: eventData["Event Venue"] ?? "Unknown Location",
                  description:
                      eventData["Event Description"] ?? "No Description",
                  club: eventData["club"] ?? "General",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
