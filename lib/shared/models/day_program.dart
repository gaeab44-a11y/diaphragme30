enum DayStatus { locked, available, completed }

enum BreathingPattern {
  boxBreathing,       // 4-4-4-4
  relaxing,           // 4-7-8
  energizing,         // 6-2-6
  coherence,          // 5-5
  deepCalm,           // 4-4-8
  wim,                // 4-0-4
}

class BreathingPhase {
  final String label;
  final int seconds;

  const BreathingPhase({required this.label, required this.seconds});
}

class DayProgram {
  final int day;
  final String title;
  final String subtitle;
  final String description;
  final String intention;
  final BreathingPattern pattern;
  final int cycles;
  final int totalMinutes;
  final DayStatus status;

  const DayProgram({
    required this.day,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.intention,
    required this.pattern,
    required this.cycles,
    required this.totalMinutes,
    this.status = DayStatus.locked,
  });

  List<BreathingPhase> get phases {
    switch (pattern) {
      case BreathingPattern.boxBreathing:
        return const [
          BreathingPhase(label: 'Inspirez', seconds: 4),
          BreathingPhase(label: 'Retenez', seconds: 4),
          BreathingPhase(label: 'Expirez', seconds: 4),
          BreathingPhase(label: 'Retenez', seconds: 4),
        ];
      case BreathingPattern.relaxing:
        return const [
          BreathingPhase(label: 'Inspirez', seconds: 4),
          BreathingPhase(label: 'Retenez', seconds: 7),
          BreathingPhase(label: 'Expirez', seconds: 8),
        ];
      case BreathingPattern.energizing:
        return const [
          BreathingPhase(label: 'Inspirez', seconds: 6),
          BreathingPhase(label: 'Retenez', seconds: 2),
          BreathingPhase(label: 'Expirez', seconds: 6),
        ];
      case BreathingPattern.coherence:
        return const [
          BreathingPhase(label: 'Inspirez', seconds: 5),
          BreathingPhase(label: 'Expirez', seconds: 5),
        ];
      case BreathingPattern.deepCalm:
        return const [
          BreathingPhase(label: 'Inspirez', seconds: 4),
          BreathingPhase(label: 'Retenez', seconds: 4),
          BreathingPhase(label: 'Expirez', seconds: 8),
        ];
      case BreathingPattern.wim:
        return const [
          BreathingPhase(label: 'Inspirez', seconds: 4),
          BreathingPhase(label: 'Expirez', seconds: 4),
        ];
    }
  }

  int get cycleDuration =>
      phases.fold(0, (sum, p) => sum + p.seconds);

  DayProgram copyWith({DayStatus? status}) {
    return DayProgram(
      day: day,
      title: title,
      subtitle: subtitle,
      description: description,
      intention: intention,
      pattern: pattern,
      cycles: cycles,
      totalMinutes: totalMinutes,
      status: status ?? this.status,
    );
  }
}
