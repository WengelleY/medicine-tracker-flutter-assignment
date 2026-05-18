import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color palette from the uploaded image
  static const Color mintGreen =
      Color(0xFFDEF5E5); // lightest - mint green
  static const Color mediumTeal =
      Color(0xFF3DAA8C); // medium teal/emerald
  static const Color deepTeal =
      Color(0xFF0B6E8A); // deep teal/ocean blue
  static const Color paleCyan =
      Color(0xFFD4EEF4); // pale cyan/ice blue
  static const Color offWhite =
      Color(0xFFF0F8FA); // near white

  // Semantic colors
  static const Color primary = deepTeal;
  static const Color secondary = mediumTeal;
  static const Color surface = mintGreen;
  static const Color background = offWhite;
  static const Color cardBg = Colors.white;

  static const Color takenGreen =
      Color(0xFF2E9B6E);
  static const Color pendingAmber =
      Color(0xFFF09B3A);
  static const Color errorRed = Color(0xFFE05252);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        surface: background,
        onSurface: const Color(0xFF1A3A42),
        error: errorRed,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      textTheme:
          GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: primary,
        ),
        displayMedium: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A3A42),
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A3A42),
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF2D5561),
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 13,
          color: const Color(0xFF4A7A88),
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: paleCyan, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: paleCyan, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: errorRed, width: 1.5),
        ),
        labelStyle: GoogleFonts.nunito(
            color: secondary,
            fontWeight: FontWeight.w600),
        hintStyle: GoogleFonts.nunito(
            color: const Color(0xFF9BC5CE)),
      ),
      elevatedButtonTheme:
          ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12)),
          textStyle: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme:
          OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(
              color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12)),
          textStyle: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w700),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: GoogleFonts.nunito(
            color: Colors.white),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(
          color: paleCyan, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: mintGreen,
        selectedColor: secondary,
        labelStyle: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 4),
      ),
    );
  }
}
