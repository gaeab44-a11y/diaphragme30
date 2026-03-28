import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typographie "Nocturne"
/// — Cormorant Garamond : display éditorial, émotionnel
/// — DM Sans : corps lisible, moderne
class AppTextStyles {
  AppTextStyles._();

  // ── DISPLAY (Cormorant — éditorial, premium) ──────────────────────────────

  static TextStyle get displayXL => GoogleFonts.cormorantGaramond(
    fontSize: 54,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.1,
  );

  static TextStyle get displayL => GoogleFonts.cormorantGaramond(
    fontSize: 40,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.15,
  );

  static TextStyle get displayM => GoogleFonts.cormorantGaramond(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static TextStyle get displayS => GoogleFonts.cormorantGaramond(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.3,
  );

  // ── HEADINGS (DM Sans) ────────────────────────────────────────────────────

  static TextStyle get headingL => GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.35,
  );

  static TextStyle get headingM => GoogleFonts.dmSans(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.4,
  );

  // ── BODY (DM Sans) ────────────────────────────────────────────────────────

  static TextStyle get bodyL => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.7,
  );

  static TextStyle get bodyM => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static TextStyle get bodyS => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // ── LABELS ────────────────────────────────────────────────────────────────

  static TextStyle get label => GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 1.8,
    height: 1.4,
  );

  static TextStyle get labelSage => GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.sage,
    letterSpacing: 1.8,
    height: 1.4,
  );

  // ── SESSION (spéciaux) ────────────────────────────────────────────────────

  /// Texte de respiration guidée — lent, suspendu
  static TextStyle get breathe => GoogleFonts.cormorantGaramond(
    fontSize: 26,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: 3.0,
    height: 1.6,
  );

  /// Timer centré sur le cercle
  static TextStyle get timer => GoogleFonts.cormorantGaramond(
    fontSize: 58,
    fontWeight: FontWeight.w200,
    color: AppColors.textPrimary,
    letterSpacing: 4,
    height: 1,
  );

  // ── BOUTONS ───────────────────────────────────────────────────────────────

  static TextStyle get btnL => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static TextStyle get btnM => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );
}
