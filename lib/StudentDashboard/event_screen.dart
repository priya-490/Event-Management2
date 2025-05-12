import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'club_list_page.dart';
import 'event_box.dart';
import 'SearchResultsPage.dart';
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final List<String> eventBanners = const [
    'assets/Eidwishes.jpg',
    'assets/IMAGINE.png',
    //'assets/event_banner_3.jpg',
  ];
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allEvents = [];
  List<Map<String, dynamic>> _filteredEvents = [];
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);

    // Auto-slide every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % eventBanners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
      }
    });

    // Fetch events data from Firestore
    _fetchEvents();

    // Set up search listener
    _searchController.addListener(_onSearchChanged);
  }

  // Fetch event data from Firestore
  void _fetchEvents() async {
    final snapshot = await FirebaseFirestore.instance.collection('events').get();

    final events = snapshot.docs.map((doc) {
      final data = doc.data();
      final dateField = data['Start Date'];
      DateTime parsedDate;

      if (dateField is Timestamp) {
        parsedDate = dateField.toDate(); // Convert Firestore Timestamp to DateTime
      } else if (dateField is String) {
        parsedDate = DateTime.tryParse(dateField) ?? DateTime.now(); // Try parsing it as String to DateTime
      } else {
        parsedDate = DateTime.now(); // Default to now if it's invalid or null
      }

      return {
        'id': doc.id,
        'image': data['imageUrl'] ?? '',
        'name': data['Event Name'] ?? '',
        'date': parsedDate,  // Use DateTime object here
        'venue': data['Event Venue'] ?? '',
        'category': data['category'] ?? '',
        'description': data['Event Description'] ?? '',
     
        'attendees': data['ParticipantsId'] is List
      ? (data['ParticipantsId'] as List).length
      : 0,  // Check if 'ParticipantsId' is a List and return its length

      };
    }).toList();
    //   final data = doc.data();
    //   return {
    //     // 'documentid' : data['DocumentId'] ?? '';
    //     'id': doc.id,
    //     'image': data['imageUrl'] ?? '',
    //     'name': data['Event Name'] ?? '',
    //     'date': data['Start Date'] ?? '',
        
    //     'venue': data['Event Venue'] ?? '',
    //     'category': data['category'] ?? '',
    //     'description': data['Event Description'] ?? '',
    //     'attendees': data['attendees'] ?? '',
    //   };
    // }).toList();

    setState(() {
       _allEvents = events;
      _filteredEvents = events;  // Initial filtered list is the full list
      //  _allEvents = snapshot.docs.map((doc) => doc.data()).toList();
      //  _filteredEvents = _allEvents; // initial state shows all events
    });
    print('Total events fetched: ${_allEvents.length}');
    for (var event in _allEvents) {
      print('Event: ${event['name']} | ${event['date']} | ${event['venue']}');
}

  }



void _onSearchChanged() {
  final query = _searchController.text.toLowerCase();

  // Only update if the widget is still in the tree (avoids errors if it's disposed).
  if (mounted) {
    setState(() {
      // Filter the events based on the query
      _filteredEvents = _allEvents.where((event) {
        // Retrieve event details safely
        final name = event['name'] ?? '';  // Default to empty string if null
        final date = event['date']; // Assume it's DateTime or null
        final venue = event['venue'] ?? '';  // Default to empty string if null

        // Debugging: print the values before converting to string
        print('Event: $event');
        print('Name: $name, Date: $date, Venue: $venue');

        // Convert DateTime to string safely
        final dateString = date is DateTime ? date.toString() : '';

        // Return true if any field matches the query (name, date, or venue)
        return name.toLowerCase().contains(query) ||
               dateString.toLowerCase().contains(query) ||
               venue.toLowerCase().contains(query);
      }).toList();
    });

    // Debugging: print the filtered events
    print('Filtered Events: $_filteredEvents');
    print('Search Query: $query');
    print('Matching Events: ${_filteredEvents.length}');
  }

  // If query is not empty and no previous navigation has occurred, navigate to results page
  if (!_navigated && query.isNotEmpty) {
    _navigated = true;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          searchController: _searchController,
          // allEvents: _filteredEvents,
          // allEvents: _allEvents,
        ),
      ),
    ).then((_) {
      _navigated = false;  // Reset after returning
    });
  }
}


// void _onSearchChanged() {
//   final query = _searchController.text.toLowerCase();

//   // Filter the events based on the query
//   if (mounted){
//   setState(() {
//     _filteredEvents = _allEvents.where((event) {
//       final name = event['name'];
//       print('Event: $event');

//       final date = event['date'];
//       final venue = event['venue'];

//       // Debugging: print the values before converting to string
//       print('Name: $name, Date: $date, Venue: $venue');

//       // Convert date to string to check if it contains the query
//       final dateString = date is DateTime ? date.toString() : ''; 

//       final query = _searchController.text.toLowerCase();

//   return name.toLowerCase().contains(query) ||
//          dateString.toLowerCase().contains(query) ||
//          venue.toLowerCase().contains(query);




//       // return (name ?? '').toString().toLowerCase().contains(query) ||
//       //         dateString.toLowerCase().contains(query) ||
//       //        (venue ?? '').toString().toLowerCase().contains(query);
//     }).toList();
//   });
//   print('Filtered Events: $_filteredEvents');

//   // print('Filtered Events: ${_filteredEvents.map((e) => e['Event Name']).toList()}');
//   print('Search Query: $query');
//   print('Matching Events: ${_filteredEvents.length}');
//   }

//   if (!_navigated && query.isNotEmpty) {
//   _navigated = true;
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => SearchResultsPage(
//         // searchQuery: query,  // Pass the search query to the results page
//         // filteredEvents: _filteredEvents,  // Pass the filtered events to the results page
//         searchController: _searchController,
//         // allEvents: _allEvents,
//          allEvents:  _filteredEvents,
//       ),
//     ),
//   ).then((_) {
//     _navigated = false; // Reset after returning
//   });
// }



  
  // Navigation logic - only navigate if there’s a valid query and if not navigated yet
  // if (!_navigated && query.isNotEmpty) {
  //   _navigated = true;
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SearchResultsPage(
  //         // searchQuery: query, // Pass the search query to the results page
  //         // filteredEvents: _filteredEvents,
  //          // Pass the filtered events to the results page
  //         searchController: _searchController,
  //         allEvents: _allEvents,
  //       ),
  //     ),
  //   ).then((_) {
  //     _navigated = false; // Reset after returning
  //   });
  // }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    _searchController.dispose();  // Clean up the controller
    super.dispose();
  }

  final List<String> eventCategories = const ["BOLA", "BOST", "BOCA", "BOWA", "BOSA"];

  final List<String> eventTypes = const [
    'assets/fest_event.jpeg',  // Event type 1
    'assets/gc.jpeg',  // Event type 2
    'assets/cultinter.jpg',  // Event type 3
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    Color primaryColor = isDarkMode ? Colors.deepPurple.shade400 : Colors.deepPurple;
    Color backgroundColor = isDarkMode ? Colors.black87 : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color inputColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Events", style: TextStyle(color: textColor)),
        backgroundColor: primaryColor,
        actions: [
          // 🌙 Theme Toggle Button
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: textColor),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            TextField(
              controller: _searchController,
              style: TextStyle(color: textColor),
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: "Search events...",
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.black54),
                prefixIcon: Icon(Icons.search, color: textColor),
                filled: true,
                fillColor: inputColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🖼 Event Banner Slider (Using PageView)
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: eventBanners.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(eventBanners[index], fit: BoxFit.cover),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 📌 Event Categories (Scrollable)
            Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: eventCategories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClubListPage(categoryKey: eventCategories[index].toLowerCase()),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            eventCategories[index],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 📌 Event Type Heading
            Text(
              "Event Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8),

            // 🖼 Event Type Images (Bigger Boxes)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: eventTypes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 180,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(eventTypes[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Type ${index + 1}",
                          style: TextStyle(color: textColor, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // const SizedBox(height: 16),

            // // 🧾 Display Filtered Events
            // Text(
            //   "Events",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            // ),
            // const SizedBox(height: 8),
            // _filteredEvents.isEmpty
            //     ? Center(child: Text("No events found.", style: TextStyle(color: textColor)))
            //     : ListView.builder(
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         itemCount: _filteredEvents.length,
            //         itemBuilder: (context, index) {
            //            final event = _filteredEvents[index];
            //            DateTime parsedDate;
            //           if (event['date'] is String) {
            //             // If it's a String, try parsing it
            //             parsedDate = DateTime.tryParse(event['date']) ?? DateTime.now(); // Default to now if parsing fails
            //           } else if (event['date'] is Timestamp) {
            //             // If it's a Firestore Timestamp, convert to DateTime
            //             parsedDate = (event['date'] as Timestamp).toDate();
            //           } else {
            //             // If it's already a DateTime
            //             parsedDate = event['date'] ?? DateTime.now();
            //           }

            //           return EventBox(
            //             documentId: event['id'] ?? 'no',
            //             image: event['image'] ?? '',
            //             title: event['name'] ?? 'No event',
            //             date: parsedDate,  // Pass the DateTime object
            //             club: event['category'] ?? 'no',
                        
            //             attendees:
            //             event["ParticipantsId"] is List
            //               ? (event["ParticipantsId"] as List).length
            //               : 0,
            //             venue: event['venue'] ?? 'no',
            //             description: event['description'] ?? 'no',
            //           );

             
                      
            //           // return EventBox(
            //           //   documentId: event['id'] ?? ' no',
            //           //   image: event['image'] ?? '',
            //           //   title: event['name'] ?? 'No event',
            //           //   date: event['date']?? 'No dtae',
            //           //   club: event['category'] ?? 'no',
            //           //   attendees: event['attendees'] ?? 'no',

            //           //   venue: event['venue']?? 'no',
            //           //   description: event['description']?? 'no',
            //           // );
            //         },
            //       ),
          ],
        ),
      ),
    );
  }
}