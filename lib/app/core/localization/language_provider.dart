import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'supported_languages.dart';

const _kLanguageKey = 'selected_language_code';
// Set to true once the user completes the first-time language selection screen.
const _kLanguageOnboardingDone = 'language_onboarding_done';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLanguageKey);
    if (code != null) {
      final lang = languageByCode(code);
      if (lang != null) state = lang.locale;
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageKey, locale.languageCode);
  }

  /// Returns true if this is the very first launch (user has never picked a
  /// language through the onboarding flow).
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLanguageOnboardingDone) != true;
  }

  /// Call this after the user taps "Continue" on the first-time language
  /// screen so we never show it again.
  static Future<void> markOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLanguageOnboardingDone, true);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
