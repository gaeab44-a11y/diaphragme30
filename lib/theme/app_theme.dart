import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // === ESPACEMENTS ===
  static const double spacingXS  = 4.0;
  static const double spacingS   = 8.0;
  static const double spacingM   = 16.0;
  static const double spacingL   = 24.0;
  static const double spacingXL  = 32.0;
  static const double spacingXXL = 48.0;

  // === RAYONS ===
  static const double radiusS    = 10.0;
  static const double radiusM    = 16.0;
  static const double radiusL    = 24.0;
  static const double radiusXL   = 32.0;
  static const double radiusFull = 100.0;

  // === OMBRES ===
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppColors.bluePrimary.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // === THÈME CLAIR ===
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.beige,
      colorScheme: const ColorScheme.light(
        primary: AppColors.bluePrimary,
        secondary: AppColors.sand,
        surface: AppColors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textDark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: AppColors.textDark,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bluePrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusFull),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXL,
            vertical: spacingM,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.bluePrimary,
          side: const BorderSide(color: AppColors.bluePrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusFull),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXL,
            vertical: spacingM,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textMedium,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
        margin: EdgeInsets.zero,
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFFEBE5D8),
        thickness: 1,
        space: 1,
      ),
    );
  }

  // === THÈME SOMBRE ===
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.blueLight,
        secondary: AppColors.sand,
        surface: AppColors.darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.darkText),
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: AppColors.darkText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blueLight,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusFull),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingXL,
            vertical: spacingM,
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
