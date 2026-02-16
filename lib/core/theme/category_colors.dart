import 'package:flutter/material.dart';

class CategoryColors {
  CategoryColors._();

  static const Color _defaultGrey = Color(0xFF8E8E93);

  // Map for color lookup based on category names
  static const Map<String, Color> _mainColors = {
    'news': Color(0xFF1C1C1E),

    'world': Color(0xFF0A84FF),

    'technology': Color(0xFF5E5CE6),

    'business': Color(0xFFFD940A), // Sunset Orange for business

    'sport': Color.fromARGB(
      255,
      31,
      84,
      39,
    ), // High visibility green for sports

    'politics': Color(0xFF004A99), // Lighter Cyan for politics

    'culture': Color(0xFFBF5AF2), // Orchid Purple for culture
  };

  static Color getColor(String? category, {bool isDark = false}) {
    if (category == null) return _defaultGrey;

    final normalized = category.toLowerCase().trim();
    final baseColor = _mainColors[normalized] ?? _defaultGrey;

    if (!isDark) return baseColor;

    final hsl = HSLColor.fromColor(baseColor);
    return hsl.withLightness((hsl.lightness + 0.15).clamp(0.0, 0.9)).toColor();
  }

  static Color getSurface(String? category, {bool isDark = false}) {
    final color = getColor(category, isDark: isDark);
    return color.withValues(alpha: isDark ? 0.25 : 0.12);
  }
}
