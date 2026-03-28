import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class ProgressBar extends StatelessWidget {
  /// Valeur entre 0.0 et 1.0.
  final double value;
  final String? label;
  final String? trailing;
  final double height;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const ProgressBar({
    super.key,
    required this.value,
    this.label,
    this.trailing,
    this.height = 8,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? AppColors.bluePrimary;
    final bg = backgroundColor ?? AppColors.bluePale;
    final clamped = value.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || trailing != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(label!, style: AppTextStyles.bodySmall),
              if (trailing != null)
                Text(
                  trailing!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.bluePrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, animValue, _) {
              return LinearProgressIndicator(
                value: animValue,
                minHeight: height,
                backgroundColor: bg,
                valueColor: AlwaysStoppedAnimation<Color>(fg),
              );
            },
          ),
        ),
      ],
    );
  }
}
