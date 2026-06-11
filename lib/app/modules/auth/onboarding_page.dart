import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../routes/app_routes.dart';
import '../../../../l10n/generated/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> _getPages(AppLocalizations l10n) {
    return [
      {
        'title': l10n.onboarding1Title,
        'subtitle': l10n.onboarding1Subtitle,
        'image': AppImages.difwaLogoPng,
        'layout': 'standard', // title top, image center
        'isSvg': false,
      },
      {
        'title': l10n.onboarding2Title,
        'subtitle': l10n.onboarding2Subtitle,
        'image': AppImages.waterHero,
        'layout': 'card', // title top, image in rounded card
        'isSvg': false,
      },
      {
        'title': l10n.onboarding3Title,
        'subtitle': l10n.onboarding3Subtitle,
        'image': AppImages.bottleIcon,
        'layout': 'fullimage', // image fills top, curved white bottom
        'isSvg': true,
      },
      {
        'title': l10n.onboarding4Title,
        'subtitle': l10n.onboarding4Subtitle,
        'image': AppImages.waterBottle,
        'layout': 'bottom', // image top half, title+subtitle bottom, skip/next
        'isSvg': false,
      },
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) => setState(() => _currentPage = index);

  void _next(int pageCount) {
    if (_currentPage < pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _skip() => Navigator.pushReplacementNamed(context, AppRoutes.login);

  // ---------- build ----------
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = _getPages(l10n);
    final page = pages[_currentPage];
    final layout = page['layout'] as String;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: pages.length,
            itemBuilder: (ctx, i) {
              final p = pages[i];
              switch (p['layout']) {
                case 'card':
                  return _buildCardLayout(p);
                case 'fullimage':
                  return _buildFullImageLayout(p);
                case 'bottom':
                  return _buildBottomLayout(p);
                default:
                  return _buildStandardLayout(p);
              }
            },
          ),

          // Bottom controls (dots + button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildSkipNextNav(l10n, pages.length),
          ),
        ],
      ),
    );
  }

  // ─── Layout 1: Standard (title top, logo center) ──────────────────────────
  Widget _buildStandardLayout(Map<String, dynamic> page) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              page['title'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              page['subtitle'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.55,
              ),
            ),
            Expanded(
              child: Center(
                child: page['isSvg']
                    ? SvgPicture.asset(
                        page['image'],
                        width: 250,
                      )
                    : Image.asset(
                        page['image'],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Layout 2: Card (title top, image in rounded card) ───────────────────
  Widget _buildCardLayout(Map<String, dynamic> page) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              page['title'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              page['subtitle'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: page['isSvg']
                    ? SvgPicture.asset(
                        page['image'],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        page['image'],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Colors.grey,
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

  // ─── Layout 3: Full image top, curved white bottom ────────────────────────
  Widget _buildFullImageLayout(Map<String, dynamic> page) {
    return Stack(
      children: [
        // Full-bleed image
        Positioned.fill(
          child: page['isSvg']
              ? SvgPicture.asset(
                  page['image'],
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  page['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey.shade300),
                ),
        ),
        // Curved white card at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  page['title'],
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  page['subtitle'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Layout 4: Image top half, text bottom, Skip/Next ────────────────────
  Widget _buildBottomLayout(Map<String, dynamic> page) {
    return Column(
      children: [
        // Top image (50%)
        Expanded(
          child: page['isSvg']
              ? SvgPicture.asset(
                  page['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  page['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey.shade300),
                ),
        ),
        // Bottom white area
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                page['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                page['subtitle'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Nav: Skip · dots · Next ──────────────────────────────────────────────
  Widget _buildSkipNextNav(AppLocalizations l10n, int pageCount) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _skip,
            child: Text(
              l10n.skip,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildDots(pageCount),
          GestureDetector(
            onTap: () => _next(pageCount),
            child: Text(
              _currentPage < pageCount - 1 ? l10n.next : l10n.getStarted,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Dots ─────────────────────────────────────────────────────────────────
  Widget _buildDots(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == i ? 20 : 8,
          decoration: BoxDecoration(
            color: _currentPage == i ? AppColors.primary : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
