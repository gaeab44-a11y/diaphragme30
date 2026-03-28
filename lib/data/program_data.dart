import '../models/day_program.dart';

/// Liste complète des 30 jours du programme.
/// Progression logique : découverte → conscience → approfondissement → ancrage.
/// Seul le jour 1 est déverrouillé par défaut.
class ProgramData {
  ProgramData._();

  static const List<DayProgram> days = [

    // ─── SEMAINE 1 : DÉCOUVERTE (jours 1–7) ───────────────────────────────────

    DayProgram(
      id: 1,
      title: 'Premier contact',
      durationMinutes: 5,
      posture: 'Allongé sur le dos, jambes légèrement repliées',
      instruction:
          'Pose une main sur ton ventre.\n\n'
          'Ferme les yeux doucement.\n\n'
          'Respire normalement… sans forcer.\n\n'
          'Observe simplement ce qui se passe sous ta main.\n\n'
          'Tu fais bien.',
      feelingGoal: 'Sentir un léger mouvement sous ta main',
      isUnlocked: true,
    ),

    DayProgram(
      id: 2,
      title: 'Observer sans changer',
      durationMinutes: 5,
      posture: 'Allongé sur le dos, jambes légèrement repliées',
      instruction:
          'Replace ta main sur ton ventre.\n\n'
          'Cette fois, observe sans essayer de modifier ta respiration.\n\n'
          'Ton ventre monte-t-il à l\'inspiration ?\n\n'
          'Descend-il à l\'expiration ?\n\n'
          'Prends ton temps.',
      feelingGoal: 'Remarquer le rythme naturel de ton ventre',
    ),

    DayProgram(
      id: 3,
      title: 'Laisser descendre',
      durationMinutes: 6,
      posture: 'Allongé sur le dos, jambes légèrement repliées',
      instruction:
          'À chaque inspiration, laisse ton ventre se gonfler doucement.\n\n'
          'Imagine qu\'il se remplit d\'air comme un ballon.\n\n'
          'À l\'expiration, laisse-le redescendre tout seul.\n\n'
          'Pas d\'effort. Juste laisser faire.',
      feelingGoal: 'Sentir le ventre se gonfler à l\'inspiration',
    ),

    DayProgram(
      id: 4,
      title: 'La pause naturelle',
      durationMinutes: 6,
      posture: 'Allongé sur le dos, jambes légèrement repliées',
      instruction:
          'Respire doucement vers le ventre.\n\n'
          'Après chaque expiration, remarque la petite pause naturelle.\n\n'
          'Ce silence entre deux souffles… c\'est ton diaphragme au repos.\n\n'
          'Observe-le sans le prolonger.',
      feelingGoal: 'Percevoir la pause naturelle entre les souffles',
    ),

    DayProgram(
      id: 5,
      title: 'Les deux mains',
      durationMinutes: 7,
      posture: 'Allongé sur le dos',
      instruction:
          'Place une main sur le ventre, une main sur la poitrine.\n\n'
          'Respire normalement.\n\n'
          'Quelle main bouge en premier ?\n\n'
          'L\'idéal : la main du ventre monte avant celle de la poitrine.\n\n'
          'Observe sans juger.',
      feelingGoal: 'Distinguer le mouvement du ventre de celui de la poitrine',
    ),

    DayProgram(
      id: 6,
      title: 'Ralentir l\'expiration',
      durationMinutes: 7,
      posture: 'Allongé sur le dos',
      instruction:
          'Inspire doucement vers le ventre.\n\n'
          'Expire… en laissant l\'air sortir très lentement.\n\n'
          'Comme si tu soufflais sur une bougie sans l\'éteindre.\n\n'
          'Tu fais bien. Continue à ce rythme.',
      feelingGoal: 'Sentir une légère détente à chaque expiration lente',
    ),

    DayProgram(
      id: 7,
      title: 'Bilan de la semaine',
      durationMinutes: 8,
      posture: 'Allongé sur le dos, position confortable',
      instruction:
          'C\'est ta septième séance. Tu progresses.\n\n'
          'Respire vers le ventre, à ton rythme.\n\n'
          'Rappelle-toi ce que tu as ressenti cette semaine.\n\n'
          'Chaque respiration compte. Même les imparfaites.\n\n'
          'Tu fais bien.',
      feelingGoal: 'Retrouver facilement la respiration abdominale',
    ),

    // ─── SEMAINE 2 : CONSCIENCE (jours 8–14) ──────────────────────────────────

    DayProgram(
      id: 8,
      title: 'Assis, en douceur',
      durationMinutes: 7,
      posture: 'Assis sur une chaise, dos droit, pieds à plat',
      instruction:
          'Assieds-toi confortablement.\n\n'
          'Pose une main sur le ventre.\n\n'
          'Retrouve la respiration abdominale dans cette position.\n\n'
          'C\'est un peu différent qu\'allongé. C\'est normal.\n\n'
          'Prends le temps qu\'il faut.',
      feelingGoal: 'Retrouver le souffle abdominal en position assise',
    ),

    DayProgram(
      id: 9,
      title: 'Le compte de 4',
      durationMinutes: 8,
      posture: 'Assis confortablement',
      instruction:
          'Inspire en comptant mentalement jusqu\'à 4.\n\n'
          'Expire en comptant jusqu\'à 4.\n\n'
          'Rythme lent et régulier.\n\n'
          'Si tu perds le compte, recommence simplement.\n\n'
          'Respire doucement.',
      feelingGoal: 'Trouver un rythme régulier et apaisant',
    ),

    DayProgram(
      id: 10,
      title: 'Expirer plus longtemps',
      durationMinutes: 8,
      posture: 'Assis confortablement',
      instruction:
          'Inspire en comptant jusqu\'à 4.\n\n'
          'Expire en comptant jusqu\'à 6.\n\n'
          'L\'expiration plus longue calme le système nerveux.\n\n'
          'Pas besoin de forcer. Juste laisser sortir l\'air.',
      feelingGoal: 'Ressentir un calme progressif à l\'expiration',
    ),

    DayProgram(
      id: 11,
      title: 'Conscience du dos',
      durationMinutes: 8,
      posture: 'Assis, dos légèrement écarté du dossier',
      instruction:
          'Place une main dans le bas du dos.\n\n'
          'À l\'inspiration, sens ton dos se dilater légèrement.\n\n'
          'Le diaphragme pousse aussi vers l\'arrière.\n\n'
          'Observe ce mouvement discret. C\'est ton corps qui respire pleinement.',
      feelingGoal: 'Sentir la respiration s\'étendre vers le dos',
    ),

    DayProgram(
      id: 12,
      title: 'Respirer debout',
      durationMinutes: 7,
      posture: 'Debout, pieds écartés à la largeur des hanches',
      instruction:
          'Tiens-toi debout, bras relâchés.\n\n'
          'Retrouve la respiration abdominale dans cette position.\n\n'
          'Laisse tes épaules descendre à chaque expiration.\n\n'
          'Tu peux fermer les yeux si tu le souhaites.',
      feelingGoal: 'Respirer avec le ventre même en étant debout',
    ),

    DayProgram(
      id: 13,
      title: 'Le soupir libérateur',
      durationMinutes: 7,
      posture: 'Assis ou debout, comme tu préfères',
      instruction:
          'Inspire profondément vers le ventre.\n\n'
          'Expire en laissant échapper un long soupir… haaaaah.\n\n'
          'Laisse sortir toute la tension.\n\n'
          'Recommence 5 fois.\n\n'
          'Tu fais bien.',
      feelingGoal: 'Sentir une vraie décompression à chaque soupir',
    ),

    DayProgram(
      id: 14,
      title: 'Bilan de la semaine',
      durationMinutes: 10,
      posture: 'Position de ton choix',
      instruction:
          'Deux semaines derrière toi. Tu construis quelque chose.\n\n'
          'Respire à ton rythme naturel, avec conscience.\n\n'
          'Remarque comme c\'est différent de ta toute première séance.\n\n'
          'Ton diaphragme travaille. Ton corps apprend.\n\n'
          'Continue.',
      feelingGoal: 'Constater sa propre progression',
    ),

    // ─── SEMAINE 3 : APPROFONDISSEMENT (jours 15–21) ──────────────────────────

    DayProgram(
      id: 15,
      title: 'La vague',
      durationMinutes: 10,
      posture: 'Allongé sur le dos',
      instruction:
          'Imagine une vague qui part du ventre.\n\n'
          'À l\'inspiration : le ventre monte, puis les côtes s\'ouvrent.\n\n'
          'À l\'expiration : les côtes se ferment, le ventre descend.\n\n'
          'Un mouvement fluide, comme une vague sur l\'océan.',
      feelingGoal: 'Sentir une respiration en vague de bas en haut',
    ),

    DayProgram(
      id: 16,
      title: 'L\'ouverture latérale',
      durationMinutes: 10,
      posture: 'Allongé sur le dos',
      instruction:
          'Place tes mains sur les côtés de la cage thoracique.\n\n'
          'À l\'inspiration, sens tes côtes s\'écarter vers l\'extérieur.\n\n'
          'Comme un accordéon qui s\'ouvre.\n\n'
          'Expire doucement. Les côtes se rapprochent.',
      feelingGoal: 'Percevoir l\'expansion latérale des côtes',
    ),

    DayProgram(
      id: 17,
      title: 'Respiration 4-6-8',
      durationMinutes: 10,
      posture: 'Assis confortablement',
      instruction:
          'Inspire en comptant jusqu\'à 4.\n\n'
          'Retiens doucement jusqu\'à 6.\n\n'
          'Expire lentement jusqu\'à 8.\n\n'
          'Ce rythme active profondément le système de calme.\n\n'
          'Va à ton propre rythme.',
      feelingGoal: 'Ressentir une paix intérieure progressive',
    ),

    DayProgram(
      id: 18,
      title: 'En marchant',
      durationMinutes: 10,
      posture: 'En marchant lentement',
      instruction:
          'Marche lentement dans un espace calme.\n\n'
          'Synchronise ta respiration avec tes pas.\n\n'
          '2 pas pour inspirer, 3 pas pour expirer.\n\n'
          'Laisse ton ventre bouger naturellement.\n\n'
          'Prends ton temps.',
      feelingGoal: 'Intégrer la respiration au mouvement',
    ),

    DayProgram(
      id: 19,
      title: 'Le souffle du soir',
      durationMinutes: 10,
      posture: 'Allongé sur le dos, avant de dormir',
      instruction:
          'Laisse tout le poids de ta journée dans le matelas.\n\n'
          'Respire vers le ventre, très doucement.\n\n'
          'À chaque expiration, imagine relâcher une tension.\n\n'
          'Tu n\'as rien à faire. Juste respirer.',
      feelingGoal: 'S\'endormir plus facilement grâce au souffle',
    ),

    DayProgram(
      id: 20,
      title: 'Respirer dans le stress',
      durationMinutes: 8,
      posture: 'Assis, dans un moment du quotidien',
      instruction:
          'Pense à une situation légèrement stressante.\n\n'
          'Maintenant respire : inspire par le ventre, expire lentement.\n\n'
          'Remarque comment ton corps se calme.\n\n'
          'Le diaphragme est ton outil de retour au calme.',
      feelingGoal: 'Utiliser le souffle comme ancre dans le stress',
    ),

    DayProgram(
      id: 21,
      title: 'Bilan de la semaine',
      durationMinutes: 12,
      posture: 'Position de ton choix',
      instruction:
          'Trois semaines. Tu es à mi-chemin.\n\n'
          'Respire librement, sans instruction particulière.\n\n'
          'Laisse ton corps te montrer ce qu\'il a appris.\n\n'
          'Fais confiance à ton souffle.',
      feelingGoal: 'Respirer avec conscience sans effort',
    ),

    // ─── SEMAINE 4 : ANCRAGE (jours 22–30) ────────────────────────────────────

    DayProgram(
      id: 22,
      title: 'Le matin, en douceur',
      durationMinutes: 8,
      posture: 'Allongé, juste après le réveil',
      instruction:
          'Avant même de te lever…\n\n'
          'Pose une main sur le ventre.\n\n'
          'Prends cinq respirations abdominales profondes.\n\n'
          'C\'est ton cadeau du matin à toi-même.',
      feelingGoal: 'Commencer la journée avec conscience',
    ),

    DayProgram(
      id: 23,
      title: 'La cohérence cardiaque',
      durationMinutes: 10,
      posture: 'Assis confortablement',
      instruction:
          'Inspire 5 secondes.\n\n'
          'Expire 5 secondes.\n\n'
          'Ce rythme de 6 respirations par minute harmonise le cœur et le souffle.\n\n'
          'Reste dans ce rythme pendant toute la séance.',
      feelingGoal: 'Ressentir une harmonie entre le cœur et la respiration',
    ),

    DayProgram(
      id: 24,
      title: 'Respiration et sons',
      durationMinutes: 10,
      posture: 'Assis confortablement',
      instruction:
          'À l\'expiration, laisse sortir un son doux… "mmmmm".\n\n'
          'La vibration se propage dans la poitrine.\n\n'
          'Sens ton diaphragme travailler pour produire ce son.\n\n'
          'C\'est un massage de l\'intérieur.',
      feelingGoal: 'Sentir la vibration du souffle dans le corps',
    ),

    DayProgram(
      id: 25,
      title: 'Sans les mains',
      durationMinutes: 10,
      posture: 'Assis, mains posées sur les genoux',
      instruction:
          'Respire abdominalement sans poser les mains sur le ventre.\n\n'
          'Tu sais maintenant sentir le mouvement de l\'intérieur.\n\n'
          'Ferme les yeux. Fais confiance à ton corps.\n\n'
          'Tu n\'as plus besoin d\'aide extérieure.',
      feelingGoal: 'Ressentir la respiration de l\'intérieur',
    ),

    DayProgram(
      id: 26,
      title: 'Dans la nature',
      durationMinutes: 10,
      posture: 'Dehors, debout ou assis',
      instruction:
          'Trouve un endroit calme dehors.\n\n'
          'Écoute les sons autour de toi.\n\n'
          'Respire lentement, en accord avec ce que tu entends.\n\n'
          'Le vent, les oiseaux, le silence…\n\n'
          'Ton souffle fait partie du monde.',
      feelingGoal: 'Se sentir connecté à l\'environnement par le souffle',
    ),

    DayProgram(
      id: 27,
      title: 'Respiration et posture',
      durationMinutes: 10,
      posture: 'Assis, dos bien aligné',
      instruction:
          'Assieds-toi grand. Épaules relâchées.\n\n'
          'Sens comment une bonne posture facilite la respiration.\n\n'
          'Le diaphragme a besoin d\'espace pour descendre pleinement.\n\n'
          'Respire et tiens-toi bien.',
      feelingGoal: 'Comprendre le lien entre posture et respiration',
    ),

    DayProgram(
      id: 28,
      title: 'Transmettre le calme',
      durationMinutes: 10,
      posture: 'Position de ton choix',
      instruction:
          'Pense à quelqu\'un que tu aimes.\n\n'
          'Respire pour toi, et imagine lui envoyer cette paix.\n\n'
          'Chaque expiration est un cadeau.\n\n'
          'Le calme se partage.',
      feelingGoal: 'Associer la respiration à une émotion douce',
    ),

    DayProgram(
      id: 29,
      title: 'Ta respiration libre',
      durationMinutes: 12,
      posture: 'Position de ton choix',
      instruction:
          'Aujourd\'hui, pas d\'instructions.\n\n'
          'Respire simplement, comme ton corps en a envie.\n\n'
          'Observe ce qui se passe naturellement.\n\n'
          'Ton diaphragme sait maintenant comment faire.\n\n'
          'Fais-lui confiance.',
      feelingGoal: 'Respirer librement sans guidage',
    ),

    DayProgram(
      id: 30,
      title: 'Trente jours de souffle',
      durationMinutes: 15,
      posture: 'Position de ton choix, la plus confortable',
      instruction:
          'Tu es arrivé au bout.\n\n'
          'Trente jours de présence, de patience, de souffle.\n\n'
          'Respire lentement… et souviens-toi du jour 1.\n\n'
          'Tu as changé quelque chose en toi.\n\n'
          'Ce n\'est pas une fin. C\'est un début.\n\n'
          'Bravo.',
      feelingGoal: 'Ressentir la transformation accomplie',
    ),
  ];
}
