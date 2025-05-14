import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary colors
  static const Color gold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFF5E7A9);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color lightSilver = Color(0xFFE6E6E6);
  
  // Background colors
  static const Color white = Color(0xFFFAFAFA);
  static const Color charcoal = Color(0xFF2D2D2D);
  
  // Text colors
  static const Color darkText = Color(0xFF1A1A1A);
  static const Color lightText = Color(0xFFF5F5F5);
  
  // Accent colors
  static const Color accentBlue = Color(0xFF3E5C76);
  static const Color accentGreen = Color(0xFF5B8A72);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, lightGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient silverGradient = LinearGradient(
    colors: [silver, lightSilver],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Theme data
  static ThemeData lightTheme = ThemeData(
    primaryColor: gold,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.light(
      primary: gold,
      secondary: silver,
      tertiary: accentBlue,
      surface: white,
      background: white,
      onPrimary: charcoal,
      onSecondary: charcoal,
      onSurface: darkText,
      onBackground: darkText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      foregroundColor: darkText,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        color: darkText,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        color: darkText,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        color: darkText,
      ),
      headlineMedium: GoogleFonts.montserrat(
        color: darkText,
      ),
      bodyLarge: GoogleFonts.montserrat(
        color: darkText,
      ),
      bodyMedium: GoogleFonts.montserrat(
        color: darkText,
      ),
    ),
  );
} 