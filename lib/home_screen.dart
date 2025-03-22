// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'theme_provider.dart';
// import 'event_box.dart';
// import 'landing_page.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     final List<Map<String, String>> events = [
//       {
//         "title": "Tech Conference 2025",
//         "date": "March 15, 2025",
//         "attendees": "500+",
//         "image": "assets/b.jpeg",
//         "location": "New York",
//         "description": "A gathering of top tech minds to discuss the future.",
//         "category": "Technology",
//       },
//       {
//         "title": "Music Fest 2025",
//         "date": "April 10, 2025",
//         "attendees": "1000+",
//         "image": "assets/c.jpg",
//         "location": "Los Angeles",
//         "description": "Enjoy a night filled with music and entertainment.",
//         "category": "Entertainment",
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Events"),
//         centerTitle: true,
//         backgroundColor:const Color(0XFFbc6c25),
//         actions: [
//           IconButton(
//             icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
//             onPressed: () {
//               themeProvider.toggleTheme();
//             },
//           ),

//           //sign out button 
//           IconButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               if (context.mounted) {
//                 // navigate to landing page after sign out 
//                 Navigator.pushAndRemoveUntil( 
//                   context,
//                   MaterialPageRoute(builder: (context) => const OnboardingScreen()),
//                   (route) => false,
//                  );
//               }
//             } ,
//            tooltip: "Sign Out",

//             ),
//         ],
//       ),
      
//       body: ListView.builder(
//         padding: const EdgeInsets.all(10),
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           final event = events[index];
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: EventBox(
//               title: event["title"]!,
//               date: event["date"]!,
//               attendees: event["attendees"]!,
//               image: event["image"]!,
//               location: event["location"]!,
//               description: event["description"]!,
//               category: event["category"]!,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'event_box.dart';
import 'landing_page.dart'; // Import the Landing Page for redirection

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<Map<String, String>> events = [
      {
        "title": "Tech Conference 2025",
        "date": "March 15, 2025",
        "attendees": "500+",
        "image": "assets/b.jpeg",
        "location": "New York",
        "description": "A gathering of top tech minds to discuss the future.",
        "category": "Technology",
      },
      {
        "title": "Music Fest 2025",
        "date": "April 10, 2025",
        "attendees": "1000+",
        "image": "assets/c.jpg",
        "location": "Los Angeles",
        "description": "Enjoy a night filled with music and entertainment.",
        "category": "Entertainment",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
        backgroundColor: const Color(0XFFbc6c25),
        actions: [
          // 🔹 Toggle Theme Button
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
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
                  MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                  (route) => false,
                );
              }
            },
            tooltip: "Sign Out",
          ),
        ],
      ),
      
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: EventBox(
              title: event["title"]!,
              date: event["date"]!,
              attendees: event["attendees"]!,
              image: event["image"]!,
              location: event["location"]!,
              description: event["description"]!,
              category: event["category"]!,
            ),
          );
        },
      ),
    );
  }
}
