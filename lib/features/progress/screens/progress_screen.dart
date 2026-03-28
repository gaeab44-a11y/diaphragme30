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
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Spacing.l),
                  _TopBar(),
                  const SizedBox(height: Spacing.xl),
                  Text('PROGRESSION', style: AppTextStyles.label),
                  const SizedBox(height: Spacing.s),
                  Text('Votre parcours', style: AppTextStyles.displayM),
                  const SizedBox(height: Spacing.xl),

                  // Stats row
                  Row(
                    children: [
                      _StatCard(
                        value: '$completed',
                        label: 'Jours\ncomplétés',
                        accent: AppColors.sage,
                      ),
                      const SizedBox(width: Spacing.m),
                      _StatCard(
                        value: '${total - completed}',
                        label: 'Jours\nrestants',
                        accent: AppColors.amber,
                      ),
                      const SizedBox(width: Spacing.m),
                      _StatCard(
                        value: '${(pct * 100).round()}%',
                        label: 'Taux de\ncomplétion',
                        accent: AppColors.sagePale,
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xl),

                  // Progress bar
                  _ProgressBar(value: pct),
                  const SizedBox(height: Spacing.xl),

                  // Calendar heatmap
                  Text('CALENDRIER', style: AppTextStyles.label),
                  const SizedBox(height: Spacing.m),
                  _CalendarHeatmap(days: provider.days),
                  const SizedBox(height: Spacing.xxl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color accent;

  const _StatCard({
    required this.value,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Spacing.m),
        decoration: BoxDecoration(
          color: AppColors.nightElevated,
          borderRadius: BorderRadius.circular(Radius.m),
          border: Border.all(color: AppColors.nightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.displayM.copyWith(color: accent),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.bodyS),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value;
  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progression globale', style: AppTextStyles.bodyM),
            Text(
              '${(value * 100).round()}%',
              style: AppTextStyles.bodyM.copyWith(color: AppColors.sage),
            ),
          ],
        ),
        const SizedBox(height: Spacing.s),
        ClipRRect(
          borderRadius: BorderRadius.circular(Radius.full),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppColors.nightElevated,
            color: AppColors.sage,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _CalendarHeatmap extends StatelessWidget {
  final List<DayProgram> days;
  const _CalendarHeatmap({required this.days});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: Spacing.s,
        mainAxisSpacing: Spacing.s,
        childAspectRatio: 1,
      ),
      itemCount: days.length,
      itemBuilder: (context, i) {
        final d = days[i];
        final isCompleted = d.status == DayStatus.completed;
        final isAvailable = d.status == DayStatus.available;
        return Container(
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.completedBg
                : isAvailable
                    ? AppColors.sageGhost
                    : AppColors.locked,
            borderRadius: BorderRadius.circular(Radius.s),
            border: Border.all(
              color: isCompleted
                  ? AppColors.completed.withValues(alpha: 0.5)
                  : isAvailable
                      ? AppColors.sage.withValues(alpha: 0.3)
                      : Colors.transparent,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.completed,
                    size: 14,
                  )
                : Text(
                    '${d.day}',
                    style: AppTextStyles.bodyS.copyWith(
                      fontSize: 10,
                      color: isAvailable
                          ? AppColors.sagePale
                          : AppColors.lockedText,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
