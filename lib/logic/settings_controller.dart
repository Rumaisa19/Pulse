import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_news/providers/theme_provider.dart';

class SettingsController {
  final BuildContext context;

  SettingsController(this.context);

  // Read current theme state
  bool get isDarkMode => context.watch<ThemeProvider>().isDark;

  // Toggle theme action
  void toggleTheme() {
    context.read<ThemeProvider>().toggle();
  }

  // Navigation
  void goBack() {
    context.pop();
  }

  // Versioning info logic
  String get appVersion => '1.0.0';
  String get dataSource => 'The Guardian API';
}
