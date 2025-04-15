import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Details - ${event['Event Name']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/a.jpeg', height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text('Event Name: ${event['Event Name']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Venue: ${event['Event Venue']}'),
            Text('Start Date: ${event['Start Date'].toDate()}'),
            Text('End Date: ${event['End Date'].toDate()}'),
            Text('Description: ${event['Event Description']}'),
            Text('Price: ₹${event['Payment Info']['price']}'),
            Text('Paid: ${event['Payment Info']['isPaid'] ? "Yes" : "No"}'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _updateEventStatus(context, 'approved'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () => _updateEventStatus(context, 'rejected'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateEventStatus(BuildContext context, String status) {
    FirebaseFirestore.instance.collection('events').doc(event.id).update({'status': status}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event $status Successfully')));
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $error')));
    });
  }
}
