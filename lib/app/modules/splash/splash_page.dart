import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/auth_store.dart';
import '../../routes/app_routes.dart';
import '../../core/constants/app_images.dart';
import '../../core/localization/language_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. First-time launch → show language picker before anything else
    final isFirst = await LocaleNotifier.isFirstLaunch();
    if (!mounted) return;
    if (isFirst) {
      Navigator.pushReplacementNamed(context, AppRoutes.firstTimeLanguage);
      return;
    }

    // 2. Perform initialization check via AuthStore
    await ref.read(authStoreProvider.notifier).init();

    if (!mounted) return;

    // 3. Decide navigation based on Auth status
    final authState = ref.read(authStoreProvider);

    if (authState is AuthAuthenticated) {
      final role = (authState.user.role).toLowerCase();

      if (role.contains('rider') ||
          role.contains('delivery') ||
          role.contains('driver') ||
          role.contains('staff')) {
        Navigator.pushReplacementNamed(context, AppRoutes.riderHome);
      } else if (role.contains('retailer') || role.contains('vendor')) {
        Navigator.pushReplacementNamed(context, AppRoutes.retailerHome);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.shrink(),
    );
  }
}
