import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'binary_play_screen.dart';

class BinarySetupScreen extends StatelessWidget {
  const BinarySetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  ),
                  const Spacer(),
                  Text(
                    'BINARY',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Info card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF00FF41).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOW TO PLAY',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF00FF41),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _Tip(
                      icon: '🔢',
                      text: 'Convert Decimal ↔ Binary',
                    ),
                    const SizedBox(height: 10),
                    _Tip(
                      icon: '❤️',
                      text: '3 lives — wrong answers cost a life',
                    ),
                    const SizedBox(height: 10),
                    _Tip(
                      icon: '⏱️',
                      text:
                          '90 seconds — correct answers add +3 seconds',
                    ),
                    const SizedBox(height: 10),
                    _Tip(
                      icon: '⬆️',
                      text:
                          'Difficulty increases every 5 correct answers',
                    ),
                    const SizedBox(height: 10),
                    _Tip(
                      icon: '🏆',
                      text: 'Score more points at higher levels',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Levels card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _LevelRow(
                      level: 1,
                      label: '4-bit  (0 – 15)',
                      pts: '10 pts',
                      color: Colors.greenAccent,
                    ),
                    const Divider(color: AppColors.white50, height: 20),
                    _LevelRow(
                      level: 2,
                      label: '6-bit  (16 – 63)',
                      pts: '20 pts',
                      color: Colors.yellowAccent,
                    ),
                    const Divider(color: AppColors.white50, height: 20),
                    _LevelRow(
                      level: 3,
                      label: '8-bit  (64 – 255)',
                      pts: '30 pts',
                      color: Colors.orangeAccent,
                    ),
                    const Divider(color: AppColors.white50, height: 20),
                    _LevelRow(
                      level: 4,
                      label: '8-bit hard (random)',
                      pts: '50 pts',
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Start button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const BinaryPlayScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: AppColors.white50),
                    ),
                    elevation: 8,
                    shadowColor: accent.withValues(alpha: 0.4),
                  ),
                  child: Text(
                    'START',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white50,
            ),
          ),
        ),
      ],
    );
  }
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({
    required this.level,
    required this.label,
    required this.pts,
    required this.color,
  });
  final int level;
  final String label;
  final String pts;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.6)),
          ),
          child: Center(
            child: Text(
              '$level',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.white),
          ),
        ),
        Text(
          pts,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
