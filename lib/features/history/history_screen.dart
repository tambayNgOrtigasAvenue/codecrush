import 'package:flutter/material.dart';

import '../../app/database/database_helper.dart';
import '../../app/database/player_progress.dart';
import '../../app/theme/app_colors.dart';
import '../home/home_screen.dart';
import '../lessons/lessons_screen.dart';
import '../settings/settings_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<PlayerProgress> _progressList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final progress = await DatabaseHelper.instance.getAllProgress();
    setState(() {
      _progressList = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasClassic = _progressList.any((p) => p.lessonId == 'classic_mode');
    final hasRun = _progressList.any((p) => p.lessonId == 'run_mode');

    final classicScore = hasClassic
        ? _progressList.firstWhere((p) => p.lessonId == 'classic_mode').score
        : 0;
    final runScore = hasRun
        ? _progressList.firstWhere((p) => p.lessonId == 'run_mode').score
        : 0;

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
                children: [
                  const _SectionTitle(title: 'High Scores'),
                  if (_progressList.isEmpty)
                    const _EmptyState()
                  else ...[
                    if (hasClassic)
                      _ScoreCard(title: 'Word Mode', score: classicScore, icon: Icons.text_fields),
                    if (hasRun)
                      _ScoreCard(title: 'Run Mode', score: runScore, icon: Icons.directions_run),
                  ],
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

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.title,
    required this.score,
    required this.icon,
  });

  final String title;
  final int score;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'High Score',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.white50,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$score WPM',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
