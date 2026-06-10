import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Design system color tokens mapping existing AppColors to standardized semantic states.
class DsColors {
  DsColors._();

  // Core Brand Colors
  static const Color primary = AppColors.primaryTheme;
  static const Color primaryDark = AppColors.primaryColorNew;
  static const Color primaryLight = AppColors.primaryLight;
  static const Color secondary = AppColors.secondary;
  
  // Surfaces
  static const Color background = AppColors.scaffoldBg;
  static const Color surface = AppColors.white;
  static const Color surfaceDark = AppColors.blackLight;
  
  // Borders & Inputs
  static const Color border = AppColors.borderColor;
  static const Color inactive = AppColors.inactive;
  static const Color inputFocused = AppColors.primaryTheme;

  // Typography
  static const Color textPrimary = AppColors.black;
  static const Color textSecondary = AppColors.grey;
  static const Color textMuted = AppColors.darkGrey;
  static const Color textOnPrimary = AppColors.white;

  // Semantic Feedback (Google/Swiggy/Uber-style harmonized accents)
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color successLight = Color(0xFFECFDF5);
  
  static const Color error = Color(0xFFEF4444); // Slate Red
  static const Color errorLight = Color(0xFFFEF2F2);
  
  static const Color warning = Color(0xFFF57C00); // Amber Orange
  static const Color warningLight = Color(0xFFFFF9C4);

  static const Color info = Color(0xFF0284C7); // Water Blue
  static const Color infoLight = Color(0xFFE0F2FE);
}
