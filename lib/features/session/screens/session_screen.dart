import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/day_program.dart';
import '../../../shared/providers/program_provider.dart';

class SessionScreen extends StatefulWidget {
  final int dayNumber;
  const SessionScreen({super.key, required this.dayNumber});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _glowController;
  Timer? _phaseTimer;

  DayProgram? _program;
  int _currentPhaseIndex = 0;
  int _currentCycle = 0;
  int _phaseSecondsLeft = 0;
  bool _isRunning = false;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(vsync: this);
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProgramProvider>();
      setState(() {
        _program = provider.getDayProgram(widget.dayNumber);
        if (_program != null) {
          _phaseSecondsLeft = _program!.phases[0].seconds;
        }
      });
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    _glowController.dispose();
    _phaseTimer?.cancel();
    super.dispose();
  }

  void _startSession() {
    setState(() => _isRunning = true);
    _runPhase();
  }

  void _runPhase() {
    if (_program == null) return;
    HapticFeedback.lightImpact();
    final phase = _program!.phases[_currentPhaseIndex];

    _breathController.stop();
    _breathController.duration = Duration(seconds: phase.seconds);

    // Inhale → expand, exhale → contract, hold → stay
    final label = phase.label.toLowerCase();
    if (label.contains('insp')) {
      _breathController.forward(from: 0);
    } else if (label.contains('exp')) {
      _breathController.reverse(from: 1);
    }

    setState(() => _phaseSecondsLeft = phase.seconds);

    _phaseTimer?.cancel();
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _phaseSecondsLeft--);
      if (_phaseSecondsLeft <= 0) {
        t.cancel();
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    if (_program == null) return;
    final nextPhase = _currentPhaseIndex + 1;

    if (nextPhase >= _program!.phases.length) {
      _currentPhaseIndex = 0;
      _currentCycle++;
      if (_currentCycle >= _program!.cycles) {
        _completeSession();
        return;
      }
    } else {
      _currentPhaseIndex = nextPhase;
    }
    _runPhase();
  }

  Future<void> _completeSession() async {
    _phaseTimer?.cancel();
    _breathController.stop();
    setState(() {
      _isRunning = false;
      _isComplete = true;
    });
    await context.read<ProgramProvider>().completeDay(widget.dayNumber);
  }

  void _pauseResume() {
    if (_isRunning) {
      _phaseTimer?.cancel();
      _breathController.stop();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _runPhase();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_program == null) {
      return const Scaffold(
        backgroundColor: AppColors.night,
        body: Center(child: CircularProgressIndicator(color: AppColors.sage)),
      );
    }

    if (_isComplete) return _CompletionView(program: _program!);

    final phase = _program!.phases[_currentPhaseIndex];

    return Scaffold(
      backgroundColor: AppColors.night,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Subtitle
                    Text(_program!.subtitle, style: AppTextStyles.label),
                    const SizedBox(height: Spacing.s),
                    Text(_program!.title, style: AppTextStyles.displayM),
                    const Flexible(child: SizedBox(height: Spacing.xl)),

                    // Breathing orb
                    _BreathingOrb(
                      controller: _breathController,
                      glowController: _glowController,
                      isRunning: _isRunning,
                      phaseLabel: _isRunning ? phase.label : 'Prêt',
                      secondsLeft: _phaseSecondsLeft,
                    ),

                    const Flexible(child: SizedBox(height: Spacing.xl)),

                    // Cycle counter
                    if (_isRunning)
                      Text(
                        'Cycle ${_currentCycle + 1} / ${_program!.cycles}',
                        style: AppTextStyles.bodyM,
                      ),
                  ],
                ),
              ),
            ),

            // Intention
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
              child: Text(
                '"${_program!.intention}"',
                style: AppTextStyles.breathe.copyWith(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: Spacing.m),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.l),
              child: _isRunning
                  ? Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _pauseResume,
                            child: const Text('Pause'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isRunning ? null : (_currentCycle == 0 ? _startSession : _pauseResume),
                            child: Text(
                              _currentCycle == 0 ? 'Démarrer' : 'Reprendre',
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: Spacing.l),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.l,
        vertical: Spacing.m,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.nightElevated,
                border: Border.all(color: AppColors.nightBorder),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          const Spacer(),
          Text('Jour ${widget.dayNumber}', style: AppTextStyles.headingM),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _BreathingOrb extends StatelessWidget {
  final AnimationController controller;
  final AnimationController glowController;
  final bool isRunning;
  final String phaseLabel;
  final int secondsLeft;

  const _BreathingOrb({
    required this.controller,
    required this.glowController,
    required this.isRunning,
    required this.phaseLabel,
    required this.secondsLeft,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, glowController]),
      builder: (context, _) {
        final scale = 0.7 + (controller.value * 0.5);
        final glowOpacity = 0.15 + (glowController.value * 0.25);

        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.sage.withValues(alpha: glowOpacity * 0.5),
                      AppColors.sage.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
              // Main orb
              Transform.scale(
                scale: scale,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.sage.withValues(alpha: 0.9),
                        AppColors.sageDim.withValues(alpha: 0.7),
                        AppColors.sageGhost.withValues(alpha: 0.3),
                      ],
                      stops: const [0, 0.6, 1],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sage.withValues(alpha: glowOpacity),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              // Labels
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    phaseLabel.toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textPrimary,
                      letterSpacing: 3,
                    ),
                  ),
                  if (isRunning) ...[
                    const SizedBox(height: 8),
                    Text(
                      '$secondsLeft',
                      style: AppTextStyles.timer.copyWith(fontSize: 40),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CompletionView extends StatelessWidget {
  final DayProgram program;
  const _CompletionView({required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.night,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.completedBg,
                  border: Border.all(
                    color: AppColors.completed.withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.completed,
                  size: 36,
                ),
              ),
              const SizedBox(height: Spacing.xl),
              Text(
                'Jour ${program.day}\ncomplété',
                style: AppTextStyles.displayL,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.m),
              Text(
                '"${program.intention}"',
                style: AppTextStyles.breathe.copyWith(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xxl),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                    (route) => false,
                  );
                },
                child: const Text('Retour au programme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
