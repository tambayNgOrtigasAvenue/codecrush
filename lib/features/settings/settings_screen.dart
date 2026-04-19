import 'package:flutter/material.dart';

import '../../app/settings/app_settings.dart';
import '../../app/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final accentColor = settings.accentColor;
    final themeOptions = [
      AppColors.pink,
      AppColors.orange,
      AppColors.blue,
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            _SettingsAppBar(onBackTap: () => Navigator.of(context).pop()),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'System'),
            const SizedBox(height: 12),
            _SettingCard(
              child: Row(
                children: [
                  Text('THEME', style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  for (var i = 0; i < themeOptions.length; i++) ...[
                    _ColorDot(
                      color: themeOptions[i],
                      selected: themeOptions[i].value == accentColor.value,
                      onTap: () => settings.setAccentColor(themeOptions[i]),
                    ),
                    if (i != themeOptions.length - 1)
                      const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SettingCard(
              child: Row(
                children: [
                  Text('VOLUME', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Slider(
                      value: settings.volume,
                      onChanged: settings.setVolume,
                      activeColor: accentColor,
                      inactiveColor: AppColors.black25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: 'Support'),
            const SizedBox(height: 12),
            _SettingCard(
              child: Row(
                children: [
                  Text('HELP', style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: AppColors.white50),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SettingCard(
              child: Row(
                children: [
                  Text('ABOUT', style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: AppColors.white50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsAppBar extends StatelessWidget {
  const _SettingsAppBar({required this.onBackTap});

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
          Text('CUSTOMIZE', style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
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

class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    this.selected = false,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected ? Border.all(color: AppColors.white, width: 2) : null,
        ),
      ),
    );
  }
}
