import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../widgets/common_button.dart';
import 'provider/auth_provider.dart';
import 'widgets/input_field.dart';
import '../../routes/app_routes.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  // ── Register action ───────────────────────────────────────────────────────

  Future<void> _handleGetStarted() async {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (fullName.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields.', backgroundColor: Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match.', backgroundColor: Colors.red);
      return;
    }

    try {
      await ref.read(authProvider.notifier).register(
            fullName: fullName,
            email: email,
            phoneNumber: phone,
            password: password,
            confirmPassword: confirmPassword,
          );
    } catch (e) {
      _showSnackBar('Registration failed. Please try again.', backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    // Listen for auth state changes
    ref.listen<ProviderAuthState>(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        Navigator.pushNamed(
          context,
          AppRoutes.otp,
          arguments: {
            'phoneNumber': _phoneController.text.trim(),
            'otp': next.otp,
          },
        );
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
            // ── Top branding section ──
            Stack(
              children: [
                SizedBox(
                  height: 240,
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
                              width: 140,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Form section ──
            Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 24),

                  InputField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    hintText: 'e.g. Dam',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  InputField(
                    controller: _emailController,
                    label: 'Email Address',
                    hintText: 'dam@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  InputField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hintText: '5000000000',
                    prefixIcon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
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

                  InputField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hintText: '••••••••',
                    isPassword: true,
                    prefixIcon: Icons.lock_clock_outlined,
                  ),
                  const SizedBox(height: 32),

                  CommonButton(
                    text: 'Sign Up & Verify',
                    onPressed: _handleGetStarted,
                    backgroundColor: AppColors.primary,
                    borderRadius: 16,
                    isLoading: isLoading,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Login Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Verification Info
                  const SizedBox(height: 8),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_outlined, size: 14, color: Colors.grey.shade300),
                        const SizedBox(width: 6),
                        Text(
                          'Your data is secure and private',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
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
