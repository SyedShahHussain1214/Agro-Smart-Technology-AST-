import 'package:flutter/material.dart';

class AppTheme {
  // Website-inspired color palette
  static const Color primary = Color(0xFF2E7D32); // Green
  static const Color secondary = Color(0xFF1B5E20); // Darker green
  static const Color accent = Color(0xFFFFC107); // Amber accents for CTA
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF121212);

  // Shared text theme using Poppins, with Urdu titles able to use NotoNastaliq
  static const String defaultFont = 'Poppins';

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true).copyWith(
      // Set default app font at ThemeData level
      textTheme: ThemeData.light(useMaterial3: true).textTheme.apply(fontFamily: defaultFont),
    );
    return base.copyWith(
      primaryColor: primary,
      scaffoldBackgroundColor: surfaceLight,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: accent,
        surface: surfaceLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true).copyWith(
      // Set default app font at ThemeData level
      textTheme: ThemeData.dark(useMaterial3: true).textTheme.apply(fontFamily: defaultFont),
    );
    return base.copyWith(
      primaryColor: primary,
      scaffoldBackgroundColor: surfaceDark,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: accent,
        surface: surfaceDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
