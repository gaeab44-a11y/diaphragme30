import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/program_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../widgets/breathing_circle.dart';
import '../widgets/session_timer.dart';
import 'completion_screen.dart';

class SessionScreen extends StatefulWidget {
  final int dayId;
  const SessionScreen({super.key, required this.dayId});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isPaused = false;

  final List<String> _phrases = const [
    'Respire doucement',
    'Observe ton ventre',
    'Laisse venir l\'air',
    'Tu fais bien',
    'Expire lentement',
    'Prends ton temps',
    'Reste présent',
    'Sens le mouvement',
  ];
  int _phraseIndex = 0;
  Timer? _phraseTimer;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProgramProvider>();
    final day = provider.getDayById(widget.dayId);
    _totalSeconds = (day?.durationMinutes ?? 5) * 60;
    _remainingSeconds = _totalSeconds;
    _startTimer();
    _startPhraseRotation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phraseTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        _onSessionComplete();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _startPhraseRotation() {
    _phraseTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!_isPaused && mounted) {
        setState(() => _phraseIndex = (_phraseIndex + 1) % _phrases.length);
      }
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
    if (_isPaused) {
      _timer?.cancel();
    } else {
      _startTimer();
    }
  }

  void _onSessionComplete() {
    final provider = context.read<ProgramProvider>();
    provider.completeDay(widget.dayId);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, a, b) => CompletionScreen(dayId: widget.dayId),
        transitionsBuilder: (ctx, a, b, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remainingSeconds / _totalSeconds);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.sessionGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _showExitDialog,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      'Jour ${widget.dayId}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Halo externe décoratif
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.sessionGlow.withValues(alpha: 0.06),
                ),
                child: Center(
                  child: BreathingCircle(
                    size: 220,
                    color: AppColors.sessionGlow,
                    darkMode: true,
                    isPaused: _isPaused,
                    child: SessionTimer(
                      seconds: _remainingSeconds,
                      darkMode: true,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingXXL),

              // Phrase guidée
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.08),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: Text(
                  _isPaused ? 'En pause' : _phrases[_phraseIndex],
                  key: ValueKey(_isPaused ? 'pause' : _phraseIndex),
                  style: AppTextStyles.breathingText,
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(flex: 3),

              // Barre de progression
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingXL,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusFull),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 3,
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingXXL),

              // Contrôles
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingXL,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Terminer
                    TextButton(
                      onPressed: _onSessionComplete,
                      child: Text(
                        'Terminer',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                    ),

                    // Pause
                    GestureDetector(
                      onTap: _togglePause,
                      child: Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          _isPaused
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 30,
                        ),
                      ),
                    ),

                    const SizedBox(width: 80),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingXXL),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF1A2D22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Quitter la séance ?',
                style: AppTextStyles.headingMedium.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                'Ta progression ne sera pas sauvegardée.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXL),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Continuer'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Quitter'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
