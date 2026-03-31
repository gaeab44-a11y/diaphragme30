import 'dart:async';
import 'dart:math' show pi;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:provider/provider.dart';
import '../../../core/services/sound_service.dart';
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
  late AnimationController _ringController;
  Timer? _phaseTimer;

  DayProgram? _program;
  int _currentPhaseIndex = 0;
  int _currentCycle = 0;
  int _phaseSecondsLeft = 0;
  int _phaseSecondsTotal = 0;
  bool _isRunning = false;
  bool _isComplete = false;
  bool _ambientOn = false;

  final _sound = SoundService.instance;

  Color get _bgColor {
    if (!_isRunning || _program == null) return AppColors.night;
    final label = _program!.phases[_currentPhaseIndex].label.toLowerCase();
    if (label.contains('insp')) return const Color(0xFF06091E);
    if (label.contains('exp')) return const Color(0xFF050E0C);
    return const Color(0xFF070810);
  }

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(vsync: this);
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProgramProvider>();
      setState(() {
        _program = provider.getDayProgram(widget.dayNumber);
        if (_program != null) {
          _phaseSecondsLeft = _program!.phases[0].seconds;
          _phaseSecondsTotal = _program!.phases[0].seconds;
        }
      });
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    _glowController.dispose();
    _ringController.dispose();
    _phaseTimer?.cancel();
    _sound.stopAmbient();
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

    _sound.playChime(phase.label);
    _ringController.forward(from: 0);

    _breathController.stop();
    _breathController.duration = Duration(seconds: phase.seconds);

    final label = phase.label.toLowerCase();
    if (label.contains('insp')) {
      _breathController.forward(from: 0);
    } else if (label.contains('exp')) {
      _breathController.reverse(from: 1);
    }

    setState(() {
      _phaseSecondsLeft = phase.seconds;
      _phaseSecondsTotal = phase.seconds;
    });
    _startPhaseTimer();
  }

  void _resumePhase() {
    if (_program == null) return;
    final phase = _program!.phases[_currentPhaseIndex];
    _breathController.duration = Duration(seconds: phase.seconds);
    final progress = 1.0 - (_phaseSecondsLeft / phase.seconds);
    final label = phase.label.toLowerCase();
    if (label.contains('insp')) {
      _breathController.forward(from: progress);
    } else if (label.contains('exp')) {
      _breathController.reverse(from: 1.0 - progress);
    }
    _startPhaseTimer();
  }

  void _startPhaseTimer() {
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
    _sound.stopAmbient();
    setState(() {
      _isRunning = false;
      _isComplete = true;
      _ambientOn = false;
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
      _resumePhase();
    }
  }

  void _toggleAmbient() {
    _sound.toggleAmbient();
    setState(() => _ambientOn = _sound.ambientOn);
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
    final phaseProgress = _phaseSecondsTotal > 0
        ? _phaseSecondsLeft / _phaseSecondsTotal
        : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOut,
      color: _bgColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_program!.subtitle, style: AppTextStyles.label),
                      const SizedBox(height: Spacing.s),
                      Text(_program!.title, style: AppTextStyles.displayM),
                      const Flexible(child: SizedBox(height: Spacing.l)),
                      _AnatomyView(
                        breathController: _breathController,
                        glowController: _glowController,
                        ringController: _ringController,
                        isRunning: _isRunning,
                        phaseLabel: _isRunning ? phase.label : 'Prêt',
                        phaseProgress: phaseProgress,
                      ),
                      const Flexible(child: SizedBox(height: Spacing.l)),
                      if (_isRunning)
                        Text(
                          'Cycle ${_currentCycle + 1} / ${_program!.cycles}',
                          style: AppTextStyles.bodyM,
                        ),
                    ],
                  ),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.l),
                child: _isRunning
                    ? Row(children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _pauseResume,
                            child: const Text('Pause'),
                          ),
                        ),
                      ])
                    : Row(children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _currentCycle == 0 ? _startSession : _pauseResume,
                            child: Text(
                              _currentCycle == 0 ? 'Démarrer' : 'Reprendre',
                            ),
                          ),
                        ),
                      ]),
              ),
              const SizedBox(height: Spacing.l),
            ],
          ),
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
          GestureDetector(
            onTap: _toggleAmbient,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _ambientOn ? AppColors.sageGhost : AppColors.nightElevated,
                border: Border.all(
                  color: _ambientOn ? AppColors.sage : AppColors.nightBorder,
                ),
              ),
              child: Icon(
                _ambientOn
                    ? Icons.music_note_rounded
                    : Icons.music_off_rounded,
                color: _ambientOn ? AppColors.sage : AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vue anatomique : cage thoracique + poumons + diaphragme animé
// ─────────────────────────────────────────────────────────────────────────────

class _AnatomyView extends StatelessWidget {
  final AnimationController breathController;
  final AnimationController glowController;
  final AnimationController ringController;
  final bool isRunning;
  final String phaseLabel;
  final double phaseProgress;

  const _AnatomyView({
    required this.breathController,
    required this.glowController,
    required this.ringController,
    required this.isRunning,
    required this.phaseLabel,
    required this.phaseProgress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([breathController, glowController, ringController]),
      builder: (context, _) {
        return SizedBox(
          width: 290,
          height: 290,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(290, 290),
                painter: _AnatomyPainter(
                  breathValue: breathController.value,
                  glowValue: glowController.value,
                  ringValue: ringController.value,
                  phaseProgress: phaseProgress,
                  isRunning: isRunning,
                ),
              ),
              // Label de phase — centré verticalement vers le bas de la vue
              Positioned(
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF080F18).withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.nightBorder.withValues(alpha: 0.6)),
                  ),
                  child: Text(
                    phaseLabel.toUpperCase(),
                    style: AppTextStyles.label.copyWith(letterSpacing: 3),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Peintre anatomique
// ─────────────────────────────────────────────────────────────────────────────

class _AnatomyPainter extends CustomPainter {
  final double breathValue; // 0 = expiration, 1 = inspiration
  final double glowValue;
  final double ringValue;
  final double phaseProgress;
  final bool isRunning;

  static const _bone       = Color(0xFFBACECA);
  static const _lungFill   = Color(0xFF6AABA0);
  static const _diaphShadow = Color(0xFF803828);
  static const _diaphFill  = Color(0xFFB06048);
  static const _diaphLine  = Color(0xFFD08060);
  static const _diaphHL    = Color(0xFFEAB890); // specular highlight
  static const _tendon     = Color(0xFFEED0B0); // central tendon
  static const _sage       = Color(0xFF7DB5A8);

  const _AnatomyPainter({
    required this.breathValue,
    required this.glowValue,
    required this.ringValue,
    required this.phaseProgress,
    required this.isRunning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final b  = breathValue;

    _drawRibs(canvas, size, cx);
    _drawLungs(canvas, size, cx, b);
    _drawDiaphragm(canvas, cx, b);
    if (isRunning) _drawTimerArc(canvas, size);
  }

  // ── Sternum + 6 paires de côtes ──────────────────────────────────────────

  void _drawRibs(Canvas canvas, Size size, double cx) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, size.height * 0.38),
          width: 12,
          height: size.height * 0.52,
        ),
        ui.Radius.circular(4),
      ),
      Paint()
        ..style = PaintingStyle.fill
        ..color = _bone.withValues(alpha: 0.22),
    );

    final ribs = [
      (0.09, 50.0, 10.0, 0.42, 2.8),
      (0.20, 63.0, 17.0, 0.39, 2.8),
      (0.31, 71.0, 23.0, 0.36, 2.6),
      (0.41, 75.0, 27.0, 0.33, 2.5),
      (0.51, 72.0, 25.0, 0.29, 2.3),
      (0.59, 62.0, 19.0, 0.25, 2.1),
    ];

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final (yR, w, drop, opacity, sw) in ribs) {
      final ry = size.height * yR;
      paint
        ..strokeWidth = sw
        ..color = _bone.withValues(alpha: opacity);

      final right = Path()
        ..moveTo(cx + 7, ry)
        ..cubicTo(cx + w * 0.38, ry - 7, cx + w * 0.80, ry + drop * 0.5, cx + w, ry + drop);
      canvas.drawPath(right, paint);

      final left = Path()
        ..moveTo(cx - 7, ry)
        ..cubicTo(cx - w * 0.38, ry - 7, cx - w * 0.80, ry + drop * 0.5, cx - w, ry + drop);
      canvas.drawPath(left, paint);
    }
  }

  // ── Poumons ───────────────────────────────────────────────────────────────

  void _drawLungs(Canvas canvas, Size size, double cx, double b) {
    final expand  = 1.0 + b * 0.11;
    final lungTop = size.height * 0.08;
    // Le bas des poumons se synchronise avec l'apex du diaphragme
    final lungBot = 182.0 + b * 28.0;

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = _lungFill.withValues(alpha: 0.13 + b * 0.10);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = _lungFill.withValues(alpha: 0.38 + b * 0.22);

    final right = _lungPath(cx, lungTop, lungBot, expand, isRight: true);
    canvas.drawPath(right, fill);
    canvas.drawPath(right, stroke);

    final left = _lungPath(cx, lungTop, lungBot, expand, isRight: false);
    canvas.drawPath(left, fill);
    canvas.drawPath(left, stroke);
  }

  Path _lungPath(double cx, double top, double bot, double expand, {required bool isRight}) {
    final s           = isRight ? 1.0 : -1.0;
    final innerX      = cx + 9 * s;
    final outerX      = cx + (28 + 52 * expand) * s;
    final mid         = top + (bot - top) * 0.48;
    final widthFactor = isRight ? 1.0 : 0.88;
    final effOuter    = cx + ((outerX - cx) * widthFactor);

    return Path()
      ..moveTo(innerX, top + 6)
      ..cubicTo(cx + 38 * s * expand, top - 2, effOuter, top + 22, effOuter, mid - 12)
      ..cubicTo(effOuter, mid + 18, effOuter - 14 * s, bot - 10, cx + 22 * s * expand, bot)
      ..cubicTo(cx + 10 * s, bot + 2, innerX, bot - 18, innerX, mid + 8)
      ..cubicTo(innerX, mid - 18, innerX, top + 22, innerX, top + 6)
      ..close();
  }

  // ── Diaphragme : dôme anatomique complet ─────────────────────────────────
  //
  //  b=0 (expiration) : dôme HAUT et bombé   — apex remonte, courbure max
  //  b=1 (inspiration): dôme DESCENDU et plat — apex descend, muscle contracté

  void _drawDiaphragm(Canvas canvas, double cx, double b) {
    // Position de l'apex (point culminant du dôme)
    // Expiration: 182 (haut)  →  Inspiration: 210 (bas)
    final apexY = 182.0 + b * 28.0;
    // Hauteur du dôme (distance apex→bords latéraux)
    // Expiration: très courbé (28px)  →  Inspiration: aplati (10px)
    final domeH = 28.0 - b * 18.0;
    final sideY = apexY + domeH;
    // Légèrement plus large à l'inspiration (muscle contracté s'étale)
    final w = 82.0 + b * 6.0;
    final glow = (0.62 + glowValue * 0.22 + ringValue * 0.28).clamp(0.0, 1.0);

    _diaphGlow(canvas, cx, apexY, sideY, w);
    _diaphBody(canvas, cx, apexY, sideY, w, b);
    _diaphFibers(canvas, cx, apexY, sideY, w);
    _diaphCrura(canvas, cx, sideY, w, b);
    _diaphOutlines(canvas, cx, apexY, sideY, w, glow);
    _diaphTendon(canvas, cx, apexY, b);
  }

  // 1. Halo atmosphérique (flou derrière le muscle)
  void _diaphGlow(Canvas canvas, double cx, double apexY, double sideY, double w) {
    final alpha = 0.10 + glowValue * 0.08 + ringValue * 0.14;
    final expanded = w + 22;
    final glowPath = _buildDomePath(cx, apexY - 4, sideY + 2, expanded)
      ..lineTo(cx + expanded, sideY + 44)
      ..lineTo(cx - expanded, sideY + 44)
      ..close();
    canvas.drawPath(
      glowPath,
      Paint()
        ..style = PaintingStyle.fill
        ..color = _diaphFill.withValues(alpha: alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );
  }

  // 2. Corps du muscle (remplissage + ombrage intérieur)
  void _diaphBody(Canvas canvas, double cx, double apexY, double sideY, double w, double b) {
    final body = _buildDomePath(cx, apexY, sideY, w)
      ..lineTo(cx + w, sideY + 48)
      ..lineTo(cx - w, sideY + 48)
      ..close();

    // Couche de base
    canvas.drawPath(
      body,
      Paint()
        ..style = PaintingStyle.fill
        ..color = _diaphFill.withValues(alpha: 0.28 + b * 0.08),
    );

    // Zone plus claire au centre (relief du dôme)
    final highlight = Path()
      ..moveTo(cx - w * 0.55, sideY - 2)
      ..cubicTo(cx - w * 0.25, sideY - 4, cx - w * 0.10, apexY + 4, cx, apexY + 4)
      ..cubicTo(cx + w * 0.10, apexY + 4, cx + w * 0.25, sideY - 4, cx + w * 0.55, sideY - 2)
      ..lineTo(cx + w * 0.55, sideY + 12)
      ..lineTo(cx - w * 0.55, sideY + 12)
      ..close();
    canvas.drawPath(
      highlight,
      Paint()
        ..style = PaintingStyle.fill
        ..color = _diaphHL.withValues(alpha: 0.08 + (1 - b) * 0.05),
    );
  }

  // 3. Fibres musculaires radiales (émanant du tendon central)
  void _diaphFibers(Canvas canvas, double cx, double apexY, double sideY, double w) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const steps = 12;
    for (int i = 1; i <= steps; i++) {
      final t       = i / (steps + 1.0);
      final opacity = (0.32 - t * 0.20).clamp(0.04, 0.32);
      final sw      = (1.4 - t * 0.6).clamp(0.5, 1.4);
      paint
        ..strokeWidth = sw
        ..color = _diaphLine.withValues(alpha: opacity);

      // Point d'origine : bord du tendon central, légèrement écarté
      final startR = Offset(cx + 6, apexY + 6);
      final startL = Offset(cx - 6, apexY + 6);

      // Point d'arrivée : sur la courbe du dôme (calculé via bezier)
      final endR = _domePoint(cx, apexY, sideY, w, t, isRight: true);
      final endL = _domePoint(cx, apexY, sideY, w, t, isRight: false);

      canvas.drawLine(startR, endR, paint);
      canvas.drawLine(startL, endL, paint);
    }
  }

  // 4. Piliers (crura) : les jambes du diaphragme vers la colonne
  void _diaphCrura(Canvas canvas, double cx, double sideY, double w, double b) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Épaisseur réduite à l'inspiration (contracté)
    final cruralW  = 2.4 - b * 0.6;
    final cruralOp = 0.50 + b * 0.10;

    paint..strokeWidth = cruralW..color = _diaphFill.withValues(alpha: cruralOp);

    final rightCrus = Path()
      ..moveTo(cx + w * 0.90, sideY + 4)
      ..cubicTo(cx + 40, sideY + 24, cx + 18, sideY + 42, cx + 10, sideY + 52);
    canvas.drawPath(rightCrus, paint);

    final leftCrus = Path()
      ..moveTo(cx - w * 0.90, sideY + 4)
      ..cubicTo(cx - 40, sideY + 24, cx - 18, sideY + 42, cx - 10, sideY + 52);
    canvas.drawPath(leftCrus, paint);

    // Reflet intérieur sur les piliers
    paint..strokeWidth = 1.0..color = _diaphLine.withValues(alpha: 0.30);

    final rightInner = Path()
      ..moveTo(cx + w * 0.84, sideY + 6)
      ..cubicTo(cx + 32, sideY + 27, cx + 12, sideY + 44, cx + 6, sideY + 53);
    canvas.drawPath(rightInner, paint);

    final leftInner = Path()
      ..moveTo(cx - w * 0.84, sideY + 6)
      ..cubicTo(cx - 32, sideY + 27, cx - 12, sideY + 44, cx - 6, sideY + 53);
    canvas.drawPath(leftInner, paint);
  }

  // 5. Contours du dôme (ombre + ligne principale + reflets)
  void _diaphOutlines(Canvas canvas, double cx, double apexY, double sideY, double w, double glow) {
    final dome = _buildDomePath(cx, apexY, sideY, w);

    // Ombre sous le contour (diffusion)
    canvas.drawPath(
      dome,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..color = _diaphShadow.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Ligne principale — éclaire au changement de phase
    canvas.drawPath(
      dome,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.8
        ..strokeCap = StrokeCap.round
        ..color = _diaphLine.withValues(alpha: glow),
    );

    // Contour intérieur décalé (profondeur)
    final inner = _buildDomePath(cx, apexY + 9, sideY - 3, w - 12);
    canvas.drawPath(
      inner,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round
        ..color = _diaphLine.withValues(alpha: glow * 0.32),
    );

    // Reflet spéculaire (liseré lumineux sur le bord supérieur du dôme)
    final specular = _buildDomePath(cx, apexY - 1, sideY - domeHighlight(sideY, apexY), w * 0.68);
    canvas.drawPath(
      specular,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..color = _diaphHL.withValues(alpha: glow * 0.60),
    );
  }

  double domeHighlight(double sideY, double apexY) => (sideY - apexY) * 0.25 + 2;

  // 6. Tendon central (zone claire en forme d'ovale à l'apex)
  void _diaphTendon(Canvas canvas, double cx, double apexY, double b) {
    final tw = 28.0 - b * 8.0;  // plus petit à l'inspiration (dôme aplati)
    final th = 12.0 - b * 4.0;
    final center = Offset(cx, apexY + th * 0.6);

    // Remplissage nacré
    canvas.drawOval(
      Rect.fromCenter(center: center, width: tw, height: th),
      Paint()
        ..style = PaintingStyle.fill
        ..color = _tendon.withValues(alpha: 0.48),
    );

    // Contour plus lumineux
    canvas.drawOval(
      Rect.fromCenter(center: center, width: tw, height: th),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = _tendon.withValues(alpha: 0.75),
    );

    // Petit reflet au centre du tendon
    canvas.drawOval(
      Rect.fromCenter(center: center - const Offset(0, 1), width: tw * 0.45, height: th * 0.45),
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white.withValues(alpha: 0.18),
    );
  }

  // ── Helpers bezier ────────────────────────────────────────────────────────

  /// Construit le chemin du dôme (arc de gauche à droite via l'apex).
  Path _buildDomePath(double cx, double apexY, double sideY, double w) {
    return Path()
      ..moveTo(cx - w, sideY)
      ..cubicTo(cx - w * 0.52, sideY, cx - w * 0.22, apexY, cx, apexY)
      ..cubicTo(cx + w * 0.22, apexY, cx + w * 0.52, sideY, cx + w, sideY);
  }

  /// Évalue un point sur la courbe bezier du dôme (pour positionner les fibres).
  Offset _domePoint(double cx, double apexY, double sideY, double w, double t, {required bool isRight}) {
    final s  = isRight ? 1.0 : -1.0;
    final p0 = Offset(cx, apexY);
    final p1 = Offset(cx + w * 0.22 * s, apexY);
    final p2 = Offset(cx + w * 0.52 * s, sideY);
    final p3 = Offset(cx + w * s, sideY);
    final u  = 1.0 - t;
    return Offset(
      u * u * u * p0.dx + 3 * u * u * t * p1.dx + 3 * u * t * t * p2.dx + t * t * t * p3.dx,
      u * u * u * p0.dy + 3 * u * u * t * p1.dy + 3 * u * t * t * p2.dy + t * t * t * p3.dy,
    );
  }

  // ── Arc timer ─────────────────────────────────────────────────────────────

  void _drawTimerArc(Canvas canvas, Size size) {
    if (phaseProgress <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = _sage.withValues(alpha: 0.11),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      phaseProgress * 2 * pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round
        ..color = _sage.withValues(alpha: 0.62),
    );
  }

  @override
  bool shouldRepaint(_AnatomyPainter old) =>
      breathValue != old.breathValue ||
      glowValue != old.glowValue ||
      ringValue != old.ringValue ||
      phaseProgress != old.phaseProgress ||
      isRunning != old.isRunning;
}

// ─────────────────────────────────────────────────────────────────────────────
// Écran de complétion avec animation en cascade
// ─────────────────────────────────────────────────────────────────────────────

class _CompletionView extends StatefulWidget {
  final DayProgram program;
  const _CompletionView({required this.program});

  @override
  State<_CompletionView> createState() => _CompletionViewState();
}

class _CompletionViewState extends State<_CompletionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _iconScale;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _intentionFade;
  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _iconScale = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
    );
    _titleFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.25, 0.6, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.25, 0.6, curve: Curves.easeOutCubic),
    ));
    _intentionFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.45, 0.78, curve: Curves.easeOut),
    );
    _buttonFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.62, 0.95, curve: Curves.easeOut),
    );
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.62, 0.95, curve: Curves.easeOutCubic),
    ));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
              ScaleTransition(
                scale: _iconScale,
                child: FadeTransition(
                  opacity: _iconScale,
                  child: Container(
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
                ),
              ),
              const SizedBox(height: Spacing.xl),
              SlideTransition(
                position: _titleSlide,
                child: FadeTransition(
                  opacity: _titleFade,
                  child: Text(
                    'Jour ${widget.program.day}\ncomplété',
                    style: AppTextStyles.displayL,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.m),
              FadeTransition(
                opacity: _intentionFade,
                child: Text(
                  '"${widget.program.intention}"',
                  style: AppTextStyles.breathe.copyWith(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Spacing.xxl),
              SlideTransition(
                position: _buttonSlide,
                child: FadeTransition(
                  opacity: _buttonFade,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                      );
                    },
                    child: const Text('Retour au programme'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
