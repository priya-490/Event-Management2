import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Import Provider for Theme support
import '../Theme/theme_provider.dart'; // ✅ Import ThemeProvider
import 'package:intl/intl.dart';


class ViewDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // ✅ Get theme state
    bool isDarkMode = themeProvider.isDarkMode;

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
                  image,
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
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // ✅ Event Details Section
              // _buildDetailRow(Icons.date_range, "Date", date, isDarkMode),
              _buildDetailRow(Icons.date_range, "Date", DateFormat('dd MMM yyyy').format(date), isDarkMode),

              _buildDetailRow(
                Icons.location_on,
                "Location",
                venue,
                isDarkMode,
              ),
              _buildDetailRow(Icons.people, "Attendees", attendees.toString(), isDarkMode),
              _buildDetailRow(Icons.category, "Category", club, isDarkMode),
              const SizedBox(height: 16),

              // ✅ Organizer Information
              _buildSectionHeader("Organizer", isDarkMode),
              _buildDetailRow(Icons.person, "Organizer", organizer, isDarkMode),
              _buildDetailRow(Icons.phone, "Contact", contact, isDarkMode),
              _buildDetailRow(Icons.public, "Website", website, isDarkMode),

              // ✅ Event Schedule
              _buildSectionHeader("Schedule", isDarkMode),
              Text(schedule, style: _detailTextStyle(isDarkMode)),

              // ✅ Pricing Information
              _buildSectionHeader("Pricing", isDarkMode),
              Text(pricing, style: _detailTextStyle(isDarkMode)),

              // ✅ Special Guests & Speakers
              _buildSectionHeader("Speakers/Guests", isDarkMode),
              Text(speakers, style: _detailTextStyle(isDarkMode)),

              // ✅ Event Rules & Guidelines
              _buildSectionHeader("Rules & Guidelines", isDarkMode),
              Text(rules, style: _detailTextStyle(isDarkMode)),

              // ✅ Social Media Links
              _buildSectionHeader("Follow Us", isDarkMode),
              Text(socialMedia, style: _detailTextStyle(isDarkMode)),

              const SizedBox(height: 20),

              // ✅ Register Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registered for $title! 🎉")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFFbc6c25), // Button color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
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

  // 🔹 Utility to Build Detail Rows
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

  // 🔹 Section Headers
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
