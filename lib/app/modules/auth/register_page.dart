import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_images.dart';
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
      backgroundColor: const Color(0xFFE0F7FA), // Soft water-like cyan
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Top Spacing ──
            const SizedBox(height: 60),

            // ── Form section ──
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 80,
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
                      width: 140,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Create Account',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Fill in your details below to get started.',
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFF64748B), height: 1.5),
                  ),
                  const SizedBox(height: 38),

                  InputField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    hintText: 'e.g. John Doe',
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 24),

                  InputField(
                    controller: _emailController,
                    label: 'Email Address',
                    hintText: 'user@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),

                  InputField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hintText: '5000000000',
                    prefixIcon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),

                  InputField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: '••••••••',
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 24),

                  InputField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hintText: '••••••••',
                    isPassword: true,
                    prefixIcon: Icons.lock_clock_outlined,
                  ),
                  const SizedBox(height: 48),

                  // Gradient Button
                  GestureDetector(
                    onTap: isLoading ? null : _handleGetStarted,
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
                                'Sign Up & Verify',
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
                  
                  // Login Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xFF06B6D4),
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
                        Icon(Icons.shield_outlined, size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 6),
                        Text(
                          'Your data is secure and private',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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
    ));
  }
}
