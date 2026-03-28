import 'package:flutter/material.dart';

/// Palette "Nocturne" — premium, immersive, sensorielle
class AppColors {
  AppColors._();

  // ── FONDS SOMBRES (dark-first) ─────────────────────────────────────────────
  static const Color night         = Color(0xFF080F18); // fond principal
  static const Color nightMid      = Color(0xFF0C1620); // surfaces
  static const Color nightElevated = Color(0xFF122030); // cartes élevées
  static const Color nightBorder   = Color(0xFF1E3048); // bordures subtiles

  // ── SAGE (vert respiration) ────────────────────────────────────────────────
  static const Color sage          = Color(0xFF7DB5A8); // accent principal
  static const Color sageDim       = Color(0xFF4D8878); // sage sombre/actif
  static const Color sagePale      = Color(0xFFC4DDD8); // sage pâle
  static const Color sageGhost     = Color(0xFF1A3530); // sage sur fond nuit

  // ── AMBER (chaleur / complétion) ──────────────────────────────────────────
  static const Color amber         = Color(0xFFC8926A); // accent chaud
  static const Color amberPale     = Color(0xFFEDD8C4); // amber pâle
  static const Color amberGhost    = Color(0xFF2A1E14); // amber sur fond nuit

  // ── TEXTES ────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFEDE7DC); // blanc chaud (fond sombre)
  static const Color textSecondary = Color(0xFF6E8499); // gris-bleu moyen
  static const Color textMuted     = Color(0xFF384D5C); // très subtil
  static const Color textOnLight   = Color(0xFF0F1E2A); // texte sur fond clair

  // ── CLAIRS (quelques écrans) ──────────────────────────────────────────────
  static const Color cream         = Color(0xFFF5F0E8); // fond crème
  static const Color ivory         = Color(0xFFFAFAF5); // surface ivoire
  static const Color sand          = Color(0xFFE8D8BC); // sable chaud

  // ── ÉTATS ────────────────────────────────────────────────────────────────
  static const Color completed     = Color(0xFF5A9E82); // jour complété
  static const Color completedBg   = Color(0xFF152E24); // fond complété
  static const Color locked        = Color(0xFF1A2A38); // jour verrouillé
  static const Color lockedText    = Color(0xFF2E4560); // texte verrouillé

  // ── DÉGRADÉS ─────────────────────────────────────────────────────────────
  static const LinearGradient nightGradient = LinearGradient(
    colors: [Color(0xFF080F18), Color(0xFF0C1A28)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient sageGradient = LinearGradient(
    colors: [Color(0xFF2D6858), Color(0xFF4D9888)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFF8A4E2A), Color(0xFFC8926A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient breathGlow = RadialGradient(
    colors: [Color(0x407DB5A8), Color(0x007DB5A8)],
    radius: 0.8,
  );
}
