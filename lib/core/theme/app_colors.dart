import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Brand Colors ---
  static const Color pulseRed = Color(0xFFD62828); // Primary brand color for news
  static const Color pulseRedBright = Color(0xFFFF4D58); // Bright variant of brand color
  static const Color pulseRedMuted = Color(0x1AD62828); // Muted variant for subtle use

  // --- Light Theme Colors ---
  static const Color lightBackground = Color(0xFFF9F9FB); // Light background for a clean look
  static const Color lightSurface = Color(0xFFFFFFFF); // Surface color for cards and dialogs
  static const Color lightDivider = Color(0xFFEBEBEF); // Divider color for separation

  static const Color lightTextPrimary = Color(0xFF121212); // Primary text color for readability
  static const Color lightTextSecondary = Color(0xFF4A4A4A); // Secondary text color for less emphasis
  static const Color lightTextTertiary = Color(0xFF8E8E93); // Tertiary text color for muted text

  // --- Dark Theme Colors ---
  static const Color darkBackground = Color(0xFF0D0D0E); // Dark background for a premium feel
  static const Color darkSurface = Color(0xFF161618); // Surface color for dark theme elements
  static const Color darkSurfaceElevated = Color(0xFF1C1C1E); // Elevated surface color for depth
  static const Color darkDivider = Color(0xFF252525); // Divider color for dark theme

  static const Color darkTextPrimary = Color(0xFFF2F2F7); // Primary text color for dark theme
  static const Color darkTextSecondary = Color(0xFFADADAF); // Secondary text color for dark theme
  static const Color darkTextTertiary = Color(0xFF636366); // Tertiary text color for dark theme

  // --- Glassmorphism Colors ---
  static const Color glassLight = Color(0xB3FFFFFF); // Light glass effect with 70% opacity
  static const Color glassDark = Color(0x99161618); // Dark glass effect with 60% opacity
  static const Color glassBorderLight = Color(0x33FFFFFF); // Light border for glass elements
  static const Color glassBorderDark = Color(0x1AFFFFFF); // Dark border for glass elements

  static const double blurStrong = 25.0; // Blur intensity for glassmorphism effect

  // --- Image Overlay Colors ---
  static const List<Color> cardOverlay = [
    Color(0x00000000), // Transparent overlay
    Color(0x22000000), // Semi-transparent overlay for depth
    Color(0xCC000000), // Heavy shadow for text legibility
  ];
}
