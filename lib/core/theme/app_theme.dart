import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.surfaceLight,

      // The "News Hybrid" Text Theme
      textTheme: TextTheme(
        // SPLASH & FEATURED (DAZED Style)
        displayLarge: GoogleFonts.bebasNeue(
          fontSize: 85,
          fontWeight: FontWeight.w900,
          letterSpacing: -2.5, // Tighter for that "Brutal" block look
          height: 0.9,
          color: AppColors.deepInk,
        ),

        // LARGE NUMBERS (The "01", "02" markers)
        displayMedium: GoogleFonts.bebasNeue(
          fontSize: 120,
          letterSpacing: -4.0,
          height: 0.8,
          color: AppColors.deepInk,
        ),

        // NEWS HEADLINES (Poppins for readability)
        titleLarge: GoogleFonts.poppins(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          height: 1.2,
          color: AppColors.deepInk,
        ),

        // CATEGORY LABELS (Wide tracking)
        labelLarge: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.5,
          color: AppColors.deepInk,
        ),

        // ARTICLE BODY
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          height: 1.6,
          color: AppColors.deepInk,
        ),
      ),

      // Clean AppBar for Editorial Look
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
