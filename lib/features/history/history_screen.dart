import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../home/home_screen.dart';
import '../lessons/lessons_screen.dart';
import '../settings/settings_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _HistoryAppBar(
              onSettingsTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                children: const [
                  _SectionTitle(title: 'High Scores'),
                  _EmptyState(),
                  SizedBox(height: 20),
                  _SectionTitle(title: 'Recent'),
                  _EmptyState(),
                ],
              ),
            ),
            _BottomNav(
              onLessonsTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LessonsScreen()),
                );
              },
              onPlayTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryAppBar extends StatelessWidget {
  const _HistoryAppBar({required this.onSettingsTap});

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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.white50),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'No games played yet.',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.onLessonsTap, required this.onPlayTap});

  final VoidCallback onLessonsTap;
  final VoidCallback onPlayTap;

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
                const Icon(Icons.history, color: AppColors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'HISTORY',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPlayTap,
            icon: const Icon(Icons.play_arrow, color: AppColors.white50),
          ),
        ],
      ),
    );
  }
}
