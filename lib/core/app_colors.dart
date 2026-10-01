import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const bg = Color(0xFFF4F6FD);
  static const navy = Color(0xFF0B0B2B);
  static const purple = Color(0xFF5B21F0);
  static const blue = Color(0xFF4C7FE8);
  static const textGrey = Color(0xFF5B6275);
  static const hint = Color(0xFF9AA0BA);
  static const border = Color(0xFFDADCF3);
  static const error = Color(0xFFE5383B);
  static const success = Color(0xFF16A34A);

  static const buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF6C2FF6), Color(0xFF4A5CE8), Color(0xFF4C7FE8)],
    stops: [0.0, 0.55, 1.0],
  );
}

class AppText {
  AppText._();

  static TextStyle style(double size, FontWeight weight, Color color,
          {double? height, double? letterSpacing}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
}
