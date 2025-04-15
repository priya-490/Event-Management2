import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'event_box.dart';
import '../LandingPage/landing_page.dart';
import '../StudentDashboard/user_dashboard.dart';
import '../StudentDashboard/event_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Default to Events Page (Middle Tab)

  final List<Widget> _pages = [
    HomePage(), // Left Tab
    EventsPage(), // Middle Tab
    UserDashboardScreen(), // Right Tab (Dashboard with Profile & Support)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF6A0DAD), // Professional Purple Shade
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.deepPurple[50],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}

// class EventsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Events"),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF6A0DAD),
//       ),
//       body: const Center(
//         child: Text("Welcome to the Events Page"),
//       ),
//     );
//   }
// }

class HomePage extends StatelessWidget {
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













// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // // import 'theme_provider.dart';
// // // import 'event_box.dart';
// // // import 'landing_page.dart';

// // // class HomeScreen extends StatelessWidget {
// // //   const HomeScreen({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final themeProvider = Provider.of<ThemeProvider>(context);

// // //     final List<Map<String, String>> events = [
// // //       {
// // //         "title": "Tech Conference 2025",
// // //         "date": "March 15, 2025",
// // //         "attendees": "500+",
// // //         "image": "assets/b.jpeg",
// // //         "location": "New York",
// // //         "description": "A gathering of top tech minds to discuss the future.",
// // //         "category": "Technology",
// // //       },
// // //       {
// // //         "title": "Music Fest 2025",
// // //         "date": "April 10, 2025",
// // //         "attendees": "1000+",
// // //         "image": "assets/c.jpg",
// // //         "location": "Los Angeles",
// // //         "description": "Enjoy a night filled with music and entertainment.",
// // //         "category": "Entertainment",
// // //       },
// // //     ];

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("Events"),
// // //         centerTitle: true,
// // //         backgroundColor:const Color(0XFFbc6c25),
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
// // //             onPressed: () {
// // //               themeProvider.toggleTheme();
// // //             },
// // //           ),

// // //           //sign out button 
// // //           IconButton(
// // //             onPressed: () async {
// // //               await FirebaseAuth.instance.signOut();
// // //               if (context.mounted) {
// // //                 // navigate to landing page after sign out 
// // //                 Navigator.pushAndRemoveUntil( 
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => const OnboardingScreen()),
// // //                   (route) => false,
// // //                  );
// // //               }
// // //             } ,
// // //            tooltip: "Sign Out",

// // //             ),
// // //         ],
// // //       ),
      
// // //       body: ListView.builder(
// // //         padding: const EdgeInsets.all(10),
// // //         itemCount: events.length,
// // //         itemBuilder: (context, index) {
// // //           final event = events[index];
// // //           return Padding(
// // //             padding: const EdgeInsets.only(bottom: 10),
// // //             child: EventBox(
// // //               title: event["title"]!,
// // //               date: event["date"]!,
// // //               attendees: event["attendees"]!,
// // //               image: event["image"]!,
// // //               location: event["location"]!,
// // //               description: event["description"]!,
// // //               category: event["category"]!,
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }


// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:provider/provider.dart';
// // import '../Theme/theme_provider.dart';
// // import 'event_box.dart';
// // import '../LandingPage/landing_page.dart'; // Import the Landing Page for redirection
// // import '../StudentDashboard/user_dashboard.dart'; // 🔹 Updated: Import User Dashboard
// // import 'event_screen.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   _HomeScreenState createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   int _selectedIndex = 0; // 🔹 Updated: Track the selected tab

// //   final List<Widget> _pages = [
// //     EventsScreen(), // 🔹 Updated: Separate Event Page
// //     UserDashboardScreen(),
    
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// // // class HomeScreen extends StatelessWidget {
// // //   const HomeScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final themeProvider = Provider.of<ThemeProvider>(context);

// //     final List<Map<String, String>> events = [
// //       {
// //         "title": "Tech Conference 2025",
// //         "date": "March 15, 2025",
// //         "attendees": "500+",
// //         "image": "assets/b.jpeg",
// //         "location": "New York",
// //         "description": "A gathering of top tech minds to discuss the future.",
// //         "category": "Technology",
// //       },
// //       {
// //         "title": "Music Fest 2025",
// //         "date": "April 10, 2025",
// //         "attendees": "1000+",
// //         "image": "assets/c.jpg",
// //         "location": "Los Angeles",
// //         "description": "Enjoy a night filled with music and entertainment.",
// //         "category": "Entertainment",
// //       },
// //     ];

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Events"),
// //         centerTitle: true,
// //         backgroundColor: const Color(0XFFbc6c25),
// //         actions: [
// //           // 🔹 Toggle Theme Button
// //           IconButton(
// //             icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
// //             onPressed: () {
// //               themeProvider.toggleTheme();
// //             },
// //           ) ,
          
// //           // 🔹 Sign Out Button
// //           IconButton(
// //             icon: const Icon(Icons.logout),
// //             onPressed: () async {
// //               await FirebaseAuth.instance.signOut();
// //               if (context.mounted) {
// //                 // Navigate to Landing Page after Sign Out
// //                 Navigator.pushAndRemoveUntil(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const OnboardingScreen()),
// //                   (route) => false,
// //                 );
// //               }
// //             },
// //             tooltip: "Sign Out",
// //           ),
// //         ],
// //       ),
      
// //       body: ListView.builder(
// //         padding: const EdgeInsets.all(10),
// //         itemCount: events.length,
// //         itemBuilder: (context, index) {
// //           final event = events[index];
// //           return Padding(
// //             padding: const EdgeInsets.only(bottom: 10),
// //             child: EventBox(
// //               title: event["title"]!,
// //               date: event["date"]!,
// //               attendees: event["attendees"]!,
// //               image: event["image"]!,
// //               location: event["location"]!,
// //               description: event["description"]!,
// //               category: event["category"]!,
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import '../Theme/theme_provider.dart';
// import 'event_box.dart';
// import '../LandingPage/landing_page.dart';

// // 🔹 HomeScreen with Bottom Navigation Bar
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0; // 🔹 Track the selected tab

//   // 🔹 List of pages
//   final List<Widget> _pages = [
//     EventsPage(),
//     DashboardPage(),
//     ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.orange, // 🔹 Highlight selected tab
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event),
//             label: 'Events',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// // 🔹 Events Page
// class EventsPage extends StatelessWidget {
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
//         backgroundColor: const Color(0XFFbc6c25),
//         actions: [
//           IconButton(
//             icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
//             onPressed: () {
//               themeProvider.toggleTheme();
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               if (context.mounted) {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const OnboardingScreen()),
//                   (route) => false,
//                 );
//               }
//             },
//             tooltip: "Sign Out",
//           ),
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

// // 🔹 Profile Page
// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Profile")),
//       body: const Center(
//         child: Text("User Profile Information"),
//       ),
//     );
//   }
// }

// // 🔹 Dashboard Page (Placeholder for now)
// class DashboardPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard")),
//       body: const Center(
//         child: Text("Dashboard Content"),
//       ),
//     );
//   }
// }

