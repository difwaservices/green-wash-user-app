import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

// ============================================================
//  TEXT STYLES  (Google Fonts — Poppins & Inter)
// ============================================================

class AppTextStyles {
  AppTextStyles._();

  // ── Caption / Small ──────────────────────────────────────────
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  static TextStyle text12w300 = GoogleFonts.poppins(
    fontSize: 12, fontWeight: FontWeight.w300, color: AppColors.black);
  static TextStyle text12w400 = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.black);
  static TextStyle text12w500 = GoogleFonts.poppins(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.black);
  static TextStyle text12w700 = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.black);
  static TextStyle text12w700Primary = GoogleFonts.poppins(
    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryTheme);
  static TextStyle text12bold = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.black);

  // ── Body ──────────────────────────────────────────────────────
  static TextStyle text14w300 = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w300, color: AppColors.black);
  static TextStyle text14w400 = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.black);
  static TextStyle text14w500 = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black);
  static TextStyle text14w500Inter = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black);
  static TextStyle text14w700 = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.black);
  static TextStyle text14red = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.red);
  static TextStyle text14normal = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.black);
  static TextStyle text14desc = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w300, color: AppColors.black);
  static TextStyle text14grey = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkGrey);

  // ── Sub-heading ───────────────────────────────────────────────
  static TextStyle text16w300 = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w300, color: AppColors.black);
  static TextStyle text16w600 = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white);
  static TextStyle text16w700 = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black);
  static TextStyle text16w700Underline = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    decoration: TextDecoration.underline,
  );
  static TextStyle text16white = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);
  static TextStyle text16grey = GoogleFonts.poppins(
    fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkGrey);
  static TextStyle subheading = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black);

  // ── Heading ───────────────────────────────────────────────────
  static TextStyle text18w300 = GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w300, color: AppColors.black);
  static TextStyle text18w400 = GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w400, color: AppColors.black);
  static TextStyle text18w500 = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.black);
  static TextStyle text18w600 = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.black);
  static TextStyle text18w700 = GoogleFonts.inter(
    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.black);
  static TextStyle text18w700Poppins = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.black);
  static TextStyle text18white = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle text18logoColor = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w400, color: AppColors.logoPrimary);
  static TextStyle heading = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.black);
  static TextStyle normalHeading = GoogleFonts.poppins(
    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.black);

  // ── Large Heading ─────────────────────────────────────────────
  static TextStyle text20w300 = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w300, color: AppColors.black);
  static TextStyle text20w600 = GoogleFonts.inter(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.white);
  static TextStyle text20w600Poppins = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black);
  static TextStyle text20w700 = GoogleFonts.inter(
    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.black);
  static TextStyle text20w700Poppins = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.black);
  static TextStyle fieldText = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.normal, color: AppColors.black);

  static TextStyle text22w300 = GoogleFonts.inter(
    fontSize: 22, fontWeight: FontWeight.w300, color: AppColors.black);

  static TextStyle text24w600 = GoogleFonts.inter(
    fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.black);
  static TextStyle text24white = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle text24black = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle text24poppinsBold = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black);

  static TextStyle text28w300 = GoogleFonts.poppins(
    fontSize: 28, fontWeight: FontWeight.w300, color: AppColors.black);
  static TextStyle text28w600 = GoogleFonts.poppins(
    fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.black);
  static TextStyle largeHeading = GoogleFonts.poppins(
    fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.primaryTheme);

  static TextStyle text32w600 = GoogleFonts.poppins(
    fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.black);
  static TextStyle text35w600 = GoogleFonts.poppins(
    fontSize: 35, fontWeight: FontWeight.w600, color: AppColors.black);
  static TextStyle text40w600 = GoogleFonts.poppins(
    fontSize: 40, fontWeight: FontWeight.w600, color: AppColors.black);
  static TextStyle text49w600 = GoogleFonts.poppins(
    fontSize: 49, fontWeight: FontWeight.w600, color: AppColors.black);

  // ── Nexa-font styles (legacy / AppStyle) ─────────────────────
  static const TextStyle nexaHeading1 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold,
    color: Color(0xFF169DFF), fontFamily: 'Nexa');
  static const TextStyle nexaHeading = TextStyle(
    fontSize: 16, fontWeight: FontWeight.bold,
    color: Color(0xFF169DFF), fontFamily: 'Nexa');
  static const TextStyle nexaHeading2 = TextStyle(
    fontSize: 14, fontWeight: FontWeight.bold,
    color: Color(0xFF169DFF), fontFamily: 'Nexa');
  static const TextStyle nexaHeadingBlack = TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold,
    color: Color(0xFF0E0E0E), fontFamily: 'Nexa');
  static const TextStyle nexaHeadingWhite = TextStyle(
    fontSize: 18, fontWeight: FontWeight.bold,
    color: Colors.white, fontFamily: 'Nexa');
  static const TextStyle nexaRed = TextStyle(
    fontSize: 14, fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 240, 31, 31), fontFamily: 'Nexa');
  static const TextStyle nexaStatus = TextStyle(
    fontSize: 11, fontWeight: FontWeight.normal,
    color: Color.fromARGB(255, 33, 32, 32), fontFamily: 'Nexa');
  static const TextStyle nexaPlaceholder = TextStyle(
    fontSize: 12, fontWeight: FontWeight.normal,
    color: Color.fromARGB(131, 139, 136, 139), fontFamily: 'Nexa');

  // ── Custom builder ────────────────────────────────────────────
  static TextStyle custom({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black87,
  }) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
