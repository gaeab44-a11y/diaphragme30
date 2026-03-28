import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/program_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  int _page = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      label: 'JOUR 1 SUR 30',
      title: 'Votre souffle,\nvotre pouvoir.',
      body:
          'En 30 jours, transformez votre relation à la respiration. Une pratique quotidienne, guidée, sensorielle.',
    ),
    _OnboardingPage(
      label: 'SCIENCE',
      title: 'Prouvé par\nla science.',
      body:
          'La respiration consciente réduit le cortisol, améliore le sommeil et renforce la cohérence cardiaque.',
    ),
    _OnboardingPage(
      label: 'VOTRE VOYAGE',
      title: '5 minutes\npar jour.',
      body:
          'Chaque session s\'adapte à votre niveau. Débutant ou confirmé, votre parcours vous attend.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      setState(() => _page++);
    } else {
      _start();
    }
  }

  Future<void> _start() async {
    await context.read<ProgramProvider>().startProgram();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _pages[_page];
    return Scaffold(
      backgroundColor: AppColors.night,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.l),
          child: Column(
            children: [
              const SizedBox(height: Spacing.xl),
              // Breathing orb
              Expanded(
                flex: 5,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, child) => Transform.scale(
                      scale: _scale.value,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [
                              Color(0x807DB5A8),
                              Color(0x307DB5A8),
                              Color(0x007DB5A8),
                            ],
                          ),
                          boxShadow: AppTheme.glowSage(opacity: _opacity.value * 0.4),
                        ),
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.sage,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.label, style: AppTextStyles.label),
                    const SizedBox(height: Spacing.m),
                    Text(p.title, style: AppTextStyles.displayL),
                    const SizedBox(height: Spacing.m),
                    Text(p.body, style: AppTextStyles.bodyL),
                    const Spacer(),
                    // Dots
                    Row(
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          width: i == _page ? 24 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _page
                                ? AppColors.sage
                                : AppColors.nightBorder,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.l),
                    ElevatedButton(
                      onPressed: _next,
                      child: Text(
                        _page < _pages.length - 1 ? 'Continuer' : 'Commencer',
                      ),
                    ),
                    const SizedBox(height: Spacing.m),
                    if (_page < _pages.length - 1)
                      Center(
                        child: TextButton(
                          onPressed: _start,
                          child: const Text('Passer'),
                        ),
                      ),
                    const SizedBox(height: Spacing.m),
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

class _OnboardingPage {
  final String label;
  final String title;
  final String body;
  const _OnboardingPage({
    required this.label,
    required this.title,
    required this.body,
  });
}
