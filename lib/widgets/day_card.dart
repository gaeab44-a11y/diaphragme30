import 'package:flutter/material.dart';
import '../models/day_program.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class DayCard extends StatelessWidget {
  final DayProgram day;
  final VoidCallback? onTap;

  const DayCard({super.key, required this.day, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLocked = !day.isUnlocked;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedOpacity(
        opacity: isLocked ? 0.45 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingL,
            vertical: AppTheme.spacingXS,
          ),
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            color: _cardColor(),
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: day.isUnlocked && !day.isCompleted
                ? Border.all(color: AppColors.bluePale, width: 1.5)
                : null,
          ),
          child: Row(
            children: [
              // Indicateur numéro/état
              _DayBadge(day: day),
              const SizedBox(width: AppTheme.spacingM),

              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jour ${day.id}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _labelColor(),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      day.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isLocked
                            ? AppColors.textLight
                            : AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Durée + flèche
              if (!isLocked) ...[
                Text(
                  '${day.durationMinutes} min',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                if (!day.isCompleted)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMedium,
                    size: 20,
                  ),
              ],

              if (isLocked)
                Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textLight,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _cardColor() {
    if (day.isCompleted) return AppColors.greenPale;
    if (day.isUnlocked) return Colors.white;
    return const Color(0xFFEEEAE0);
  }

  Color _labelColor() {
    if (day.isCompleted) return AppColors.greenSoft;
    if (day.isUnlocked) return AppColors.bluePrimary;
    return AppColors.textLight;
  }
}

class _DayBadge extends StatelessWidget {
  final DayProgram day;
  const _DayBadge({required this.day});

  @override
  Widget build(BuildContext context) {
    if (day.isCompleted) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.greenSoft,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
      );
    }

    if (day.isUnlocked) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.bluePale,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: Center(
          child: Text(
            '${day.id}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.bluePrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E0D4),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Center(
        child: Text(
          '${day.id}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
