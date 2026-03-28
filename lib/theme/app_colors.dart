import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === FORÊT — couleur principale ===
  static const Color bluePrimary  = Color(0xFF2C5140); // vert forêt profond
  static const Color blueLight    = Color(0xFF3D7A60); // vert forêt moyen
  static const Color bluePale     = Color(0xFFEAF4F0); // vert fantôme (fonds)

  // === FONDS ===
  static const Color beige        = Color(0xFFF6F1EA); // crème principale
  static const Color white        = Color(0xFFFDFAF6); // surface légère
  static const Color card         = Color(0xFFFFFFFF); // carte blanche pure

  // === SABLE — accent chaud ===
  static const Color sand         = Color(0xFFC49060); // caramel chaud
  static const Color sandLight    = Color(0xFFE8C99A); // sable clair
  static const Color sandPale     = Color(0xFFF5EAD8); // sable très pâle

  // === VERT COMPLÉTION ===
  static const Color greenSoft    = Color(0xFF5A9E78); // complété
  static const Color greenPale    = Color(0xFFD0EDDF); // fond complété

  // === TEXTES ===
  static const Color textDark     = Color(0xFF1A2E22); // texte principal
  static const Color textMedium   = Color(0xFF4A6558); // texte secondaire
  static const Color textLight    = Color(0xFF8EA89D); // texte discret

  // === ÉTATS ===
  static const Color completed    = Color(0xFF5A9E78);
  static const Color locked       = Color(0xFFE0D9D0);
  static const Color lockedText   = Color(0xFFB0A898);
  static const Color active       = Color(0xFF2C5140);

  // === SESSION (fond sombre immersif) ===
  static const Color sessionBg    = Color(0xFF0C1A13);
  static const Color sessionGlow  = Color(0xFF3D7A60);

  // === DÉGRADÉS ===
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF2C5140), Color(0xFF3D7A60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient sessionGradient = LinearGradient(
    colors: [Color(0xFF0C1A13), Color(0xFF142219)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient completionGradient = LinearGradient(
    colors: [Color(0xFF2C5140), Color(0xFF5A9E78)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // === MODE SOMBRE ===
  static const Color darkBackground    = Color(0xFF111A13);
  static const Color darkSurface       = Color(0xFF1A2820);
  static const Color darkCard          = Color(0xFF213328);
  static const Color darkText          = Color(0xFFF0EDE8);
  static const Color darkTextSecondary = Color(0xFF8FA89D);
}
