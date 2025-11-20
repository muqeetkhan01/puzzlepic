import 'package:flutter/material.dart';

class AppColors {
  // Background gradient (exact Figma Indigo → Purple → Pink)
  static const List<Color> backgroundGradient = [
    Color(0xFF312E81), // Indigo-900
    Color(0xFF581C87), // Purple-900
    Color(0xFF831843), // Pink-900
  ];

  // Logo gradient (Blue → Purple → Pink)
  static const List<Color> logoGradient = [
    Color(0xFF60A5FA), // Blue-400
    Color(0xFFA855F7), // Purple-500
    Color(0xFFEC4899), // Pink-500
  ];

  // Login Button Gradient
  static const List<Color> loginButtonGradient = [
    Color(0xFF3B82F6), // Blue-500
    Color(0xFF2563EB), // Blue-600
  ];

  // Signup Button Gradient
  static const List<Color> signupButtonGradient = [
    Color(0xFFA855F7), // Purple-500
    Color(0xFF9333EA), // Purple-600
  ];

  // Opacity whites
  static Color white10 = Colors.white.withOpacity(0.10);
  static Color white20 = Colors.white.withOpacity(0.20);
  static Color white40 = Colors.white.withOpacity(0.40);
  static Color white50 = Colors.white.withOpacity(0.50);
  static Color white70 = Colors.white.withOpacity(0.70);

  static const Color white = Colors.white;
}
