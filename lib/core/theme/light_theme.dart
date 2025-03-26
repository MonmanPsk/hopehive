import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00A8AA),
        brightness: Brightness.light,
        primary: const Color(0xFF00A8AA),
        surface: Colors.white,
      ),
      fontFamily: GoogleFonts.kanit().fontFamily,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 20),
        titleMedium: TextStyle(fontSize: 16),
        titleSmall: TextStyle(fontSize: 15),
        bodyLarge: TextStyle(fontSize: 14),
        bodyMedium: TextStyle(fontSize: 12),
        bodySmall: TextStyle(fontSize: 9),
        labelLarge: TextStyle(fontSize: 18),
        labelMedium: TextStyle(fontSize: 16),
      ).apply(
        bodyColor: const Color(0xFF2A2A2A),
        displayColor: const Color(0xFF2A2A2A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF00A8AA).withOpacity(0.1),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color(0xFF00A8AA).withOpacity(0.2)),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color(0xFF00A8AA).withOpacity(0.2)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF00A8AA)),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: TextStyle(
          fontSize: 15,
          color: const Color(0xFF696969).withOpacity(0.9),
        ),
        labelStyle: TextStyle(
          fontSize: 15,
          color: const Color(0xFF696969).withOpacity(0.9),
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 15,
          color: Color(0xFF00A8AA),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFF94449)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFF94449)),
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFFF94449),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A8AA),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
