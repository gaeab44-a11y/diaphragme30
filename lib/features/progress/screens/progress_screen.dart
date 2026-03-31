import 'dart:math' show pi, cos, sin, Random;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/day_program.dart';
import '../../../shared/providers/program_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgramProvider>(
      builder: (context, provider, _) {
        final completed = provider.completedCount;
        final total = provider.days.length;
        final pct = total > 0 ? completed / total : 0.0;

        return Scaffold(
          backgroundColor: AppColors.night,
          body: Stack(
            fit: StackFit.expand,
            children: [
              const CustomPaint(painter: _StarfieldPainter()),
              SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.l),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Spacing.l),
                            // Back button
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.nightElevated,
                                  border: Border.all(
                                      color: AppColors.nightBorder),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: AppColors.textPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.xl),
                            // Editorial header
                            Text('PROGRESSION', style: AppTextStyles.labelSage),
                            const SizedBox(height: Spacing.s),
                            Text('Votre parcours\nen 30 jours.',
                                style: AppTextStyles.displayL),
                            const SizedBox(height: Spacing.xxl),
                            // Progress ring centered
                            Center(
                              child: _ProgressRing(
                                  completed: completed, total: 30),
                            ),
                            const SizedBox(height: Spacing.xxl),
                            // Stat cards
                            Text('STATISTIQUES', style: AppTextStyles.label),
                            const SizedBox(height: Spacing.m),
                            _StatRow(
                                completed: completed,
                                total: total,
                                pct: pct),
                            const SizedBox(height: Spacing.xxl),
                            // Calendar heatmap
                            Text('CALENDRIER', style: AppTextStyles.label),
                            const SizedBox(height: Spacing.m),
                            _CalendarHeatmap(days: provider.days),
                            const SizedBox(height: Spacing.xxxl),
                          ],
                        ),
                      ),
                    ),
                  ],
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
// Fond étoilé
// ─────────────────────────────────────────────────────────────────────────────

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter();

  static final _stars = List.generate(60, (i) {
    final rng = Random(i * 137 + 42);
    return (
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      size: 0.5 + rng.nextDouble() * 1.5,
      opacity: 0.04 + rng.nextDouble() * 0.11,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final s in _stars) {
      paint.color = Colors.white.withValues(alpha: s.opacity);
      canvas.drawCircle(
          Offset(s.x * size.width, s.y * size.height), s.size, paint);
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Anneau de progression
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressRing extends StatelessWidget {
  final int completed;
  final int total;
  const _ProgressRing({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(180, 180),
            painter: _ProgressRingPainter(
                progress: progress, completed: completed, total: total),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$completed',
                style: AppTextStyles.displayM
                    .copyWith(color: AppColors.sage, fontSize: 52),
              ),
              Text('/ $total jours', style: AppTextStyles.bodyS),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final int completed;
  final int total;
  const _ProgressRingPainter(
      {required this.progress, required this.completed, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        progress * 2 * pi,
        false,
        Paint()
          ..color = AppColors.sage.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round,
      );
    }
    for (int i = 0; i < total; i++) {
      final angle = -pi / 2 + (i / total) * 2 * pi;
      final isComp = i < completed;
      final isToday = i == completed;
      canvas.drawCircle(
        Offset(center.dx + cos(angle) * radius,
            center.dy + sin(angle) * radius),
        isToday ? 5.0 : isComp ? 3.5 : 2.5,
        Paint()
          ..color = isComp
              ? AppColors.completed
              : isToday
                  ? AppColors.sage
                  : AppColors.nightBorder
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter old) =>
      progress != old.progress || completed != old.completed;
}

// ─────────────────────────────────────────────────────────────────────────────
// Rangée de cartes stat avec bordure accent gauche
// ─────────────────────────────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  final int completed;
  final int total;
  final double pct;
  const _StatRow(
      {required this.completed, required this.total, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _StatCard(
              value: '$completed',
              label: 'Jours complétés',
              accent: AppColors.sage,
            ),
            const SizedBox(width: Spacing.m),
            _StatCard(
              value: '${total - completed}',
              label: 'Jours restants',
              accent: AppColors.amber,
            ),
          ],
        ),
        const SizedBox(height: Spacing.m),
        _StatCard(
          value: '${(pct * 100).round()}%',
          label: 'Taux de complétion',
          accent: AppColors.sagePale,
          wide: true,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color accent;
  final bool wide;

  const _StatCard({
    required this.value,
    required this.label,
    required this.accent,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.m, vertical: Spacing.m),
      decoration: BoxDecoration(
        color: AppColors.nightElevated,
        borderRadius: BorderRadius.circular(Radius.m),
        border: Border(
          left: BorderSide(color: accent, width: 3),
          top: BorderSide(color: AppColors.nightBorder),
          right: BorderSide(color: AppColors.nightBorder),
          bottom: BorderSide(color: AppColors.nightBorder),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            value,
            style: AppTextStyles.displayM.copyWith(color: accent, fontSize: 36),
          ),
          const SizedBox(width: Spacing.s),
          Text(label, style: AppTextStyles.bodyS),
        ],
      ),
    );

    return wide ? card : Expanded(child: card);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendrier heatmap
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarHeatmap extends StatelessWidget {
  final List<DayProgram> days;
  const _CalendarHeatmap({required this.days});

  @override
  Widget build(BuildContext context) {
    final sections = [
      ('Sem. 1', days.where((d) => d.day >= 1 && d.day <= 7).toList()),
      ('Sem. 2', days.where((d) => d.day >= 8 && d.day <= 14).toList()),
      ('Sem. 3', days.where((d) => d.day >= 15 && d.day <= 21).toList()),
      ('Sem. 4', days.where((d) => d.day >= 22 && d.day <= 28).toList()),
      ('Bonus', days.where((d) => d.day >= 29).toList()),
    ];

    return Column(
      children: sections.map((entry) {
        final label = entry.$1;
        final weekDays = entry.$2;
        if (weekDays.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: Spacing.m),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Text(label,
                    style: AppTextStyles.bodyS
                        .copyWith(color: AppColors.textMuted)),
              ),
              Expanded(
                child: Row(
                  children: weekDays.map((d) {
                    final isCompleted = d.status == DayStatus.completed;
                    final isAvailable = d.status == DayStatus.available;
                    return Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.completedBg
                                  : isAvailable
                                      ? AppColors.sageGhost
                                      : AppColors.locked,
                              borderRadius:
                                  BorderRadius.circular(Radius.s),
                              border: Border.all(
                                color: isCompleted
                                    ? AppColors.completed
                                        .withValues(alpha: 0.5)
                                    : isAvailable
                                        ? AppColors.sage
                                            .withValues(alpha: 0.35)
                                        : Colors.transparent,
                                width: isCompleted || isAvailable ? 1 : 0,
                              ),
                            ),
                            child: Center(
                              child: isCompleted
                                  ? Icon(
                                      Icons.check_rounded,
                                      color: AppColors.completed,
                                      size: _iconSize(weekDays.length),
                                    )
                                  : Text(
                                      '${d.day}',
                                      style: AppTextStyles.bodyS.copyWith(
                                        fontSize: _fontSize(weekDays.length),
                                        color: isAvailable
                                            ? AppColors.sagePale
                                            : AppColors.lockedText,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  double _iconSize(int count) => count <= 2 ? 16 : 13;
  double _fontSize(int count) => count <= 2 ? 12 : 9;
}
