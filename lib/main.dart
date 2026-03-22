import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/cart_service.dart';
import 'app/data/services/wallet_service.dart';
import 'app/data/services/address_service.dart';
import 'app/data/services/shop_service.dart';
import 'app/data/services/order_service.dart';
import 'app/data/services/db_service.dart';
import 'app/core/theme/app_theme.dart';

// Use a standard Provider and ListenableBuilder for reactivity
final cartProviderManager = Provider<CartProvider>((ref) {
  return CartProvider(
    service: ref.watch(cartServiceProvider),
    walletService: ref.watch(walletServiceProvider),
    addressService: ref.watch(addressServiceProvider),
    shopService: ref.watch(shopServiceProvider),
    orderService: ref.watch(orderServiceProvider),
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: Could not load .env file: $e");
  }

  runApp(
    const ProviderScope(
      child: DifwaWaterApp(),
    ),
  );
}

class DifwaWaterApp extends ConsumerWidget {
  const DifwaWaterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the instance of CartProvider
    final cartProvider = ref.watch(cartProviderManager);

    // ListenableBuilder ensures we react to notifyListeners() calls
    return ListenableBuilder(
      listenable: cartProvider,
      builder: (context, _) {
        return CartProviderScope(
          provider: cartProvider,
          child: MaterialApp(
            title: 'Difwa Water',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            routes: AppPages.routes,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
            ),
          ),
        );
      },
    );
  }
}
