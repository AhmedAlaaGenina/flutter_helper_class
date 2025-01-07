import 'package:fashion/core/constant/constants.dart';
import 'package:fashion/core/helpers/helpers.dart';
import 'package:fashion/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final locale = Locale(CacheHelper.getData(key: AppStrings.locale) ??
        Intl.systemLocale.split("_")[0]);
    if (S.delegate.supportedLocales.contains(locale)) S.load(locale);
    return locale;
  }

  Future<void> setLocale(String localeName) async {
    Locale locale = Locale(localeName);
    if (!S.delegate.supportedLocales.contains(locale)) return;
    state = locale;
    S.load(locale);
    CacheHelper.setData(key: AppStrings.locale, value: localeName);
  }

  bool isArabic() =>
      (CacheHelper.getData(key: AppStrings.locale) ??
          Intl.getCurrentLocale()) ==
      "ar";

  void clearLocale() {
    CacheHelper.remove(key: AppStrings.locale);
    state = Locale(Intl.systemLocale.split("_")[0]);
  }
}

// provider
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scio_phile/constants/app_names.dart';
import 'package:scio_phile/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  late Locale _currentLocale;

  LocaleProvider(this._prefs) {
    // Initialize locale from SharedPreferences or system locale
    final savedLocale = _prefs.getString(AppNames.locale);
    _currentLocale = Locale(savedLocale ?? Intl.systemLocale.split("_")[0]);

    // Load the locale if it's supported
    if (S.delegate.supportedLocales.contains(_currentLocale)) {
      S.load(_currentLocale);
    }
  }

  Locale get locale => _currentLocale;

  Future<void> setLocale(String localeName) async {
    Locale newLocale = Locale(localeName);
    if (!S.delegate.supportedLocales.contains(newLocale)) return;

    _currentLocale = newLocale;
    await S.load(newLocale);
    await _prefs.setString(AppNames.locale, localeName);
    notifyListeners();
  }

  bool isArabic() =>
      (_prefs.getString(AppNames.locale) ?? Intl.getCurrentLocale()) == "ar";

  Future<void> clearLocale() async {
    await _prefs.remove(AppNames.locale);
    _currentLocale = Locale(Intl.systemLocale.split("_")[0]);
    notifyListeners();
  }
}
