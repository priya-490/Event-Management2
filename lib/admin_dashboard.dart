import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();

  // Function to create an event in Firestore
  Future<void> createEvent() async {
    if (_eventNameController.text.isEmpty ||
        _eventDescriptionController.text.isEmpty ||
        _eventDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('events').add({
        'name': _eventNameController.text,
        'description': _eventDescriptionController.text,
        'date': _eventDateController.text,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );

      _eventNameController.clear();
      _eventDescriptionController.clear();
      _eventDateController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFFbc6c25),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Event',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _eventNameController,
              decoration: const InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _eventDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Event Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _eventDateController,
              decoration: const InputDecoration(
                labelText: 'Event Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: createEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFbc6c25),
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}
