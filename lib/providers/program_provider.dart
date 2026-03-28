import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/day_program.dart';
import '../data/program_data.dart';

class ProgramProvider extends ChangeNotifier {
  static const String _prefsKey = 'program_state';
  static const String _onboardingKey = 'onboarding_done';

  List<DayProgram> _days = [];
  bool _isLoaded = false;
  bool _onboardingDone = false;

  // ── Getters ────────────────────────────────────────────────────────────────

  List<DayProgram> get days => _days;
  bool get isLoaded => _isLoaded;
  bool get onboardingDone => _onboardingDone;

  /// Jour actuellement actif = premier jour déverrouillé non complété.
  /// Si tous sont complétés, retourne le dernier.
  DayProgram get currentDay {
    final active = _days.where((d) => d.isUnlocked && !d.isCompleted);
    if (active.isNotEmpty) return active.first;
    return _days.last;
  }

  /// Numéro du jour actuel (1-based)
  int get currentDayIndex => currentDay.id;

  /// Nombre de jours complétés
  int get completedCount => _days.where((d) => d.isCompleted).length;

  /// Progression globale (0.0 → 1.0)
  double get progressPercent => completedCount / _days.length;

  /// L'utilisateur a-t-il tout terminé ?
  bool get isProgramComplete => completedCount == _days.length;

  // ── Initialisation ─────────────────────────────────────────────────────────

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    _onboardingDone = prefs.getBool(_onboardingKey) ?? false;

    final savedJson = prefs.getString(_prefsKey);

    if (savedJson != null) {
      _days = _loadFromJson(savedJson);
    } else {
      // Premier lancement : on prend les données brutes, jour 1 déverrouillé
      _days = List<DayProgram>.from(ProgramData.days);
    }

    _isLoaded = true;
    notifyListeners();
  }

  // ── Actions utilisateur ────────────────────────────────────────────────────

  /// Marque l'onboarding comme terminé
  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }

  /// Valide un jour et déverrouille le suivant
  Future<void> completeDay(int dayId) async {
    final index = _days.indexWhere((d) => d.id == dayId);
    if (index == -1) return;

    // Marquer le jour comme complété
    _days[index] = _days[index].copyWith(isCompleted: true);

    // Déverrouiller le jour suivant s'il existe
    final nextIndex = index + 1;
    if (nextIndex < _days.length) {
      _days[nextIndex] = _days[nextIndex].copyWith(isUnlocked: true);
    }

    await _save();
    notifyListeners();
  }

  /// Sauvegarde le ressenti post-séance d'un jour
  Future<void> saveFeeling(int dayId, String feeling) async {
    final index = _days.indexWhere((d) => d.id == dayId);
    if (index == -1) return;
    _days[index] = _days[index].copyWith(feeling: feeling);
    await _save();
    notifyListeners();
  }

  /// Réinitialise tout le programme (pour les tests / debug)
  Future<void> resetProgram() async {
    _days = List<DayProgram>.from(ProgramData.days);
    _onboardingDone = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    await prefs.remove(_onboardingKey);
    notifyListeners();
  }

  /// Retourne un jour par son id
  DayProgram? getDayById(int id) {
    try {
      return _days.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Persistance ────────────────────────────────────────────────────────────

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _days.map((d) => d.toJson()).toList();
    await prefs.setString(_prefsKey, jsonEncode(jsonList));
  }

  List<DayProgram> _loadFromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    // Reconstruction : on fusionne les données statiques avec l'état sauvegardé
    final savedMap = <int, Map<String, dynamic>>{};
    for (final item in jsonList) {
      final map = item as Map<String, dynamic>;
      savedMap[map['id'] as int] = map;
    }

    return ProgramData.days.map((day) {
      final saved = savedMap[day.id];
      if (saved != null) return day.withSavedState(saved);
      return day;
    }).toList();
  }
}
