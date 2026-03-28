import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/program_provider.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';

class DiaphragmeApp extends StatelessWidget {
  const DiaphragmeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgramProvider()..init(),
      child: MaterialApp(
        title: 'Diaphragme 30',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const _RootRouter(),
      ),
    );
  }
}

/// Redirige vers Onboarding ou Home selon l'état de l'utilisateur.
class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgramProvider>(
      builder: (context, provider, _) {
        // Pendant le chargement
        if (!provider.isLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Première ouverture → Onboarding
        if (!provider.onboardingDone) {
          return const OnboardingScreen();
        }

        // Déjà vu → Accueil
        return const HomeScreen();
      },
    );
  }
}
