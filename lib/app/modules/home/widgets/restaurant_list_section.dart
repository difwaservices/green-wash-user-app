import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/shop_product_model.dart';
import '../provider/shop_provider.dart';
import '../view/restaurant_menu_page.dart';
import 'filter_bottom_sheet.dart';
import '../../../core/constants/app_images.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../provider/search_provider.dart';
import '../../../routes/app_routes.dart';

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

// â”€â”€ Shops List â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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
              Expanded(
                child: const Text(
                  'Water Plants Near You',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${shops.length} Plants',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
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
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.filter_list_rounded,
                          size: 16, color: Color(0xFF2E7D32)),
                      SizedBox(width: 4),
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E7D32),
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
            return _ShopCard(shop: shops[index]);
          },
        ),
      ],
    );
  }
}

// â”€â”€ Individual Shop Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ShopCard extends ConsumerWidget {
  final ShopModel shop;

  const _ShopCard({required this.shop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(shopProductsProvider(shop.id));
    final userPosAsync = ref.watch(userLocationProvider);
    final distLabel = userPosAsync.whenOrNull(
      data: (pos) => shopDistanceLabel(
        userPos: pos,
        shopLat: shop.lat,
        shopLng: shop.lng,
      ),
    );

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
          MaterialPageRoute(builder: (_) => RestaurantMenuPage(shop: shop)),
        );
      },
      child: Opacity(
        opacity: shop.isShopActive ? 1.0 : 0.85,
        child: Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00ACC1).withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // â”€â”€ 1. Info Row: thumbnail left, details right â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Shop thumbnail
                      _ShopThumb(shop: shop),
                      // Vertical divider between image and details
                      Container(
                        width: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF00ACC1).withValues(alpha: 0.0),
                              const Color(0xFF00ACC1).withValues(alpha: 0.25),
                              const Color(0xFF00ACC1).withValues(alpha: 0.25),
                              const Color(0xFF00ACC1).withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                      // Details column â€” fills the full height of the image
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name + featured badge
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    shop.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A1A1A),
                                      height: 1.25,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (shop.isFeatured) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3CD),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: const Color(0xFFFFD600)),
                                    ),
                                    child: const Text(
                                      'â­ Top',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5D4037),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              shop.location.isNotEmpty
                                  ? shop.location
                                  : 'Water Supplier',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Rating row (shown when available)
                            if (shop.rating > 0) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 13, color: Color(0xFFFBBF24)),
                                  const SizedBox(width: 3),
                                  Text(
                                    shop.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const Spacer(),
                            // Thin rule before chips
                            Container(
                              height: 1,
                              margin: const EdgeInsets.only(bottom: 7),
                              color: const Color(0xFF00ACC1)
                                  .withValues(alpha: 0.1),
                            ),
                            // Info chips: distance Â· open/closed Â· contact
                            Wrap(
                              spacing: 5,
                              runSpacing: 4,
                              children: [
                                if (distLabel != null)
                                  _InfoChip(
                                    icon: Icons.place_rounded,
                                    label: distLabel,
                                    color: const Color(0xFF1B5E20),
                                    bg: const Color(0xFFE0F7FA),
                                  ),
                                _InfoChip(
                                  icon: shop.isShopActive
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.cancel_outlined,
                                  label: shop.isShopActive ? 'Open' : 'Closed',
                                  color: shop.isShopActive
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFDC2626),
                                  bg: shop.isShopActive
                                      ? const Color(0xFFD1FAE5)
                                      : const Color(0xFFFFE4E6),
                                ),
                                if (shop.contact.isNotEmpty)
                                  _ContactChip(contact: shop.contact),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // â”€â”€ 2. Product Carousel â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              productsAsync.when(
                data: (products) {
                  final items = products
                      .where((p) => p.status == 'Published')
                      .take(12)
                      .toList();
                  if (items.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 1,
                        color: const Color(0xFF00ACC1).withValues(alpha: 0.1),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 7, 12, 4),
                        child: Row(
                          children: [
                            const Text(
                              'Products',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${items.length} items',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                size: 9, color: Color(0xFF2E7D32)),
                          ],
                        ),
                      ),
                      _ProductCarouselStrip(
                        products: items,
                        shopActive: shop.isShopActive,
                        shopName: shop.name,
                      ),
                    ],
                  );
                },
                loading: () => _CarouselShimmer(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(
        begin: 0.04, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
  }
}

// â”€â”€ Shop Thumbnail â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ShopThumb extends StatelessWidget {
  final ShopModel shop;
  const _ShopThumb({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F9FE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF00ACC1).withValues(alpha: 0.18),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: shop.image.length > 5
            ? Image.network(
                shop.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() => Padding(
        padding: const EdgeInsets.all(14),
        child: Image.asset(AppImages.difwaLogoPng, fit: BoxFit.contain),
      );
}

// â”€â”€ Info Chip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Contact Chip (tappable) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ContactChip extends StatelessWidget {
  final String contact;
  const _ContactChip({required this.contact});

  @override
  Widget build(BuildContext context) {
    final isEmail = contact.contains('@');
    final displayLabel = isEmail ? contact.split('@').first : contact;
    return GestureDetector(
      onTap: () {
        final uri = isEmail
            ? Uri(scheme: 'mailto', path: contact)
            : Uri(scheme: 'tel', path: contact);
        launchUrl(uri);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEmail ? Icons.alternate_email_rounded : Icons.phone_rounded,
              size: 11,
              color: const Color(0xFF1B5E20),
            ),
            const SizedBox(width: 3),
            Text(
              displayLabel,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B5E20)),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€ Carousel Shimmer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CarouselShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (_, __) => Container(
          width: 84,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// â”€â”€ Product Strip (manually swipeable, no auto-scroll) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ProductCarouselStrip extends StatelessWidget {
  final List<ShopProduct> products;
  final bool shopActive;
  final String shopName;
  const _ProductCarouselStrip({
    required this.products,
    required this.shopActive,
    required this.shopName,
  });

  static const double _itemW = 84.0;
  static const double _gap = 10.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 106,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (_, i) => _ProductChip(
          product: products[i],
        ),
      ),
    );
  }
}

// â”€â”€ Product Chip (item in carousel) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ProductChip extends StatelessWidget {
  final ShopProduct product;
  const _ProductChip({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _ProductCarouselStrip._itemW,
      margin: const EdgeInsets.only(right: _ProductCarouselStrip._gap),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F9FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00ACC1).withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: product.primaryImage.isNotEmpty
                  ? Image.network(
                      product.primaryImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallback(),
                    )
                  : _fallback(),
            ),
          ),
          // Name + price
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'â‚¹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFFE0F7FA),
      child: const Center(
        child:
            Icon(Icons.water_drop_outlined, color: Color(0xFF2E7D32), size: 22),
      ),
    );
  }
}

// â”€â”€ Loading State â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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
      builder: (_, __) {
        final c1 = Colors.grey.withValues(alpha: _anim.value);
        final c2 = Colors.grey.withValues(alpha: _anim.value * 0.7);
        final c3 = Colors.grey.withValues(alpha: _anim.value * 0.5);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumb placeholder
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: c1,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 13),
              // Text lines placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 14,
                        width: 130,
                        decoration: BoxDecoration(
                            color: c1, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 8),
                    Container(
                        height: 10,
                        width: 90,
                        decoration: BoxDecoration(
                            color: c2, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 12),
                    Container(
                        height: 10,
                        width: 60,
                        decoration: BoxDecoration(
                            color: c2, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 12),
                    Row(children: [
                      Container(
                          height: 20,
                          width: 52,
                          decoration: BoxDecoration(
                              color: c3,
                              borderRadius: BorderRadius.circular(20))),
                      const SizedBox(width: 6),
                      Container(
                          height: 20,
                          width: 44,
                          decoration: BoxDecoration(
                              color: c3,
                              borderRadius: BorderRadius.circular(20))),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// â”€â”€ Error State â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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
                backgroundColor: const Color(0xFF2E7D32),
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

// â”€â”€ Empty State â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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
                backgroundColor: const Color(0xFF2E7D32),
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
