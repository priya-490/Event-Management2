import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approved Events by Clubs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('status', isEqualTo: 'approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          // Group events by club
          Map<String, List<QueryDocumentSnapshot>> clubEvents = {};
          for (var event in events) {
            String club = event['club'] ?? 'Unknown Club';
            if (!clubEvents.containsKey(club)) {
              clubEvents[club] = [];
            }
            clubEvents[club]!.add(event);
          }

          return ListView(
            children: clubEvents.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...entry.value.map((event) {
                    var timestamp = event['Start Date'] as Timestamp;
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.asset(
                          'assets/a.jpeg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(event['Event Name'],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Venue: ${event['Event Venue']}\nDate: ${formatDate(timestamp)}',
                        ),
                        onTap: () {},
                      ),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
