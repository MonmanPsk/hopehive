import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF00A8AA),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF00A8AA).withOpacity(0.1),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color(0xFF00A8AA).withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color(0xFF00A8AA).withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00A8AA)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintStyle: TextStyle(
          fontSize: 15,
          color: const Color(0xFF696969).withOpacity(0.9),
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
