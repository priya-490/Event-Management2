import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewDetailsScreen extends StatefulWidget {
  final String documentId;
  final String title;
  final DateTime date;
  final int attendees;
  final String image;
  final String venue;
  final String description;
  final String club;
  final String organizer;
  final String contact;
  final String website;
  final String schedule;
  final String pricing;
  final String speakers;
  final String rules;
  final String socialMedia;

  const ViewDetailsScreen({
    super.key,
    required this.documentId,
    required this.title,
    required this.date,
    required this.attendees,
    required this.image,
    required this.venue,
    required this.description,
    required this.club,
    required this.organizer,
    required this.contact,
    required this.website,
    required this.schedule,
    required this.pricing,
    required this.speakers,
    required this.rules,
    required this.socialMedia,
  });

  @override
  _ViewDetailsScreenState createState() => _ViewDetailsScreenState();
}

class _ViewDetailsScreenState extends State<ViewDetailsScreen> {
  bool isRegistered = false;
  String? userDocId; // stores the document ID from the 'users' collection

  @override
  void initState() {
    super.initState();
    // _checkIfRegistered();
    _fetchUserDocIdAndCheckRegistration();
  }

  // Future<void> _checkIfRegistered() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;

  //   final userId = user.uid;
  //   final eventSnapshot =
  //       await FirebaseFirestore.instance
  //           .collection('events')
  //           .doc(widget.documentId)
  //           .get();

  //   final participants =
  //       eventSnapshot.data()?['ParticipantsId'] as List<dynamic>?;

  //   if (participants != null && participants.contains(userId)) {
  //     setState(() {
  //       isRegistered = true;
  //     });
  //   }
  // }

  Future<void> _fetchUserDocIdAndCheckRegistration() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    // Get user's document ID from the 'users' collection
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: uid)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      userDocId = querySnapshot.docs.first.id;

      // Check if already registered
      final eventDoc =
          await FirebaseFirestore.instance
              .collection('events')
              .doc(widget.documentId)
              .get();

      final participants = eventDoc.data()?['ParticipantsId'] as List<dynamic>?;

      if (participants != null && participants.contains(userDocId)) {
        setState(() {
          isRegistered = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    // bool isRegistered = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Event Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(child: Text("Image not available")),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Event Title
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // ✅ Event Details
              _buildDetailRow(
                Icons.date_range,
                "Date",
                DateFormat('dd MMM yyyy').format(widget.date),
                isDarkMode,
              ),
              _buildDetailRow(
                Icons.location_on,
                "Location",
                widget.venue,
                isDarkMode,
              ),
              _buildDetailRow(
                Icons.people,
                "Attendees",
                widget.attendees.toString(),
                isDarkMode,
              ),
              _buildDetailRow(
                Icons.category,
                "Category",
                widget.club,
                isDarkMode,
              ),

              const SizedBox(height: 16),

              // ✅ Organizer Info
              _buildSectionHeader("Organizer", isDarkMode),
              _buildDetailRow(
                Icons.person,
                "Organizer",
                widget.organizer,
                isDarkMode,
              ),
              _buildDetailRow(
                Icons.phone,
                "Contact",
                widget.contact,
                isDarkMode,
              ),
              _buildDetailRow(
                Icons.public,
                "Website",
                widget.website,
                isDarkMode,
              ),

              // ✅ Schedule
              _buildSectionHeader("Schedule", isDarkMode),
              Text(widget.schedule, style: _detailTextStyle(isDarkMode)),

              // ✅ Pricing
              _buildSectionHeader("Pricing", isDarkMode),
              Text(widget.pricing, style: _detailTextStyle(isDarkMode)),

              // ✅ Speakers
              _buildSectionHeader("Speakers/Guests", isDarkMode),
              Text(widget.speakers, style: _detailTextStyle(isDarkMode)),

              // ✅ Rules
              _buildSectionHeader("Rules & Guidelines", isDarkMode),
              Text(widget.rules, style: _detailTextStyle(isDarkMode)),

              // ✅ Social Media
              _buildSectionHeader("Follow Us", isDarkMode),
              Text(widget.socialMedia, style: _detailTextStyle(isDarkMode)),

              const SizedBox(height: 20),

              // ✅ Register Button
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       try {
              //         final user = FirebaseAuth.instance.currentUser;
              //         if (user == null) {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             const SnackBar(
              //               content: Text("You must be logged in to register."),
              //             ),
              //           );
              //           return;
              //         }

              //         final userId = user.uid;
              //         final eventRef = FirebaseFirestore.instance
              //             .collection('events')
              //             .doc(widget.documentId);

              //         await eventRef.update({
              //           'ParticipantsId': FieldValue.arrayUnion([userId]),
              //         });

              //         ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(
              //             content: Text(
              //               "Successfully registered for ${widget.title}! 🎉",
              //             ),
              //           ),
              //         );
              //       } catch (e) {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(content: Text("Registration failed: $e")),
              //         );
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(0XFFbc6c25),
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 20,
              //         vertical: 12,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     child: const Text(
              //       "Register Now",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),

              // Center(
              //   child: ElevatedButton(
              //     onPressed:
              //         isRegistered
              //             ? null // Disable if already registered
              //             : () async {
              //               try {
              //                 final user = FirebaseAuth.instance.currentUser;
              //                 if (user == null) {
              //                   ScaffoldMessenger.of(context).showSnackBar(
              //                     const SnackBar(
              //                       content: Text(
              //                         "You must be logged in to register.",
              //                       ),
              //                     ),
              //                   );
              //                   return;
              //                 }

              //                 final userId = user.uid;

              //                 // Push user UID into ParticipantsId array
              //                 final eventRef = FirebaseFirestore.instance
              //                     .collection('events')
              //                     .doc(widget.documentId);

              //                 await eventRef.update({
              //                   'ParticipantsId': FieldValue.arrayUnion([
              //                     userId,
              //                   ]),
              //                 });

              //                 setState(() {
              //                   isRegistered = true;
              //                 });

              //                 ScaffoldMessenger.of(context).showSnackBar(
              //                   SnackBar(
              //                     content: Text(
              //                       "Successfully registered for ${widget.title}! 🎉",
              //                     ),
              //                   ),
              //                 );
              //               } catch (e) {
              //                 ScaffoldMessenger.of(context).showSnackBar(
              //                   SnackBar(
              //                     content: Text("Registration failed: $e"),
              //                   ),
              //                 );
              //               }
              //             },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor:
              //           isRegistered ? Colors.grey : const Color(0XFFbc6c25),
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 20,
              //         vertical: 12,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     child: Text(
              //       isRegistered ? "Registered" : "Register Now",
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 16,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              Center(
                child: ElevatedButton(
                  onPressed:
                      isRegistered
                          ? null
                          : () async {
                            try {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null || userDocId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "You must be logged in to register.",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final eventRef = FirebaseFirestore.instance
                                  .collection('events')
                                  .doc(widget.documentId);

                              await eventRef.update({
                                'ParticipantsId': FieldValue.arrayUnion([
                                  userDocId,
                                ]),
                              });

                              setState(() {
                                isRegistered = true;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Successfully registered for ${widget.title}! 🎉",
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Registration failed: $e"),
                                ),
                              );
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isRegistered ? Colors.grey : const Color(0XFFbc6c25),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isRegistered ? "Registered" : "Register Now",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Detail Row
  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Icon(icon, color: isDarkMode ? Colors.orange[300] : Colors.orange[600]),
        const SizedBox(width: 8),
        Text(
          "$label: $value",
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // 🔹 Section Header
  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.orange[300] : Colors.orange[600],
        ),
      ),
    );
  }

  // 🔹 Detail Text Style
  TextStyle _detailTextStyle(bool isDarkMode) {
    return TextStyle(
      fontSize: 16,
      color: isDarkMode ? Colors.white : Colors.black,
    );
  }
}
