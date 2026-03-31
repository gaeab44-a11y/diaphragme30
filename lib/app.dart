import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/program_provider.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/session/screens/session_screen.dart';
import 'features/progress/screens/progress_screen.dart';

class DiaphragmatixApp extends StatelessWidget {
  const DiaphragmatixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgramProvider()..load(),
      child: MaterialApp(
        title: 'Diaphragmatix',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const _AppRoot(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return _fade(const HomeScreen());
            case '/session':
              final day = settings.arguments as int? ?? 1;
              return _zoomScale(SessionScreen(dayNumber: day));
            case '/progress':
              return _slideUp(const ProgressScreen());
            default:
              return _fade(const _AppRoot());
          }
        },
      ),
    );
  }

  PageRoute _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (context, anim, secondaryAnim) => page,
        transitionsBuilder: (_, anim, secondary, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      );

  PageRoute _zoomScale(Widget page) => PageRouteBuilder(
        pageBuilder: (ctx, anim, sec) => page,
        transitionsBuilder: (ctx, anim, sec, child) {
          final curved =
              CurvedAnimation(parent: anim, curve: Curves.easeInOutCubic);
          return ScaleTransition(
            scale: Tween<double>(begin: 0.90, end: 1.0).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      );

  PageRoute _slideUp(Widget page) => PageRouteBuilder(
        pageBuilder: (ctx, anim, sec) => page,
        transitionsBuilder: (ctx, anim, sec, child) {
          final curved =
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 380),
      );
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate());
  }

  void _navigate() {
    final provider = context.read<ProgramProvider>();
    if (provider.hasStarted) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF080F18),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF7DB5A8),
          strokeWidth: 1.5,
        ),
      ),
    );
  }
}
