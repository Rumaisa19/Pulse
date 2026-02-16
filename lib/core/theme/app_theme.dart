import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _build(isDark: false);
  static ThemeData get darkTheme => _build(isDark: true);

  static ThemeData _build({required bool isDark}) {
    final Color bg = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final Color surface = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final Color textMain = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final Color textSub = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: bg,
      colorSchemeSeed: AppColors.pulseRed,

      // Define text styles for different parts of the app
      textTheme: _textTheme(textMain, textSub),

      appBarTheme: AppBarTheme(
        backgroundColor: bg.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: textMain,
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 1,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceElevated : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.dmSans(color: textSub.withValues(alpha: 0.5)),
      ),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      // Text styles for headlines and body text
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        color: primary,
        height: 1.1,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: primary,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 17,
        height: 1.6,
        color: primary,
        letterSpacing: -0.2,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 15,
        height: 1.5,
        color: secondary,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: primary,
      ),
    );
  }
}
