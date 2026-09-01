import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/repositories/bible_repository.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';

/// Main app widget for Syntrophe
class SyntropheApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final BibleRepository bibleRepository;

  const SyntropheApp({
    super.key,
    required this.themeProvider,
    required this.bibleRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: bibleRepository),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Wait for theme initialization to prevent flash
          if (!themeProvider.isInitialized) {
            return MaterialApp(
              title: 'Syntrophe',
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: AppTheme.lightBackground,
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.lightPrimary,
                  ),
                ),
              ),
            );
          }

          return AnimatedTheme(
            data: themeProvider.isDarkMode 
                ? AppTheme.darkTheme 
                : AppTheme.lightTheme,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: MaterialApp(
              title: 'Syntrophe',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.getMaterialThemeMode(),
              home: const OnboardingScreen(),
              routes: {
                '/home': (context) => const HomeScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}
