// // import 'package:flutter/material.dart';

// // class EventDetailPage extends StatelessWidget {
// //   final Map<String, dynamic> eventData;
// //   const EventDetailPage({super.key, required this.eventData});

// //   @override
// //   Widget build(BuildContext context) {
// //     final imageUrl = eventData['image'] ?? '';
// //     final name = eventData['name'] ?? 'No Name';
// //     final date = eventData['date'] ?? 'No Date';
// //     final time = eventData['time'] ?? 'No Time';
// //     final venue = eventData['venue'] ?? 'No Venue';
// //     final description = eventData['description'] ?? 'No Description';

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(name),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             if (imageUrl.isNotEmpty)
// //               ClipRRect(
// //                 borderRadius: BorderRadius.circular(12),
// //                 child: Image.network(
// //                   imageUrl,
// //                   width: double.infinity,
// //                   height: 220,
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //             const SizedBox(height: 20),
// //             Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 10),
// //             Text("📅 Date: $date", style: const TextStyle(fontSize: 16)),
// //             Text("📍 Venue: $venue", style: const TextStyle(fontSize: 16)),
// //             Text("⏰ Time: $time", style: const TextStyle(fontSize: 16)),
// //             const SizedBox(height: 16),
// //             Text("📝 Description:", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             const SizedBox(height: 6),
// //             Text(description, style: const TextStyle(fontSize: 16)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }





// import 'package:flutter/material.dart';

// class EventDetailPage extends StatefulWidget {
//   final Map<String, dynamic> eventData;

//   const EventDetailPage({super.key, required this.eventData});

//   @override
//   _EventDetailPageState createState() => _EventDetailPageState();
// }

// class _EventDetailPageState extends State<EventDetailPage> {
//   bool _isDarkMode = false;

//   @override
//   Widget build(BuildContext context) {
//     final event = widget.eventData;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Event Details"),
//         actions: [
//           Switch(
//             value: _isDarkMode,
//             onChanged: (value) {
//               setState(() {
//                 _isDarkMode = value;
//               });
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Show event details
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event),
//             label: 'Events',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//         ],
//         onTap: (index) {
//           // Navigate based on index
//         },
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EventDetailPage({super.key, required this.eventData});

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.eventData;
    final imageUrl = event['image'] ?? '';
    final name = event['name'] ?? 'No Name';
    final date = event['date'] ?? 'No Date';
    final time = event['time'] ?? 'No Time';
    final venue = event['venue'] ?? 'No Venue';
    final description = event['description'] ?? 'No Description';

    // Toggle theme based on _isDarkMode
    return MaterialApp(
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              appBarTheme: const AppBarTheme(
                color: Colors.black,
                iconTheme: IconThemeData(color: Colors.white),
              ),
            )
          : ThemeData.light().copyWith(
              appBarTheme: const AppBarTheme(
                color: Colors.blue,
                iconTheme: IconThemeData(color: Colors.white),
              ),
            ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(name),
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, // Moon icon for dark mode
              ),
              onPressed: _toggleDarkMode,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("📅 Date: $date", style: const TextStyle(fontSize: 16)),
              Text("📍 Venue: $venue", style: const TextStyle(fontSize: 16)),
              Text("⏰ Time: $time", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text(
                "📝 Description:",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to a more detailed page if needed
                },
                child: const Text("View Details"),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
          ],
          onTap: (index) {
            // Handle navigation if needed
          },
        ),
      ),
    );
  }
}
