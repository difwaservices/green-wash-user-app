import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/services/shop_service.dart';
import '../../../data/models/banner_model.dart';
import '../view/restaurant_menu_page.dart';
import '../view/product_details_page.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/bounce_widget.dart';

class HomeBanner extends ConsumerStatefulWidget {
  const HomeBanner({super.key});

  @override
  ConsumerState<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends ConsumerState<HomeBanner> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  Future<void> _handleBannerAction(AppBanner banner) async {
    if (banner.actionType == 'none') return;

    if (banner.actionType == 'url') {
      final uri = Uri.parse(banner.actionValue);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return;
    }

    // Show loading indicator for async actions
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      if (banner.actionType == 'shop') {
        final shop = await ref.read(shopServiceProvider).getShopDetails(banner.actionValue);
        if (mounted) Navigator.pop(context); // Remove loader
        if (shop != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RestaurantMenuPage(shop: shop)),
          );
        }
      } else if (banner.actionType == 'product') {
        final product = await ref.read(shopServiceProvider).getProductDetails(banner.actionValue);
        if (mounted) Navigator.pop(context); // Remove loader
        if (product != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailsPage(product: product)),
          );
        }
      } else {
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint('Banner Action Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(bannersProvider);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
              CarouselSlider(
                items: banners.map((banner) {
                  return BounceWidget(
                      onTap: () => _handleBannerAction(banner),
                      scaleFactor: 0.96,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: AspectRatio(
                            aspectRatio: 2 / 1,
                            child: CachedNetworkImage(
                              imageUrl: banner.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.blue.shade50,
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.water_drop, color: AppColors.primary, size: 40),
                                    const SizedBox(height: 8),
                                    Text(
                                      banner.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                }).toList(),
                carouselController: _controller,
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  viewportFraction: 1.0,
                  autoPlay: banners.length > 1,
                  autoPlayInterval: const Duration(seconds: 5),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              if (banners.length > 1) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: banners.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: _current == entry.key ? 20 : 6,
                        decoration: BoxDecoration(
                          color: _current == entry.key
                              ? const Color(0xFF06B6D4)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ).animate().fadeIn(duration: 500.ms, curve: Curves.easeIn);
      },
      loading: () => const _BannerLoader(),
      error: (e, _) => const SizedBox.shrink(), // Or show fallback local banners if needed
    );
  }
}

class _BannerLoader extends StatelessWidget {
  const _BannerLoader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1500.ms);
  }
}
