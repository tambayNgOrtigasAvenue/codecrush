import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const Shadow _textShadow = Shadow(
    offset: Offset(0, 2),
    color: AppColors.black15,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: _shadowed(
      GoogleFonts.nunito(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: AppColors.white,
      ),
    ),
    displaySmall: _shadowed(
      GoogleFonts.nunito(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
      ),
    ),
    headlineMedium: _shadowed(
      GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
      ),
    ),
    titleLarge: _shadowed(
      GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
    ),
    bodyLarge: _shadowed(
      GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
    bodyMedium: _shadowed(
      GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
    bodySmall: _shadowed(
      GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.white50,
      ),
    ),
    labelSmall: _shadowed(
      GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.white50,
      ),
    ),
  );

  static TextStyle courseTitle({Color color = AppColors.white}) => _shadowed(
    GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color,
    ),
  );

  static TextStyle courseDescription({Color color = AppColors.white50}) =>
      _shadowed(
        GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      );

  static TextStyle badge({Color color = AppColors.white}) => _shadowed(
    GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: color,
    ),
  );

  static TextStyle _shadowed(TextStyle style) =>
      style.copyWith(shadows: const [_textShadow]);

  const AppTextStyles._();
}
