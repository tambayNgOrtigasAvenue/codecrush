import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData dark({Color accentColor = AppColors.pink}) {
    final base = ThemeData.dark();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: base.colorScheme.copyWith(
        primary: accentColor,
        onPrimary: AppColors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.white,
      ),
      textTheme: AppTextStyles.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: AppTextStyles.textTheme.headlineMedium,
      ),
    );
  }

  const AppTheme._();
}
