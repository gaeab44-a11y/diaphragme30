/// Représente un jour du programme de 30 jours.
class DayProgram {
  final int id;                  // Numéro du jour (1 à 30)
  final String title;            // Titre court du jour
  final int durationMinutes;     // Durée de la séance en minutes
  final String posture;          // Position du corps (ex: "Allongé sur le dos")
  final String instruction;      // Texte guidé affiché pendant la séance
  final String feelingGoal;      // Ce que l'utilisateur devrait ressentir
  final bool isUnlocked;         // Le jour est-il accessible ?
  final bool isCompleted;        // Le jour a-t-il été validé ?
  final String? feeling;         // Ressenti post-séance sauvegardé

  const DayProgram({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.posture,
    required this.instruction,
    required this.feelingGoal,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.feeling,
  });

  /// Crée une copie avec des valeurs modifiées (immutabilité)
  DayProgram copyWith({
    int? id,
    String? title,
    int? durationMinutes,
    String? posture,
    String? instruction,
    String? feelingGoal,
    bool? isUnlocked,
    bool? isCompleted,
    String? feeling,
  }) {
    return DayProgram(
      id: id ?? this.id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      posture: posture ?? this.posture,
      instruction: instruction ?? this.instruction,
      feelingGoal: feelingGoal ?? this.feelingGoal,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      feeling: feeling ?? this.feeling,
    );
  }

  /// Sérialisation pour SharedPreferences
  Map<String, dynamic> toJson() => {
    'id': id,
    'isUnlocked': isUnlocked,
    'isCompleted': isCompleted,
    if (feeling != null) 'feeling': feeling,
  };

  /// Reconstruit depuis JSON (on garde les données statiques, on charge l'état)
  DayProgram withSavedState(Map<String, dynamic> json) {
    return copyWith(
      isUnlocked: json['isUnlocked'] as bool? ?? isUnlocked,
      isCompleted: json['isCompleted'] as bool? ?? isCompleted,
      feeling: json['feeling'] as String?,
    );
  }

  @override
  String toString() =>
      'DayProgram(id: $id, title: $title, isUnlocked: $isUnlocked, isCompleted: $isCompleted)';
}
