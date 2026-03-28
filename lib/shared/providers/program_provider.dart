import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/day_program.dart';
import '../data/program_data.dart';

class ProgramProvider extends ChangeNotifier {
  static const _completedKey = 'completed_days';
  static const _startDateKey = 'start_date';

  List<DayProgram> _days = [];
  DateTime? _startDate;
  bool _isLoaded = false;

  List<DayProgram> get days => _days;
  DateTime? get startDate => _startDate;
  bool get isLoaded => _isLoaded;
  bool get hasStarted => _startDate != null;

  int get completedCount => _days.where((d) => d.status == DayStatus.completed).length;
  int get currentDay {
    if (_startDate == null) return 0;
    final diff = DateTime.now().difference(_startDate!).inDays;
    return (diff + 1).clamp(1, 30);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final completedDays = prefs.getStringList(_completedKey) ?? [];
    final startDateStr = prefs.getString(_startDateKey);

    if (startDateStr != null) {
      _startDate = DateTime.tryParse(startDateStr);
    }

    final completed = completedDays.map(int.parse).toSet();
    _days = kProgram30Days.map((d) {
      DayStatus status;
      if (completed.contains(d.day)) {
        status = DayStatus.completed;
      } else if (_isUnlocked(d.day, completed)) {
        status = DayStatus.available;
      } else {
        status = DayStatus.locked;
      }
      return d.copyWith(status: status);
    }).toList();

    _isLoaded = true;
    notifyListeners();
  }

  bool _isUnlocked(int day, Set<int> completed) {
    if (day == 1) return true;
    return completed.contains(day - 1);
  }

  Future<void> startProgram() async {
    final prefs = await SharedPreferences.getInstance();
    _startDate = DateTime.now();
    await prefs.setString(_startDateKey, _startDate!.toIso8601String());
    await load();
  }

  Future<void> completeDay(int day) async {
    final prefs = await SharedPreferences.getInstance();
    final completedDays = prefs.getStringList(_completedKey) ?? [];
    if (!completedDays.contains(day.toString())) {
      completedDays.add(day.toString());
      await prefs.setStringList(_completedKey, completedDays);
    }
    await load();
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedKey);
    await prefs.remove(_startDateKey);
    _startDate = null;
    await load();
  }

  DayProgram? getDayProgram(int day) {
    try {
      return _days.firstWhere((d) => d.day == day);
    } catch (_) {
      return null;
    }
  }
}
