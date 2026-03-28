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
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, provider),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.l),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: Spacing.xl),
                    if (today != null) _TodayCard(day: today),
                    const SizedBox(height: Spacing.xl),
                    _SectionTitle(
                      label: 'PROGRAMME',
                      title: '30 jours de\ndécouverte',
                    ),
                    const SizedBox(height: Spacing.l),
                    _WeekGrid(days: provider.days),
                    const SizedBox(height: Spacing.xxxl),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, ProgramProvider provider) {
    return SliverAppBar(
      backgroundColor: AppColors.night,
      floating: true,
      titleSpacing: Spacing.l,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Diaphragmatix', style: AppTextStyles.headingL),
              Text(
                '${provider.completedCount} / 30 complétés',
                style: AppTextStyles.bodyS,
              ),
            ],
          ),
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

class _TodayCard extends StatelessWidget {
  final DayProgram day;
  const _TodayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final isAvailable = day.status == DayStatus.available;
    final isCompleted = day.status == DayStatus.completed;

    return GestureDetector(
      onTap: isAvailable
          ? () => Navigator.pushNamed(context, '/session', arguments: day.day)
          : null,
      child: Container(
        padding: const EdgeInsets.all(Spacing.l),
        decoration: BoxDecoration(
          color: AppColors.nightElevated,
          borderRadius: BorderRadius.circular(Radius.l),
          border: Border.all(
            color: isCompleted
                ? AppColors.completed.withValues(alpha: 0.4)
                : isAvailable
                    ? AppColors.sage.withValues(alpha: 0.3)
                    : AppColors.nightBorder,
          ),
          boxShadow: isAvailable ? AppTheme.glowSage(opacity: 0.1) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  isCompleted
                      ? 'COMPLÉTÉ'
                      : isAvailable
                          ? "AUJOURD'HUI"
                          : 'VERROUILLÉ',
                  style: isCompleted
                      ? AppTextStyles.label.copyWith(
                          color: AppColors.completed,
                          letterSpacing: 1.8,
                        )
                      : AppTextStyles.labelSage,
                ),
                const Spacer(),
                Text(
                  'Jour ${day.day}',
                  style: AppTextStyles.bodyS,
                ),
              ],
            ),
            const SizedBox(height: Spacing.m),
            Text(day.title, style: AppTextStyles.displayM),
            const SizedBox(height: Spacing.s),
            Text(day.description, style: AppTextStyles.bodyM, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: Spacing.l),
            Row(
              children: [
                _Chip(icon: Icons.timer_outlined, label: '${day.totalMinutes} min'),
                const SizedBox(width: Spacing.s),
                _Chip(icon: Icons.loop, label: '${day.cycles} cycles'),
                const Spacer(),
                if (isAvailable)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.m,
                      vertical: Spacing.s,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sage,
                      borderRadius: BorderRadius.circular(Radius.full),
                    ),
                    child: Text(
                      'Commencer',
                      style: AppTextStyles.btnM.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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

class _SectionTitle extends StatelessWidget {
  final String label;
  final String title;
  const _SectionTitle({required this.label, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: Spacing.s),
        Text(title, style: AppTextStyles.displayS),
      ],
    );
  }
}

class _WeekGrid extends StatelessWidget {
  final List<DayProgram> days;
  const _WeekGrid({required this.days});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(6, (week) {
        final start = week * 5;
        final end = (start + 5).clamp(0, days.length);
        if (start >= days.length) return const SizedBox.shrink();
        final weekDays = days.sublist(start, end);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.s, top: Spacing.m),
              child: Text(
                'Semaine ${week + 1}',
                style: AppTextStyles.bodyS,
              ),
            ),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: Spacing.s,
              mainAxisSpacing: Spacing.s,
              childAspectRatio: 1,
              children: weekDays.map((d) => _DayCell(day: d)).toList(),
            ),
          ],
        );
      }),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DayProgram day;
  const _DayCell({required this.day});

  void _showCompletedDaySheet(BuildContext context, DayProgram day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.nightElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: ui.Radius.circular(Radius.l)),
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
                      color: AppColors.completed.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.completed,
                    size: 16,
                  ),
                ),
                const SizedBox(width: Spacing.m),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'JOUR ${day.day} — COMPLÉTÉ',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.completed,
                        letterSpacing: 1.8,
                      ),
                    ),
                    Text(day.title, style: AppTextStyles.headingM),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Spacing.l),
            Text(day.description, style: AppTextStyles.bodyM),
            const SizedBox(height: Spacing.s),
            Text(
              '"${day.intention}"',
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.sagePale,
                fontStyle: FontStyle.italic,
              ),
            ),
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
    final isCompleted = day.status == DayStatus.completed;
    final isAvailable = day.status == DayStatus.available;

    return GestureDetector(
      onTap: isAvailable
          ? () => Navigator.pushNamed(context, '/session', arguments: day.day)
          : isCompleted
              ? () => _showCompletedDaySheet(context, day)
              : null,
      child: AnimatedContainer(
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
              const Icon(Icons.check_rounded, color: AppColors.completed, size: 16)
            else
              Text(
                '${day.day}',
                style: AppTextStyles.bodyS.copyWith(
                  color: isAvailable
                      ? AppColors.sagePale
                      : AppColors.lockedText,
                  fontWeight: isAvailable ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
