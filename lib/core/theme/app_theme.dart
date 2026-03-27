import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primaryDark,
        surface: AppColors.semanticGrayNeutralBgWhite,
        error: AppColors.semanticErrorFgHigh,
        onSurface: AppColors.semanticGrayNeutralFgHigh,
      ),
      scaffoldBackgroundColor: AppColors.semanticGrayNeutralBgWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.semanticGrayNeutralBgWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.semanticGrayNeutralFgHigh),
        titleTextStyle: AppTypography.heading5,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.semanticGrayNeutralBgWhite,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.semanticGrayNeutralFgMidOnWhite,
        selectedLabelStyle: AppTypography.support2,
        unselectedLabelStyle: AppTypography.support2,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: AppTypography.label2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: AppTypography.label2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.semanticGrayNeutralBgLightGray,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.semanticGrayNeutralBorderLightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.semanticGrayNeutralBorderLightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.semanticErrorFgHigh),
        ),
        hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLowOnWhite),
      ),
      cardTheme: CardThemeData(
        color: AppColors.semanticGrayNeutralBgWhite,
        elevation: 2,
        shadowColor: AppColors.foundationGrayscale200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.semanticGrayNeutralBorderLightGray, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
