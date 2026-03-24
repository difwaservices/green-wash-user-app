import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_images.dart';
import 'provider/auth_provider.dart';
import 'widgets/input_field.dart';
import '../../routes/app_routes.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.black87}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    if (identifier.isEmpty) {
      _showSnackBar('Please enter your email or phone number.', backgroundColor: Colors.red);
      return;
    }
    if (password.isEmpty) {
      _showSnackBar('Please enter your password.', backgroundColor: Colors.red);
      return;
    }

    try {
      await ref.read(authProvider.notifier).login(
        identifier: identifier,
        password: password,
      );
    } catch (e) {
      _showSnackBar('Login failed. Please try again.', backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    // Listen for auth state changes
    ref.listen<ProviderAuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        final role = (next.user.role).toLowerCase();
        if (role.contains('rider') || role.contains('delivery') || role.contains('driver')) {
          Navigator.pushReplacementNamed(context, AppRoutes.riderHome);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else if (next is AuthError) {
        _showSnackBar(next.message, backgroundColor: Colors.red);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Soft water-like cyan
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Top Spacing ──
            const SizedBox(height: 60),

            // ── Verification Form ──
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 120,
              ),
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo inside card
                  Center(
                    child: Image.asset(
                      AppImages.difwaLogoPng,
                      width: 160,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your registered email or phone number and password to login.',
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFF64748B), height: 1.5),
                  ),
                  const SizedBox(height: 38),

                  InputField(
                    controller: _identifierController,
                    label: 'Email / Phone Number',
                    hintText: 'user@example.com or 5000000000',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 24),

                  InputField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: '••••••••',
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.forgotPassword),
                      child: const Text('Forgot Password?',
                          style: TextStyle(
                              color: Color(0xFF06B6D4),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Gradient Login Button
                  GestureDetector(
                    onTap: isLoading ? null : _handleLogin,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF006064), Color(0xFF00ACC1)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00ACC1).withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),



                  // Sign Up Link
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "New to Difwa Water?",
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.signup),
                          child: const Text(
                            'Join Now / Signup',
                            style: TextStyle(
                              color: Color(0xFF06B6D4),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
