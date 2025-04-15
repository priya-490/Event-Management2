// this page is handling the home page of user dashboard created by pankaj, and this page is fetching the info sent from the home page and printing the info 

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Firestore Import
import '../Theme/theme_provider.dart';
import '../LandingPage/landing_page.dart';
import 'event_box.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A0DAD),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                  (route) => false,
                );
              }
            },
            tooltip: "Sign Out",
          ),
        ],
      ),

      // 🔹 Fetch Events from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 🔄 Loading state
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No events available.")); // 🚫 No events found
          }

          final events = snapshot.data!.docs; // 📜 Firestore data

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final eventData = events[index].data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EventBox(
                  title: eventData["Event Name"] ?? "No Title",
                  date: eventData["Start Date"] ?? "No Date",
                  attendees: eventData["ParticipantsId"] is List
                      ? (eventData["ParticipantsId"] as List).length
                      : 0, // 🔹 Convert list count to int
                  image: "assets/default.jpg", // Change this if you have an image field
                  venue: eventData["Event Venue"] ?? "Unknown Location",
                  description: eventData["Event Description"] ?? "No Description",
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
