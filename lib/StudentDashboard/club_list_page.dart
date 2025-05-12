import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ClubEventsPage.dart';

class ClubListPage extends StatefulWidget {
  final String categoryKey;

  const ClubListPage({super.key, required this.categoryKey});

  @override
  _ClubListPageState createState() => _ClubListPageState();
}

class _ClubListPageState extends State<ClubListPage> {
  bool _isDarkMode = false; // Dark Mode State

  Future<List<Map<String, dynamic>>> fetchClubs() async {
    final doc = await FirebaseFirestore.instance
        .collection('boards')
        .doc('IXVosv0MRwmCKCLDXvoW')
        .get();

    final data = doc.data();
    if (data == null || !data.containsKey(widget.categoryKey)) return [];

    final Map clubsMap = data[widget.categoryKey];
    return clubsMap.values
        .map((e) => e is Map ? e : {"name": e.toString(), "image": null})
        .cast<Map<String, dynamic>>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryKey.toUpperCase()} Clubs"),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              if (_isDarkMode) {
                // Enable Dark Mode
                ThemeMode.dark;
              } else {
                // Enable Light Mode
                ThemeMode.light;
              }
            },
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchClubs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No clubs found."));
          }

          final clubs = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: clubs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
  final club = clubs[index];
  final clubName = club['name'] ?? "Unnamed Club";
  final imageUrl = club['image'] ?? "https://via.placeholder.com/150"; // fallback image

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClubEventsPage(clubName: clubName),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.deepPurple.shade100,
                child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          // Club name
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              clubName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
},

            ),
          );
        },
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
          // Navigate to respective pages based on index
        },
      ),
    );
  }
}

