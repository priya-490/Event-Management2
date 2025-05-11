import 'package:flutter/material.dart';

class EventDetailsPage extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String attendees;
  final String category;
  final String description;
  final String imagePath; // Add imagePath here

  const EventDetailsPage({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.attendees,
    required this.category,
    required this.description,
    required this.imagePath, // Pass imagePath in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), leading: const BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use the imagePath here
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath, // This will display the correct event image
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text(date),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text(location),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.people, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text("Attendees: $attendees"),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text("Category: $category"),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(description),
          ],
        ),
      ),
    );
  }
}
