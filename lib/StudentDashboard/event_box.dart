import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'view_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventBox extends StatefulWidget {

  final String documentId;
  final String title;
  final DateTime date;
  final int attendees;
  final String image;
  final String venue;
  final String description;
  final String club;
  // final bool isDarkMode;

  const EventBox({
    super.key,
    required this.documentId,
    required this.title,
    required this.date,
    required this.attendees,
    required this.image,
    required this.venue,
    required this.description,
    required this.club,
    // required this.isDarkMode,
  });

  @override
  _EventBoxState createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  // Check if the event is already saved
  Future<void> _checkIfSaved() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final savedEvents = userDoc.data()?['savedEvents'] ?? [];
        setState(() {
          isSaved = savedEvents.contains(FirebaseFirestore.instance.collection('events').doc(widget.documentId));
        });
      }
    }
  }

  // Method to save or unsave event
  Future<void> _toggleSaveEvent() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      final eventRef = FirebaseFirestore.instance.collection('events').doc(widget.documentId);

      if (isSaved) {
        // Unsave event
        await userRef.update({
          'savedEvents': FieldValue.arrayRemove([eventRef]),
        });
      } else {
        // Save event
        await userRef.update({
          'savedEvents': FieldValue.arrayUnion([eventRef]),
        });
      }

      setState(() {
        isSaved = !isSaved;
      });

      print(isSaved ? 'Event saved successfully!' : 'Event unsaved!');
    } else {
      print('User not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            // child: Image.asset(
            //   widget.image,
            //   height: 170,
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            //   errorBuilder: (context, error, stackTrace) {
            //     return Container(
            //       height: 170,
            //       color: Colors.grey[300],
            //       child: const Center(child: Text("Image not found")),
            //     );
            //   },
            // ),
            child: widget.image.startsWith('http')
    ? Image.network(
        widget.image,
        height: 170,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 170,
          color: Colors.grey[300],
          child: const Center(child: Text("Image failed to load")),
        ),
      )
    : Image.asset(
        widget.image,
        height: 170,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 170,
          color: Colors.grey[300],
          child: const Center(child: Text("Asset not found")),
        ),
      ),

          ),

          // Event Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
  // Title
  Text(
    widget.title,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
  ),

  const SizedBox(height: 6),

  // Date
  Row(
    children: [
      Text("📅", style: TextStyle(fontSize: 18, color: Colors.purple)),
      const SizedBox(width: 6),
      Text(
        DateFormat('dd MMM yyyy').format(widget.date),
        style: TextStyle(fontSize: 15.5, color: textColor.withOpacity(0.85)),
      ),
    ],
  ),

  const SizedBox(height: 3),

  // Venue
  Row(
    children: [
      Text("📍", style: TextStyle(fontSize: 18, color: Colors.purple)),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          widget.venue,
          style: TextStyle(fontSize: 15.5, color: textColor.withOpacity(0.85)),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  ),

  const SizedBox(height: 3),

  // Attendees & Category
  Row(
    children: [
      Text("👥", style: TextStyle(fontSize: 18, color: Colors.purple)),
      const SizedBox(width: 6),
      Text(
        '${widget.attendees} Attending',
        style: TextStyle(fontSize: 15.5, color: textColor.withOpacity(0.85)),
      ),
      const SizedBox(width: 12),
      Text("🏷️", style: TextStyle(fontSize: 18, color: Colors.purple)),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          widget.club,
          style: TextStyle(fontSize: 15.5, color: textColor.withOpacity(0.85)),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  ),

  const SizedBox(height: 6),

  // Description
  Text(
    widget.description,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 15.5,
      color: textColor,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
  ),



                // Buttons (Save and View Details)
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Save Button
                    IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: const Color.fromARGB(255, 72, 4, 117),
                      ),
                      onPressed: _toggleSaveEvent,
                    ),
                    // View Details Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewDetailsScreen(
                              documentId: widget.documentId,
                              title: widget.title,
                              date: widget.date,
                              attendees: widget.attendees,
                              image: widget.image,
                              venue: widget.venue,
                              description: widget.description,
                              club: widget.club,
                              organizer: "TechFest Team",
                              contact: "+1 234 567 890",
                              website: "https://techfest.com",
                              schedule: "9:00 AM - Registration\n10:00 AM - Keynote\n12:00 PM - Workshop\n3:00 PM - Panel Discussion",
                              pricing: "Free Entry",
                              speakers: "John Doe, Jane Smith",
                              rules: "1. No outside food/drinks\n2. Arrive 15 minutes before event\n3. Follow COVID-19 guidelines",
                              socialMedia: "Twitter: @TechFest | Instagram: @TechFest2025",
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 90, 9, 152),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

