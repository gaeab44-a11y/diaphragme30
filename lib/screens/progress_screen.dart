import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/day_program.dart';
import '../providers/program_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../widgets/feeling_selector.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: Consumer<ProgramProvider>(
          builder: (context, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context, provider)),
                SliverToBoxAdapter(child: _buildRing(provider)),
                SliverToBoxAdapter(child: _buildWeekly(provider)),
                if (provider.days.any((d) => d.feeling != null))
                  SliverToBoxAdapter(child: _buildFeelings(provider)),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppTheme.spacingXXL),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProgramProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingL,
        AppTheme.spacingM,
        AppTheme.spacingL,
        AppTheme.spacingL,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: AppTheme.softShadow,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.bluePrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MA PROGRESSION',
                style: AppTextStyles.label.copyWith(color: AppColors.textLight),
              ),
              const SizedBox(height: 2),
              Text(
                '${provider.completedCount} jour${provider.completedCount > 1 ? 's' : ''} complété${provider.completedCount > 1 ? 's' : ''}',
                style: AppTextStyles.headingMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRing(ProgramProvider provider) {
    final percent = (provider.progressPercent * 100).round();
    final completed = provider.completedCount;
    final remaining = 30 - completed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      child: Column(
        children: [
          // Anneau
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: provider.progressPercent),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOut,
                  builder: (_, v, w) => SizedBox(
                    width: 164,
                    height: 164,
                    child: CircularProgressIndicator(
                      value: v,
                      strokeWidth: 10,
                      backgroundColor: AppColors.bluePale,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.bluePrimary,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percent%',
                      style: AppTextStyles.displayLarge.copyWith(
                        color: AppColors.bluePrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'accompli',
                      style: AppTextStyles.bodySmall.copyWith(
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingL),

          // Cartes stats
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '$completed',
                  label: 'Complétés',
                  valueColor: AppColors.greenSoft,
                  bg: AppColors.greenPale,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: _StatCard(
                  value: '$remaining',
                  label: 'Restants',
                  valueColor: AppColors.bluePrimary,
                  bg: AppColors.bluePale,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekly(ProgramProvider provider) {
    const weekLabels = [
      'Semaine 1 · Découverte',
      'Semaine 2 · Conscience',
      'Semaine 3 · Approfondissement',
      'Semaine 4 · Ancrage',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingL,
        AppTheme.spacingXL,
        AppTheme.spacingL,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Les 30 jours', style: AppTextStyles.headingMedium),
          const SizedBox(height: AppTheme.spacingL),
          ...List.generate(4, (w) {
            final start = w * 7;
            final end = (start + 7).clamp(0, 30);
            final weekDays = provider.days.sublist(start, end);
            final done = weekDays.where((d) => d.isCompleted).length;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        weekLabels[w],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$done/${weekDays.length}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.blueLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Row(
                    children: weekDays
                        .map((d) => Expanded(child: _WeekDayCell(day: d)))
                        .toList(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFeelings(ProgramProvider provider) {
    final counts = <String, int>{};
    for (final d in provider.days) {
      if (d.feeling != null) {
        counts[d.feeling!] = (counts[d.feeling!] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingL,
        AppTheme.spacingXL,
        AppTheme.spacingL,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mes ressentis', style: AppTextStyles.headingMedium),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Ce que tu as ressenti après chaque séance.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingL),
          ...sorted.map((e) {
            final emoji = _emojiFor(e.key);
            final frac = e.value / provider.completedCount;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.key, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark)),
                            Text(
                              '${e.value}×',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusFull),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: frac),
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeOut,
                            builder: (_, v, w) => LinearProgressIndicator(
                              value: v,
                              minHeight: 6,
                              backgroundColor: AppColors.bluePale,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                AppColors.bluePrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _emojiFor(String label) {
    try {
      return kFeelings.firstWhere((f) => f.label == label).emoji;
    } catch (_) {
      return '•';
    }
  }
}

// ── Cellule semaine ──────────────────────────────────────────────────────────

class _WeekDayCell extends StatelessWidget {
  final DayProgram day;
  const _WeekDayCell({required this.day});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Widget content;

    if (day.isCompleted) {
      bg = AppColors.greenSoft;
      final emoji =
          day.feeling != null ? _emojiFor(day.feeling!) : null;
      content = emoji != null
          ? Text(emoji, style: const TextStyle(fontSize: 13))
          : const Icon(Icons.check_rounded, color: Colors.white, size: 13);
    } else if (day.isUnlocked) {
      bg = AppColors.bluePale;
      content = Text(
        '${day.id}',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.bluePrimary,
        ),
      );
    } else {
      bg = const Color(0xFFECE8E0);
      content = Text(
        '${day.id}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppColors.textLight.withValues(alpha: 0.7),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(right: 4),
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Center(child: content),
    );
  }

  String _emojiFor(String label) {
    try {
      return kFeelings.firstWhere((f) => f.label == label).emoji;
    } catch (_) {
      return '✓';
    }
  }
}

// ── Carte stat ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color bg;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.displayMedium.copyWith(color: valueColor),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
