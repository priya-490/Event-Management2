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
    // final imageUrl = event['imageUrl'] ?? 'assets/b.jpeg';
    final imageUrl = event['imageUrl'] ?? 'assets/b.jpeg';

    final name = event['name'] ?? 'No Name';
    final date = event['date'] ?? 'No Date';
    final time = event['time'] ?? 'No Time';
    final venue = event['venue'] ?? 'No Venue';
    final description = event['description'] ?? 'No Description';
Widget imageWidget;
if (imageUrl.startsWith('http')) {
  imageWidget = Image.network(
    imageUrl,
    width: double.infinity,
    height: 220,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        'assets/b.jpeg',
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    },
  );
} else {
  imageWidget = Image.asset(
    'assets/b.jpeg',
    width: double.infinity,
    height: 220,
    fit: BoxFit.cover,
  );
}

    // Toggle theme based on _isDarkMode
    return MaterialApp(
      theme:
          _isDarkMode
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
                _isDarkMode
                    ? Icons.wb_sunny
                    : Icons.nightlight_round, // Moon icon for dark mode
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
              // if (imageUrl.isNotEmpty)
              //   ClipRRect(
              //     borderRadius: BorderRadius.circular(12),
              //     child: Image.network(
              //       imageUrl,
              //       width: double.infinity,
              //       height: 220,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              if (imageUrl.isNotEmpty)
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(12),
                //   child: Image.network(
                //     imageUrl,
                //     width: double.infinity,
                //     height: 220,
                //     fit: BoxFit.cover,
                //     errorBuilder:
                //         (context, error, stackTrace) => Container(
                //           width: double.infinity,
                //           height: 220,
                //           color: Colors.grey[300],
                //           child: const Center(
                //             child: Text(
                //               'Failed to load image',
                //               style: TextStyle(color: Colors.red),
                //             ),
                //           ),
                //         ),
                //   ),
                // ),
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: imageWidget,
),

              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text("📅 Date: $date", style: const TextStyle(fontSize: 16)),
              Text("📍 Venue: $venue", style: const TextStyle(fontSize: 16)),
              Text("⏰ Time: $time", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text(
                "📝 Description:",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(description, style: const TextStyle(fontSize: 16)),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
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
