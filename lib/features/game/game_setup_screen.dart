import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'game_play_screen.dart';

class GameSetupScreen extends StatelessWidget {
  const GameSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            _SetupAppBar(
              onBackTap: () => Navigator.of(context).pop(),
              onResetTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nothing to reset yet.')),
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TipRow(
                    icon: Icons.brightness_1,
                    text: 'characters are case-sensitive',
                  ),
                  const SizedBox(height: 8),
                  _TipRow(
                    icon: Icons.brightness_1,
                    text: 'wpm: words per minute',
                  ),
                  const SizedBox(height: 8),
                  _TipRow(icon: Icons.brightness_1, text: 'space to submit'),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GamePlayScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
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
                        child: Text(
                          'START GAME',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionTitle(title: 'High Scores'),
            const SizedBox(height: 12),
            const _EmptyState(),
            const SizedBox(height: 20),
            const _SectionTitle(title: 'Recent'),
            const SizedBox(height: 12),
            const _EmptyState(),
          ],
        ),
      ),
    );
  }
}

class _SetupAppBar extends StatelessWidget {
  const _SetupAppBar({required this.onBackTap, required this.onResetTap});

  final VoidCallback onBackTap;
  final VoidCallback onResetTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
          ),
          const Spacer(),
          Text('WORD', style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          IconButton(
            onPressed: onResetTap,
            icon: const Icon(Icons.refresh, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 6, color: AppColors.white50),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.white50),
        ),
      ],
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
