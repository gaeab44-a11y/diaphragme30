import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // === DISPLAY ===
  static const TextStyle displayLarge = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w300,
    color: AppColors.textDark,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    letterSpacing: -0.3,
    height: 1.25,
  );

  // === HEADINGS ===
  static const TextStyle headingLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: -0.2,
    height: 1.35,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 0,
    height: 1.4,
  );

  // === CORPS ===
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.7,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.5,
    letterSpacing: 0.2,
  );

  // === ÉTIQUETTES ===
  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
    letterSpacing: 1.4,
    height: 1.4,
  );

  // === BOUTONS ===
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // === SPÉCIAUX ===
  static const TextStyle dayNumber = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.bluePrimary,
  );

  static const TextStyle breathingText = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: Color(0xFFF0EDE8),
    letterSpacing: 2.0,
    height: 1.5,
  );

  static const TextStyle timerDisplay = TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.w200,
    color: Color(0xFFF0EDE8),
    letterSpacing: 4,
    height: 1,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    letterSpacing: 0.8,
  );
}
