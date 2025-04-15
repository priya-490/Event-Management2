import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'dart:async';
import 'club_list_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final List<String> eventBanners = const [
    '../assets/Eidwishes.jpg',
    '../assets/IMAGINE.png',
    'assets/event_banner_3.jpg',
  ];
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }


  final List<String> eventCategories = const ["BOLA", "BOST", "BOCA", "BOWA", "BOSA"];

  final List<String> eventTypes = const [
    '../assets/fest_event.jpeg',  // Event type 1
    '../assets/gc.jpeg',  // Event type 2
    '../assets/cultinter.jpg',  // Event type 3
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
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, color: textColor),
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
              style: TextStyle(color: textColor),
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
                controller: PageController(viewportFraction: 0.9),
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
                      onTap: () {Navigator.push(context,MaterialPageRoute(
                        builder: (context) => ClubListPage(categoryKey: eventCategories[index].toLowerCase()),
                        ),)
                        ;},
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
              height: 200,  // Adjust the height for the bigger image boxes
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: eventTypes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        // Image display (no uploading functionality)
                        Container(
                          width: 180,  // Larger width for bigger image boxes
                          height: 150,  // Larger height for bigger image boxes
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../Theme/theme_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EventsPage extends StatelessWidget {
//   const EventsPage({super.key});

//   final List<String> eventBanners = const [
//     'assets/event_banner_1.jpg',
//     'assets/event_banner_2.jpg',
//     'assets/event_banner_3.jpg',
//   ];

//   final List<String> eventCategories = const ["BOLA", "BOST", "BOCA", "BOWA", "BOSA"];

//   final List<String> eventTypes = const [
//     'assets/festival.png',
//     'assets/general_championship.png',
//     'assets/trophy.png',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     bool isDarkMode = themeProvider.isDarkMode;
//     Color primaryColor = isDarkMode ? Colors.deepPurple.shade400 : Colors.deepPurple;
//     Color backgroundColor = isDarkMode ? Colors.black87 : Colors.white;
//     Color textColor = isDarkMode ? Colors.white : Colors.black;
//     Color inputColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;

//     // Get the current user
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Events"),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF6A0DAD), // Professional purple shade
//         actions: [
//           IconButton(
//             icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
//             onPressed: () {
//               themeProvider.toggleTheme();
//             },
//           ),
//         ],
//       ),
//       // backgroundColor: backgroundColor,
//       // appBar: AppBar(
//       //   title: Text("Events", style: TextStyle(color: textColor)),
//       //   backgroundColor: primaryColor,
//       //   actions: [
//       //     // 🌙 Theme Toggle Button
//       //     IconButton(
//       //       icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, color: textColor),
//       //       onPressed: () {
//       //         themeProvider.toggleTheme();
//       //       },
//       //     ),
//       //     IconButton(
//       //       icon: Icon(Icons.search, color: textColor),
//       //       onPressed: () {},
//       //     ),
//       //   ],
//       // ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔍 Search Bar
//             TextField(
//               style: TextStyle(color: textColor),
//               decoration: InputDecoration(
//                 hintText: "Search events...",
//                 hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.black54),
//                 prefixIcon: Icon(Icons.search, color: textColor),
//                 filled: true,
//                 fillColor: inputColor,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // 🖼 Event Banner Slider (Using PageView)
//             SizedBox(
//               height: 200,
//               child: PageView.builder(
//                 itemCount: eventBanners.length,
//                 controller: PageController(viewportFraction: 0.9),
//                 itemBuilder: (context, index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.asset(eventBanners[index], fit: BoxFit.cover),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),

//             // 📌 Event Categories (Scrollable)
//             Text(
//               "Categories",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 50,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: eventCategories.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: primaryColor,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Center(
//                           child: Text(
//                             eventCategories[index],
//                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),

//             // 🎭 Event Type Section
//             Text(
//               "Event Type",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
//             ),
//             const SizedBox(height: 8),

//             // 📌 Event Type Scrollable Grid
//             SizedBox(
//               height: 100,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: eventTypes.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: AssetImage(eventTypes[index]),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Type ${index + 1}",
//                           style: TextStyle(color: textColor, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../Theme/theme_provider.dart';
// import 'package:provider/provider.dart';

// // 🔹 Theme Provider (To Manage Dark/Light Mode Toggle)
// class ThemeProvider with ChangeNotifier {
//   bool _isDarkMode = false;

//   bool get isDarkMode => _isDarkMode;

//   void toggleTheme() {
//     _isDarkMode = !_isDarkMode;
//     notifyListeners();
//   }
// }

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
    
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
//       home: const EventsPage(),
//     );
//   }
// }

// class EventsPage extends StatelessWidget {
//   const EventsPage({super.key});

//   final List<String> eventBanners = const [
//     'assets/event_banner_1.jpg',
//     'assets/event_banner_2.jpg',
//     'assets/event_banner_3.jpg',
//   ];

//   final List<String> eventCategories = const ["BOLA", "BOST", "BOCA", "BOWA", "BOSA"];

//   final List<String> eventTypes = const [
//     'assets/festival.png',
//     'assets/general_championship.png',
//     'assets/trophy.png',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     bool isDarkMode = themeProvider.isDarkMode;
//     Color primaryColor = isDarkMode ? Colors.deepPurple.shade400 : Colors.deepPurple;
//     Color backgroundColor = isDarkMode ? Colors.black87 : Colors.white;
//     Color textColor = isDarkMode ? Colors.white : Colors.black;
//     Color inputColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         title: Text("Events", style: TextStyle(color: textColor)),
//         backgroundColor: primaryColor,
//         actions: [
//           // 🌙 Theme Toggle Button
//           IconButton(
//             icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, color: textColor),
//             onPressed: () {
//               themeProvider.toggleTheme();
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.search, color: textColor),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔍 Search Bar
//             TextField(
//               style: TextStyle(color: textColor),
//               decoration: InputDecoration(
//                 hintText: "Search events...",
//                 hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.black54),
//                 prefixIcon: Icon(Icons.search, color: textColor),
//                 filled: true,
//                 fillColor: inputColor,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // 🖼 Event Banner Slider (Using PageView)
//             SizedBox(
//               height: 200,
//               child: PageView.builder(
//                 itemCount: eventBanners.length,
//                 controller: PageController(viewportFraction: 0.9),
//                 itemBuilder: (context, index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.asset(eventBanners[index], fit: BoxFit.cover),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),

//             // 📌 Event Categories (Scrollable)
//             Text(
//               "Categories",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 50,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: eventCategories.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: primaryColor,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Center(
//                           child: Text(
//                             eventCategories[index],
//                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),

//             // 🎭 Event Type Section
//             Text(
//               "Event Type",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
//             ),
//             const SizedBox(height: 8),

//             // 📌 Event Type Scrollable Grid
//             SizedBox(
//               height: 100,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: eventTypes.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: AssetImage(eventTypes[index]),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Type ${index + 1}",
//                           style: TextStyle(color: textColor, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }















// // import 'package:flutter/material.dart';

// // class EventsScreen extends StatelessWidget {
// //   const EventsScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Events")),
// //       body: const Center(child: Text("Events Page")),
// //     );
// //   }
// // }


// // // import 'package:flutter/material.dart';
// // // import 'package:carousel_slider/carousel_slider.dart';

// // // class EventsPage extends StatelessWidget {
// // //   final List<String> eventBanners = [
// // //     'assets/event_banner_1.jpg',
// // //     'assets/event_banner_2.jpg',
// // //     'assets/event_banner_3.jpg',
// // //   ];

// // //   final List<String> eventCategories = ["BOLA", "BOST", "BOCA", "BOWA", "BOSA"];

// // //   final List<String> eventTypes = [
// // //     'assets/festival.png',
// // //     'assets/general_championship.png',
// // //     'assets/trophy.png',
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       appBar: AppBar(
// // //         title: const Text("Events"),
// // //         backgroundColor: Colors.deepPurple,
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.search),
// // //             onPressed: () {
// // //               // Add search functionality
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //       body: SingleChildScrollView(
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               // Search Bar
// // //               TextField(
// // //                 decoration: InputDecoration(
// // //                   hintText: "Search events...",
// // //                   prefixIcon: const Icon(Icons.search),
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(30),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 16),

// // //               // Event Banner Slider
// // //               CarouselSlider(
// // //                 options: CarouselOptions(
// // //                   height: 200,
// // //                   autoPlay: true,
// // //                   enlargeCenterPage: true,
// // //                 ),
// // //                 items: eventBanners.map((imagePath) {
// // //                   return ClipRRect(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     child: Image.asset(imagePath, fit: BoxFit.cover),
// // //                   );
// // //                 }).toList(),
// // //               ),
// // //               const SizedBox(height: 16),

// // //               // Event Categories (Scrollable)
// // //               SizedBox(
// // //                 height: 50,
// // //                 child: ListView.builder(
// // //                   scrollDirection: Axis.horizontal,
// // //                   itemCount: eventCategories.length,
// // //                   itemBuilder: (context, index) {
// // //                     return Padding(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
// // //                       child: Container(
// // //                         padding: const EdgeInsets.symmetric(horizontal: 12),
// // //                         decoration: BoxDecoration(
// // //                           color: Colors.brown.shade400,
// // //                           borderRadius: BorderRadius.circular(12),
// // //                         ),
// // //                         child: Center(
// // //                           child: Text(
// // //                             eventCategories[index],
// // //                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     );
// // //                   },
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 16),

// // //               // Event Type Section
// // //               const Text(
// // //                 "Event Type",
// // //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //               ),
// // //               const SizedBox(height: 8),

// // //               // Event Type Horizontal Scroll
// // //               SizedBox(
// // //                 height: 80,
// // //                 child: ListView.builder(
// // //                   scrollDirection: Axis.horizontal,
// // //                   itemCount: eventTypes.length,
// // //                   itemBuilder: (context, index) {
// // //                     return Padding(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
// // //                       child: Column(
// // //                         children: [
// // //                           Container(
// // //                             width: 60,
// // //                             height: 60,
// // //                             decoration: BoxDecoration(
// // //                               borderRadius: BorderRadius.circular(12),
// // //                               image: DecorationImage(
// // //                                 image: AssetImage(eventTypes[index]),
// // //                                 fit: BoxFit.cover,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     );
// // //                   },
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }




// // import 'package:flutter/material.dart';
// // import 'package:carousel_slider/carousel_slider.dart';

// // class EventsPage extends StatelessWidget {
// //   final List<String> eventBanners = [
// //     'assets/event_banner_1.jpg',
// //     'assets/event_banner_2.jpg',
// //     'assets/event_banner_3.jpg',
// //   ];

// //   final List<String> eventCategories = ["BOLA", "BOST", "BOCA", "BOWA", "BOSA"];

// //   final List<String> eventTypes = [
// //     'assets/festival.png',
// //     'assets/general_championship.png',
// //     'assets/trophy.png',
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black87, // Dark theme background
// //       appBar: AppBar(
// //         title: const Text("Events", style: TextStyle(color: Colors.white)),
// //         backgroundColor: Colors.deepPurple.shade700,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.search, color: Colors.white),
// //             onPressed: () {
// //               // Add search functionality
// //             },
// //           ),
// //         ],
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // 🔍 Search Bar
// //             TextField(
// //               style: const TextStyle(color: Colors.white),
// //               decoration: InputDecoration(
// //                 hintText: "Search events...",
// //                 hintStyle: TextStyle(color: Colors.grey.shade400),
// //                 prefixIcon: const Icon(Icons.search, color: Colors.white),
// //                 filled: true,
// //                 fillColor: Colors.grey.shade800,
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(30),
// //                   borderSide: BorderSide.none,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),

// //             // 🖼 Event Banner Slider
// //             CarouselSlider(
// //               options: CarouselOptions(
// //                 height: 200,
// //                 autoPlay: true,
// //                 enlargeCenterPage: true,
// //                 viewportFraction: 0.9,
// //               ),
// //               items: eventBanners.map((imagePath) {
// //                 return ClipRRect(
// //                   borderRadius: BorderRadius.circular(12),
// //                   child: Image.asset(imagePath, fit: BoxFit.cover),
// //                 );
// //               }).toList(),
// //             ),
// //             const SizedBox(height: 16),

// //             // 📌 Event Categories (Scrollable)
// //             const Text(
// //               "Categories",
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
// //             ),
// //             const SizedBox(height: 8),
// //             SizedBox(
// //               height: 50,
// //               child: ListView.builder(
// //                 scrollDirection: Axis.horizontal,
// //                 itemCount: eventCategories.length,
// //                 itemBuilder: (context, index) {
// //                   return Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
// //                     child: GestureDetector(
// //                       onTap: () {
// //                         // Add category click functionality
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
// //                         decoration: BoxDecoration(
// //                           color: Colors.deepPurple.shade500,
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             eventCategories[index],
// //                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //             const SizedBox(height: 16),

// //             // 🎭 Event Type Section
// //             const Text(
// //               "Event Type",
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
// //             ),
// //             const SizedBox(height: 8),

// //             // 📌 Event Type Horizontal Scroll
// //             SizedBox(
// //               height: 90,
// //               child: ListView.builder(
// //                 scrollDirection: Axis.horizontal,
// //                 itemCount: eventTypes.length,
// //                 itemBuilder: (context, index) {
// //                   return Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //                     child: Column(
// //                       children: [
// //                         Container(
// //                           width: 70,
// //                           height: 70,
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(12),
// //                             image: DecorationImage(
// //                               image: AssetImage(eventTypes[index]),
// //                               fit: BoxFit.cover,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

