import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Centralized theme configuration.
abstract final class AppTheme {
  static TextTheme get _textTheme => TextTheme(
    displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.w700, letterSpacing: -1.5),
    displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.w700, letterSpacing: -0.5),
    displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w600),
    headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700),
    headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4),
    labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  );

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: Color(0xFF4C1D95),
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.accent,
      onSecondary: AppColors.darkBackground,
      secondaryContainer: Color(0xFF0E7490),
      onSecondaryContainer: AppColors.accentLight,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkCard,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkDivider,
      error: Color(0xFFEF4444),
      onError: AppColors.white,
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: Color(0xFFFCA5A5),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _textTheme.apply(bodyColor: AppColors.darkTextPrimary, displayColor: AppColors.darkTextPrimary),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCard,
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.accent),
        side: const BorderSide(color: AppColors.darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: Color(0xFFEDE9FE),
      onPrimaryContainer: Color(0xFF4C1D95),
      secondary: AppColors.accent,
      onSecondary: AppColors.white,
      secondaryContainer: Color(0xFFCFFAFE),
      onSecondaryContainer: Color(0xFF0E7490),
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightCard,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightBorder,
      outlineVariant: Color(0xFFF1F5F9),
      error: Color(0xFFEF4444),
      onError: AppColors.white,
      errorContainer: Color(0xFFFEE2E2),
      onErrorContainer: Color(0xFF7F1D1D),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: _textTheme.apply(bodyColor: AppColors.lightTextPrimary, displayColor: AppColors.lightTextPrimary),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
        shadowColor: const Color(0x0F000000),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.lightBorder, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightCard,
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary),
        side: const BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }
}
