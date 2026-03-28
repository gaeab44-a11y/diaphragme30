import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/program_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import '../widgets/feeling_selector.dart';
import 'home_screen.dart';

class CompletionScreen extends StatelessWidget {
  final int dayId;
  const CompletionScreen({super.key, required this.dayId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProgramProvider>();
    final isLast = dayId == 30;
    final nextDay = provider.getDayById(dayId + 1);

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header vert avec check
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: AppColors.completionGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingL,
                  AppTheme.spacingXXL,
                  AppTheme.spacingL,
                  AppTheme.spacingXXL,
                ),
                child: Column(
                  children: [
                    // Cercle check
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    Text(
                      isLast ? 'Programme\nterminé !' : 'Séance\nterminée',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: Colors.white,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      isLast
                          ? 'Tu as complété les 30 jours.\nTon diaphragme te remercie.'
                          : _message(dayId),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Corps
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacingM),

                    // Sélecteur de ressenti
                    FeelingSelector(
                      onSelected: (feeling) =>
                          provider.saveFeeling(dayId, feeling),
                    ),

                    // Jour suivant
                    if (!isLast && nextDay != null) ...[
                      const SizedBox(height: AppTheme.spacingXL),
                      Text(
                        'PROCHAIN',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusL),
                          boxShadow: AppTheme.softShadow,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.bluePale,
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusM),
                              ),
                              child: Center(
                                child: Text(
                                  '${nextDay.id}',
                                  style: AppTextStyles.headingMedium.copyWith(
                                    color: AppColors.bluePrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jour ${nextDay.id} débloqué',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.blueLight,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    nextDay.title,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.lock_open_rounded,
                              color: AppColors.blueLight,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: AppTheme.spacingXXL),

                    ElevatedButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HomeScreen()),
                        (_) => false,
                      ),
                      child: const Text('Retour à l\'accueil'),
                    ),

                    const SizedBox(height: AppTheme.spacingL),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _message(int id) {
    if (id <= 7) return 'Tu découvres ton souffle.\nChaque séance compte.';
    if (id <= 14) return 'Ta conscience s\'affine.\nContinue comme ça.';
    if (id <= 21) return 'Tu approfondis ta pratique.\nTu fais vraiment bien.';
    return 'Tu ancres cette habitude.\nElle t\'appartient.';
  }
}
