// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../Theme/theme_provider.dart';
// import 'add_event.dart';
// import 'event_details.dart';

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Manage Events"),
//         leading: const Icon(Icons.arrow_back),
//         actions: [
//           Icon(Icons.notifications),
//           SizedBox(width: 16),
//           IconButton(
//             icon: Icon(
//               themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
//             ),
//             onPressed: () {
//               themeProvider.toggleTheme();
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 0.8,
//           children: List.generate(events.length, (index) {
//             return EventCard(event: events[index]);
//           }),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.purple.shade300,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddEventScreen()),
//           );
//         },
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.purple,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }

// class EventCard extends StatelessWidget {
//   final Event event;
//   const EventCard({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(12),
//                 ),
//                 color: Colors.grey[300],
//               ),
//               child: const Center(
//                 child: Text(
//                   "Image Not Found",
//                   style: TextStyle(fontSize: 12, color: Colors.red),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   event.title,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.calendar_today,
//                       size: 14,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(event.date),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 14, color: Colors.red),
//                     const SizedBox(width: 4),
//                     Text(event.location),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (context) => EventDetailsPage(
//                               title: "Tech Fest 2025",
//                               date: "March 20, 2025",
//                               location: "New York, USA",
//                               attendees: "1.2K",
//                               category: "Technology",
//                               description:
//                                   "Join the biggest tech festival with top industry experts!",
//                               imageUrl:
//                                   "https://source.unsplash.com/400x300/?technology,festival",
//                             ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple.shade100,
//                     foregroundColor: Colors.black,
//                   ),
//                   child: const Text("View Details"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Event {
//   final String title;
//   final String date;
//   final String location;

//   Event({required this.title, required this.date, required this.location});
// }

// List<Event> events = [
//   Event(
//     title: "Tech Fest 2025",
//     date: "March 20, 2025",
//     location: "New York, USA",
//   ),
//   Event(
//     title: "Startup Conference",
//     date: "April 5, 2025",
//     location: "San Francisco, USA",
//   ),
// ];
