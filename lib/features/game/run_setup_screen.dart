import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'run_customize_screen.dart';
import 'run_play_screen.dart';

class RunSetupScreen extends StatelessWidget {
  const RunSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            _RunAppBar(onBackTap: () => Navigator.of(context).pop()),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionButton(
                        label: 'START',
                        color: accentColor,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RunPlayScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        label: 'CUSTOMIZE',
                        color: accentColor,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RunCustomizeScreen(),
                            ),
                          );
                        },
                      ),
                    ],
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

class _RunAppBar extends StatelessWidget {
  const _RunAppBar({required this.onBackTap});

  final VoidCallback onBackTap;

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
          Text('RUN', style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          const SizedBox(width: 40),
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: color,
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
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
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
