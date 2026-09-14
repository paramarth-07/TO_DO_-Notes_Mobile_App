import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens conforming to Warm Minimal Tactile (DESIGN.md & screen.png)
class AppColors {
  // Background & Surfaces
  static const Color background = Color(0xFFF7F7F5);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF4F4F2);
  static const Color surfaceContainerHigh = Color(0xFFEAEAE6);

  // Ink Typography
  static const Color onSurface = Color(0xFF141414);
  static const Color onSurfaceVariant = Color(0xFF7A7A78);
  static const Color outlineSubtle = Color(0xFFEDEDE8);

  // Flame Orange Accents
  static const Color primary = Color(0xFFF36C21);
  static const Color primaryContainer = Color(0xFFF36C21);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primarySubtle = Color(0x1AF36C21); // 10% opacity

  // Dark Selection Pill
  static const Color darkPill = Color(0xFF1A1A1A);

  // Priority Palettes
  static const Color priorityHighBg = Color(0xFFFFF1F0);
  static const Color priorityHighText = Color(0xFFDC2626);
  static const Color priorityHighBorder = Color(0xFFFECDD3);

  static const Color priorityMedBg = Color(0xFFFFF7ED);
  static const Color priorityMedText = Color(0xFFD97706);
  static const Color priorityMedBorder = Color(0xFFFED7AA);

  static const Color priorityLowBg = Color(0xFFF0FDF4);
  static const Color priorityLowText = Color(0xFF16A34A);
  static const Color priorityLowBorder = Color(0xFFBBF7D0);

  // Shadows
  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: Color.fromRGBO(20, 20, 20, 0.03),
          offset: Offset(0, 4),
          blurRadius: 16,
        ),
        const BoxShadow(
          color: Color.fromRGBO(20, 20, 20, 0.01),
          offset: Offset(0, 1),
          blurRadius: 4,
        ),
      ];

  static List<BoxShadow> get fabShadow => [
        const BoxShadow(
          color: Color.fromRGBO(243, 108, 33, 0.35),
          offset: Offset(0, 8),
          blurRadius: 20,
        ),
      ];
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        surface: AppColors.surfaceCard,
        onSurface: AppColors.onSurface,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
          letterSpacing: -0.8,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
          letterSpacing: -0.3,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.surfaceContainerHigh, width: 1),
        ),
      ),
    );
  }
}
