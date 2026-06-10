import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/localization/supported_languages.dart';
import '../../../routes/app_routes.dart';

/// Shown once on first launch so the user can pick their preferred language
/// before seeing the onboarding / home screen.
class FirstTimeLanguagePage extends ConsumerStatefulWidget {
  const FirstTimeLanguagePage({super.key});

  @override
  ConsumerState<FirstTimeLanguagePage> createState() =>
      _FirstTimeLanguagePageState();
}

class _FirstTimeLanguagePageState extends ConsumerState<FirstTimeLanguagePage> {
  String _selectedCode = 'en';

  @override
  void initState() {
    super.initState();
    // Pre-select whatever locale was restored from prefs (usually 'en')
    _selectedCode = ref.read(localeProvider).languageCode;
  }

  Future<void> _onContinue() async {
    final lang = languageByCode(_selectedCode);
    if (lang != null) {
      await ref.read(localeProvider.notifier).setLocale(lang.locale);
    }
    await LocaleNotifier.markOnboardingDone();

    if (!mounted) return;
    // Replace this screen with login so back-press never returns here
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                children: [
                  Image.asset(
                    AppImages.difwaLogoPng,
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Choose Your Language',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select the language you are most comfortable with',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),

            // ── Language list ────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: kSupportedLanguages.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 56),
                itemBuilder: (context, index) {
                  final lang = kSupportedLanguages[index];
                  final isSelected = _selectedCode == lang.code;
                  return _LangTile(
                    language: lang,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedCode = lang.code),
                  );
                },
              ),
            ),

            // ── Continue button ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: GestureDetector(
                onTap: _onContinue,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF006064), Color(0xFF00ACC1)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00ACC1).withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  final SupportedLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Row(
          children: [
            // Flag / language initial avatar
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Text(
                _flag(language.code),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.nativeName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  Text(
                    language.name,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _flag(String code) {
    const flags = {
      'en': '🇬🇧',
      'hi': '🇮🇳',
      'bn': '🇮🇳',
      'te': '🇮🇳',
      'mr': '🇮🇳',
      'ta': '🇮🇳',
      'kn': '🇮🇳',
      'ml': '🇮🇳',
      'gu': '🇮🇳',
      'pa': '🇮🇳',
    };
    return flags[code] ?? '🌐';
  }
}
