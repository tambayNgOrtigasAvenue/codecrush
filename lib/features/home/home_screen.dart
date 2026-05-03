import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../game/game_setup_screen.dart';
import '../game/run_setup_screen.dart';
import '../history/history_screen.dart';
import '../lessons/lessons_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _HomeAppBar(
              onSettingsTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 152 / 107,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _ModeTile(
                      title: 'ABC',
                      label: 'Word',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GameSetupScreen(),
                          ),
                        );
                      },
                    ),
                    const _ModeTile(title: 'SEN', label: 'Sentence'),
                    const _ModeTile(title: '010', label: 'Binary'),
                    _ModeTile(
                      icon: Icons.directions_run,
                      label: 'Run',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RunSetupScreen(),
                          ),
                        );
                      },
                    ),
                    const _ModeTile(icon: Icons.sports_esports, label: 'Shoot'),
                  ],
                ),
              ),
            ),
            _BottomNav(
              onLessonsTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LessonsScreen()),
                );
              },
              onHistoryTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({required this.onSettingsTap});

  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          const Spacer(),
          Text('CODECRUSH', style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          IconButton(
            onPressed: onSettingsTap,
            icon: Icon(Icons.settings, color: accentColor),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    this.title,
    required this.label,
    this.icon,
    this.onTap,
  })
    : assert(title != null || icon != null);

  final String? title;
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: AppColors.white,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label mode is coming soon.')),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white50),
          boxShadow: const [
            BoxShadow(
              color: AppColors.black20,
              offset: Offset(0, 8),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(icon, color: AppColors.white, size: 28)
              else
                Text(title!, style: titleStyle),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.onHistoryTap, required this.onLessonsTap});

  final VoidCallback onHistoryTap;
  final VoidCallback onLessonsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: onLessonsTap,
            icon: const Icon(Icons.menu_book, color: AppColors.white50),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.play_arrow, color: AppColors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'PLAY',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onHistoryTap,
            icon: const Icon(Icons.history, color: AppColors.white50),
          ),
        ],
      ),
    );
  }
}
