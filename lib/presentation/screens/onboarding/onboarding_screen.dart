import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';

/// Onboarding screen with 3 slides: Welcome, Permissions, First Verse
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Welcome to Syntrophe',
      subtitle: 'Growing together in the Word',
      description: 'Your offline-first Bible study companion for daily devotion, note-taking, and sermon library.',
      icon: Icons.auto_stories,
      illustration: 'assets/images/welcome.svg',
    ),
    OnboardingSlide(
      title: 'Stay Connected',
      subtitle: 'Permissions & Notifications',
      description: 'Enable notifications for daily verses and study reminders. All data is stored locally on your device.',
      icon: Icons.notifications_active,
      illustration: 'assets/images/permissions.svg',
    ),
    OnboardingSlide(
      title: 'Start Your Journey',
      subtitle: 'First Verse',
      description: 'Begin with John 3:16 - "For God so loved the world..."',
      icon: Icons.favorite,
      illustration: 'assets/images/first_verse.svg',
      verse: 'John 3:16',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _completeOnboarding(),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildSlide(_slides[index], isDarkMode);
                },
              ),
            ),

            // Indicators and Next button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Page indicators
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (index) => _buildIndicator(index, isDarkMode),
                      ),
                    ),
                  ),

                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode 
                          ? AppTheme.darkPrimary 
                          : AppTheme.lightPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage < _slides.length - 1 ? 'Next' : 'Get Started',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: (isDarkMode 
                      ? AppTheme.darkPrimary 
                      : AppTheme.lightPrimary)
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.icon,
              size: 100,
              color: isDarkMode 
                  ? AppTheme.darkPrimary 
                  : AppTheme.lightPrimary,
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            slide.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDarkMode 
                  ? AppTheme.darkTextPrimary 
                  : AppTheme.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            slide.subtitle,
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode 
                  ? AppTheme.darkPrimary 
                  : AppTheme.lightPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            slide.description,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode 
                  ? AppTheme.darkTextSecondary 
                  : AppTheme.lightTextSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Optional verse preview
          if (slide.verse != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (isDarkMode 
                        ? AppTheme.darkSurface 
                        : AppTheme.lightSurface)
                    .withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isDarkMode 
                          ? AppTheme.darkPrimary 
                          : AppTheme.lightPrimary)
                      .withOpacity(0.3),
                ),
              ),
              child: Text(
                '"For God so loved the world that he gave his one and only Son..."',
                style: AppTheme.scriptureTextStyle(
                  fontSize: 18,
                  isDarkMode: isDarkMode,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIndicator(int index, bool isDarkMode) {
    final isActive = index == _currentPage;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? (isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary)
            : (isDarkMode ? AppTheme.darkDivider : AppTheme.lightDivider),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, '/home');
  }
}

/// Slide data model
class OnboardingSlide {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String illustration;
  final String? verse;

  OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.illustration,
    this.verse,
  });
}
