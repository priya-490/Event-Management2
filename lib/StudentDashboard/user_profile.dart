// // import 'package:flutter/material.dart';

// // class ProfileScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Manage Profile")),
// //       body: Center(child: Text("Profile Screen - Coming Soon")),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import '../Theme/theme_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ManageProfileScreen extends StatefulWidget {
//   @override
//   _ManageProfileScreenState createState() => _ManageProfileScreenState();
// }

// class _ManageProfileScreenState extends State<ManageProfileScreen> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final List<String> _interests = ["Tech", "Music", "Sports", "Arts"];
//   String? _selectedInterest;
//   final user = FirebaseAuth.instance.currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = user?.displayName ?? "";
//     _phoneController.text = user?.phoneNumber ?? "";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Manage Profile"),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF6A0DAD),
//         actions: [
//           IconButton(
//             icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
//             onPressed: () {
//               themeProvider.toggleTheme();
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Profile Picture
//             Center(
//               child: Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: user?.photoURL != null
//                         ? NetworkImage(user!.photoURL!)
//                         : const AssetImage('assets/profile_pic.png') as ImageProvider,
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: IconButton(
//                       icon: const Icon(Icons.camera_alt, color: Colors.purple),
//                       onPressed: () {
//                         // TODO: Implement profile picture upload
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Name
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: "Full Name"),
//             ),
//             const SizedBox(height: 10),

//             // Email (non-editable)
//             TextField(
//               decoration: InputDecoration(
//                 labelText: "Email",
//                 hintText: user?.email ?? "",
//                 enabled: false,
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Phone Number
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(labelText: "Phone Number"),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 10),

//             // Interests Dropdown
//             DropdownButtonFormField<String>(
//               value: _selectedInterest,
//               hint: const Text("Select Interest"),
//               items: _interests.map((String interest) {
//                 return DropdownMenuItem<String>(
//                   value: interest,
//                   child: Text(interest),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedInterest = newValue;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),

//             // Action Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     final user = FirebaseAuth.instance.currentUser;
//                     if (user == null) {
//                       print("User is null. Cannot update profile.");
//                       return;
//                     }
//                     FirebaseFirestore.instance.collection('users').doc(user?.uid ?? "default_uid").update({
//                       'fullName': _nameController.text,
//                       'phoneNumber': _phoneController.text,});
//                     // TODO: Implement save profile changes
//                   },
//                   child: const Text("Save Changes"),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   onPressed: () {
//                     // TODO: Implement delete account
//                   },
//                   child: const Text("Delete Account"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProfileScreen extends StatefulWidget {
  @override
  _ManageProfileScreenState createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<String> _interests = ["Tech", "Music", "Sports", "Arts"];
  String? _selectedInterest;
  bool _isLoading = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['fullName'] ?? "";
          _phoneController.text = userDoc['phoneNumber'] ?? "";
          _selectedInterest = userDoc['interest'] ?? null;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> _saveChanges() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'fullName': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'interest': _selectedInterest ?? "None",
      });

      await user!.updateDisplayName(_nameController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: ${e.toString()}")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _deleteAccount() {
    // TODO: Implement delete account logic with FirebaseAuth
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Delete account feature coming soon!")),
    );
  }

  void _uploadProfilePicture() {
    // TODO: Implement profile picture upload
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile picture upload coming soon!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Profile"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A0DAD),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : const AssetImage('assets/profile_pic.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.purple),
                      onPressed: _uploadProfilePicture,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 10),

            // Email (non-editable)
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                hintText: user?.email ?? "Not Available",
                enabled: false,
              ),
            ),
            const SizedBox(height: 10),

            // Phone Number
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),

            // Interests Dropdown
            DropdownButtonFormField<String>(
              value: _selectedInterest,
              hint: const Text("Select Interest"),
              items: _interests.map((String interest) {
                return DropdownMenuItem<String>(
                  value: interest,
                  child: Text(interest),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedInterest = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveChanges,
                        child: const Text("Save Changes"),
                      ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _deleteAccount,
                  child: const Text("Delete Account"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
