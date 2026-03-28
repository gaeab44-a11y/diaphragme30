import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

/// Ressentis disponibles (emoji + label).
class Feeling {
  final String emoji;
  final String label;
  const Feeling(this.emoji, this.label);
}

/// Liste publique utilisable depuis d'autres widgets (ex: ProgressScreen).
const kFeelings = [
  Feeling('😌', 'Apaisé'),
  Feeling('😊', 'Bien'),
  Feeling('😐', 'Neutre'),
  Feeling('😶', 'Distrait'),
  Feeling('😕', 'Difficile'),
];

/// Sélecteur de ressenti post-séance.
/// Appelle [onSelected] avec le label du ressenti choisi.
class FeelingSelector extends StatefulWidget {
  final ValueChanged<String> onSelected;
  final String? initialValue;

  const FeelingSelector({
    super.key,
    required this.onSelected,
    this.initialValue,
  });

  @override
  State<FeelingSelector> createState() => _FeelingSelectorState();
}

class _FeelingSelectorState extends State<FeelingSelector> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comment tu te sens ?',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: kFeelings.map((f) => _FeelingChip(
            feeling: f,
            isSelected: _selected == f.label,
            onTap: () {
              setState(() => _selected = f.label);
              widget.onSelected(f.label);
            },
          )).toList(),
        ),
      ],
    );
  }
}

class _FeelingChip extends StatelessWidget {
  final Feeling feeling;
  final bool isSelected;
  final VoidCallback onTap;

  const _FeelingChip({
    required this.feeling,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingS,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bluePale : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.bluePrimary : AppColors.textLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              feeling.emoji,
              style: TextStyle(fontSize: isSelected ? 28 : 24),
            ),
            const SizedBox(height: 4),
            Text(
              feeling.label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected
                    ? AppColors.bluePrimary
                    : AppColors.textMedium,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
