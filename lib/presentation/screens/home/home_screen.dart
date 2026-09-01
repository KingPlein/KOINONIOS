import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/bible_repository.dart';

/// Home screen with dashboard showing daily verse, streak, quick actions, and recent activity
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(isDarkMode),
          _buildBibleTab(),
          _buildNotesTab(),
          _buildSermonsTab(),
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        backgroundColor: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
        indicatorColor: (isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Bible',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_outlined),
            selectedIcon: Icon(Icons.note),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Sermons',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(bool isDarkMode) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting header
            _buildGreeting(isDarkMode),

            const SizedBox(height: 24),

            // Daily Verse card
            _buildDailyVerseCard(isDarkMode),

            const SizedBox(height: 24),

            // Streak counter and quick stats
            _buildStatsRow(isDarkMode),

            const SizedBox(height: 24),

            // Quick actions row
            _buildQuickActions(isDarkMode),

            const SizedBox(height: 24),

            // Recent activity
            _buildRecentActivity(isDarkMode),

            const SizedBox(height: 24),

            // Upcoming alarm preview
            _buildUpcomingAlarm(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(bool isDarkMode) {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, Brother/Sister',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Peace be with you',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyVerseCard(bool isDarkMode) {
    return Consumer<BibleRepository>(
      builder: (context, repo, _) {
        return Card(
          color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: (isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_stories,
                      color: isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Verse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (repo.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (repo.hasError)
                  Text(
                    'Error loading verse',
                    style: TextStyle(
                      color: isDarkMode ? AppTheme.darkError : AppTheme.lightError,
                    ),
                  )
                else
                  FutureBuilder(
                    future: repo.getDailyVerse(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final verse = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verse.text,
                              style: AppTheme.scriptureTextStyle(
                                fontSize: 18,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '— ${verse.reference}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode 
                                    ? AppTheme.darkPrimary 
                                    : AppTheme.lightPrimary,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            isDarkMode,
            icon: Icons.local_fire_department,
            value: '7',
            label: 'Day Streak',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            isDarkMode,
            icon: Icons.bookmark,
            value: '23',
            label: 'Highlights',
            color: isDarkMode ? AppTheme.darkSecondary : AppTheme.lightSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            isDarkMode,
            icon: Icons.note_alt,
            value: '12',
            label: 'Notes',
            color: isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    bool isDarkMode, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? AppTheme.darkDivider : AppTheme.lightDivider,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionButton(
              isDarkMode,
              icon: Icons.menu_book,
              label: 'Read Bible',
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            _buildQuickActionButton(
              isDarkMode,
              icon: Icons.note_add,
              label: 'Take Note',
              onTap: () => setState(() => _selectedIndex = 2),
            ),
            _buildQuickActionButton(
              isDarkMode,
              icon: Icons.mic,
              label: 'Record',
              onTap: () {}, // Navigate to transcribe
            ),
            _buildQuickActionButton(
              isDarkMode,
              icon: Icons.video_library,
              label: 'Find Sermon',
              onTap: () => setState(() => _selectedIndex = 3),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    bool isDarkMode, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: (isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        // Placeholder for recent notes/sermons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? AppTheme.darkDivider : AppTheme.lightDivider,
            ),
          ),
          child: Text(
            'Your recent activity will appear here',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingAlarm(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_active,
            color: isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Reminder',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  ),
                ),
                Text(
                  'Evening Reflection at 9:00 PM',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder tabs - would be implemented in separate files
  Widget _buildBibleTab() => const Center(child: Text('Bible Reader'));
  Widget _buildNotesTab() => const Center(child: Text('Notes List'));
  Widget _buildSermonsTab() => const Center(child: Text('Sermon Library'));
  Widget _buildSettingsTab() => const Center(child: Text('Settings'));
}
