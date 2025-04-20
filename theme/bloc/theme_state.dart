part of 'theme_bloc.dart';

enum ThemeStatus { initial, loading, loaded, error }

class ThemeState extends Equatable {
  final ThemeStatus status;
  final ThemeMode themeMode;
  final AppTypographyFont typographyFont;
  final double fontSizeScaleFactor;
  final String? errorMessage;
  final ThemeData? themeData;

  const ThemeState({
    this.status = ThemeStatus.initial,
    this.themeMode = ThemeMode.system,
    this.typographyFont = AppTypographyFont.appDefault,
    this.fontSizeScaleFactor = 1.0,
    this.errorMessage,
    this.themeData,
  });

  // Current brightness based on theme mode
  Brightness get currentBrightness {
    if (themeMode == ThemeMode.system) {
      final platformBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return platformBrightness;
    }
    return themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }

  // Create a copy of this state with optional new values
  ThemeState copyWith({
    ThemeStatus? status,
    ThemeMode? themeMode,
    AppTypographyFont? typographyFont,
    double? fontSizeScaleFactor,
    String? errorMessage,
    bool clearError = false,
    ThemeData? themeData,
  }) {
    return ThemeState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      typographyFont: typographyFont ?? this.typographyFont,
      fontSizeScaleFactor: fontSizeScaleFactor ?? this.fontSizeScaleFactor,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      themeData: themeData ?? this.themeData,
    );
  }

  // Create theme data based on current state
  ThemeData createThemeData() =>
      AppTheme.create(
        brightness: currentBrightness,
        typography: typographyFont,
        fontSizeScaleFactor: fontSizeScaleFactor,
      ).build();

  @override
  List<Object?> get props => [
    status,
    themeMode,
    typographyFont,
    fontSizeScaleFactor,
    themeData,
    errorMessage,
  ];
}
