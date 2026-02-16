import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const _boxName = 'settings';
  static const _key = 'isDarkMode';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _load();
  }

  void _load() {
    final box = Hive.box(_boxName);
    final saved = box.get(_key);
    if (saved != null) {
      _themeMode = (saved as bool) ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  Future<void> toggle() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await Hive.box(_boxName).put(_key, isDark);
  }
}
