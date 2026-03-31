import 'dart:math' show pi, cos, sin, Random;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/day_program.dart';
import '../../../shared/providers/program_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgramProvider>(
      builder: (context, provider, _) {
        final today = provider.getDayProgram(provider.currentDay);
        return Scaffold(
          backgroundColor: AppColors.night,
          body: Stack(
            fit: StackFit.expand,
            children: [
              const CustomPaint(painter: _StarfieldPainter()),
              CustomScrollView(
                slivers: [
                  _buildAppBar(context, provider),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.l),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: Spacing.xl),
                        if (today != null)
                          _HeroSection(
                            today: today,
                            completedCount: provider.completedCount,
                          ),
                        const SizedBox(height: Spacing.xxl),
                        Text('PROGRAMME', style: AppTextStyles.label),
                        const SizedBox(height: Spacing.l),
                        _WeekGrid(days: provider.days),
                        const SizedBox(height: Spacing.xxxl),
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, ProgramProvider provider) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      titleSpacing: Spacing.l,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Diaphragmatix', style: AppTextStyles.headingL),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/progress'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.nightElevated,
                border: Border.all(color: AppColors.nightBorder),
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section hero éditoriale
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final DayProgram today;
  final int completedCount;

  const _HeroSection({required this.today, required this.completedCount});

  @override
  Widget build(BuildContext context) {
    final isAvailable = today.status == DayStatus.available;
    final isCompleted = today.status == DayStatus.completed;
    final weekLabel = today.subtitle.contains('—')
        ? today.subtitle.split('—').last.trim().toUpperCase()
        : today.subtitle.toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('JOUR ${today.day} — $weekLabel', style: AppTextStyles.labelSage),
        const SizedBox(height: Spacing.s),
        // C — FittedBox pour éviter l'overflow sur les titres longs
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(today.title, style: AppTextStyles.displayXL),
        ),
        const SizedBox(height: Spacing.xl),
        Center(
          child: _ProgressRing(completed: completedCount, total: 30),
        ),
        const SizedBox(height: Spacing.xl),
        Text(
          '"${today.intention}"',
          style: AppTextStyles.breathe.copyWith(
            fontSize: 17,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: Spacing.xl),
        if (isAvailable)
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                context, '/session',
                arguments: today.day),
            child: const Text('Commencer la session'),
          )
        else if (isCompleted)
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.m, vertical: Spacing.s),
            decoration: BoxDecoration(
              color: AppColors.completedBg,
              borderRadius: BorderRadius.circular(Radius.full),
              border: Border.all(
                  color: AppColors.completed.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_rounded,
                    color: AppColors.completed, size: 16),
                const SizedBox(width: Spacing.s),
                Text('Session complétée',
                    style: AppTextStyles.bodyS
                        .copyWith(color: AppColors.completed)),
              ],
            ),
          ),
        const SizedBox(height: Spacing.m),
        Row(
          children: [
            _Chip(icon: Icons.timer_outlined, label: '${today.totalMinutes} min'),
            const SizedBox(width: Spacing.s),
            _Chip(icon: Icons.loop, label: '${today.cycles} cycles'),
          ],
        ),
      ],
    );
  }
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
      width: 164,
      height: 164,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(164, 164),
            painter: _ProgressRingPainter(
                progress: progress, completed: completed, total: total),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$completed',
                style: AppTextStyles.displayM
                    .copyWith(color: AppColors.sage, fontSize: 44),
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
          ..strokeWidth = 8
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
        isToday ? 4.5 : isComp ? 3.5 : 2.5,
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
// Grille des semaines
// ─────────────────────────────────────────────────────────────────────────────

class _WeekGrid extends StatelessWidget {
  final List<DayProgram> days;
  const _WeekGrid({required this.days});

  @override
  Widget build(BuildContext context) {
    final sections = [
      ('Semaine 1', days.where((d) => d.day >= 1 && d.day <= 7).toList()),
      ('Semaine 2', days.where((d) => d.day >= 8 && d.day <= 14).toList()),
      ('Semaine 3', days.where((d) => d.day >= 15 && d.day <= 21).toList()),
      ('Semaine 4', days.where((d) => d.day >= 22 && d.day <= 28).toList()),
      ('Bonus', days.where((d) => d.day >= 29).toList()),
    ];

    return Column(
      children: sections.map((entry) {
        final label = entry.$1;
        final weekDays = entry.$2;
        if (weekDays.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(bottom: Spacing.s, top: Spacing.m),
              child: Text(label, style: AppTextStyles.bodyS),
            ),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: Spacing.s,
              mainAxisSpacing: Spacing.s,
              childAspectRatio: 1,
              children: weekDays.map((d) => _DayCell(day: d)).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cellule de jour avec shimmer sur le jour disponible
// ─────────────────────────────────────────────────────────────────────────────

class _DayCell extends StatefulWidget {
  final DayProgram day;
  const _DayCell({required this.day});

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> with SingleTickerProviderStateMixin {
  AnimationController? _shimmer;

  @override
  void initState() {
    super.initState();
    if (widget.day.status == DayStatus.available) {
      _shimmer = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2400),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _shimmer?.dispose();
    super.dispose();
  }

  void _showCompletedDaySheet(BuildContext context, DayProgram day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.nightElevated,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: ui.Radius.circular(Radius.l)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(Spacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.completedBg,
                    border: Border.all(
                        color: AppColors.completed.withValues(alpha: 0.5)),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.completed, size: 16),
                ),
                const SizedBox(width: Spacing.m),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('JOUR ${day.day} — COMPLÉTÉ',
                        style: AppTextStyles.label.copyWith(
                            color: AppColors.completed, letterSpacing: 1.8)),
                    Text(day.title, style: AppTextStyles.headingM),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Spacing.l),
            Text(day.description, style: AppTextStyles.bodyM),
            const SizedBox(height: Spacing.s),
            Text('"${day.intention}"',
                style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.sagePale,
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: Spacing.xl),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/session', arguments: day.day);
              },
              child: const Text('Rejouer la session'),
            ),
            const SizedBox(height: Spacing.m),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.day.status == DayStatus.completed;
    final isAvailable = widget.day.status == DayStatus.available;

    Widget cell = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.completedBg
            : isAvailable
                ? AppColors.sageGhost
                : AppColors.locked,
        borderRadius: BorderRadius.circular(Radius.m),
        border: Border.all(
          color: isCompleted
              ? AppColors.completed.withValues(alpha: 0.4)
              : isAvailable
                  ? AppColors.sage.withValues(alpha: 0.4)
                  : Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isCompleted)
            const Icon(Icons.check_rounded,
                color: AppColors.completed, size: 16)
          else
            Text(
              '${widget.day.day}',
              style: AppTextStyles.bodyS.copyWith(
                color: isAvailable
                    ? AppColors.sagePale
                    : AppColors.lockedText,
                fontWeight:
                    isAvailable ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
        ],
      ),
    );

    // Shimmer sur le jour disponible
    if (isAvailable && _shimmer != null) {
      cell = AnimatedBuilder(
        animation: _shimmer!,
        builder: (_, child) => ClipRRect(
          borderRadius: BorderRadius.circular(Radius.m),
          child: Stack(
            children: [
              child!,
              CustomPaint(
                size: Size.infinite,
                painter: _ShimmerPainter(value: _shimmer!.value),
              ),
            ],
          ),
        ),
        child: cell,
      );
    }

    return GestureDetector(
      onTap: isAvailable
          ? () => Navigator.pushNamed(context, '/session',
              arguments: widget.day.day)
          : isCompleted
              ? () => _showCompletedDaySheet(context, widget.day)
              : null,
      child: cell,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Peintre shimmer
// ─────────────────────────────────────────────────────────────────────────────

class _ShimmerPainter extends CustomPainter {
  final double value; // 0-1
  const _ShimmerPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    // Le reflet balaye de gauche à droite
    final shift = value * 3.0 - 1.0; // -1 → 2
    final gradient = LinearGradient(
      colors: [
        Colors.transparent,
        Colors.white.withValues(alpha: 0.1),
        Colors.transparent,
      ],
      stops: const [0.3, 0.5, 0.7],
      begin: Alignment(shift - 1.0, -0.5),
      end: Alignment(shift + 1.0, 0.5),
    );
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      ui.Radius.circular(Radius.m),
    );
    canvas.drawRRect(
        rrect, Paint()..shader = gradient.createShader(Offset.zero & size));
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => value != old.value;
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip d'info
// ─────────────────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.s, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.nightMid,
        borderRadius: BorderRadius.circular(Radius.full),
        border: Border.all(color: AppColors.nightBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.bodyS),
        ],
      ),
    );
  }
}
