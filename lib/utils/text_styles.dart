import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class TextStyles {
  static TextTheme get textTheme => TextTheme(
    headlineLarge: GoogleFonts.quicksand(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    headlineMedium: GoogleFonts.quicksand(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    titleLarge: GoogleFonts.quicksand(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    bodyLarge: GoogleFonts.quicksand(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),
    bodyMedium: GoogleFonts.quicksand(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),
  );

  // Headline styles with automatic color selection
  static TextStyle get headline => GoogleFonts.quicksand(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnDark,
  );

  static TextStyle get headlineLight => GoogleFonts.quicksand(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnLight,
  );

  // Subtitle styles
  static TextStyle get subtitle => GoogleFonts.quicksand(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
  );

  static TextStyle get subtitleLight => GoogleFonts.quicksand(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnLight,
  );

  // Body styles
  static TextStyle get body => GoogleFonts.quicksand(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textOnDark,
  );

  static TextStyle get bodyLight => GoogleFonts.quicksand(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textOnLight,
  );

  // Caption styles
  static TextStyle get caption => GoogleFonts.quicksand(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textLightColor,
  );

  // Button text styles
  static TextStyle get buttonText => GoogleFonts.quicksand(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
  );

  // Helper method to get text style with appropriate color for background
  static TextStyle getTextStyleForBackground(TextStyle baseStyle, Color backgroundColor) {
    return baseStyle.copyWith(
      color: AppColors.getTextColorForBackground(backgroundColor),
    );
  }
}