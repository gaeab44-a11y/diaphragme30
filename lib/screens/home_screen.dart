import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/day_program.dart';
import '../providers/program_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../widgets/progress_bar.dart';
import 'program_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: Consumer<ProgramProvider>(
          builder: (context, provider, _) {
            if (!provider.isLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _Header(provider: provider)),
                SliverToBoxAdapter(child: _TodayCard(provider: provider)),
                SliverToBoxAdapter(child: _ProgressSection(provider: provider)),
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
}

// ── En-tête ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final ProgramProvider provider;
  const _Header({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingL,
        AppTheme.spacingL,
        AppTheme.spacingL,
        AppTheme.spacingM,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting().toUpperCase(),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  'Diaphragme 30',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Bouton stats
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProgressScreen()),
            ),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: AppTheme.softShadow,
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.bluePrimary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bonjour';
    if (h < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }
}

// ── Carte du jour ─────────────────────────────────────────────────────────────

class _TodayCard extends StatelessWidget {
  final ProgramProvider provider;
  const _TodayCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final day = provider.currentDay;
    final isDone = provider.isProgramComplete;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.heroGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.bluePrimary.withValues(alpha: 0.35),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          child: Stack(
            children: [
              // Cercle décoratif arrière-plan
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: -20,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.03),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge jour
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusFull),
                      ),
                      child: Text(
                        isDone
                            ? 'PROGRAMME TERMINÉ'
                            : 'JOUR ${day.id} SUR 30',
                        style: AppTextStyles.label.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingL),

                    // Titre
                    Text(
                      isDone ? 'Tu as tout accompli.' : day.title,
                      style: AppTextStyles.headingLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingS),

                    // Sous-titre
                    Text(
                      isDone
                          ? 'Ton diaphragme te remercie.'
                          : '${day.durationMinutes} min  ·  ${day.posture}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingXL),

                    // Bouton
                    if (!isDone)
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProgramScreen(dayId: day.id),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Center(
                            child: Text(
                              day.isCompleted
                                  ? 'Revoir la séance'
                                  : 'Commencer la séance',
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: AppColors.bluePrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section progression ───────────────────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  final ProgramProvider provider;
  const _ProgressSection({required this.provider});

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Programme', style: AppTextStyles.headingMedium),
              Text(
                '${provider.completedCount} / 30',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.bluePrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),

          ProgressBar(value: provider.progressPercent, height: 6),

          const SizedBox(height: AppTheme.spacingXL),

          _DaysGrid(provider: provider),
        ],
      ),
    );
  }
}

// ── Grille 30 jours ──────────────────────────────────────────────────────────

class _DaysGrid extends StatelessWidget {
  final ProgramProvider provider;
  const _DaysGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemCount: provider.days.length,
      itemBuilder: (context, index) {
        final day = provider.days[index];
        return GestureDetector(
          onTap: day.isUnlocked
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgramScreen(dayId: day.id),
                    ),
                  )
              : null,
          child: _DayChip(day: day),
        );
      },
    );
  }
}

class _DayChip extends StatelessWidget {
  final DayProgram day;
  const _DayChip({required this.day});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Widget child;

    if (day.isCompleted) {
      bg = AppColors.greenSoft;
      child = const Icon(Icons.check_rounded, color: Colors.white, size: 14);
    } else if (day.isUnlocked) {
      bg = AppColors.card;
      child = Text(
        '${day.id}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.bluePrimary,
        ),
      );
    } else {
      bg = const Color(0xFFECE8E0);
      child = Text(
        '${day.id}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.lockedText,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        boxShadow: day.isUnlocked && !day.isCompleted
            ? AppTheme.softShadow
            : null,
      ),
      child: Center(child: child),
    );
  }
}
