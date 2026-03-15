part of 'locale_cubit.dart';

class LocaleState {
  final Locale locale;
  final bool isLoading;

  const LocaleState({required this.locale, this.isLoading = false});

  bool get isArabic => locale.languageCode == AppConstants.arabicLanguageCode;
  LocaleState copyWith({Locale? locale, bool? isLoading}) {
    return LocaleState(
      locale: locale ?? this.locale,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
