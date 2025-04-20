import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typo_color_them/theme/theme.dart';
import 'package:typo_color_them/theme/typography/typography.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // Keys for shared preferences
  static const String _themeModeKey = 'theme_mode';
  static const String _typographyFontKey = 'typography_font';
  static const String _fontSizeScaleFactorKey = 'font_size_scale_factor';

  ThemeBloc() : super(const ThemeState()) {
    on<ThemeInitialize>(_onInitialize);
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<ThemeUpdated>(_onThemeUpdated);
    on<TypographyFontChanged>(_onTypographyFontChanged);
    on<FontSizeScaleFactorChanged>(_onFontSizeScaleFactorChanged);
    on<ThemeModeAndFontChanged>(_onThemeModeAndFontChanged);
    on<ThemeReset>(_onThemeReset);
  }

  // Handler for ThemeInitialize event
  Future<void> _onInitialize(
    ThemeInitialize event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(status: ThemeStatus.loading));

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load theme mode
      final themeModeString = prefs.getString(_themeModeKey);
      ThemeMode themeMode = ThemeMode.system;

      if (themeModeString != null) {
        if (themeModeString == 'ThemeMode.dark') {
          themeMode = ThemeMode.dark;
        } else if (themeModeString == 'ThemeMode.light') {
          themeMode = ThemeMode.light;
        }
      }

      // Load typography font
      final typographyFontString = prefs.getString(_typographyFontKey);
      AppTypographyFont typographyFont = AppTypographyFont.appDefault;

      if (typographyFontString != null) {
        for (var font in AppTypographyFont.values) {
          if (font.toString() == typographyFontString) {
            typographyFont = font;
            break;
          }
        }
      }

      // Load font size scale factor
      final fontSizeScaleFactor =
          prefs.getDouble(_fontSizeScaleFactorKey) ?? 1.0;

      final newState = state.copyWith(
        status: ThemeStatus.loaded,
        themeMode: themeMode,
        typographyFont: typographyFont,
        fontSizeScaleFactor: fontSizeScaleFactor,
        clearError: true,
      );

      // Generate theme data
      final themeData = newState.createThemeData();

      emit(newState.copyWith(themeData: themeData));
    } catch (e) {
      emit(
        state.copyWith(
          status: ThemeStatus.error,
          errorMessage: 'Failed to load theme settings: $e',
        ),
      );
    }
  }

  // Handler for ThemeModeChanged event
  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, event.themeMode.toString());

      final newState = state.copyWith(
        themeMode: event.themeMode,
        status: ThemeStatus.loaded,
      );

      final themeData = newState.createThemeData();
      emit(newState.copyWith(themeData: themeData));
    } catch (e) {
      emit(
        state.copyWith(
          status: ThemeStatus.error,
          errorMessage: 'Failed to save theme mode: $e',
        ),
      );
    }
  }

  void _onThemeUpdated(ThemeUpdated event, Emitter<ThemeState> emit) {
    // Simply update the theme data to reflect system changes
    emit(
      state.copyWith(themeData: event.themeData, status: ThemeStatus.loaded),
    );
  }

  // Handler for TypographyFontChanged event
  Future<void> _onTypographyFontChanged(
    TypographyFontChanged event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_typographyFontKey, event.typography.toString());
      TypographyFactory.clearCache();
      final newState = state.copyWith(
        typographyFont: event.typography,
        status: ThemeStatus.loaded,
      );

      final themeData = newState.createThemeData();
      emit(newState.copyWith(themeData: themeData));
    } catch (e) {
      emit(
        state.copyWith(
          status: ThemeStatus.error,
          errorMessage: 'Failed to save typography font: $e',
        ),
      );
    }
  }

  // Handler for FontSizeScaleFactorChanged event
  Future<void> _onFontSizeScaleFactorChanged(
    FontSizeScaleFactorChanged event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeScaleFactorKey, event.scaleFactor);

      final newState = state.copyWith(
        fontSizeScaleFactor: event.scaleFactor,
        status: ThemeStatus.loaded,
      );

      final themeData = newState.createThemeData();
      emit(newState.copyWith(themeData: themeData));
    } catch (e) {
      emit(
        state.copyWith(
          status: ThemeStatus.error,
          errorMessage: 'Failed to save font size scale factor: $e',
        ),
      );
    }
  }

  // Handler for ThemeModeAndFontChanged event
  Future<void> _onThemeModeAndFontChanged(
    ThemeModeAndFontChanged event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, event.themeMode.toString());
      await prefs.setString(_typographyFontKey, event.typography.toString());

      final newState = state.copyWith(
        themeMode: event.themeMode,
        typographyFont: event.typography,
        status: ThemeStatus.loaded,
      );

      final themeData = newState.createThemeData();
      emit(newState.copyWith(themeData: themeData));
    } catch (e) {
      emit(
        state.copyWith(
          status: ThemeStatus.error,
          errorMessage: 'Failed to save theme mode and font: $e',
        ),
      );
    }
  }

  // Handler for ThemeReset event
  Future<void> _onThemeReset(ThemeReset event, Emitter<ThemeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeModeKey);
      await prefs.remove(_typographyFontKey);
      await prefs.remove(_fontSizeScaleFactorKey);

      const defaultState = ThemeState();
      final themeData = defaultState.createThemeData();

      emit(
        const ThemeState(
          status: ThemeStatus.loaded,
        ).copyWith(themeData: themeData),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ThemeStatus.error,
          errorMessage: 'Failed to reset theme settings: $e',
        ),
      );
    }
  }
}
