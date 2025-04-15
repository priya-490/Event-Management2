import 'package:flutter/material.dart';
import '../Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
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
        child: const Text(
          "Here you can add the terms and conditions of your app. \n\nUsers must agree before using the service.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
