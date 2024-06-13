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
