import 'package:flutter/material.dart';
import 'package:twitter/themes/dark_mode.dart';
import 'package:twitter/themes/light_mode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Durum değiştiğinde dinleyicilere bildirimde bulunur.
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners(); // Durum değiştiğinde dinleyicilere bildirimde bulunur.
  }
}
