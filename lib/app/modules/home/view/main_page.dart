import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import '../../cart/view/cart_page.dart';
import '../../profile/view/profile_page.dart';
import '../../subscription/subscription_page.dart';
import '../../wallet/view/wallet_page.dart';
import '../controller/main_controller.dart';
import '../../../data/services/db_service.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/cart_summary_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/state/auth_store.dart';
import '../../../routes/app_routes.dart';
import '../../../data/services/socket_service.dart';
import '../../profile/widgets/review_dialog.dart';
import '../../../../l10n/generated/app_localizations.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  DateTime? _lastPressedAt;

  final List<Widget> _pages = [
    const HomePage(),
    const SubscriptionPage(), // Index 1: Daily
    const CartPage(), // Index 2: Central FAB
    const WalletPage(), // Index 3
    const ProfilePage(), // Index 4
  ];

  @override
  void initState() {
    super.initState();
    // Initial cart sync from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CartProviderScope.of(context).loadCartFromApi();
      _setupSocketListeners();
    });
  }

  void _setupSocketListeners() {
    final socket = ref.read(socketServiceProvider);
    final user = ref.read(currentUserProvider);

    if (user != null) {
      socket.joinUserRoom(user.id);
    }

    socket.onOrderDelivered((data) {
      if (!mounted) return;

      final orderId = data['orderId']?.toString() ?? '';
      final products = data['products'] as List? ?? [];

      if (orderId.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ReviewDialog(
            orderId: orderId,
            items: products
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList(),
            retailerId: products.isNotEmpty
                ? (products[0] as Map)['retailer']?.toString() ?? ''
                : '',
            isOrderReview: true,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    final socket = ref.read(socketServiceProvider);
    final user = ref.read(currentUserProvider);
    if (user != null) {
      socket.leaveUserRoom(user.id);
    }
    socket.offOrderDelivered();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentIndex = ref.watch(mainIndexProvider);
    final cart = CartProviderScope.of(context);
    final bool showSummary =
        cart.itemCount > 0 && currentIndex != 2; // 2 is CartPage

    ref.listen(isAuthenticatedProvider, (previous, next) {
      if (next == false) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.login, (route) => false);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        if (currentIndex != 0) {
          ref.read(mainIndexProvider.notifier).setIndex(0);
          return;
        }

        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Press back again to exit the app.',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              backgroundColor: Color(0xFF0891B2),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          );
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        extendBody: true,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: IndexedStack(
                  index: currentIndex,
                  children: _pages,
                ),
              ),
              if (showSummary)
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 95,
                  left: 0,
                  right: 0,
                  child: CartSummaryBar(cart: cart),
                ),
            ],
          ),
        ),
        bottomNavigationBar: _buildCustomBottomBar(currentIndex),
      ),
    );
  }

  Widget _buildCustomBottomBar(int currentIndex) {
    final l10n = AppLocalizations.of(context);
    bool isCartSelected = currentIndex == 2;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: _buildNavItem(currentIndex, 0, Icons.home_filled, l10n.navHome),
                  ),
                  Expanded(
                    child: _buildNavItem(currentIndex, 1, Icons.local_shipping_rounded, l10n.subscription),
                  ),
                  const SizedBox(width: 80), // Space for the FAB
                  Expanded(
                    child: _buildNavItem(currentIndex, 3, Icons.wallet_rounded, l10n.wallet),
                  ),
                  Expanded(
                    child: _buildNavItem(currentIndex, 4, Icons.person_rounded, l10n.profile),
                  ),
                ],
              ),
              Positioned(
                top: -30,
                child: GestureDetector(
                  onTap: () {
                    ref.read(mainIndexProvider.notifier).setIndex(2);
                  },
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF06B6D4).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.white,
                      size: 28,
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

  Widget _buildNavItem(
      int currentIndex, int index, IconData icon, String label) {
    bool isSelected = currentIndex == index;
    final Color color = isSelected ? const Color(0xFF06B6D4) : const Color(0xFF94A3B8);
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.read(mainIndexProvider.notifier).setIndex(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
