import 'package:flutter/material.dart';

class Tokens {
  static const Color primary = Color(0xFF0F172A); // navy background for sidebar
  static const Color primaryHover = Color(0xFF0B1220);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFECECF0);
  static const Color mutedForeground = Color(0xFF717182);
  static const Color textPrimary = Color(0xFF111827);
  static const Color accent = Color(0xFFE9EBEF);
  static const Color destructive = Color(0xFFD4183D);
  static const Color inputBackground = Color(0xFFF3F3F5);
  static const Color border = Color(0x1A000000);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted2 = Color(0xFF475569);
  static const Color blue = Color(0xFF2563EB); // --primary button
  static const Color blueHover = Color(0xFF3B82F6);
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue700 = Color(0xFF2563EB);
  static const Color gray700 = Color(0xFF374151);
  static const Color green100 = Color(0xFFD1FAE5);
  static const Color green700 = Color(0xFF15803D);
  static const Color purple100 = Color(0xFFF3E8FF);
  static const Color purple700 = Color(0xFF7C3AED);

  static const double radiusSm = 6.0;
  static const double radius = 10.0; // 0.625rem
  static const double radiusLg = 12.0;
  static const double radius2xl = 16.0; // map for rounded-2xl from React

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacing = 16.0;
  static const double spacingLg = 24.0;

  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.08),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
