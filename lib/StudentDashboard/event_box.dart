// // // this page is handling the home page of user dashboard created by pankaj, and this page is fetching the info sent from the home page and printing the info
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart'; // ✅ Import Provider
// // import '../Theme/theme_provider.dart'; // ✅ Import ThemeProvider
// // import 'view_detail.dart'; // ✅ Import ViewDetailsScreen
// // import 'package:intl/intl.dart';

// // class EventBox extends StatelessWidget {
// //   final String documentId;
// //   final String title;
// //   final DateTime date;
// //   final int attendees;
// //   final String image;
// //   final String venue;
// //   final String description;
// //   final String club;
// //   // final String club;
// //   final bool isDarkMode;

// //   const EventBox({
// //     super.key,
// //     required this.documentId,
// //     required this.title,
// //     required this.date,
// //     required this.attendees,
// //     required this.image,
// //     required this.venue,
// //     required this.description,
// //     required this.club,
// //     // required this.club,
// //     required this.isDarkMode,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final themeProvider = Provider.of<ThemeProvider>(
// //       context,
// //     ); // ✅ Get theme state
// //     bool isDarkMode = themeProvider.isDarkMode;

// //     return Card(
// //       color:
// //           isDarkMode
// //               ? Colors.grey[900]
// //               : Colors.white, // ✅ Theme-aware card color
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //       elevation: 4,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
// //             child: Image.asset(
// //               image,
// //               height: 150,
// //               width: double.infinity,
// //               fit: BoxFit.cover,
// //               errorBuilder: (context, error, stackTrace) {
// //                 return Container(
// //                   height: 150,
// //                   color: Colors.grey[300],
// //                   child: const Center(child: Text("Image not found")),
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(10),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   title,
// //                   style: TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                     color:
// //                         isDarkMode
// //                             ? Colors.white
// //                             : Colors.black, // ✅ Theme-aware text color
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),
// //                 Text(
// //                   "📅 Date: ${DateFormat('dd MMM yyyy').format(date)}",
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
// //                   ),
// //                 ),
// //                 Text(
// //                   "📍 Location: $venue",
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
// //                   ),
// //                 ),
// //                 Text(
// //                   "👥 Attendees: $attendees",
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
// //                   ),
// //                 ),
// //                 Text(
// //                   "🏷️ Category: $club",
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   description,
// //                   maxLines: 2,
// //                   overflow: TextOverflow.ellipsis,
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: isDarkMode ? Colors.white : Colors.black,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Align(
// //                   alignment: Alignment.bottomRight,
// //                   child: ElevatedButton(
// //                     onPressed: () {
// //                       // ✅ Navigate to ViewDetailsScreen with additional information
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder:
// //                               (context) => ViewDetailsScreen(
// //                                 documentId: doc.id,
// //                                 title: title,
// //                                 date: date,
// //                                 attendees: attendees,
// //                                 image: image,
// //                                 venue: venue,
// //                                 description: description,
// //                                 club: club,
// //                                 organizer:
// //                                     "TechFest Team", // ✅ Example organizer
// //                                 contact:
// //                                     "+1 234 567 890", // ✅ Example contact info
// //                                 website:
// //                                     "https://techfest.com", // ✅ Example website
// //                                 schedule:
// //                                     "9:00 AM - Registration\n10:00 AM - Keynote\n12:00 PM - Workshop\n3:00 PM - Panel Discussion", // ✅ Example schedule
// //                                 pricing: "Free Entry", // ✅ Example pricing
// //                                 speakers:
// //                                     "John Doe, Jane Smith", // ✅ Example speakers
// //                                 rules:
// //                                     "1. No outside food/drinks\n2. Arrive 15 minutes before event\n3. Follow COVID-19 guidelines", // ✅ Example rules
// //                                 socialMedia:
// //                                     "Twitter: @TechFest | Instagram: @TechFest2025", // ✅ Example social media
// //                               ),
// //                         ),
// //                       );
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0XFFbc6c25), // Button color
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                     child: const Text(
// //                       "View Details",
// //                       style: TextStyle(
// //                         color:
// //                             Colors.white, // ✅ White text for better visibility
// //                         fontWeight: FontWeight.bold, // Optional: Make it bold
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../Theme/theme_provider.dart';
// import 'view_detail.dart';
// import 'package:intl/intl.dart';

// class EventBox extends StatelessWidget {
//   final String documentId;
//   final String title;
//   final DateTime date;
//   final int attendees;
//   final String image;
//   final String venue;
//   final String description;
//   final String club;
//   // final bool isDarkMode;

//   const EventBox({
//     super.key,
//     required this.documentId,
//     required this.title,
//     required this.date,
//     required this.attendees,
//     required this.image,
//     required this.venue,
//     required this.description,
//     required this.club,
//     // required this.isDarkMode,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     bool isDarkMode = themeProvider.isDarkMode;

//     return Card(
//       color: isDarkMode ? Colors.grey[900] : Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 4,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertic
//al(top: Radius.circular(10)),
//             child: Image.asset(
//               imageUrl,
//               height: 150,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   height: 150,
//                   color: Colors.grey[300],
//                   child: const Center(child: Text("Image not found")),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   "📅 Date: ${DateFormat('dd MMM yyyy').format(date)}",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//                   ),
//                 ),
//                 Text(
//                   "📍 Location: $venue",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//                   ),
//                 ),
//                 Text(
//                   "👥 Attendees: $attendees",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//                   ),
//                 ),
//                 Text(
//                   "🏷️ Category: $club",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   description,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ViewDetailsScreen(
//                             documentId: documentId, // ✅ Corrected this line
//                             title: title,
//                             date: date,
//                             attendees: attendees,
//                             image: image,
//                             venue: venue,
//                             description: description,
//                             club: club,
//                             organizer: "TechFest Team",
//                             contact: "+1 234 567 890",
//                             website: "https://techfest.com",
//                             schedule:
//                                 "9:00 AM - Registration\n10:00 AM - Keynote\n12:00 PM - Workshop\n3:00 PM - Panel Discussion",
//                             pricing: "Free Entry",
//                             speakers: "John Doe, Jane Smith",
//                             rules:
//                                 "1. No outside food/drinks\n2. Arrive 15 minutes before event\n3. Follow COVID-19 guidelines",
//                             socialMedia:
//                                 "Twitter: @TechFest | Instagram: @TechFest2025",
//                           ),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0XFFbc6c25),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       "View Details",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// HERE 

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../Theme/theme_provider.dart';
// import 'view_detail.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';


// class EventBox extends StatelessWidget {
//   final String documentId;
//   final String title;
//   final DateTime date;
//   final int attendees;
//   final String image;
//   final String venue;
//   final String description;
//   final String club;

//   const EventBox({
//     super.key,
//     required this.documentId,
//     required this.title,
//     required this.date,
//     required this.attendees,
//     required this.image,
//     required this.venue,
//     required this.description,
//     required this.club,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
//     final textColor = isDarkMode ? Colors.white : Colors.black;
//     final subTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

//     return Card(
//       color: isDarkMode ? Colors.grey[900] : Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 5,
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Event Image
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Image.asset(
//               image,
//               height: 170,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   height: 170,
//                   color: Colors.grey[300],
//                   child: const Center(child: Text("Image not found")),
//                 );
//               },
//             ),
//           ),

//           // Event Info
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: textColor,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // Date & Venue
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, size: 16, color: subTextColor),
//                     const SizedBox(width: 6),
//                     Text(
//                       DateFormat('dd MMM yyyy').format(date),
//                       style: TextStyle(fontSize: 14, color: subTextColor),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.location_on, size: 16, color: subTextColor),
//                     const SizedBox(width: 6),
//                     Text(
//                       venue,
//                       style: TextStyle(fontSize: 14, color: subTextColor),
//                     ),
//                   ],
//                 ),

//                 // Attendees & Category
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.people, size: 16, color: subTextColor),
//                     const SizedBox(width: 6),
//                     Text(
//                       '$attendees Attending',
//                       style: TextStyle(fontSize: 14, color: subTextColor),
//                     ),
//                     const SizedBox(width: 12),
//                     Icon(Icons.category, size: 16, color: subTextColor),
//                     const SizedBox(width: 6),
//                     Text(
//                       club,
//                       style: TextStyle(fontSize: 14, color: subTextColor),
//                     ),
//                   ],
//                 ),

//                 // Description
//                 const SizedBox(height: 10),
//                 Text(
//                   description,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(fontSize: 14, color: textColor),
//                 ),

//                 // Button
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: ElevatedButton(
//                     onPressed: () async {
//   try {
//     final docSnapshot = await FirebaseFirestore.instance
//         .collection('events')
//         .doc(documentId)
//         .get();

//     if (docSnapshot.exists) {
//       final data = docSnapshot.data()!;
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ViewDetailsScreen(
//             documentId: documentId,
//             title: title,
//             date: date,
//             attendees: attendees,
//             image: image,
//             venue: venue,
//             description: description,
//             club: club,
//             organizer: data['organizer'] ?? "Not specified",
//             contact: data['contact'] ?? "Not specified",
//             website: data['website'] ?? "N/A",
//             schedule: data['schedule'] ?? "To be announced",
//             pricing: data['pricing'] ?? "Free",
//             speakers: data['speakers'] ?? "TBA",
//             rules: data['rules'] ?? "Standard rules apply",
//             socialMedia: data['socialMedia'] ?? "",
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Event details not found.')),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error loading details: $e')),
//     );
//   }
// },

//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 90, 9, 152),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       "View Details",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'view_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';




class EventBox extends StatefulWidget {
  final String documentId;
  final String title;
  final DateTime date;
  final int attendees;
  final String image;
  final String venue;
  final String description;
  final String club;

  const EventBox({
    super.key,
    required this.documentId,
    required this.title,
    required this.date,
    required this.attendees,
    required this.image,
    required this.venue,
    required this.description,
    required this.club,
  });

  @override
  _EventBoxState createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  // Check if the event is already saved
  Future<void> _checkIfSaved() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        final savedEvents = userDoc.data()?['savedEvents'] ?? [];
        setState(() {
          isSaved = savedEvents.contains(FirebaseFirestore.instance.collection('events').doc(widget.documentId));
        });
      }
    }
  }

  // Method to save or unsave event
  Future<void> _toggleSaveEvent() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      final eventRef = FirebaseFirestore.instance.collection('events').doc(widget.documentId);

      if (isSaved) {
        // Unsave event
        await userRef.update({
          'savedEvents': FieldValue.arrayRemove([eventRef]),
        });
      } else {
        // Save event
        await userRef.update({
          'savedEvents': FieldValue.arrayUnion([eventRef]),
        });
      }

      setState(() {
        isSaved = !isSaved;
      });

      print(isSaved ? 'Event saved successfully!' : 'Event unsaved!');
    } else {
      print('User not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return Card(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              widget.image,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 170,
                  color: Colors.grey[300],
                  child: const Center(child: Text("Image not found")),
                );
              },
            ),
          ),

          // Event Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
  // Title
  Text(
    widget.title,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
  ),

  const SizedBox(height: 6),

  // Date
  Row(
    children: [
      Text("📅", style: TextStyle(fontSize: 18, color: Colors.purple)),
      const SizedBox(width: 6),
      Text(
        DateFormat('dd MMM yyyy').format(widget.date),
        style: TextStyle(fontSize: 15.5, color: textColor.withOpacity(0.85)),
      ),
    ],
  ),

  const SizedBox(height: 3),

  // Venue
  Row(
    children: [
      Text("📍", style: TextStyle(fontSize: 18, color: Colors.purple)),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          widget.venue,
          style: TextStyle(fontSize: 15.5, color: textColor.withOpacity(0.85)),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  ),

  const SizedBox(height: 3),

  // Attendees & Category
  Row(
    children: [
      Text("👥", style: TextStyle(fontSize: 18, color: Colors.purple)),
      const SizedBox(width: 6),
      Text(
        '${widget.attendees} Attending',
        style: TextStyle(fontSize: 15.5, color: textColor.withOpacity(0.85)),
      ),
      const SizedBox(width: 12),
      Text("🏷️", style: TextStyle(fontSize: 18, color: Colors.purple)),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          widget.club,
          style: TextStyle(fontSize: 15.5, color: textColor.withOpacity(0.85)),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  ),

  const SizedBox(height: 6),

  // Description
  Text(
    widget.description,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 15.5,
      color: textColor,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
  ),



                // Buttons (Save and View Details)
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Save Button
                    IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: const Color.fromARGB(255, 72, 4, 117),
                      ),
                      onPressed: _toggleSaveEvent,
                    ),
                    // View Details Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewDetailsScreen(
                              documentId: widget.documentId,
                              title: widget.title,
                              date: widget.date,
                              attendees: widget.attendees,
                              image: widget.image,
                              venue: widget.venue,
                              description: widget.description,
                              club: widget.club,
                              organizer: "TechFest Team",
                              contact: "+1 234 567 890",
                              website: "https://techfest.com",
                              schedule: "9:00 AM - Registration\n10:00 AM - Keynote\n12:00 PM - Workshop\n3:00 PM - Panel Discussion",
                              pricing: "Free Entry",
                              speakers: "John Doe, Jane Smith",
                              rules: "1. No outside food/drinks\n2. Arrive 15 minutes before event\n3. Follow COVID-19 guidelines",
                              socialMedia: "Twitter: @TechFest | Instagram: @TechFest2025",
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 90, 9, 152),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "View Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

