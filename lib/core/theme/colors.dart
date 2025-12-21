import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF4F46E5);
  static const primaryLight = Color(0xFF818CF8);
  static const primaryDark = Color(0xFF3730A3);
  
  static const secondary = Color(0xFF0D9488);
  static const secondaryLight = Color(0xFF2DD4BF);
  static const secondaryDark = Color(0xFF0F766E);
  
  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);
  
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const surfaceVariant = Color(0xFFF1F5F9);
  
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted = Color(0xFF94A3B8);
  
  static const border = Color(0xFFE2E8F0);
  static const borderFocused = primary;
  
  static const gradientPrimary = [Color(0xFF4F46E5), Color(0xFF7C3AED)];
  static const gradientSecondary = [Color(0xFF0D9488), Color(0xFF06B6D4)];
  
  static Color roleColor(String role) {
    switch (role.toLowerCase()) {
      case 'root':
        return Colors.orange;
      case 'librarian':
        return Colors.green;
      case 'reader':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

