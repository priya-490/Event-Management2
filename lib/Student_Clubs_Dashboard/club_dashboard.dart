import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'add_event.dart';
import 'event_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ClubDashboard extends StatefulWidget {
  const ClubDashboard({super.key});

  @override
  _ClubDashboardState createState() => _ClubDashboardState();
}

class _ClubDashboardState extends State<ClubDashboard> {
  List<Event> events = []; // State variable to store events

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Fetch events when the screen loads
  }

  /// Fetch events from Firestore
  Future<void> fetchEvents() async {
    try {
      //String userId = FirebaseAuth.instance.currentUser?.email ?? "";
      //String clubName = userId.split('@')[0]; // Extract "club" from "club@iitrpr.ac.in"
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        return;
      }

      // get the club name associated with the logged in club rep
      final clubQuery =
          await FirebaseFirestore.instance
              .collection('approved_clubs')
              .where('Club Email', isEqualTo: userEmail)
              .get();

      if (clubQuery.docs.isEmpty) return;

      final clubName = clubQuery.docs.first.data()['Club Name'];
      //debugging
     print("\n ###Fetched club name: '$clubName'\n");

      // String clubName = "Dcypher";

//debugging
final eventsSnapshot = await FirebaseFirestore.instance.collection('events').get();
for (var doc in eventsSnapshot.docs) {
  print("\n ###Event: ${doc.data()['Event Name']}, club: '${doc.data()['club']}' \n");
}

      // Fetch events only for this club
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .where('club', isEqualTo: clubName) // Filter by club name
              .get();

      List<Event> loadedEvents =
          snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();

      setState(() {
        events = loadedEvents; // Update state with filtered events
      });
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Separate approved and unapproved events
    // Separate approved and unapproved events
    final approvedEvents =
        events.where((event) => event.status == "approved").toList();
    final unapprovedEvents =
        events.where((event) => event.status == "pending").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Events"),
        leading: const Icon(Icons.arrow_back),
        actions: [
          Icon(Icons.notifications),
          const SizedBox(width: 16),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unapproved Events Section
            const Text(
              "Pending Approval",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            unapprovedEvents.isEmpty
                ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("No events pending approval"),
                )
                : GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                  children: List.generate(unapprovedEvents.length, (index) {
                    return EventCard(event: unapprovedEvents[index]);
                  }),
                ),

            const SizedBox(height: 24),

            // Approved Events Section
            const Text(
              "Approved Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            approvedEvents.isEmpty
                ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("No approved events"),
                )
                : GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                  children: List.generate(approvedEvents.length, (index) {
                    return EventCard(event: approvedEvents[index]);
                  }),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade300,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[300],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      "Image Not Found",
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                  if (event.status == "pending")
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Pending",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.eventName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('yyyy-MM-dd').format(event.startDate),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(event.eventVenue),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EventDetailsPage(
                              eventName: event.eventName,
                              startDate: event.startDate,
                              endDate: event.endDate,
                              isPaid: event.isPaid,
                              price: event.price,
                              userId: event.userId,
                              eventVenue: event.eventVenue,
                              attendees: event.attendees,
                              club: event.club,
                              eventDescription: event.eventDescription,
                              eventImage: event.eventImage,
                              status: event.status,
                              documentId: event.documentId,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        event.status == "approved"
                            ? Colors.purple.shade100
                            : Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("View Details"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String? documentId; // For Firestore reference
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
  final String userId; // To track who created the event

  Event({
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

//   factory Event.fromFirestore(DocumentSnapshot doc) {
//   Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
//   Map<String, dynamic> paymentInfo =
//       data['Payment Info'] as Map<String, dynamic>? ?? {};

//   return Event(
//     documentId: doc.id,
//     eventName: data['Event Name'] ?? 'Unnamed Event',
//     eventDescription: data['Event Description'] ?? 'No Description',
//     startDate: data['Start Date'] is Timestamp
//         ? (data['Start Date'] as Timestamp).toDate()
//         : DateTime.tryParse(data['Start Date'].toString()) ?? DateTime.now(),
//     endDate: data['End Date'] is Timestamp
//         ? (data['End Date'] as Timestamp).toDate()
//         : DateTime.tryParse(data['End Date'].toString()) ?? DateTime.now(),
//     eventVenue: data['Event Venue'] ?? 'Venue not mentioned',
//     // eventImage: data['image'] ?? '',
//     eventImage: data['image'] is List
//     ? (data['image'] as List).isNotEmpty
//         ? (data['image'] as List).first.toString()
//         : ''
//     : data['image']?.toString() ?? '',

//     attendees: (data['attendees'] as num?)?.toInt() ?? 0,
//     isPaid: paymentInfo['isPaid'] ?? false,
//     price: (paymentInfo['price'] as num?)?.toDouble() ?? 0.0,
//     club: data['club'] ?? 'Not Set',
//     status: data['status'] ?? 'pending',
//     userId: data['userId'] ?? '',
//   );
// }

factory Event.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
  Map<String, dynamic> paymentInfo = data['Payment Info'] as Map<String, dynamic>? ?? {};

  return Event(
    documentId: doc.id,
    eventName: data['Event Name']?.toString() ?? 'Unnamed Event',
    eventDescription: data['Event Description']?.toString() ?? 'No Description',
    startDate: data['Start Date'] is Timestamp
        ? (data['Start Date'] as Timestamp).toDate()
        : DateTime.tryParse(data['Start Date'].toString()) ?? DateTime.now(),
    endDate: data['End Date'] is Timestamp
        ? (data['End Date'] as Timestamp).toDate()
        : DateTime.tryParse(data['End Date'].toString()) ?? DateTime.now(),

    eventVenue: data['Event Venue'] is List
        ? (data['Event Venue'] as List).isNotEmpty
            ? (data['Event Venue'] as List).first.toString()
            : 'Venue not mentioned'
        : data['Event Venue']?.toString() ?? 'Venue not mentioned',

    eventImage: data['image'] is List
        ? (data['image'] as List).isNotEmpty
            ? (data['image'] as List).first.toString()
            : ''
        : data['image']?.toString() ?? '',

    club: data['club'] is List
        ? (data['club'] as List).isNotEmpty
            ? (data['club'] as List).first.toString()
            : 'Not Set'
        : data['club']?.toString() ?? 'Not Set',

    attendees: (data['attendees'] as num?)?.toInt() ?? 0,
    isPaid: paymentInfo['isPaid'] ?? false,
    price: (paymentInfo['price'] as num?)?.toDouble() ?? 0.0,
    status: data['status']?.toString() ?? 'pending',
    userId: data['userId']?.toString() ?? '',
  );
}

}
