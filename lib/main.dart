import 'package:flutter/material.dart';

import 'app/settings/app_settings.dart';
import 'app/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = AppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      settings: _settings,
      child: AnimatedBuilder(
        animation: _settings,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark(accentColor: _settings.accentColor),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
