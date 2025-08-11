import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - More vibrant and accessible
  static const Color primaryColor = Color(0xFF1976D2); // Darker blue for better contrast
  static const Color secondaryColor = Color(0xFFE65100); // Darker orange
  static const Color accentColor = Color(0xFF2E7D32); // Darker green
  
  // Text colors - High contrast for readability
  static const Color textColor = Color(0xFF1A1A1A); // Very dark gray, almost black
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF424242); // Darker gray for better contrast
  static const Color textLightColor = Color(0xFF616161); // Medium gray
  static const Color textWhiteColor = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF); // White text on dark backgrounds
  static const Color textOnLight = Color(0xFF1A1A1A); // Dark text on light backgrounds
  
  // Background colors - Better contrast
  static const Color backgroundColor = Color(0xFFFAFAFA); // Slightly darker white
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF5F5F5); // Light gray surface
  
  // Status colors - More accessible
  static const Color successColor = Color(0xFF2E7D32); // Darker green
  static const Color success = Color(0xFF2E7D32);
  static const Color errorColor = Color(0xFFD32F2F); // Darker red
  static const Color error = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFE65100); // Darker orange
  static const Color warning = Color(0xFFE65100);
  static const Color infoColor = Color(0xFF1976D2); // Darker blue
  
  // Category colors - Better contrast and accessibility
  static const Color mathColor = Color(0xFFC2185B); // Darker pink
  static const Color generalKnowledgeColor = Color(0xFFE65100); // Darker orange
  static const Color scienceColor = Color(0xFF1565C0); // Darker blue
  static const Color historyColor = Color(0xFF5D4037); // Darker brown
  
  // Additional colors for better UI
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0xFF000000);
  static const Color overlayColor = Color(0x80000000);
  
  // Gradients - Better contrast
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryColor, Color(0xFF0D47A1)], // Even darker blue
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryColor, Color(0xFFBF360C)], // Darker orange
  );
  
  // Light gradients for cards
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFF5F5F5)],
  );
  
  // Get category color by name
  static Color getCategoryColorByName(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'math':
        return mathColor;
      case 'general knowledge':
        return generalKnowledgeColor;
      case 'science':
        return scienceColor;
      case 'history':
        return historyColor;
      default:
        return primaryColor;
    }
  }
  
  // Helper method to get text color based on background
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance to determine if background is light or dark
    double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textOnLight : textOnDark;
  }
  
  // Helper method to get contrast color
  static Color getContrastColor(Color color) {
    double luminance = color.computeLuminance();
    return luminance > 0.5 ? textOnLight : textOnDark;
  }
}