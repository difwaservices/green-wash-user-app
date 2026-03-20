import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/db_service.dart';
import 'app/data/services/cart_service.dart';
import 'app/data/services/wallet_service.dart';
import 'app/data/services/address_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/services/location_tracking_service.dart';
import 'app/data/services/notification_service.dart';
import 'app/data/services/fcm_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

void main() {
  runApp(
    // ProviderScope is required at the root so Riverpod providers are available
    // throughout the entire widget tree.
    const ProviderScope(
      child: DifwabiteApp(),
    ),
  );
}

class DifwabiteApp extends ConsumerWidget {
  const DifwabiteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartService = ref.watch(cartServiceProvider);
    final walletService = ref.watch(walletServiceProvider);
    final addressService = ref.watch(addressServiceProvider);

    return CartProviderScope(
      provider: CartProvider(
        service: cartService,
        walletService: walletService,
        addressService: addressService,
      ),
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
  }
}
