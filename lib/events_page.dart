// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// void main() {
//   runApp(EventApp());
// }

// class EventApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: EventPage(),
//     );
//   }
// }

// class EventPage extends StatelessWidget {
//   final List<String> bannerImages = [
//     'assets/banner1.png',
//     'assets/banner2.png',
//     'assets/banner3.png',
//   ];

//   final List<Map<String, String>> eventCategories = [
//     {'icon': 'assets/icon1.png', 'label': 'BOLA'},
//     {'icon': 'assets/icon2.png', 'label': 'BOST'},
//     {'icon': 'assets/icon3.png', 'label': 'BOCA'},
//     {'icon': 'assets/icon4.png', 'label': 'BOWA'},
//     {'icon': 'assets/icon1.png', 'label': 'BOSA'},
//   ];

//   final List<Map<String, String>> eventTypes = [
//     {'image': 'assets/festival.png', 'name': 'Festival'},
//     {'image': 'assets/general_championship.png', 'name': 'General Championship'},
//     {'image': 'assets/esports.png', 'name': 'Esports'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Search Bar
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       icon: Icon(Icons.search, color: Colors.black54),
//                       hintText: "Search",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),

//                 // Event Banner (Carousel Slider)
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: 200,
//                     autoPlay: true,
//                     enlargeCenterPage: true,
//                   ),
//                   items: bannerImages.map((image) {
//                     return Container(
//                       margin: EdgeInsets.symmetric(horizontal: 5),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         image: DecorationImage(
//                           image: AssetImage(image),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 SizedBox(height: 16),

//                 // Event Categories (Grid View)
//                 GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 5,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: eventCategories.length,
//                   itemBuilder: (context, index) {
//                     return Column(
//                       children: [
//                         Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.brown[400],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Center(
//                             child: Image.asset(eventCategories[index]['icon']!, width: 30),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(eventCategories[index]['label']!, style: TextStyle(fontSize: 12)),
//                       ],
//                     );
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 // Event Type Section
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("Event Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     Icon(Icons.arrow_forward, size: 20),
//                   ],
//                 ),
//                 SizedBox(height: 10),

//                 // Event Type List
//                 SizedBox(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: eventTypes.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.only(right: 10),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 80,
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 image: DecorationImage(
//                                   image: AssetImage(eventTypes[index]['image']!),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             Text(eventTypes[index]['name']!, style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
