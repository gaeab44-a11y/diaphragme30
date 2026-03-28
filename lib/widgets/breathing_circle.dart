import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Cercle animé de respiration.
/// [size] = diamètre de base, [color] = couleur du cercle intérieur.
/// S'adapte automatiquement (mode sombre via [darkMode]).
class BreathingCircle extends StatefulWidget {
  final double size;
  final Color? color;
  final bool darkMode;
  final bool isPaused;
  final Widget? child;

  const BreathingCircle({
    super.key,
    this.size = 200,
    this.color,
    this.darkMode = false,
    this.isPaused = false,
    this.child,
  });

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.70, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(BreathingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
      } else {
        _controller.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ??
        (widget.darkMode ? Colors.white : AppColors.bluePrimary);
    final outerColor = baseColor.withValues(alpha: widget.darkMode ? 0.12 : 0.10);
    final innerColor = baseColor.withValues(alpha: widget.darkMode ? 0.18 : 0.15);

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        final outerSize = widget.size * _scale.value;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Center(
            child: Container(
              width: outerSize,
              height: outerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: outerColor,
              ),
              child: Center(
                child: Container(
                  width: widget.size * 0.70,
                  height: widget.size * 0.70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: innerColor,
                  ),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
