import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Import Provider
import '../Theme/theme_provider.dart'; // ✅ Import ThemeProvider
import 'view_detail.dart'; // ✅ Import ViewDetailsScreen

class EventBox extends StatelessWidget {
  final String title;
  final String date;
  final String attendees;
  final String image;
  final String location;
  final String description;
  final String category;

  const EventBox({
    super.key,
    required this.title,
    required this.date,
    required this.attendees,
    required this.image,
    required this.location,
    required this.description,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // ✅ Get theme state
    bool isDarkMode = themeProvider.isDarkMode;

    return Card(
      color:
          isDarkMode
              ? Colors.grey[900]
              : Colors.white, // ✅ Theme-aware card color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: Text("Image not found")),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        isDarkMode
                            ? Colors.white
                            : Colors.black, // ✅ Theme-aware text color
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "📅 Date: $date",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                Text(
                  "📍 Location: $location",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                Text(
                  "👥 Attendees: $attendees",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                Text(
                  "🏷️ Category: $category",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ Navigate to ViewDetailsScreen with additional information
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ViewDetailsScreen(
                                title: title,
                                date: date,
                                attendees: attendees,
                                image: image,
                                location: location,
                                description: description,
                                category: category,
                                organizer:
                                    "TechFest Team", // ✅ Example organizer
                                contact:
                                    "+1 234 567 890", // ✅ Example contact info
                                website:
                                    "https://techfest.com", // ✅ Example website
                                schedule:
                                    "9:00 AM - Registration\n10:00 AM - Keynote\n12:00 PM - Workshop\n3:00 PM - Panel Discussion", // ✅ Example schedule
                                pricing: "Free Entry", // ✅ Example pricing
                                speakers:
                                    "John Doe, Jane Smith", // ✅ Example speakers
                                rules:
                                    "1. No outside food/drinks\n2. Arrive 15 minutes before event\n3. Follow COVID-19 guidelines", // ✅ Example rules
                                socialMedia:
                                    "Twitter: @TechFest | Instagram: @TechFest2025", // ✅ Example social media
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFFbc6c25), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        color:
                            Colors.white, // ✅ White text for better visibility
                        fontWeight: FontWeight.bold, // Optional: Make it bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
