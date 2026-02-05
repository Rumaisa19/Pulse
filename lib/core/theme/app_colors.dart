import 'package:flutter/material.dart';

class AppColors {
  // 1. BRANDING & ACCENTS
  static const Color accentPink = Color(0xFFFF4081); // The "Magaz" dot color
  static const Color deepInk = Color(0xFF000000);   // For that brutalist black
  static const Color ghostWhite = Color(0xFFFDFCFB); // "Warm Paper" for news reading

  // 2. DYNAMIC GRADIENTS (For the "Magazine Cover" feel)
  // Peach set for "Technology" or "Featured"
  static const List<Color> peachGradient = [
    Color(0xFFFFF5EE),
    Color(0xFFFFDCC9),
    Color(0xFFFFB899),
  ];

  // Pink set for "Fashion" or "Breaking"
  static const List<Color> pinkGradient = [
    Color(0xFFFFCDD2),
    Color(0xFFEF5350),
    Color(0xFFC62828),
  ];

  // 3. UI SURFACES
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color textSecondary = Color(0xFF666666);
}