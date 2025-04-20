import 'package:flutter/material.dart';
import 'package:typo_color_them/theme/colors/colors.dart';

class LightColors extends BaseColors {
  const LightColors();

  // Primary colors
  @override
  Color get primary => Colors.blue;

  @override
  Color get primaryDark => Colors.blue.shade700;

  @override
  Color get primaryLight => Colors.blue.shade300;

  @override
  Color get onPrimary => Colors.white;

  // Secondary colors
  @override
  Color get secondary => Colors.teal;

  @override
  Color get secondaryDark => Colors.teal.shade700;

  @override
  Color get secondaryLight => Colors.teal.shade300;

  @override
  Color get onSecondary => Colors.white;

  // Background colors
  @override
  Color get background => Colors.white;

  @override
  Color get surface => Colors.grey.shade50;

  @override
  Color get onBackground => Colors.black87;

  @override
  Color get onSurface => Colors.black87;

  // Semantic colors
  @override
  Color get error => Colors.red.shade700;

  @override
  Color get success => Colors.green.shade600;

  @override
  Color get warning => Colors.amber.shade700;

  @override
  Color get info => Colors.blue.shade600;

  @override
  Color get onError => Colors.white;

  @override
  Color get onSuccess => Colors.white;

  @override
  Color get onWarning => Colors.black;

  @override
  Color get onInfo => Colors.white;

  // Surface variants (Material 3)
  @override
  Color get surfaceVariant => Colors.grey.shade100;

  @override
  Color get onSurfaceVariant => Colors.grey.shade700;

  // Extended colors (Material 3)
  @override
  Color get outline => Colors.grey.shade400;

  @override
  Color get outlineVariant => Colors.grey.shade300;

  @override
  Color get inversePrimary => Colors.blue.shade200;

  @override
  Color get inverseSurface => Colors.grey.shade900;

  @override
  Color get onInverseSurface => Colors.white;

  @override
  Color get scrim => Colors.black.withOpacity(0.2);

  @override
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryLight,
      onPrimaryContainer: Colors.black87,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: Colors.black87,
      tertiary: info,
      onTertiary: onInfo,
      tertiaryContainer: info.withOpacity(0.1),
      onTertiaryContainer: info.darker(),
      error: error,
      onError: onError,
      errorContainer: error.withOpacity(0.1),
      onErrorContainer: error.darker(),
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface,
      inversePrimary: inversePrimary,
      shadow: scrim,
      scrim: scrim,
    );
  }
}

// Extension to provide additional color utilities
extension ColorExtension on Color {
  Color darker([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighter([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
}
