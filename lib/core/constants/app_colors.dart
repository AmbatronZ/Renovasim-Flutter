import 'package:flutter/material.dart';

class AppColors {
  // Static colors - always same
  static const coconutGreen = Color(0xFF8BA023);
  static const thatchGreen = Color(0xFF3B411E);
  
  // Dynamic colors based on theme
  static Color scaffoldBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF5F5F5);
  }

  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2A2A)
        : Colors.white;
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF2C2C2B);
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFB0B0B0)
        : const Color(0xFF747473);
  }

  static Color dividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF0F0F0);
  }

  static Color shadowColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withOpacity(0.3)
        : const Color(0xFF2C2C2B).withOpacity(0.07);
  }

  // Legacy static colors for backward compatibility
  static const zenGray = Color(0xFF747473);
  static const metallicBlack = Color(0xFF2C2C2B);
  static const techWhite = Color(0xFFF5F5F5);
  static const white = Colors.white;
}