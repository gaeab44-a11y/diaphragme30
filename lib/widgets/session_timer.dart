import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Affiche un timer mm:ss dans le style séance.
/// [seconds] = secondes restantes, [darkMode] = sur fond sombre.
class SessionTimer extends StatelessWidget {
  final int seconds;
  final bool darkMode;

  const SessionTimer({
    super.key,
    required this.seconds,
    this.darkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _format(seconds),
      style: darkMode
          ? AppTextStyles.timerDisplay
          : AppTextStyles.timerDisplay.copyWith(color: Colors.black87),
    );
  }

  String _format(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
