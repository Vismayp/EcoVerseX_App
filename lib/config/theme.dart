import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Design tokens aligned with App.html (Tailwind config)
  static const Color primary = Color(0xFF13EC13);

  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color backgroundDark = Color(0xFF102210);
  static const Color cardDark = Color(0xFF162B16);
  static const Color surfaceDarker = Color(0xFF0D1B0D);
  static const Color surfaceInput = Color(0xFF283928);

  // Back-compat names used across the codebase
  static const Color secondary = primary;
  static const Color background = backgroundLight;
  static const Color surface = Colors.white;

  static const Color error = Color(0xFFD32F2F);

  static const Color textPrimary = Color(0xFF0B130B);
  static const Color textSecondary = Color(0xFF355135);
  static const Color textLight = Color(0xFF6C7D6C);

  static const Color accent = Color(0xFFFFD700);
  static const Color border = Color(0x1AFFFFFF);

  static const Color onDark = Colors.white;
  static const Color onDarkMuted = Color(0xA6FFFFFF);
  static const Color onDarkFaint = Color(0x66FFFFFF);

  // Aliases for readability in new Neo widgets
  static const Color mutedOnDark = onDarkMuted;
  static const Color faintOnDark = onDarkFaint;
}

class AppTheme {
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        fontSize: 34,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        background: AppColors.backgroundLight,
      ).copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        error: AppColors.error,
        surface: Colors.white,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: displayLarge.copyWith(color: AppColors.textPrimary),
        displaySmall: displaySmall.copyWith(color: AppColors.textPrimary),
        headlineMedium: headlineMedium.copyWith(color: AppColors.textPrimary),
        headlineSmall: headlineSmall.copyWith(color: AppColors.textPrimary),
        bodyLarge: bodyLarge.copyWith(color: AppColors.textSecondary),
        bodyMedium: bodyMedium.copyWith(color: AppColors.textSecondary),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: headlineMedium.copyWith(color: AppColors.textPrimary),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.black.withOpacity(0.06)),
        ),
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        labelStyle: GoogleFonts.plusJakartaSans(color: AppColors.textLight),
        hintStyle:
            GoogleFonts.plusJakartaSans(color: Colors.black.withOpacity(0.45)),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        background: AppColors.backgroundDark,
      ).copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.cardDark,
        error: AppColors.error,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: displayLarge.copyWith(color: AppColors.onDark),
        displaySmall: displaySmall.copyWith(color: AppColors.onDark),
        headlineMedium: headlineMedium.copyWith(color: AppColors.onDark),
        headlineSmall: headlineSmall.copyWith(color: AppColors.onDark),
        bodyLarge: bodyLarge.copyWith(color: AppColors.onDarkMuted),
        bodyMedium: bodyMedium.copyWith(color: AppColors.onDarkMuted),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.onDark,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: headlineMedium.copyWith(color: AppColors.onDark),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
        margin: const EdgeInsets.only(bottom: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        labelStyle:
            GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.55)),
        hintStyle:
            GoogleFonts.plusJakartaSans(color: Colors.white.withOpacity(0.40)),
      ),
    );
  }
}
