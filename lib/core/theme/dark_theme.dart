import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF00A8AA),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      fontFamily: GoogleFonts.kanit().fontFamily,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 36),
        displayMedium: TextStyle(fontSize: 32),
        displaySmall: TextStyle(fontSize: 24),
        titleLarge: TextStyle(fontSize: 20),
        titleMedium: TextStyle(fontSize: 16),
        titleSmall: TextStyle(fontSize: 15),
        bodyLarge: TextStyle(fontSize: 14),
        bodyMedium: TextStyle(fontSize: 12),
        bodySmall: TextStyle(fontSize: 9),
        labelLarge: TextStyle(fontSize: 18),
        labelMedium: TextStyle(fontSize: 16),
      ),
    );
  }
}
