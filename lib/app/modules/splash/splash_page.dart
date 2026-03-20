import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../routes/app_routes.dart';
import '../../data/services/db_service.dart';
import '../../data/models/food_models.dart';
import '../../core/constants/app_images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../home/view/main_page.dart';
import '../auth/provider/auth_provider.dart';
import '../auth/login_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Bypassed legacy auth check to prevent silent background exceptions
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(authProvider.notifier).init();
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ── SAFE BYPASS NAVIGATION ──
      // Guaranteed to navigate without relying on routes that might be broken or looped.
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()), // Navigate straight to LoginPage
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch state change to navigate immediately if the minimum delay has passed
    // Bypassing auth state listener
    // No more checking auth responses here to avoid app getting frozen.

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Replaced SVG with a solid Icon to definitively solve any flutter_svg silent rendering crashes
                const Icon(
                  Icons.water_drop,
                  size: 150,
                  color: Color(0xFF0EA5E9),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
