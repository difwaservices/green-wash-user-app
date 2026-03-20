import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // New Brand Colors (Difwa Blue Theme)
  static const Color primary = Color(0xFF169DFF);
  static const Color logoPrimary = Color(0xFF1D3757);
  static const Color logoSecondary = Color(0xFF11BAF9);
  static const Color secondary = Color(0xFFDDE1F5);
  static const Color buttonBgColor = Color(0xFF096FCE);
  static const Color buttonTextColor = Color(0xFF4878BB);
  static const Color inputField = Color(0xFF169DFF);
  static const Color cardBgColor = Color(0xFFE9F5F9);

  // Theme Helpers
  static const Color primaryTheme = Color.fromARGB(255, 58, 165, 228);
  static const Color primaryColorNew = Color(0xFF02739C);
  static const Color primaryColor = primary;

  // Neutrals
  static const Color black = Color(0xFF0E0E0E);
  static const Color blackLight = Color.fromARGB(255, 26, 25, 25);
  static const Color blackLight2 = Color.fromARGB(255, 22, 21, 21);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softGrey = Color(0xFFF9FAFB);
  static const Color darkGrey = Color.fromARGB(179, 132, 132, 132);
  static const Color borderColor = Color(0xFFD9D9D9);
  static const Color inactive = Color.fromARGB(159, 206, 206, 206);

  // Semantic
  static const Color red = Colors.red;
  static const Color redColor = Color.fromARGB(255, 240, 31, 31);
  static const Color green = Colors.green;
  static const Color grey = Colors.grey;
  static const Color myGreen = Color(0xFF4CAF50);

  // Gradients
  static const LinearGradient buttonBgGradient = LinearGradient(
    colors: [Color(0xFF3EFFFF), Color(0xFF169DFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient iconBg = LinearGradient(
    colors: [Color(0xFF3EFFFF), Color(0xFF169DFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF141E30), Color(0xFF243B55)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Color(0xFFf8f8f8), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color iconBgStart = Color(0xFF3EFFFF);
  static const Color iconBgEnd = Color(0xFF169DFF);

  // ── Backward Compatibility Aliases ──────────────────────────
  static const Color error = redColor;
  static const Color scaffoldBg = softGrey;
  static const Color scaffoldBgAlt = Color(0xFFF5F5F5);
  static const Color textPrimary = black;
  static const Color textSecondary = grey;
  static const Color textDark = blackLight;
  static const Color textMuted = darkGrey;
  static const Color mywhite = white;
  static const Color myblack = black;
  static const Color buttonbgColor = buttonBgColor;
  static const Color accentGreen = logoSecondary;
  static const Color accent = logoSecondary;
  static const Color primaryDark = logoPrimary;
  static const Color primaryButton = buttonBgColor;
  static const Color primaryLight = secondary;
  static const Color logoprimary = logoPrimary;
  static const Color logosecondry = logoSecondary;
}
