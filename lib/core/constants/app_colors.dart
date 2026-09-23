import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Primaries (Vibrant Royal Purple & Electric Violet)
  static const Color primary = Color(0xFF7C1C9C);
  static const Color primaryLight = Color(0xFF9C27B0);
  static const Color primaryDark = Color(0xFF4A0072);
  static const Color primaryAccent = Color(0xFF6200EA);
  static const Color primarySubtle = Color(0xFFF3E5F5);

  // Vibrant Brand Accents (Flash / Promo / Energy)
  static const Color accent = Color(0xFFFF6D00); // Energetic Orange
  static const Color accentLight = Color(0xFFFF9E40);
  static const Color accentPink = Color(0xFFFF1493); // Deep Pink
  static const Color accentYellow = Color(0xFFFFD600); // Electric Yellow
  static const Color accentSubtle = Color(0xFFFFF3E0);

  // Discount / Freshness Green
  static const Color success = Color(0xFF00A859);
  static const Color successLight = Color(0xFF48C78E);
  static const Color successDark = Color(0xFF007A3E);
  static const Color successSubtle = Color(0xFFE8F8F0);

  // Warning & Alert
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color errorSubtle = Color(0xFFFFEBEE);

  // Neutral Colors (Light mode primary)
  static const Color background = Color(0xFFF6F8FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF0F3F7);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Special Visuals
  static const Color ratingStar = Color(0xFFFFB300);
  static const Color flashBadge = Color(0xFFFF3366);
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // Gradients for Visual Richness
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8E24AA), Color(0xFF6200EA), Color(0xFF3D00A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF6A0DAD), Color(0xFF4A0072)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient flashGradient = LinearGradient(
    colors: [Color(0xFFFF1744), Color(0xFFFF6D00), Color(0xFFFF9100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient savingsGradient = LinearGradient(
    colors: [Color(0xFF00B074), Color(0xFF00E676)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient auroraGradient = LinearGradient(
    colors: [Color(0xFF7928CA), Color(0xFFFF0080)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mangoGradient = LinearGradient(
    colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0x77000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Glowing shadow styles
  static List<BoxShadow> glowShadow(Color color, {double blur = 14, double opacity = 0.25}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blur,
        offset: const Offset(0, 4),
      ),
    ];
  }

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
}
