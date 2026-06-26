import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/auth_store.dart';
import '../../routes/app_routes.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();

    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // 3-second cap â€” cached users finish instantly, others don't wait all day.
      await ref
          .read(authStoreProvider.notifier)
          .init()
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // Timeout or error â€” navigate with whatever state we already have.
    }

    if (!mounted) return;

    // Ensure animation finishes before navigating
    if (_animationController.isAnimating) {
      await _animationController.forward();
    }

    // Additional tiny delay for smooth visual transition
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;
    _navigate();
  }

  void _navigate() {
    final authState = ref.read(authStoreProvider);

    if (authState is AuthAuthenticated) {
      final role = authState.user.role.toLowerCase();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: 250,
                  errorBuilder: (context, error, stackTrace) => Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                        ),
                        child: const Icon(Icons.local_laundry_service,
                            size: 100, color: Color(0xFF2E7D32)),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Animated Text
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const Text(
                      'GREEN WASH CO.',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'GREEN FROM THE START, CLEAN TO THE HEART.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Loading Indicator
                    const SizedBox(
                      width: 35,
                      height: 35,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
