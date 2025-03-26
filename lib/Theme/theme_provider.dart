import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // ✅ Private variable to store theme state

  bool get isDarkMode => _isDarkMode; // ✅ Public getter for isDarkMode

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // ✅ Notify UI when theme changes
  }
}
