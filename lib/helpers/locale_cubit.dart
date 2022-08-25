import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noonpool/helpers/constants.dart';
import 'package:noonpool/helpers/shared_preference_util.dart';

class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(null);

  updateCurrentLocale(Locale? locale) {
    AppPreferences.setLocaleLanguageCode(
      localeLanguageCode:
          locale?.languageCode ?? AppPreferences.defaultLocaleLanguageCode,
    );
    emit(locale);
  }
}

class AppLocale {
  final String rawName;
  final int index;
  final String translatedName;
  final Locale? locale;

  AppLocale({
    required this.rawName,
    required this.index,
    required this.translatedName,
    required this.locale,
  });
}

List<AppLocale> appLocales(BuildContext context) => [
      AppLocale(
        rawName: "System Default",
        index: 0,
        translatedName: '(${AppLocalizations.of(context)!.systemDefault})',
        locale: null,
      ),
      AppLocale(
        rawName: "English",
        index: 1,
        translatedName: '(${AppLocalizations.of(context)!.english})',
        locale: const Locale('en'),
      ),
      AppLocale(
        rawName: "Persian",
        index: 2,
        translatedName: '(${AppLocalizations.of(context)!.persian})',
        locale: const Locale('fa'),
      ),
      AppLocale(
        rawName: "Chinease",
        index: 3,
        translatedName: '(${AppLocalizations.of(context)!.chinease})',
        locale: const Locale('zh'),
      ),
      AppLocale(
        rawName: "Arabic",
        index: 4,
        translatedName: '(${AppLocalizations.of(context)!.arabic})',
        locale: const Locale('ar'),
      ),
      AppLocale(
        rawName: "Russian",
        index: 5,
        translatedName: '(${AppLocalizations.of(context)!.russia})',
        locale: const Locale('ru'),
      ),
      AppLocale(
        rawName: "Turkish",
        index: 6,
        translatedName: '(${AppLocalizations.of(context)!.turkish})',
        locale: const Locale('tr'),
      ),
    ];
