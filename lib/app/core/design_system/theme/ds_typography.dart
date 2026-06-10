import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ds_colors.dart';

/// Design system typography rules.
/// Standardizes font choices, sizes, weights, and leading heights.
class DsTypography {
  DsTypography._();

  // Font Families
  static final String primaryFont = GoogleFonts.poppins().fontFamily ?? 'Poppins';
  static final String secondaryFont = GoogleFonts.inter().fontFamily ?? 'Inter';

  // ── Headings (Poppins) ──────────────────────────────────────────
  
  /// Large, impactful screen titles (e.g. Onboarding, Splash headers)
  static TextStyle get headingLarge => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: DsColors.textPrimary,
        height: 1.25,
      );

  /// Standard screen title & page headers
  static TextStyle get headingMedium => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: DsColors.textPrimary,
        height: 1.3,
      );

  /// Card titles, dialog headers
  static TextStyle get headingSmall => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: DsColors.textPrimary,
        height: 1.3,
      );

  // ── Body Text (Poppins & Inter) ─────────────────────────────────

  /// Large body text, input fields, highlighted items
  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: DsColors.textPrimary,
        height: 1.4,
      );

  /// Standard body text for descriptions and paragraph copy
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: DsColors.textPrimary,
        height: 1.5,
      );

  /// Semi-bold body variant for buttons and list element keys
  static TextStyle get bodyMediumSemiBold => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: DsColors.textPrimary,
        height: 1.4,
      );

  /// Medium body text for primary buttons
  static TextStyle get buttonText => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: DsColors.textOnPrimary,
        height: 1.2,
      );

  // ── Caption & Small Metadata (Inter) ─────────────────────────────

  /// Captions, minor labels, timestamps, input helper messages
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: DsColors.textSecondary,
        height: 1.3,
      );

  /// Strong caption for badges, errors, or highlighted metadata
  static TextStyle get captionBold => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: DsColors.textPrimary,
        height: 1.3,
      );

  /// Extremely small labels (e.g. tab labels, badge pills)
  static TextStyle get overline => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: DsColors.textSecondary,
        letterSpacing: 0.5,
        height: 1.2,
      );
}
