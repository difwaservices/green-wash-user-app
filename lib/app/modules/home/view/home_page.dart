import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/services/db_service.dart';
import '../../../data/services/wallet_service.dart';
import '../provider/shop_provider.dart';
import '../widgets/home_header.dart';
import '../../../routes/app_routes.dart';
import '../widgets/service_items_bottom_sheet.dart';
import 'premium_club_page.dart';
import 'schedule_pickup_page.dart';
import 'delivery_tracking_page.dart';
import '../../../core/ads/ad_banner_widget.dart';
import 'exclusive_packages_page.dart';
import 'product_details_page.dart';
import '../../../data/models/food_models.dart';
import '../../../data/models/product_model.dart';
import '../../../../core/state/auth_store.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              const HomeHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(shopsListProvider.notifier).refresh();
                    if (context.mounted) {
                      CartProviderScope.of(context).loadAddresses();
                      CartProviderScope.of(context).syncWallet();
                    }
                    ref.invalidate(walletBalanceProvider);
                    ref.invalidate(walletHistoryProvider);
                  },
                  color: const Color(0xFF0F9D58), // Green primary
                  displacement: 40,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 16),
                        _WelcomeBanner(),
                        SizedBox(height: 16),
                        _QuickActionsSection(),
                        SizedBox(height: 24),
                        _HeroBanner(),
                        SizedBox(height: 24),
                        _ServicesSection(), // Acts as Categories
                        SizedBox(height: 32),
                        _TrendingSection(),
                        SizedBox(height: 16),
                        AdBannerWidget(), // Banner Ad between sections
                        SizedBox(height: 16),
                        _RecommendedSection(),
                        SizedBox(height: 32),
                        _RecentlyAddedSection(),
                        SizedBox(height: 32),
                        _HowItWorksSection(),
                        SizedBox(height: 32),
                        _PackagesSection(),
                        SizedBox(height: 32),
                        _PremiumBanner(),
                        SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.search);
        },
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'Search laundry services, packages...',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeBanner extends ConsumerWidget {
  const _WelcomeBanner();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coreState = ref.watch(authStoreProvider);
    final user = coreState is AuthAuthenticated ? coreState.user : null;
    final userName = user?.fullName ?? 'Guest';
    final firstName = userName.split(' ').first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getGreeting()},',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            firstName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : AppColors.primaryDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Let\'s make your clothes shine today!',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF2E7D32).withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}



class _HeroBanner extends StatefulWidget {
  const _HeroBanner();
  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  static final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Premium Care\nFor Your Clothes',
      'subtitle': 'Impeccable washing, folding & dry cleaning.',
      'cta': 'Schedule Pickup',
      'image': 'assets/images/premium_wash_hero.png',
      'gradientStart': const Color(0xFF0A4429),
      'gradientEnd': const Color(0xFF1B5E20),
      'badge': 'ðŸŒ¿ Eco Friendly',
    },
    {
      'title': 'Express Wash\n& Fold Service',
      'subtitle': 'Doorstep pickup & 24-hour delivery guaranteed.',
      'cta': 'Book Now',
      'image': 'assets/images/hero_banner_wash.png',
      'gradientStart': const Color(0xFF004D40),
      'gradientEnd': const Color(0xFF00695C),
      'badge': 'âš¡ 24h Express',
    },
    {
      'title': 'Dry Clean &\nSteam Ironing',
      'subtitle': 'Professional care for delicate & formal wear.',
      'cta': 'Get Offer',
      'image': 'assets/images/hero_banner.png',
      'gradientStart': const Color(0xFF1A237E),
      'gradientEnd': const Color(0xFF283593),
      'badge': 'ðŸ’Ž Premium',
    },
    {
      'title': 'Blanket & Sofa\nDeep Cleaning',
      'subtitle': 'Heavy items cleaned & delivered fresh to your door.',
      'cta': 'Learn More',
      'image': 'assets/images/premium_wash_hero.png',
      'gradientStart': const Color(0xFF3E2723),
      'gradientEnd': const Color(0xFF4E342E),
      'badge': 'ðŸ›‹ï¸ Home Care',
    },
  ];


  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  /// Pause auto-scroll when user manually swipes, resume after 3 seconds.
  void _pauseAndResume() {
    _autoScrollTimer?.cancel();
    Timer(const Duration(seconds: 3), () {
      if (mounted) _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // â”€â”€ Carousel â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F9D58).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 220,
                // NotificationListener intercepts scroll notifications from the
                // PageView so the outer SingleChildScrollView does NOT steal
                // horizontal drag events.
                child: NotificationListener<ScrollNotification>(
                  onNotification: (_) => true, // consume â€” stop bubbling up
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(
                      parent: PageScrollPhysics(),
                    ),
                    itemCount: _banners.length,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                      _pauseAndResume(); // user swiped manually
                    },
                    itemBuilder: (context, index) {
                      final banner = _banners[index];
                      return _BannerSlide(
                        title: banner['title'] as String,
                        subtitle: banner['subtitle'] as String,
                        ctaLabel: banner['cta'] as String,
                        imagePath: banner['image'] as String,
                        gradientStart: banner['gradientStart'] as Color,
                        gradientEnd: banner['gradientEnd'] as Color,
                        badge: banner['badge'] as String,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // â”€â”€ Dot Indicators â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF2E7D32).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BannerSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaLabel;
  final String imagePath;
  final Color gradientStart;
  final Color gradientEnd;
  final String badge;

  const _BannerSlide({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.imagePath,
    required this.gradientStart,
    required this.gradientEnd,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          imagePath,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 220,
            color: const Color(0xFF0A4429),
          ),
        ),
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                gradientStart.withOpacity(0.93),
                gradientEnd.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Badge chip at top
        Positioned(
          top: 16,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.35)),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              height: 1.25,
                              letterSpacing: 0.3,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SchedulePickupPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0A4429),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        ctaLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class _ServicesSection extends StatelessWidget {
  const _ServicesSection();
  @override
  Widget build(BuildContext context) {
    final services = [
      {'icon': Icons.local_laundry_service_rounded, 'label': 'Wash & Fold'},
      {'icon': Icons.dry_cleaning_rounded, 'label': 'Dry Clean'},
      {'icon': Icons.iron_rounded, 'label': 'Ironing'},
      {'icon': Icons.checkroom_rounded, 'label': 'Premium'},
      {'icon': Icons.king_bed_rounded, 'label': 'Blankets'},
      {'icon': Icons.auto_fix_high_rounded, 'label': 'Stains'},
      {'icon': Icons.ice_skating_rounded, 'label': 'Shoe Care'},
      {'icon': Icons.more_horiz_rounded, 'label': 'More'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Explore Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0A4429), // Deep green
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 24,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return GestureDetector(
              onTap: () {
                ServiceItemsBottomSheet.show(
                    context, service['label'] as String);
              },
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // Light green bg
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFC8E6C9),
                          width: 1), // Subtle green border
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50)
                              .withOpacity(0.08), // Green shadow
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      service['icon'] as IconData,
                      color: const Color(0xFF2E7D32), // Vibrant green icon
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    service['label'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B5E20), // Dark green text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PackagesSection extends StatelessWidget {
  const _PackagesSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exclusive Packages',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A4429),
                  letterSpacing: 0.3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExclusivePackagesPage()),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E7D32), // Green link
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: const [
              ProductCard(
                imagePath: 'assets/images/pkg_monthly_wash.png',
                title: 'Monthly Wash Plan',
                price: 'â‚¹1499',
                oldPrice: 'â‚¹1999',
                discount: 'SAVE 25%',
              ),
              SizedBox(width: 20),
              ProductCard(
                imagePath: 'assets/images/pkg_dry_clean.png',
                title: 'Premium Dry Clean',
                price: 'â‚¹499',
                oldPrice: 'â‚¹699',
                discount: 'SAVE 15%',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String oldPrice;
  final String discount;

  const ProductCard({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.discount,
  });

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final numericPrice =
            double.tryParse(price.replaceAll('â‚¹', '').replaceAll(',', '')) ??
                0.0;
        final product = Product(
          id: 'pkg_$title',
          name: title,
          image: imagePath,
          price: numericPrice,
          weight: 'Exclusive Package',
          category: 'Packages',
          badgeText: discount,
          description: 'This is an exclusive laundry package tailored for you.',
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color(0xFFE8F5E9),
              width: 1.5), // Subtle green border
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A4429)
                  .withOpacity(0.06), // Soft green shadow
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.asset(
                    imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32), // Vibrant green tag
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E7D32).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0A4429), // Dark green text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2E7D32), // Green price
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        oldPrice,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF81C784), // Faded green strikethrough
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          final cart = CartProviderScope.of(context);
                          final numericPrice = double.tryParse(price
                                  .replaceAll('â‚¹', '')
                                  .replaceAll(',', '')) ??
                              0.0;
                          cart.addToCart(CartItem(
                            id: 'pkg_$title',
                            title: title,
                            unitPrice: numericPrice,
                            subtitle: 'Exclusive Package',
                            image: imagePath,
                            category: 'Packages',
                            quantity: 1,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$title added to cart!'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFF2E7D32),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.cart);
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_shopping_cart_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8F5E9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFF0A4429).withOpacity(0.04), // Soft green shadow
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'How It Works',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0A4429),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStep(context, Icons.calendar_month_rounded, 'Schedule', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SchedulePickupPage()),
                );
              }),
              _buildDivider(),
              _buildStep(context, Icons.water_drop_rounded, 'Wash', () {
                Navigator.pushNamed(context, AppRoutes.search);
              }),
              _buildDivider(),
              _buildStep(context, Icons.electric_moped_rounded, 'Deliver', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DeliveryTrackingPage()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9), // Lightest green
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC8E6C9), width: 2),
            ),
            child: Icon(icon, color: const Color(0xFF388E3C), size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 30,
      height: 2,
      decoration: BoxDecoration(
        color: const Color(0xFFA5D6A7), // Green divider
        borderRadius: BorderRadius.circular(2),
      ),
      margin: const EdgeInsets.only(bottom: 30),
    );
  }
}

class _PremiumBanner extends StatelessWidget {
  const _PremiumBanner();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF09311B), // Very deep forest green
            Color(0xFF14532D), // Rich emerald
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14532D).withOpacity(0.4), // Emerald shadow
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Text(
              'MEMBERSHIP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Join the Wash Club',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Enjoy unlimited free pickups and an\nexclusive 10% cashback on all orders.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFC8E6C9), // Light pastel green
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PremiumClubPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Crisp white button
                foregroundColor: const Color(0xFF09311B), // Deep green text
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Unlock Premium Benefits',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actions = [
      {'icon': Icons.local_shipping_rounded, 'label': 'Schedule', 'route': AppRoutes.cart},
      {'icon': Icons.map_rounded, 'label': 'Track', 'route': AppRoutes.trackOrder},
      {'icon': Icons.star_rounded, 'label': 'Premium', 'route': null},
      {'icon': Icons.headset_mic_rounded, 'label': 'Support', 'route': AppRoutes.help},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return GestureDetector(
            onTap: () {
              if (action['label'] == 'Premium') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumClubPage()));
              } else if (action['route'] != null) {
                Navigator.pushNamed(context, action['route'] as String);
              }
            },
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    action['icon'] as IconData,
                    color: const Color(0xFF2E7D32),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TrendingSection extends StatelessWidget {
  const _TrendingSection();

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalList(
      context: context,
      title: 'Trending Now ðŸ”¥',
      items: [
        {'title': 'Winter Coat Cleaning', 'price': 'â‚¹499', 'image': 'assets/images/premium_wash_hero.png'},
        {'title': 'Express Wash & Fold', 'price': 'â‚¹299', 'image': 'assets/images/laundry_package_1.png'},
        {'title': 'Sneaker Deep Clean', 'price': 'â‚¹349', 'image': 'assets/images/pkg_shoe_care.png'},
        {'title': 'Dry Cleaning', 'price': 'â‚¹199', 'image': 'assets/images/pkg_dry_clean.png'},
        {'title': 'Steam Ironing', 'price': 'â‚¹149', 'image': 'assets/images/pkg_ironing.png'},
      ],
    );
  }
}

class _RecommendedSection extends StatelessWidget {
  const _RecommendedSection();

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalList(
      context: context,
      title: 'Recommended For You ðŸŒŸ',
      items: [
        {'title': 'Premium Office Wear', 'price': 'â‚¹899', 'image': 'assets/images/premium_wash_hero.png'},
        {'title': 'Delicate Silk Care', 'price': 'â‚¹599', 'image': 'assets/images/laundry_package_2.png'},
        {'title': 'Family Bundle Pack', 'price': 'â‚¹1499', 'image': 'assets/images/pkg_family_bundle.png'},
        {'title': 'Monthly Wash Plan', 'price': 'â‚¹2999', 'image': 'assets/images/pkg_monthly_wash.png'},
        {'title': 'Weekly Refresh', 'price': 'â‚¹799', 'image': 'assets/images/pkg_weekly_refresh.png'},
      ],
    );
  }
}

class _RecentlyAddedSection extends StatelessWidget {
  const _RecentlyAddedSection();

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalList(
      context: context,
      title: 'Recently Added ðŸ†•',
      items: [
        {'title': 'Leather Jacket Care', 'price': 'â‚¹1299', 'image': 'assets/images/laundry_package_1.png'},
        {'title': 'Carpet Deep Wash', 'price': 'â‚¹1999', 'image': 'assets/images/hero_banner_wash.png'},
        {'title': 'Premium Package 1', 'price': 'â‚¹2499', 'image': 'assets/images/premium_package_1.png'},
        {'title': 'Premium Package 2', 'price': 'â‚¹3499', 'image': 'assets/images/premium_package_2.png'},
        {'title': 'Laundry Package', 'price': 'â‚¹599', 'image': 'assets/images/laundry_package_2.png'},
      ],
    );
  }
}

Widget _buildHorizontalList({required BuildContext context, required String title, required List<Map<String, String>> items}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0A4429),
                letterSpacing: 0.3,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SchedulePickupPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.arrow_forward_rounded, color: isDark ? Colors.white54 : const Color(0xFF0A4429), size: 20),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 180,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              width: 160,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SchedulePickupPage()),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          item['image']!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 100,
                            color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                            child: Icon(Icons.image_not_supported, color: isDark ? Colors.white38 : Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['price']!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
