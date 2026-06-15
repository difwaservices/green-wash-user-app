import 'package:flutter/material.dart';

/// Design system spacing tokens.
/// Standardizes margins, padding, and gaps using a consistent 4px/8px grid.
class DsSpacing {
  DsSpacing._();

  // Raw spacing tokens
  static const double xsmall = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xlarge = 24.0;
  static const double xxlarge = 32.0;
  static const double huge = 48.0;

  // Pre-configured EdgeInsets padding
  static const EdgeInsets allNone = EdgeInsets.zero;
  static const EdgeInsets allXSmall = EdgeInsets.all(xsmall);
  static const EdgeInsets allSmall = EdgeInsets.all(small);
  static const EdgeInsets allMedium = EdgeInsets.all(medium);
  static const EdgeInsets allLarge = EdgeInsets.all(large);
  static const EdgeInsets allXLarge = EdgeInsets.all(xlarge);
  static const EdgeInsets allXXLarge = EdgeInsets.all(xxlarge);

  static const EdgeInsets symmetricH4 = EdgeInsets.symmetric(horizontal: xsmall);
  static const EdgeInsets symmetricH8 = EdgeInsets.symmetric(horizontal: small);
  static const EdgeInsets symmetricH12 = EdgeInsets.symmetric(horizontal: medium);
  static const EdgeInsets symmetricH16 = EdgeInsets.symmetric(horizontal: large);
  static const EdgeInsets symmetricH24 = EdgeInsets.symmetric(horizontal: xlarge);

  static const EdgeInsets symmetricV4 = EdgeInsets.symmetric(vertical: xsmall);
  static const EdgeInsets symmetricV8 = EdgeInsets.symmetric(vertical: small);
  static const EdgeInsets symmetricV12 = EdgeInsets.symmetric(vertical: medium);
  static const EdgeInsets symmetricV16 = EdgeInsets.symmetric(vertical: large);
  static const EdgeInsets symmetricV24 = EdgeInsets.symmetric(vertical: xlarge);

  // Pre-configured SizedBox horizontal gaps (width)
  static const SizedBox gapH4 = SizedBox(width: xsmall);
  static const SizedBox gapH8 = SizedBox(width: small);
  static const SizedBox gapH12 = SizedBox(width: medium);
  static const SizedBox gapH16 = SizedBox(width: large);
  static const SizedBox gapH24 = SizedBox(width: xlarge);
  static const SizedBox gapH32 = SizedBox(width: xxlarge);
  static const SizedBox gapH48 = SizedBox(width: huge);

  // Pre-configured SizedBox vertical gaps (height)
  static const SizedBox gapV4 = SizedBox(height: xsmall);
  static const SizedBox gapV8 = SizedBox(height: small);
  static const SizedBox gapV12 = SizedBox(height: medium);
  static const SizedBox gapV16 = SizedBox(height: large);
  static const SizedBox gapV24 = SizedBox(height: xlarge);
  static const SizedBox gapV32 = SizedBox(height: xxlarge);
  static const SizedBox gapV48 = SizedBox(height: huge);
}
