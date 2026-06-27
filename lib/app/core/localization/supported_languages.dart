import 'package:flutter/material.dart';

class SupportedLanguage {
  final String code;
  final String name;
  final String nativeName;
  final Locale locale;

  const SupportedLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.locale,
  });
}

const List<SupportedLanguage> kSupportedLanguages = [
  SupportedLanguage(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    locale: Locale('en'),
  ),
  SupportedLanguage(
    code: 'hi',
    name: 'Hindi',
    nativeName: 'हिन्दी',
    locale: Locale('hi'),
  ),
  SupportedLanguage(
    code: 'bn',
    name: 'Bengali',
    nativeName: 'বাংলা',
    locale: Locale('bn'),
  ),
  SupportedLanguage(
    code: 'te',
    name: 'Telugu',
    nativeName: 'తెలుగు',
    locale: Locale('te'),
  ),
  SupportedLanguage(
    code: 'mr',
    name: 'Marathi',
    nativeName: 'मराठी',
    locale: Locale('mr'),
  ),
  SupportedLanguage(
    code: 'ta',
    name: 'Tamil',
    nativeName: 'தமிழ்',
    locale: Locale('ta'),
  ),
  SupportedLanguage(
    code: 'kn',
    name: 'Kannada',
    nativeName: 'ಕನ್ನಡ',
    locale: Locale('kn'),
  ),
  SupportedLanguage(
    code: 'ml',
    name: 'Malayalam',
    nativeName: 'മലയാളം',
    locale: Locale('ml'),
  ),
  SupportedLanguage(
    code: 'gu',
    name: 'Gujarati',
    nativeName: 'ગુજરાતી',
    locale: Locale('gu'),
  ),
  SupportedLanguage(
    code: 'pa',
    name: 'Punjabi',
    nativeName: 'ਪੰਜਾਬੀ',
    locale: Locale('pa'),
  ),
];

List<Locale> get kSupportedLocales =>
    kSupportedLanguages.map((l) => l.locale).toList();

SupportedLanguage? languageByCode(String code) {
  try {
    return kSupportedLanguages.firstWhere((l) => l.code == code);
  } catch (_) {
    return null;
  }
}
