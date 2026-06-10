import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/models/shop_product_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/db_service.dart';
import '../../../data/services/favorites_service.dart';
import '../provider/shop_provider.dart';
import '../widgets/cart_summary_bar.dart';
import '../widgets/quantity_selector.dart';
import 'package:difwawaterapp/app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import 'product_details_page.dart';
import '../../../data/services/shop_service.dart';
import '../widgets/product_card.dart';

class RestaurantMenuPage extends ConsumerStatefulWidget {
  final ShopModel shop;
  const RestaurantMenuPage({super.key, required this.shop});

  @override
  ConsumerState<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends ConsumerState<RestaurantMenuPage> {
  double? _realDistance;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _loadDetailsAndFetchLocation();
  }

  Future<void> _loadDetailsAndFetchLocation() async {
    try {
      final detailedShop = await ref.read(shopDetailsProvider(widget.shop.id).future);
      if (detailedShop != null) {
        _fetchRealDistance(detailedShop);
      } else {
        _fetchRealDistance(widget.shop);
      }
    } catch (e) {
      _fetchRealDistance(widget.shop);
    }
  }

  Future<void> _fetchRealDistance(ShopModel resolvedShop) async {
    // If shop lat/long not available, we can't calculate
    if (resolvedShop.lat == null || resolvedShop.lng == null) return;
    
    setState(() => _isLocating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
         setState(() => _isLocating = false);
         return; 
      }
      
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
           setState(() => _isLocating = false);
           return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
         setState(() => _isLocating = false);
         return;
      }
      
      // Get current location (low accuracy to be fast)
      final userPos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      final dist = Geolocator.distanceBetween(
        userPos.latitude,
        userPos.longitude,
        resolvedShop.lat!,
        resolvedShop.lng!,
      ) / 1000.0;
      
      if (mounted) {
        setState(() {
          _realDistance = dist;
          _isLocating = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  String get _heroImage {
    final images = [
      'assets/images/Difwa_dish_1.png',
      'assets/images/Difwa_dish_2.png',
      'assets/images/Difwa_dish_3.png',
      'assets/images/Difwa_lemon_herb.png',
      'assets/images/Difwa_tiger_trio.png',
      'assets/images/Difwa_cooked_duo.png',
    ];
    final code = widget.shop.id.codeUnits.fold<int>(0, (a, b) => a + b);
    return images[code % images.length];
  }

  @override
  Widget build(BuildContext context) {
    final shopDetailsAsync = ref.watch(shopDetailsProvider(widget.shop.id));
    final currentShop = shopDetailsAsync.maybeWhen(
      data: (detailedShop) => detailedShop ?? widget.shop,
      orElse: () => widget.shop,
    );
    
    final productsAsync = ref.watch(shopProductsProvider(currentShop.id));
    final cart = CartProviderScope.of(context);
    final isShopActive = currentShop.isShopActive;

    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);
    final double itemWidth = (screenWidth - 32 - (crossAxisCount - 1) * 12) / crossAxisCount;
    final double targetHeight = (itemWidth * 1.55).clamp(235.0, 270.0);
    final double childAspectRatio = itemWidth / targetHeight;

    // Determine the distance string
    String distanceStr = '';
    // Priority 1: User's explicitly selected address
    if (currentShop.lat != null && currentShop.lng != null && cart.addresses.isNotEmpty && cart.selectedAddressIndex < cart.addresses.length) {
       final userAddress = cart.addresses[cart.selectedAddressIndex];
       if (userAddress.latitude != null && userAddress.longitude != null) {
           final dist = Geolocator.distanceBetween(
             userAddress.latitude!,
             userAddress.longitude!,
             currentShop.lat!,
             currentShop.lng!,
           ) / 1000;
           distanceStr = '${dist.toStringAsFixed(1)} km';
       }
    }

    // Priority 2: Live device GPS location
    if (distanceStr.isEmpty && _realDistance != null) {
      distanceStr = '${_realDistance!.toStringAsFixed(1)} km';
    }
    
    // Fallback if APIs or Address not ready
    if (distanceStr.isEmpty) {
      if (_isLocating) {
         distanceStr = 'Locating...';
      } else {
         final code = currentShop.id.codeUnits.fold<int>(0, (a, b) => a + b);
         distanceStr = '${(((code % 50) + 5) / 10.0).toStringAsFixed(1)} km';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        bottom: false, // Keep status bar behavior, but handle bottom separately
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: isShopActive
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                  : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
              child: Opacity(
                opacity: isShopActive ? 1.0 : 0.8,
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    ref.invalidate(shopsListProvider);
                    ref.invalidate(shopProductsProvider(currentShop.id));
                    await ref.read(shopProductsProvider(currentShop.id).future);
                  },
                  child: SafeArea(
                    bottom: true, // This handles the navigation bar area
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 220,
                          pinned: true,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withValues(alpha: 0.9),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.black87, size: 20),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          actions: [],
                          flexibleSpace: FlexibleSpaceBar(
                            background: _buildHeroBanner(currentShop),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF00ACC1)
                                      .withValues(alpha: 0.2),
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentShop.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentShop.location.isNotEmpty
                                      ? currentShop.location
                                      : 'Shop Location',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    _MetaChip(
                                      icon: Icons.location_on_rounded,
                                      label: distanceStr,
                                      iconColor: const Color(0xFF06B6D4),
                                    ),
                                    const SizedBox(width: 12),
                                    _MetaChip(
                                      icon: Icons.star_rounded,
                                      label: '${currentShop.rating}',
                                      iconColor: Colors.amber,
                                    ),
                                  ],
                                ),
                                if (!isShopActive) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.error_outline,
                                            color: Colors.white, size: 20),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'This plant is currently offline.',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // ── Products Section Header ────────────────────────────────────
                        const SliverPadding(
                          padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
                          sliver: SliverToBoxAdapter(
                            child: Text(
                              'WATER VARIETIES',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        // ── Products Grid ─────────────────────────────────────────────
                        productsAsync.when(
                          loading: () => const SliverToBoxAdapter(
                            child: _ProductsLoadingGrid(),
                          ),
                          error: (err, _) => SliverToBoxAdapter(
                            child: _ProductsErrorState(
                              message: err.toString(),
                              onRetry: () => ref.invalidate(
                                  shopProductsProvider(widget.shop.id)),
                            ),
                          ),
                          data: (products) {
                            if (products.isEmpty) {
                              return const SliverToBoxAdapter(
                                  child: _ProductsEmptyState());
                            }
                            return SliverPadding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: childAspectRatio,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final product = products[index];
                                    return ProductCard(
                                      product: product.toProduct(isShopActive,
                                          shopName: currentShop.name),
                                    );
                                  },
                                  childCount: products.length,
                                ),
                              ),
                            );
                          },
                        ),

                        const SliverPadding(
                            padding: EdgeInsets.only(bottom: 200)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Floating Back Button removed (handled by SliverAppBar) ────────

            if (cart.itemCount > 0 && isShopActive)
              Positioned(
                bottom:
                    20, // Reduced but wrapped in SafeArea if needed, or just let it sit high
                left: 0,
                right: 0,
                child: SafeArea(
                  child: CartSummaryBar(
                    cart: cart,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.cart);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(ShopModel currentShop) {
    final networkUrl = currentShop.image;
    if (networkUrl.length > 5) {
      return Image.network(
        networkUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _localHero(),
      );
    }
        return _localHero();
  }

  Widget _localHero() {
    return Image.asset(
      _heroImage,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        child: const Center(
            child: Icon(Icons.water_drop_outlined, size: 64, color: Colors.grey)),
      ),
    );
  }
}

// ── Products Loading Grid ─────────────────────────────────────────────────────

class _ProductsLoadingGrid extends StatelessWidget {
  const _ProductsLoadingGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => const _ProductShimmerCard(),
      ),
    );
  }
}

class _ProductShimmerCard extends StatefulWidget {
  const _ProductShimmerCard();

  @override
  State<_ProductShimmerCard> createState() => _ProductShimmerCardState();
}

class _ProductShimmerCardState extends State<_ProductShimmerCard>
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: _anim.value),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 12,
                      width: 100,
                      color: Colors.grey.withValues(alpha: _anim.value)),
                  const SizedBox(height: 6),
                  Container(
                      height: 10,
                      width: 70,
                      color: Colors.grey.withValues(alpha: _anim.value * 0.7)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Products Error/Empty States ───────────────────────────────────────────────

class _ProductsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProductsErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('Failed to load products',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 6),
            Text('Login required to view the catalogue.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsEmptyState extends StatelessWidget {
  const _ProductsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.water_drop_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text('No products available',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            SizedBox(height: 6),
            Text('This source has no water products yet.',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ── Meta Chip Helper ──────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

