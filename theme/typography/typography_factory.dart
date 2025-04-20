import 'package:typo_color_them/theme/typography/typography.dart';

enum AppTypographyFont {
  appDefault,
  roboto,
  cairo,
  englishTypography,
  arabicTypography,
  // Add more as needed
}

/// Factory class for creating typography instances with different font families
class TypographyFactory {
  static final Map<String, BaseTypography> _cache = {};

  static BaseTypography create(
    AppTypographyFont typography, {
    double fontSizeScaleFactor = 1.0,
  }) {
    final key = '${typography.toString()}_$fontSizeScaleFactor';

    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final instance = _createInstance(typography, fontSizeScaleFactor);
    _cache[key] = instance;
    return instance;
  }

  // Add a method to clear the cache
  static void clearCache() {
    _cache.clear();
  }

  /// Create a new instance without caching (for internal use)
  static BaseTypography _createInstance(
    AppTypographyFont typography,
    double fontSizeScaleFactor,
  ) {
    switch (typography) {
      case AppTypographyFont.appDefault:
        return AppTypography(fontSizeScaleFactor: fontSizeScaleFactor);
      case AppTypographyFont.cairo:
        return AppTypography(
          fontFamily: 'Cairo',
          fontSizeScaleFactor: fontSizeScaleFactor,
        );
      case AppTypographyFont.englishTypography:
        return EnglishTypography(fontSizeScaleFactor: fontSizeScaleFactor);
      case AppTypographyFont.arabicTypography:
        return ArabicTypography(fontSizeScaleFactor: fontSizeScaleFactor);
      case AppTypographyFont.roboto:
        return AppTypography(
          fontFamily: 'Roboto',
          fontSizeScaleFactor: fontSizeScaleFactor,
        );
    }
  }
}
