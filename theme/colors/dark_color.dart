import 'package:flutter/material.dart';
import 'package:typo_color_them/theme/colors/colors.dart';

class DarkColors extends BaseColors {
  const DarkColors();

  // Primary colors
  @override
  Color get primary => Colors.tealAccent.shade700;

  @override
  Color get primaryDark => Colors.tealAccent.shade400;

  @override
  Color get primaryLight => Colors.teal.shade200;

  @override
  Color get onPrimary => Colors.black;

  // Secondary colors
  @override
  Color get secondary => Colors.deepPurpleAccent;

  @override
  Color get secondaryDark => Colors.deepPurpleAccent.shade700;

  @override
  Color get secondaryLight => Colors.deepPurpleAccent.shade100;

  @override
  Color get onSecondary => Colors.white;

  // Background colors
  @override
  Color get background => Colors.black;

  @override
  Color get surface => Colors.grey.shade900;

  @override
  Color get onBackground => Colors.white;

  @override
  Color get onSurface => Colors.white;

  // Semantic colors
  @override
  Color get error => Colors.redAccent.shade400;

  @override
  Color get success => Colors.greenAccent.shade700;

  @override
  Color get warning => Colors.amberAccent.shade700;

  @override
  Color get info => Colors.blueAccent.shade400;

  @override
  Color get onError => Colors.black;

  @override
  Color get onSuccess => Colors.black;

  @override
  Color get onWarning => Colors.black;

  @override
  Color get onInfo => Colors.black;

  // Surface variants (Material 3)
  @override
  Color get surfaceVariant => Colors.grey.shade800;

  @override
  Color get onSurfaceVariant => Colors.grey.shade300;

  // Extended colors (Material 3)
  @override
  Color get outline => Colors.grey.shade700;

  @override
  Color get outlineVariant => Colors.grey.shade600;

  @override
  Color get inversePrimary => Colors.tealAccent.shade200;

  @override
  Color get inverseSurface => Colors.white;

  @override
  Color get onInverseSurface => Colors.black;

  @override
  Color get scrim => Colors.black.withOpacity(0.4);

  @override
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryLight,
      onPrimaryContainer: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: onSecondary,
      tertiary: info,
      onTertiary: onInfo,
      tertiaryContainer: info.withOpacity(0.2),
      onTertiaryContainer: onInfo,
      error: error,
      onError: onError,
      errorContainer: error.withOpacity(0.2),
      onErrorContainer: onError,

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
