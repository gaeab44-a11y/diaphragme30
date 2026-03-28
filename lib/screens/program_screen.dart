import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/program_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import 'session_screen.dart';

class ProgramScreen extends StatelessWidget {
  final int dayId;
  const ProgramScreen({super.key, required this.dayId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProgramProvider>();
    final day = provider.getDayById(dayId);

    if (day == null) {
      return const Scaffold(
        body: Center(child: Text('Jour introuvable')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: Stack(
        children: [
          // Fond vert en haut
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusM),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (day.isCompleted)
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
                          child: Row(
                            children: [
                              const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Complété',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Titre dans la zone verte
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'JOUR ${day.id}'.toUpperCase(),
                        style: AppTextStyles.label.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        day.title,
                        style: AppTextStyles.displayMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spacingXL),

                // Contenu scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.spacingL,
                      AppTheme.spacingL,
                      AppTheme.spacingL,
                      AppTheme.spacingXXL,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chips infos
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.timer_outlined,
                              label: '${day.durationMinutes} minutes',
                            ),
                            const SizedBox(width: AppTheme.spacingS),
                            Expanded(
                              child: _InfoChip(
                                icon: Icons.accessibility_new_rounded,
                                label: day.posture,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppTheme.spacingXL),

                        // Ce que tu vas faire
                        _SectionCard(
                          label: 'CE QUE TU VAS FAIRE',
                          color: AppColors.bluePale,
                          labelColor: AppColors.blueLight,
                          child: Text(
                            day.instruction,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textDark,
                              height: 1.75,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacingM),

                        // Ce que tu pourrais ressentir
                        _SectionCard(
                          label: 'CE QUE TU POURRAIS RESSENTIR',
                          color: AppColors.sandPale,
                          labelColor: AppColors.sand,
                          child: Text(
                            day.feelingGoal,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textDark,
                              height: 1.75,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacingXXL),

                        // Bouton démarrer
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SessionScreen(dayId: day.id),
                            ),
                          ),
                          child: Text(
                            day.isCompleted
                                ? 'Refaire la séance'
                                : 'Démarrer la séance',
                          ),
                        ),
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
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.blueLight),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String label;
  final Color color;
  final Color labelColor;
  final Widget child;
  const _SectionCard({
    required this.label,
    required this.color,
    required this.labelColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: labelColor),
          ),
          const SizedBox(height: AppTheme.spacingM),
          child,
        ],
      ),
    );
  }
}
