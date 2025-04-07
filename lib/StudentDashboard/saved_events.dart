import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SavedEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Events"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A0DAD),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text("Please log in to view saved events."))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('saved_events')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No saved events yet."));
                }

                final events = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final eventData = event.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Color(0xFF6A0DAD)),
                        title: Text(eventData['title'] ?? "Event Title"),
                        subtitle: Text(eventData['date'] ?? "Date Not Available"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('saved_events')
                                .doc(event.id)
                                .delete();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
