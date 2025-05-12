// import 'package:flutter/material.dart';
// import 'event_box.dart';  // Make sure this is the correct path for EventBox
// import 'package:cloud_firestore/cloud_firestore.dart';


// class SearchResultsPage extends StatefulWidget {
//   final TextEditingController searchController;
//   final List<Map<String, dynamic>> allEvents;

//   SearchResultsPage({
//     required this.searchController,
//     required this.allEvents,
//   });

//   @override
//   _SearchResultsPageState createState() => _SearchResultsPageState();
// }

// class _SearchResultsPageState extends State<SearchResultsPage> {
//   List<Map<String, dynamic>> _filteredEvents = [];

//   @override
//   void initState() {
//     super.initState();
//     widget.searchController.addListener(_filterResults);
//     _filterResults();  // Initial filter call
//   }

//   // Filter results based on the search query
//   void _filterResults() {
//     final query = widget.searchController.text.toLowerCase();

//     if (!mounted) return;

//     setState(() {
//       _filteredEvents = widget.allEvents.where((event) {
//         final name = event['name']?.toString().toLowerCase() ?? '';
//         final venue = event['venue']?.toString().toLowerCase() ?? '';
//         final date = event['date'];
        
//         // Handle date safely and convert to string
//         final dateString = date is DateTime ? date.toString() : '';

//         // Filter events where any of the fields match the query
//         return name.contains(query) ||
//                venue.contains(query) ||
//                dateString.toLowerCase().contains(query);
//       }).toList();

//       print('Filtered Events: $_filteredEvents');
//     });
//   }

//   // Dispose of listener when the page is disposed
//   @override
//   void dispose() {
//     widget.searchController.removeListener(_filterResults);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           controller: widget.searchController,
//           decoration: InputDecoration(hintText: 'Search events...'),
//         ),
//       ),
      
//       body: _filteredEvents.isEmpty
//           ? Center(child: Text('No events found'))
//           : ListView.builder(
//               itemCount: _filteredEvents.length,
//               itemBuilder: (context, index) {
//                 final event = _filteredEvents[index];
//                 DateTime parsedDate;
//                 if (event['date'] is String) {
//                   // If it's a String, try parsing it
//                   parsedDate = DateTime.tryParse(event['date']) ?? DateTime.now(); // Default to now if parsing fails
//                 } else if (event['date'] is Timestamp) {
//                   // If it's a Firestore Timestamp, convert to DateTime
//                   parsedDate = (event['date'] as Timestamp).toDate();
//                 } else {
//                   // If it's already a DateTime
//                   parsedDate = event['date'] ?? DateTime.now();
//                 }

//                 return EventBox(
//                   documentId: event['id'] ?? 'no',
//                   image: event['image'] ?? '',
//                   title: event['name'] ?? 'No event',
//                   date: parsedDate,  // Pass the DateTime object
//                   club: event['category'] ?? 'no',
                  
//                   attendees:
//                   event["ParticipantsId"] is List
//                     ? (event["ParticipantsId"] as List).length
//                     : 0,
//                   venue: event['venue'] ?? 'no',
//                   description: event['description'] ?? 'no',
//                 );

//                 // return EventBox(
//                 //   documentId: event['id'] ?? 'no',
//                 //   image: event['imageUrl']?? 'no',
//                 //   title: event['Event Name']?? "no ",
//                 //   date: event['Start Date'] ?? 'No Date',
//                 //   club: event['category'] ?? 'No category',
//                 //   attendees: event['attendees'] ?? 'No attendees',
//                 //   venue: event['Event Venue'] ?? 'No venue',
//                 //   description: event['Event Description'] ?? 'No description',
//                 // );
//               },

              
//             ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_box.dart';

class SearchResultsPage extends StatefulWidget {
  final TextEditingController searchController;

  SearchResultsPage({required this.searchController});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () => setState(() {});
    widget.searchController.addListener(_listener);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_listener);
    super.dispose();
  }

  List<Map<String, dynamic>> _filterEvents(QuerySnapshot snapshot) {
    final query = widget.searchController.text.toLowerCase();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {...data, 'id': doc.id};
    }).where((event) {
      final name = event['Event Name']?.toString().toLowerCase() ?? '';
      final venue = event['Event Venue']?.toString().toLowerCase() ?? '';
      final date = event['Start Date'];
      final dateString = date is Timestamp
          ? date.toDate().toString().toLowerCase()
          : (date?.toString().toLowerCase() ?? '');

      return name.contains(query) || venue.contains(query) || dateString.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: widget.searchController,
          decoration: InputDecoration(hintText: 'Search events...'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No events available.'));
          }

          final filteredEvents = _filterEvents(snapshot.data!);

          if (filteredEvents.isEmpty) {
            return Center(child: Text('No events found.'));
          }

          return ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];

              DateTime parsedDate;
              final rawDate = event['Start Date'];
              if (rawDate is Timestamp) {
                parsedDate = rawDate.toDate();
              } else if (rawDate is String) {
                parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
              } else {
                parsedDate = DateTime.now(); // Fallback
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // child: Card(
                //   elevation: 3,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(16),
                //   ),
                  child: EventBox(
                    documentId: event['id'] ?? 'no',
                    image: event['imageUrl'] ?? '',
                    title: event['Event Name'] ?? 'No event',
                    date: parsedDate,
                    club: event['club'] ?? 'no',
                    attendees: event['ParticipantsId'] is List
                        ? (event['ParticipantsId'] as List).length
                        : 0,
                    venue: event['Event Venue'] ?? 'no',
                    description: event['Event Description'] ?? 'no',
                  ),
                // ),
              );
            },
          );
        },
      ),
    );
  }
}

