import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'edit_event_page.dart';

class EventDetailsPage extends StatelessWidget {
  final String? documentId; // Firestore document ID
  final String eventName;
  final String eventDescription;
  final DateTime startDate;
  final DateTime endDate;
  final String eventVenue;
  final String eventImage;
  final int attendees;
  final bool isPaid;
  final double price;
  final String club;
  final String status; // "approved" or "pending"
  final String userId;

  const EventDetailsPage({
    super.key,
    this.documentId,
    required this.eventName,
    required this.eventDescription,
    required this.startDate,
    required this.endDate,
    required this.eventVenue,
    required this.eventImage,
    required this.isPaid,
    required this.attendees,
    required this.price,
    required this.club,
    required this.status,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isAdmin = true; // Replace with actual admin check logic

    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
        backgroundColor: Colors.purple.shade300,
        actions: [
          if (isAdmin && status == "pending")
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () => {},
            ),
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Approval Status Banner
            if (status == "pending")
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.orange,
                child: const Center(
                  child: Text(
                    "PENDING APPROVAL",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Event Image
            eventImage.isNotEmpty
                ? Image.network(
                  eventImage,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
                : Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                ),

            // Event Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${DateFormat('yyyy-MM-dd').format(startDate)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 5),
                      Text(eventVenue, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 18,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "$attendees attendees",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.category,
                        size: 18,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 5),
                      Text("Club: $club", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "About this event",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(eventDescription, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),

            // Action Buttons (for admin)
            if (isAdmin)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Edit Event Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditEventPage(
                                  documentId: documentId!,
                                  eventName: eventName,
                                  eventDescription: eventDescription,
                                  startDate: startDate,
                                  endDate: endDate,
                                  eventVenue: eventVenue,
                                  eventImage: eventImage,
                                  isPaid: isPaid,
                                  attendees: attendees,
                                  price: price,
                                  club: club,
                                  status: status,
                                ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Event"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),

                    // Delete Event Button
                    ElevatedButton.icon(
                      onPressed: () {
                        _confirmDelete(context);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete Event"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Event"),
            content: const Text("Are you sure you want to delete this event?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog before deleting
                  await _deleteEvent(context); // Call delete function
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  // ✅ Function to delete event from Firestore
  Future<void> _deleteEvent(BuildContext context) async {
    if (documentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Document ID is null")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(documentId)
          .delete(); // 🔥 Delete event from Firestore

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event deleted successfully!")),
      );

      Navigator.pop(context); // Go back after deletion
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete event: $error")));
    }
  }
}