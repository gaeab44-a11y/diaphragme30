import '../models/day_program.dart';

final List<DayProgram> kProgram30Days = [
  // ── SEMAINE 1 : Éveil ────────────────────────────────────────────────────
  DayProgram(
    day: 1,
    title: 'Premier souffle',
    subtitle: 'Semaine 1 — Éveil',
    description:
        'Découvrez votre souffle naturel. Sans forcer, sans modifier — observez simplement ce qui est déjà là.',
    intention: 'Je m\'accueille tel que je suis.',
    pattern: BreathingPattern.coherence,
    cycles: 6,
    totalMinutes: 4,
    status: DayStatus.available,
  ),
  DayProgram(
    day: 2,
    title: 'Le rythme du cœur',
    subtitle: 'Semaine 1 — Éveil',
    description:
        'La cohérence cardiaque synchronise votre système nerveux. Respirez à 6 respirations par minute.',
    intention: 'Je suis en accord avec moi-même.',
    pattern: BreathingPattern.coherence,
    cycles: 10,
    totalMinutes: 5,
  ),
  DayProgram(
    day: 3,
    title: 'Ancrage profond',
    subtitle: 'Semaine 1 — Éveil',
    description:
        'La respiration carrée stabilise le mental. Quatre temps égaux : inspirer, retenir, expirer, retenir.',
    intention: 'Je pose mes fondations.',
    pattern: BreathingPattern.boxBreathing,
    cycles: 6,
    totalMinutes: 5,
  ),
  DayProgram(
    day: 4,
    title: 'Lâcher prise',
    subtitle: 'Semaine 1 — Éveil',
    description:
        'La technique 4-7-8 active le nerf vague et induit un calme profond. Idéale le soir.',
    intention: 'Je relâche ce que je ne contrôle pas.',
    pattern: BreathingPattern.relaxing,
    cycles: 4,
    totalMinutes: 4,
  ),
  DayProgram(
    day: 5,
    title: 'Énergie matinale',
    subtitle: 'Semaine 1 — Éveil',
    description:
        'Réveillez votre corps avec une respiration tonique. Inspirations longues, expirations dynamiques.',
    intention: 'Je choisis ma journée.',
    pattern: BreathingPattern.energizing,
    cycles: 8,
    totalMinutes: 5,
  ),
  DayProgram(
    day: 6,
    title: 'Calme intérieur',
    subtitle: 'Semaine 1 — Éveil',
    description:
        'L\'expiration doublée active la réponse parasympathique. Relâchez les tensions accumulées.',
    intention: 'Je choisis la paix.',
    pattern: BreathingPattern.deepCalm,
    cycles: 6,
    totalMinutes: 5,
  ),
  DayProgram(
    day: 7,
    title: 'Premier bilan',
    subtitle: 'Semaine 1 — Éveil',
    description:
        'Une semaine de pratique. Ressentez la différence. Votre respiration est votre ancre.',
    intention: 'Je reconnais mon chemin parcouru.',
    pattern: BreathingPattern.coherence,
    cycles: 12,
    totalMinutes: 6,
  ),

  // ── SEMAINE 2 : Approfondissement ────────────────────────────────────────
  DayProgram(
    day: 8,
    title: 'Corps & souffle',
    subtitle: 'Semaine 2 — Approfondissement',
    description:
        'Portez attention aux sensations physiques de chaque respiration. Le ventre, la poitrine, les épaules.',
    intention: 'J\'habite mon corps.',
    pattern: BreathingPattern.boxBreathing,
    cycles: 8,
    totalMinutes: 6,
  ),
  DayProgram(
    day: 9,
    title: 'La vague',
    subtitle: 'Semaine 2 — Approfondissement',
    description:
        'Imaginez votre souffle comme une vague — montée progressive, sommet, descente douce.',
    intention: 'Je flue avec la vie.',
    pattern: BreathingPattern.coherence,
    cycles: 12,
    totalMinutes: 6,
  ),
  DayProgram(
    day: 10,
    title: 'Clarté mentale',
    subtitle: 'Semaine 2 — Approfondissement',
    description:
        'L\'hyperventilation contrôlée libère les tensions cognitives. Pratiquez avec douceur.',
    intention: 'Je clarifie mes pensées.',
    pattern: BreathingPattern.energizing,
    cycles: 10,
    totalMinutes: 6,
  ),
  DayProgram(
    day: 11,
    title: 'Sommeil profond',
    subtitle: 'Semaine 2 — Approfondissement',
    description:
        'Préparez votre système nerveux au repos. La technique 4-7-8 en position allongée.',
    intention: 'Je m\'offre le repos.',
    pattern: BreathingPattern.relaxing,
    cycles: 6,
    totalMinutes: 5,
  ),
  DayProgram(
    day: 12,
    title: 'Résilience',
    subtitle: 'Semaine 2 — Approfondissement',
    description:
        'La respiration carré en situation de stress. Votre outil d\'ancrage dans les tempêtes.',
    intention: 'Je suis plus fort que je ne le crois.',
    pattern: BreathingPattern.boxBreathing,
    cycles: 10,
    totalMinutes: 7,
  ),
  DayProgram(
    day: 13,
    title: 'Équilibre',
    subtitle: 'Semaine 2 — Approfondissement',
    description:
        'Alternez cohérence et respiration profonde. Trouvez votre propre rythme naturel.',
    intention: 'Je trouve mon centre.',
    pattern: BreathingPattern.deepCalm,
    cycles: 8,
    totalMinutes: 6,
  ),
  DayProgram(
    day: 14,
    title: 'Mi-parcours',
    subtitle: 'Semaine 2 — Approfondissement',
    description:
        'Deux semaines. Votre pratique prend racine. Célébrez chaque souffle conscient.',
    intention: 'Je célèbre ma constance.',
    pattern: BreathingPattern.coherence,
    cycles: 15,
    totalMinutes: 8,
  ),

  // ── SEMAINE 3 : Transformation ───────────────────────────────────────────
  DayProgram(
    day: 15,
    title: 'L\'éveil du guerrier',
    subtitle: 'Semaine 3 — Transformation',
    description:
        'Technique Wim Hof adaptée. Cycles puissants suivis de rétention. Pour les courageux.',
    intention: 'J\'explore mes limites avec sagesse.',
    pattern: BreathingPattern.wim,
    cycles: 12,
    totalMinutes: 8,
  ),
  DayProgram(
    day: 16,
    title: 'Concentration pure',
    subtitle: 'Semaine 3 — Transformation',
    description:
        'Respiration 4-4-4-4 pendant une tâche cognitive. Découvrez la pleine présence.',
    intention: 'Je suis pleinement là.',
    pattern: BreathingPattern.boxBreathing,
    cycles: 12,
    totalMinutes: 8,
  ),
  DayProgram(
    day: 17,
    title: 'Créativité',
    subtitle: 'Semaine 3 — Transformation',
    description:
        'La cohérence favorise les états alpha. Respirez et laissez les idées émerger.',
    intention: 'Je m\'ouvre à l\'inspiration.',
    pattern: BreathingPattern.coherence,
    cycles: 18,
    totalMinutes: 9,
  ),
  DayProgram(
    day: 18,
    title: 'Guérison',
    subtitle: 'Semaine 3 — Transformation',
    description:
        'L\'expiration longue stimule la récupération cellulaire. Respirez pour vous soigner.',
    intention: 'Je prends soin de moi.',
    pattern: BreathingPattern.deepCalm,
    cycles: 10,
    totalMinutes: 8,
  ),
  DayProgram(
    day: 19,
    title: 'Confiance',
    subtitle: 'Semaine 3 — Transformation',
    description:
        'Inspirations profondes et expansives. Prenez votre place dans l\'espace.',
    intention: 'J\'occupe pleinement ma place.',
    pattern: BreathingPattern.energizing,
    cycles: 12,
    totalMinutes: 8,
  ),
  DayProgram(
    day: 20,
    title: 'Ancêtres du souffle',
    subtitle: 'Semaine 3 — Transformation',
    description:
        'Pranayama modernisé. Chaque culture a sa sagesse du souffle. Vous héritez de toutes.',
    intention: 'Je m\'inscris dans une longue lignée.',
    pattern: BreathingPattern.relaxing,
    cycles: 8,
    totalMinutes: 8,
  ),
  DayProgram(
    day: 21,
    title: 'Trois semaines',
    subtitle: 'Semaine 3 — Transformation',
    description:
        '21 jours : le seuil d\'une habitude. Votre cerveau a commencé à recâbler.',
    intention: 'Je suis en train de changer.',
    pattern: BreathingPattern.coherence,
    cycles: 18,
    totalMinutes: 10,
  ),

  // ── SEMAINE 4 : Maîtrise ─────────────────────────────────────────────────
  DayProgram(
    day: 22,
    title: 'Maître de soi',
    subtitle: 'Semaine 4 — Maîtrise',
    description:
        'Intégrez toutes les techniques. Laissez votre intuition choisir le rythme.',
    intention: 'Je suis mon propre guide.',
    pattern: BreathingPattern.boxBreathing,
    cycles: 15,
    totalMinutes: 10,
  ),
  DayProgram(
    day: 23,
    title: 'Présence totale',
    subtitle: 'Semaine 4 — Maîtrise',
    description:
        'Respiration et pleine conscience. Chaque souffle comme s\'il était le premier.',
    intention: 'Je suis présent, maintenant.',
    pattern: BreathingPattern.coherence,
    cycles: 20,
    totalMinutes: 10,
  ),
  DayProgram(
    day: 24,
    title: 'Gratitude',
    subtitle: 'Semaine 4 — Maîtrise',
    description:
        'Respirez avec gratitude. Pour chaque inspiration — la vie. Pour chaque expiration — le don.',
    intention: 'Je suis reconnaissant d\'exister.',
    pattern: BreathingPattern.deepCalm,
    cycles: 12,
    totalMinutes: 10,
  ),
  DayProgram(
    day: 25,
    title: 'Énergie vitale',
    subtitle: 'Semaine 4 — Maîtrise',
    description:
        'Le prana, le qi, l\'élan vital — quelle que soit sa forme, vous l\'avez cultivé.',
    intention: 'Je rayonne depuis mon centre.',
    pattern: BreathingPattern.wim,
    cycles: 15,
    totalMinutes: 10,
  ),
  DayProgram(
    day: 26,
    title: 'Transmission',
    subtitle: 'Semaine 4 — Maîtrise',
    description:
        'Pratiquez comme si vous l\'enseigniez à quelqu\'un que vous aimez.',
    intention: 'Je partage ce que j\'ai appris.',
    pattern: BreathingPattern.coherence,
    cycles: 20,
    totalMinutes: 10,
  ),
  DayProgram(
    day: 27,
    title: 'L\'avant-dernier',
    subtitle: 'Semaine 4 — Maîtrise',
    description:
        'Presque là. Ressentez la profondeur de votre pratique. Vous avez tenu.',
    intention: 'Je persévère jusqu\'au bout.',
    pattern: BreathingPattern.relaxing,
    cycles: 10,
    totalMinutes: 10,
  ),
  DayProgram(
    day: 28,
    title: 'Intégration',
    subtitle: 'Semaine 4 — Maîtrise',
    description:
        'Quatre semaines de transformation. Laissez tout s\'intégrer dans un silence respiratoire.',
    intention: 'Je suis complet.',
    pattern: BreathingPattern.deepCalm,
    cycles: 15,
    totalMinutes: 12,
  ),

  // ── BONUS ─────────────────────────────────────────────────────────────────
  DayProgram(
    day: 29,
    title: 'Au-delà',
    subtitle: 'Bonus — Transcendance',
    description:
        'Au-delà des 28 jours, vous êtes libre. Cette pratique vous appartient maintenant.',
    intention: 'Je continue, pour moi.',
    pattern: BreathingPattern.coherence,
    cycles: 20,
    totalMinutes: 12,
  ),
  DayProgram(
    day: 30,
    title: 'La renaissance',
    subtitle: 'Bonus — Transcendance',
    description:
        '30 jours. Un nouveau rapport à votre souffle, à votre corps, à vous-même. Bienvenue.',
    intention: 'Je suis né une seconde fois.',
    pattern: BreathingPattern.boxBreathing,
    cycles: 20,
    totalMinutes: 15,
  ),
];
