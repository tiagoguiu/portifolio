import 'package:flutter/material.dart';

/// Application color palette.
abstract final class AppColors {
  // Dark theme surfaces
  static const darkBackground = Color(0xFF0A0E1A);
  static const darkSurface = Color(0xFF111827);
  static const darkCard = Color(0xFF1A2236);
  static const darkBorder = Color(0xFF2D3748);
  static const darkDivider = Color(0xFF1E2A3E);

  // Brand / accent
  static const primary = Color(0xFF7C3AED); // violet-600
  static const primaryLight = Color(0xFFA78BFA); // violet-400
  static const accent = Color(0xFF06B6D4); // cyan-500
  static const accentLight = Color(0xFF67E8F9); // cyan-300
  static const gradientStart = Color(0xFF7C3AED);
  static const gradientEnd = Color(0xFF06B6D4);

  // Status
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);

  // Dark text
  static const darkTextPrimary = Color(0xFFF1F5F9);
  static const darkTextSecondary = Color(0xFF94A3B8);
  static const darkTextMuted = Color(0xFF475569);

  // Light theme surfaces
  static const lightBackground = Color(0xFFF8FAFF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFF1F5FB);
  static const lightBorder = Color(0xFFE2E8F0);

  // Light text
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF475569);
  static const lightTextMuted = Color(0xFF94A3B8);

  // Shared
  static const white = Color(0xFFFFFFFF);
  static const transparent = Colors.transparent;

  static const LinearGradient brandGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
