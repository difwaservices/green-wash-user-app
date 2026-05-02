import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/shop_product_model.dart';
import '../provider/shop_provider.dart';
import '../view/restaurant_menu_page.dart';
import 'filter_bottom_sheet.dart';
import '../../../core/constants/app_images.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../provider/search_provider.dart';
import '../../../routes/app_routes.dart';

// ── Cuisine types to cycle through for display ───────────────────────────────
const List<String> _cuisineTypes = [
  'Purified · Mineral',
  'Alkaline · RO+UV',
  'Natural · Spring',
  'Distilled · Clean',
  'Ionized · Balanced',
  'Bottled · Bulk',
  'Sparkling · Fresh',
  'Filtered · Pure',
  'Eco-Friendly · Safe',
  'Premium · Health',
  'Domestic · Supply',
];

class RestaurantListSection extends ConsumerWidget {
  const RestaurantListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopsAsync = ref.watch(shopsListProvider);

    return shopsAsync.when(
      loading: () => const _ShopsLoadingState(),
      error: (err, _) => _ShopsErrorState(
        message: err.toString(),
        onRetry: () => ref.invalidate(shopsListProvider),
      ),
      data: (shops) {
        if (shops.isEmpty) {
          return _ShopsEmptyState(
              onRetry: () => ref.invalidate(shopsListProvider));
        }
        return _ShopsList(shops: shops);
      },
    );
  }
}

// ── Shops List ────────────────────────────────────────────────────────────────

class _ShopsList extends ConsumerWidget {
  final List<ShopModel> shops;
  const _ShopsList({required this.shops});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              const Text(
                'Water Plants Near You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Text(
                '${shops.length} Plants',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  final searchState = ref.read(searchProvider);
                  final initialResult = searchState.priceRange != null ||
                          searchState.selectedCategoryIds.isNotEmpty ||
                          searchState.selectedDeliverySlots.isNotEmpty
                      ? FilterResult(
                          priceRange: searchState.priceRange ??
                              const RangeValues(10, 2000),
                          selectedCategoryIds: searchState.selectedCategoryIds,
                          selectedDeliverySlots:
                              searchState.selectedDeliverySlots,
                        )
                      : null;

                  final result = await FilterBottomSheet.show(context,
                      initialResult: initialResult);
                  if (result != null) {
                    ref.read(searchProvider.notifier).applyAdvancedFilters(
                          priceRange: result.priceRange,
                          selectedCategoryIds: result.selectedCategoryIds,
                          selectedDeliverySlots: result.selectedDeliverySlots,
                        );
                    if (context.mounted) {
                      Navigator.pushNamed(context, AppRoutes.search);
                    }
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.filter_list_rounded,
                          size: 16, color: Color(0xFF06B6D4)),
                      SizedBox(width: 4),
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF06B6D4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: shops.length,
          itemBuilder: (context, index) {
            return _ShopCard(
              shop: shops[index],
              index: index,
            );
          },
        ),
      ],
    );
  }
}

// ── Individual Shop Card ──────────────────────────────────────────────────────

class _ShopCard extends StatelessWidget {
  final ShopModel shop;
  final int index;

  const _ShopCard({required this.shop, required this.index});

  String get _cuisine => _cuisineTypes[index % _cuisineTypes.length];

  // Generate a deterministic rating from shop ID

  bool get _isFeatured => shop.isFeatured;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!shop.isShopActive) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This plant is currently not accepting orders.'),
                backgroundColor: Colors.black87,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RestaurantMenuPage(shop: shop),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Opacity(
            opacity: shop.isShopActive ? 1.0 : 0.8,
            child: ColorFiltered(
              colorFilter: shop.isShopActive
                  ? const ColorFilter.mode(
                      Colors.transparent, BlendMode.multiply)
                  : const ColorFilter.mode(
                      Color.fromARGB(255, 255, 255, 255), BlendMode.saturation),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF00ACC1).withOpacity(0.2),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Hero Banner ─────────────────────────────────────────────────
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: _buildHeroImage(),
                          ),
                          // Closed/Offline Overlay
                          if (!shop.isShopActive)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade700,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'CLOSED',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // Top dish label overlay
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                shop.businessName.isNotEmpty
                                    ? shop.businessName
                                    : 'Pure Water · ₹499+',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          // Featured badge
                          if (_isFeatured)
                            Positioned(
                              bottom: 10,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3CD),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: const Color(0xFFFFD600)),
                                ),
                                child: const Text(
                                  '⭐ Featured',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5D4037),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      // ── Info Row ─────────────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shop.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _cuisine,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                    ]),
              ),
            ),
          ),
        ));
  }

  Widget _buildHeroImage() {
    // Prefer banner from API, then local asset fallback
    final networkUrl = shop.image;
    if (networkUrl.length > 5) {
      return Container(
        color: Colors.white,
        child: Image.network(
          networkUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _localFallback(),
        ),
      );
    }
    return _localFallback();
  }

  Widget _localFallback() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Image.asset(
            AppImages.difwaLogoPng,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

// ── Loading State ─────────────────────────────────────────────────────────────

class _ShopsLoadingState extends StatelessWidget {
  const _ShopsLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Image.asset(
              AppImages.difwaLogoPng,
              width: 100,
              height: 100,
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.1, 1.1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut)
                .fadeIn(begin: 0.6, duration: 1000.ms, curve: Curves.easeInOut),
          ),
        ),
        ...List.generate(3, (i) => const _ShopShimmerCard()),
      ],
    );
  }
}

class _ShopShimmerCard extends StatefulWidget {
  const _ShopShimmerCard();

  @override
  State<_ShopShimmerCard> createState() => _ShopShimmerCardState();
}

class _ShopShimmerCardState extends State<_ShopShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.8)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: _anim.value),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: _anim.value),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: _anim.value * 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 12,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: _anim.value * 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
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

// ── Error State ───────────────────────────────────────────────────────────────

class _ShopsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ShopsErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'Could not load water plants',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 6),
            Text(
              'Please check connection and try again.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _ShopsEmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ShopsEmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.storefront_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No water plants found',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 6),
            Text(
              'Check back later for nearby water plants.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Refresh',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
