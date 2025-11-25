import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/design_tokens.dart';

class AppTheme {
  static final ColorScheme _colorScheme =
      ColorScheme.fromSeed(seedColor: AppColors.primary);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    scaffoldBackgroundColor: Tokens.background,
    textTheme: (() {
      final base = GoogleFonts.interTextTheme();
      return base
          .copyWith(
            displayLarge: base.displayLarge
                ?.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
            displayMedium: base.displayMedium
                ?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
            headlineSmall: base.headlineSmall
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            titleLarge: base.titleLarge
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            bodyLarge: base.bodyLarge
                ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
            bodyMedium: base.bodyMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
            labelLarge: base.labelLarge
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
          )
          .apply(
              bodyColor: Tokens.textPrimary, displayColor: Tokens.textPrimary);
    })(),
    appBarTheme: AppBarTheme(
      backgroundColor: Tokens.surface,
      foregroundColor: Tokens.textPrimary,
      elevation: 1,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: Tokens.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Tokens.radius)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Tokens.radius),
          borderSide: BorderSide.none),
      labelStyle: GoogleFonts.inter(color: Tokens.muted),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Tokens.radius2xl)),
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Tokens.radius2xl))),
    iconTheme: IconThemeData(color: _colorScheme.onSurface.withAlpha(204)),
    dividerColor: Colors.grey.shade200,
  );
}
