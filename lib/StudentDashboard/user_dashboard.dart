// import 'package:flutter/material.dart';

// class UserDashboardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("User Dashboard")),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildDashboardTile(context, icon: Icons.person, title: "Manage Profile", route: '/profile'),
//           _buildDashboardTile(context, icon: Icons.bookmark, title: "Saved Events", route: '/saved-events'),
//           _buildDashboardTile(context, icon: Icons.notifications, title: "Notifications", route: '/notifications'),
//           _buildDashboardTile(context, icon: Icons.lock, title: "Change Password", route: '/change-password'),
//           _buildDashboardTile(context, icon: Icons.article, title: "Terms & Conditions", route: '/terms'),
//           _buildDashboardTile(context, icon: Icons.support_agent, title: "Support", route: '/support'),
//           const Divider(thickness: 1, height: 30),
//           _buildDashboardTile(context, icon: Icons.exit_to_app, title: "Logout", route: '/signin', isLogout: true),
//         ],
//       ),
//     );
//   }

//   Widget _buildDashboardTile(BuildContext context, {required IconData icon, required String title, required String route, bool isLogout = false}) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: Icon(icon, color: isLogout ? Colors.red : Colors.purple, size: 28),
//         title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//         onTap: () {
//           if (isLogout) {
//             _logoutUser(context);
//           } else {
//             Navigator.pushNamed(context, route);
//           }
//         },
//       ),
//     );
//   }

//   void _logoutUser(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Logout"),
//         content: const Text("Are you sure you want to log out?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//           TextButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/signin');
//             },
//             child: const Text("Logout", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../LandingPage/landing_page.dart';
import 'user_profile.dart' ;
import 'saved_events.dart' ;
import 'change_password.dart';
import 'terms_conditions.dart';
import 'support.dart';
import 'notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A0DAD), // Professional purple shade
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Section with Real-Time Updates
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show loading state
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Text("No user data found"); // Handle missing document
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

              return Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userData.containsKey('photoURL') && userData['photoURL'] != null
                        ? NetworkImage(userData['photoURL'])
                        : const AssetImage('assets/profile_pic.png') as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['fullName'] ?? "User Name",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),


          // Profile Section
          // Column(
          //   children: [
          //     CircleAvatar(
          //       radius: 50,
          //       backgroundImage: user?.photoURL != null
          //           ? NetworkImage(user!.photoURL!)
          //           : const AssetImage('assets/profile_pic.png') as ImageProvider,
          //     ),
          //     const SizedBox(height: 10),
          //     Text(
          //       user?.displayName ?? "User Name",
          //       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //     ),
          //     const SizedBox(height: 20),
          //   ],
          // ),
          _buildTile(Icons.person, "Manage Profile", () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => ManageProfileScreen()),
            );
            }),
          _buildTile(Icons.bookmark, "Saved Events", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SavedEventsScreen()),
              );
          }),
          _buildTile(Icons.notifications, "Notifications", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
            }),
          _buildTile(Icons.lock, "Change Password", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
          }),
          _buildTile(Icons.article, "Terms & Conditions", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TermsConditionsScreen()));
          }),
          _buildTile(Icons.support, "Support", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SupportScreen()));
          }),
          _buildTile(Icons.logout, "Logout", () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                (route) => false,
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF6A0DAD)),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}