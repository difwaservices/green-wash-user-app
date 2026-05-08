import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import '../../../data/services/db_service.dart';
import '../widgets/home_header.dart';
import '../../../data/services/wallet_service.dart';
import '../widgets/home_banner.dart';
import '../widgets/restaurant_list_section.dart';
import '../widgets/communication_banner.dart';

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
              if (context.mounted) {
                CartProviderScope.of(context).loadAddresses();
                CartProviderScope.of(context).syncWallet();
              }
              ref.invalidate(walletBalanceProvider);
              ref.invalidate(walletHistoryProvider);
            },
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Sticky Header: Location & Search
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  backgroundColor: const Color(0xFFF7F8FA),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 110 + MediaQuery.of(context).padding.top,
                  flexibleSpace: const FlexibleSpaceBar(
                    background: HomeHeader(),
                  ),
                ),

                // Banner (Horizontal Scrolling Carousel)
                const SliverToBoxAdapter(child: HomeBanner()),

                // Communication Hub Banner (Broadcasts)
                const SliverToBoxAdapter(child: CommunicationBanner()),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Restaurants Section
                const SliverToBoxAdapter(child: RestaurantListSection()),

                // Footer
                const SliverToBoxAdapter(child: AnimatedFooterText()),

                // Bottom Spacing for Navigation Bar
                const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
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
  late Animation<int> _characterCount;
  final String _text = 'With love from Difwa.';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _characterCount = IntTween(begin: 0, end: _text.length).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
      child: Center(
        child: AnimatedBuilder(
          animation: _characterCount,
          builder: (context, child) {
            String visibleText = _text.substring(0, _characterCount.value);
            bool showCursor = (_controller.value * 10).toInt() % 2 == 0;

            return Text(
              '$visibleText${showCursor && _characterCount.value < _text.length ? "|" : ""}',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB4B4B4),
                height: 1.2,
                letterSpacing: -0.5,
              ),
            );
          },
        ),
      ),
    );
  }
}
