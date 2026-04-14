import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import '../../../data/services/db_service.dart';
import '../widgets/home_header.dart';
import '../../../data/services/wallet_service.dart';
import '../widgets/home_banner.dart';
import '../widgets/restaurant_list_section.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/shop_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF7F8FA),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(shopsListProvider.notifier).refresh();
              CartProviderScope.of(context).loadAddresses();
              CartProviderScope.of(context).syncWallet();
              ref.invalidate(walletBalanceProvider);
              ref.invalidate(walletHistoryProvider);
            },
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).padding.top,
                    color: const Color(
                        0xFFF7F8FA), // Light grey blending with header
                  ),
                ),

                // Header: Location & Search
                const SliverToBoxAdapter(child: HomeHeader()),

                // Banner (Horizontal Scrolling Carousel)
                const SliverToBoxAdapter(child: HomeBanner()),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Restaurants Section
                const SliverToBoxAdapter(child: RestaurantListSection()),

                // Footer
                const SliverToBoxAdapter(child: AnimatedFooterText()),

                // Bottom Spacing for Navigation Bar
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedFooterText extends StatefulWidget {
  const AnimatedFooterText({super.key});

  @override
  State<AnimatedFooterText> createState() => _AnimatedFooterTextState();
}

class _AnimatedFooterTextState extends State<AnimatedFooterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 129),
      child: Text(
        'With love,\nfrom Difwa.',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: Color(0xFFB4B4B4),
          height: 1.1,
          letterSpacing: -1.5,
        ),
      ),
    );
  }
}
