import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextTheme get textTheme => TextTheme(
    headlineLarge: GoogleFonts.quicksand(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.quicksand(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.quicksand(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.quicksand(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.quicksand(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  );

  static TextStyle get headline => GoogleFonts.quicksand(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get subtitle => GoogleFonts.quicksand(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get body => GoogleFonts.quicksand(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
}