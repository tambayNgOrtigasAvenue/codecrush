import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppSettings extends ChangeNotifier {
  AppSettings({
    Color? accentColor,
    double volume = 0.5,
    int characterIndex = 0,
  })  : _accentColor = accentColor ?? AppColors.pink,
        _volume = volume,
        _characterIndex = characterIndex;

  Color _accentColor;
  double _volume;
  int _characterIndex;

  Color get accentColor => _accentColor;
  double get volume => _volume;
  int get characterIndex => _characterIndex;

  void setAccentColor(Color color) {
    if (color == _accentColor) {
      return;
    }
    _accentColor = color;
    notifyListeners();
  }

  void setVolume(double value) {
    if (value == _volume) {
      return;
    }
    _volume = value;
    notifyListeners();
  }

  void setCharacterIndex(int index) {
    if (index == _characterIndex) {
      return;
    }
    _characterIndex = index;
    notifyListeners();
  }
}

class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);

  static AppSettings of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found in widget tree.');
    return scope!.notifier!;
  }
}
