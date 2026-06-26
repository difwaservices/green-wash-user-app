import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Unified Brand Colors (Eco Green)
  static const Color primary = Color(0xFF2E7D32); // Eco Green
  static const Color primaryDark = Color(0xFF1B5E20); // Dark Green
  static const Color primaryLight = Color(0xFFD1FAE5); // Light Green
  
  static const Color logoPrimary = Color(0xFF064E3B); // Darkest Green
  static const Color logoSecondary = Color(0xFF4CAF50); // Bright Green
  
  static const Color secondary = Color(0xFFECFDF5); // Tinted Green White
  static const Color buttonBgColor = Color(0xFF2E7D32); 
  static const Color buttonTextColor = Colors.white;
  static const Color inputField = Color(0xFF2E7D32);
  static const Color cardBgColor = Color(0xFFFFFFFF);

  // Theme Helpers
  static const Color primaryTheme = Color(0xFF2E7D32);
  static const Color primaryColorNew = Color(0xFF1B5E20);
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
  static const Color green = Color(0xFF2E7D32); // Swapped to brand green
  static const Color grey = Colors.grey;
  static const Color myGreen = Color(0xFF2E7D32);

  // Gradients
  static const LinearGradient buttonBgGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient iconBg = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
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

  // â”€â”€ Backward Compatibility Aliases â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
  static const Color accentBlue = Color(0xFF06B6D4);
  static const Color accent = Color(0xFF06B6D4);
  static const Color primaryButton = Color(0xFF06B6D4);
  static const Color logoprimary = logoPrimary;
  static const Color logosecondry = logoSecondary;
  static const Color accentGreen = Color(0xFF06B6D4); // Swapped to brand cyan
}
