import 'package:flutter/material.dart';
import 'package:typo_color_them/theme/theme.dart';

/// Theme data generator
class AppTheme {
  final BaseTypography typography;
  final BaseColors colors;
  final double elevation;
  final bool useMaterial3;

  const AppTheme({
    required this.typography,
    required this.colors,
    this.elevation = 2.0,
    this.useMaterial3 = true,
  });

  /// Create theme based on system brightness
  static AppTheme create({
    required Brightness brightness,
    AppTypographyFont typography = AppTypographyFont.appDefault,
    double? fontSizeScaleFactor,
  }) {
    return AppTheme(
      typography: TypographyFactory.create(
        typography,
        fontSizeScaleFactor: fontSizeScaleFactor ?? 1.0,
      ),
      colors:
          brightness == Brightness.dark
              ? const DarkColors()
              : const LightColors(),
    );
  }

  /// Create theme based on provided typography and colors
  static AppTheme createWithCustomColors({
    required AppTypographyFont typography,
    required BaseColors colors,
    double fontSizeScaleFactor = 1.0,
    double elevation = 2.0,
    bool useMaterial3 = true,
  }) {
    return AppTheme(
      typography: TypographyFactory.create(
        typography,
        fontSizeScaleFactor: fontSizeScaleFactor,
      ),
      colors: colors,
      elevation: elevation,
      useMaterial3: useMaterial3,
    );
  }

  /// Create ThemeData based on provided typography and colors
  ThemeData build() {
    final brightness =
        colors is DarkColors ? Brightness.dark : Brightness.light;
    final colorScheme = colors.toColorScheme();

    return ThemeData(
      useMaterial3: useMaterial3,
      fontFamily: typography.fontFamily,
      brightness: brightness,
      colorScheme: colorScheme,

      // Apply color scheme to various components
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: elevation,
      ),
      cardTheme: CardTheme(
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: elevation,
        ),
      ),

      // Extensions
      extensions: [AppThemeExtension(typography: typography, colors: colors)],
    );
  }

  static AppThemeExtension of(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>();
    assert(ext != null, 'AppThemeExtension is not found in ThemeData');
    return ext!;
  }
}
