import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // ✅ Needed for DateFormat

class EventDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  // ✅ Moved up
  String _formatDate(dynamic date) {
    final formatter = DateFormat('dd MMM yyyy');
    if (date is Timestamp) {
      return formatter.format(date.toDate());
    } else if (date is String) {
      try {
        return formatter.format(DateTime.parse(date));
      } catch (e) {
        return 'Invalid date';
      }
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final paymentInfo = event['Payment Info'] ?? {};

    return Scaffold(
      appBar: AppBar(title: Text('Event Details - ${event['Event Name']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/a.jpeg', height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              'Event Name: ${event['Event Name']}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Venue: ${event['Event Venue']}'),
            const SizedBox(height: 8),
            Text('Start Date: ${_formatDate(event['Start Date'])}'),
            const SizedBox(height: 8),
            Text('End Date: ${_formatDate(event['End Date'])}'),
            const SizedBox(height: 8),
            Text('Description: ${event['Event Description']}'),
            const SizedBox(height: 8),
            Text('Price: ₹${paymentInfo['price'] ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Paid: ${paymentInfo['isPaid'] == true ? "Yes" : "No"}'),
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
    FirebaseFirestore.instance
        .collection('events')
        .doc(event.id)
        .update({'status': status})
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event $status Successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $error')),
      );
    });
  }
}
