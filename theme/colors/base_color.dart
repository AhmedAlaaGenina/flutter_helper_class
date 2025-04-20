import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Contract for colors implementations
abstract class BaseColors extends Equatable {
  const BaseColors();

  // Primary colors
  Color get primary;
  Color get primaryDark;
  Color get primaryLight;
  Color get onPrimary;

  // Secondary colors
  Color get secondary;
  Color get secondaryDark;
  Color get secondaryLight;
  Color get onSecondary;

  // Background colors
  Color get background;
  Color get surface;
  Color get onBackground;
  Color get onSurface;

  // Semantic colors
  Color get error;
  Color get success;
  Color get warning;
  Color get info;
  Color get onError;
  Color get onSuccess; // Missing in original
  Color get onWarning; // Missing in original
  Color get onInfo; // Missing in original

  // Surface variants (Material 3)
  Color get surfaceVariant;
  Color get onSurfaceVariant;

  // Extended colors (Material 3)
  Color get outline;
  Color get outlineVariant;
  Color get inversePrimary;
  Color get inverseSurface;
  Color get onInverseSurface;
  Color get scrim;

  // Generate a complete ColorScheme
  ColorScheme toColorScheme();

  @override
  List<Object?> get props => [
    primary,
    primaryDark,
    primaryLight,
    onPrimary,
    secondary,
    secondaryDark,
    secondaryLight,
    onSecondary,
    background,
    surface,
    onBackground,
    onSurface,
    error,
    success,
    warning,
    info,
    onError,
    onSuccess,
    onWarning,
    onInfo,
  ];
}
