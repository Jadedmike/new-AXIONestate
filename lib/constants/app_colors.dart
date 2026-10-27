import 'package:flutter/material.dart';

/// App-wide custom color palette matching Axion Digital design system.
class AppColors {
  AppColors._();

  // Primary Surface / Base Background: Warm Ivory -> const Color(0xFFF8F6F0)
  static const Color warmIvory = Color(0xFFF8F6F0);

  // Primary Text, Headings & Dark CTA Buttons: Mocha Brown -> const Color(0xFF34211B)
  static const Color mochaBrown = Color(0xFF34211B);
  static const Color mochaBrownHover = Color(0xFF4A332B);

  // Glass Borders, Badges & Focus Elements: Ice Blue -> const Color(0xFFA0BDDB)
  static const Color iceBlue = Color(0xFFA0BDDB);
  static const Color iceBlueLight = Color(0xFFD6E4F0);

  // Secondary surface / Sand tones
  static const Color warmSand = Color(0xFFEDE7DC);

  // Status & accents
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Translucent Glass fills
  static Color glassSidebar = warmIvory.withValues(alpha: 0.45);
  static Color glassCard = warmIvory.withValues(alpha: 0.70);
  static Color glassCardStrong = warmIvory.withValues(alpha: 0.85);
  static Color glassBorder = iceBlue.withValues(alpha: 0.35);
  static Color glassBorderStrong = iceBlue.withValues(alpha: 0.60);
  static Color glassShadow = mochaBrown.withValues(alpha: 0.12);
  static Color glassShadowLight = mochaBrown.withValues(alpha: 0.06);

  // Text opacities
  static Color textPrimary = mochaBrown;
  static Color textSecondary = mochaBrown.withValues(alpha: 0.75);
  static Color textMuted = mochaBrown.withValues(alpha: 0.55);
  static Color textOnDark = warmIvory;
  static Color textOnDarkMuted = warmIvory.withValues(alpha: 0.85);
}
