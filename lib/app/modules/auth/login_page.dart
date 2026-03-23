import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../widgets/common_button.dart';
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
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (next is AuthError) {
        _showSnackBar(next.message, backgroundColor: Colors.red);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Premium Branding ──
            Stack(
              children: [
                SizedBox(
                  height: 340,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          AppImages.splashBg,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppImages.difwaLogoPng,
                              width: 180,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Verification Form ──
            Container(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your registered email or phone number and password to login.',
                    style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 38),

                  InputField(
                    controller: _identifierController,
                    label: 'Email / Phone Number',
                    hintText: 'user@example.com or 5000000000',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

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
                      onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                      child: const Text('Forgot Password?', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  CommonButton(
                    text: 'Login',
                    onPressed: _handleLogin,
                    backgroundColor: AppColors.primary,
                    borderRadius: 16,
                    isLoading: isLoading,
                  ),

                  const SizedBox(height: 32),

                  // Sign Up Link
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "New to Difwa Water?",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.signup),
                          child: const Text(
                            'Join Now / Signup',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
