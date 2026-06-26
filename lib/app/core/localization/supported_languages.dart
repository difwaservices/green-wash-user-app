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
    nativeName: 'à¤¹à¤¿à¤‚à¤¦à¥€',
    locale: Locale('hi'),
  ),
  SupportedLanguage(
    code: 'bn',
    name: 'Bengali',
    nativeName: 'à¦¬à¦¾à¦‚à¦²à¦¾',
    locale: Locale('bn'),
  ),
  SupportedLanguage(
    code: 'te',
    name: 'Telugu',
    nativeName: 'à°¤à±†à°²à±à°—à±',
    locale: Locale('te'),
  ),
  SupportedLanguage(
    code: 'mr',
    name: 'Marathi',
    nativeName: 'à¤®à¤°à¤¾à¤ à¥€',
    locale: Locale('mr'),
  ),
  SupportedLanguage(
    code: 'ta',
    name: 'Tamil',
    nativeName: 'à®¤à®®à®¿à®´à¯',
    locale: Locale('ta'),
  ),
  SupportedLanguage(
    code: 'kn',
    name: 'Kannada',
    nativeName: 'à²•à²¨à³à²¨à²¡',
    locale: Locale('kn'),
  ),
  SupportedLanguage(
    code: 'ml',
    name: 'Malayalam',
    nativeName: 'à´®à´²à´¯à´¾à´³à´‚',
    locale: Locale('ml'),
  ),
  SupportedLanguage(
    code: 'gu',
    name: 'Gujarati',
    nativeName: 'àª—à«àªœàª°àª¾àª¤à«€',
    locale: Locale('gu'),
  ),
  SupportedLanguage(
    code: 'pa',
    name: 'Punjabi',
    nativeName: 'à¨ªà©°à¨œà¨¾à¨¬à©€',
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
