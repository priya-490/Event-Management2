// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'ClubEventsPage.dart';
// import 'package:audioplayers/audioplayers.dart'; // Import for sound effect

// class ClubListPage extends StatelessWidget {
//   final String categoryKey; // e.g., "bola"

//   const ClubListPage({super.key, required this.categoryKey});

//   Future<List<Map<String, dynamic>>> fetchClubs() async {
//     final doc = await FirebaseFirestore.instance
//         .collection('boards')
//         .doc('IXVosv0MRwmCKCLDXvoW')
//         .get();

//     final data = doc.data();
//     if (data == null || !data.containsKey(categoryKey)) return [];

//     final Map clubsMap = data[categoryKey];

//     return clubsMap.values
//         .map((e) => e is Map ? e : {"name": e.toString(), "image": null})
//         .cast<Map<String, dynamic>>()
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${categoryKey.toUpperCase()} Clubs"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchClubs(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No clubs found."));
//           }

//           final clubs = snapshot.data!;

//           return Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: GridView.builder(
//               itemCount: clubs.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2, // 2 cards per row
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 1.7, // Adjusted aspect ratio for smaller cards
//               ),
//               itemBuilder: (context, index) {
//                 final club = clubs[index];
//                 final clubName = club['name'];
//                 final imageUrl = club['image']; // Fetch the image URL if available

//                 return GestureDetector(
//                   onTap: () async {
//                     // // Play click sound before navigating
//                     // print("Card tapped!");
//                     // final player = AudioPlayer(); // Initialize the audio player
//                     // await player.play(AssetSource('assets/click.mp3')); // Play click sound on tap

//                     // Navigate to the ClubEventsPage after sound is played
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ClubEventsPage(clubName: clubName),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     color: Colors.deepPurple.shade100,
//                     child: Stack(
//                       children: [
//                         // Display the image as the background
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: imageUrl != null && imageUrl.isNotEmpty
//                               ? Image.network(
//                                   imageUrl,
//                                   width: double.infinity,
//                                   height: double.infinity,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) => Container(
//                                     color: Colors.deepPurple.shade100,
//                                     alignment: Alignment.center,
//                                     child: const Icon(Icons.broken_image, size: 40, color: Colors.white70),
//                                   ),
//                                 )
//                               : Container(
//                                   color: Colors.deepPurple.shade100,
//                                   alignment: Alignment.center,
//                                   child: const Icon(Icons.image, size: 40, color: Colors.white70),
//                                 ),
//                         ),
//                         // Overlay with gradient to blend name with image
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               // Gradient effect to make the text blend smoothly
//                               gradient: LinearGradient(
//                                 colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//                                 begin: Alignment.bottomCenter,
//                                 end: Alignment.topCenter,
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               clubName,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 22, // Bigger font for visibility
//                                 fontWeight: FontWeight.bold,
//                                 shadows: [
//                                   Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 2)
//                                 ],
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }






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
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                final club = clubs[index];
                final clubName = club['name'];
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
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.deepPurple.shade100,
                    child: Center(
                      child: Text(
                        clubName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
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

