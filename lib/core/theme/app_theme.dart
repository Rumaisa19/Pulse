import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.surfaceLight,

      // Setting up the global Text Theme
      textTheme: TextTheme(
        // For the Big Logo/Splash
        displayLarge: GoogleFonts.bebasNeue(
          fontSize: 85,
          fontWeight: FontWeight.w900,
          color: AppColors.deepInk,
        ),
        // For Headlines
        titleLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.deepInk,
        ),
        // For Body Text
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: AppColors.deepInk),
      ),
    );
  }
}
