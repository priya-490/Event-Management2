import 'package:flutter/material.dart';
import '../Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Support"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A0DAD),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Need help?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Contact us at: support@example.com", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Phone: +1 234 567 890", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
