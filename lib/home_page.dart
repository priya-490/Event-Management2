
// // import 'package:carousel_slider/carousel_slider.dart';
// import 'package:carousel_slider/carousel_controller.dart';
// import 'package:flutter/material.dart' hide CarouselController;


// void main() {
//   runApp(const EventApp());
// }

// class EventApp extends StatelessWidget {
//   const EventApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: EventHomePage(),
//     );
//   }
// }

// class EventHomePage extends StatelessWidget {
//   final List<String> eventBanners = [
//     'assets/banner1.jpg',
//     'assets/banner2.jpg',
//     'assets/banner3.jpg'
//   ];

//   final List<String> categories = ['BOLA', 'BOST', 'BOCA', 'BOWA', 'BOSA'];

//   final List<Map<String, String>> eventTypes = [
//     {'image': 'assets/festival.png', 'name': 'Festival'},
//     {'image': 'assets/general_championship.png', 'name': 'General Championship'},
//     {'image': 'assets/trophy.png', 'name': 'Tournament'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Search',
//               prefixIcon: Icon(Icons.search, color: Colors.grey),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               fillColor: Colors.grey[200],
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Carousel for Event Banners
//             CarouselSlider(
//               options: CarouselOptions(height: 180.0, autoPlay: true),
//               items: eventBanners.map((banner) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Container(
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         image: DecorationImage(
//                           image: AssetImage(banner),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16),
//             // Category Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: categories.map((category) {
//                 return Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.brown[400],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     category,
//                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16),
//             // Event Types
//             Text(
//               'Event Type',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: eventTypes.map((event) {
//                 return Column(
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         image: DecorationImage(
//                           image: AssetImage(event['image']!),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(event['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 
