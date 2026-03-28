import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class Spacing {
  Spacing._();
  static const double xs  = 4;
  static const double s   = 8;
  static const double m   = 16;
  static const double l   = 24;
  static const double xl  = 32;
  static const double xxl = 48;
  static const double xxxl = 72;
}

class Radius {
  Radius._();
  static const double s    = 8;
  static const double m    = 14;
  static const double l    = 22;
  static const double xl   = 32;
  static const double full = 100;
}

class AppTheme {
  AppTheme._();

  static List<BoxShadow> glowSage({double opacity = 0.25}) => [
    BoxShadow(
      color: AppColors.sage.withValues(alpha: opacity),
      blurRadius: 32,
      spreadRadius: 0,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> glowAmber({double opacity = 0.2}) => [
    BoxShadow(
      color: AppColors.amber.withValues(alpha: opacity),
      blurRadius: 24,
      spreadRadius: 0,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.night,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.sage,
        secondary: AppColors.amber,
        surface: AppColors.nightMid,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),

      textTheme: GoogleFonts.dmSansTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.cormorantGaramond(
          color: AppColors.textPrimary,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sage,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radius.full),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xl,
            vertical: Spacing.m,
          ),
          minimumSize: const Size(double.infinity, 56),
          textStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: BorderSide(
            color: AppColors.nightBorder,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radius.full),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xl,
            vertical: Spacing.m,
          ),
          minimumSize: const Size(double.infinity, 56),
          textStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          textStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.nightBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
