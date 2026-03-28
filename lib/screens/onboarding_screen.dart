import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/program_provider.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_styles.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _PageData(
      emoji: '🫁',
      tag: 'BIENVENUE',
      title: 'Découvre\nton souffle.',
      body: 'Un programme de 30 jours pour apprendre à respirer vraiment — sans effort, sans pression.',
      bgTop: Color(0xFF1A3028),
      bgBottom: Color(0xFF0C1A13),
    ),
    _PageData(
      emoji: '🤲',
      tag: 'COMMENT ÇA MARCHE',
      title: 'Une séance\npar jour.',
      body: 'Quelques minutes suffisent. Pas besoin d\'expérience. Ton corps sait déjà comment faire.',
      bgTop: Color(0xFF2C3A1A),
      bgBottom: Color(0xFF131A0C),
    ),
    _PageData(
      emoji: '🌿',
      tag: 'À TON RYTHME',
      title: 'Sans pression,\nsans jugement.',
      body: 'Le jour suivant s\'ouvre quand tu es prêt. Chaque respiration est un pas.',
      bgTop: Color(0xFF1A2C2A),
      bgBottom: Color(0xFF0C1614),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    context.read<ProgramProvider>().completeOnboarding();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, a, b) => const HomeScreen(),
        transitionsBuilder: (ctx, a, b, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [page.bgTop, page.bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Bouton passer
              Positioned(
                top: AppTheme.spacingM,
                right: AppTheme.spacingL,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Passer',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),

              // Contenu principal
              PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _PageContent(page: _pages[i]),
              ),

              // Bas de page : indicateurs + bouton
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacingL,
                    0,
                    AppTheme.spacingL,
                    AppTheme.spacingXXL,
                  ),
                  child: Column(
                    children: [
                      // Indicateurs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentPage == i ? 28 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == i
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusFull,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingXL),

                      // Bouton principal
                      GestureDetector(
                        onTap: _next,
                        child: Container(
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusFull,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _currentPage < _pages.length - 1
                                  ? 'Continuer'
                                  : 'Commencer',
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: page.bgTop,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _PageData page;
  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).size.height * 0.25;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.spacingXXL),

            // Emoji dans un cercle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppTheme.radiusXL),
              ),
              child: Center(
                child: Text(page.emoji, style: const TextStyle(fontSize: 36)),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.12),

            // Tag
            Text(
              page.tag,
              style: AppTextStyles.label.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),

            // Titre grand
            Text(
              page.title,
              style: AppTextStyles.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                height: 1.15,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Corps
            Text(
              page.body,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.65),
                height: 1.65,
              ),
            ),

            // Espace dynamique pour laisser place au bas fixe
            SizedBox(height: bottomPad),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  final String emoji;
  final String tag;
  final String title;
  final String body;
  final Color bgTop;
  final Color bgBottom;
  const _PageData({
    required this.emoji,
    required this.tag,
    required this.title,
    required this.body,
    required this.bgTop,
    required this.bgBottom,
  });
}
