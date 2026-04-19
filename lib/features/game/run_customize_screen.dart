import 'package:flutter/material.dart';

import '../../app/settings/app_settings.dart';
import '../../app/theme/app_colors.dart';

class RunCustomizeScreen extends StatelessWidget {
  const RunCustomizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final accentColor = Theme.of(context).colorScheme.primary;
    final characters = _characters;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _CustomizeAppBar(onBackTap: () => Navigator.of(context).pop()),
            const SizedBox(height: 20),
            Text(
              'CHOOSE A\nCHARACTER',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final selected = settings.characterIndex == index;
                    final character = characters[index];
                    return GestureDetector(
                      onTap: () => settings.setCharacterIndex(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: selected
                              ? Border.all(color: accentColor, width: 2)
                              : null,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.black25,
                              offset: Offset(0, 6),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            character.icon,
                            size: 48,
                            color: character.color,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                margin: const EdgeInsets.only(bottom: 16),
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
                  'SAVE',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
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

class _CustomizeAppBar extends StatelessWidget {
  const _CustomizeAppBar({required this.onBackTap});

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

class _CharacterOption {
  const _CharacterOption({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}

const _characters = [
  _CharacterOption(icon: Icons.bug_report, color: Color(0xFFF5DA7E)),
  _CharacterOption(icon: Icons.star, color: Color(0xFFF694BB)),
  _CharacterOption(icon: Icons.ac_unit, color: Color(0xFF5CD6FF)),
  _CharacterOption(icon: Icons.android, color: Color(0xFF7AE582)),
];
