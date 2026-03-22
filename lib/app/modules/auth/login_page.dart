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
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
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

  // ── Send OTP action ───────────────────────────────────────────────────────

  Future<void> _handleSendOtp() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      _showSnackBar('Please enter a valid phone number.', backgroundColor: Colors.red);
      return;
    }

    try {
      await ref.read(authProvider.notifier).sendOtp(phoneNumber: phone);
    } catch (e) {
      _showSnackBar('Failed to send OTP. Please try again.', backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    // Listen for auth state changes
    ref.listen<ProviderAuthState>(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        // Success moves to OTP verification
        Navigator.pushNamed(
          context,
          AppRoutes.otp,
          arguments: {
            'phoneNumber': _phoneController.text.trim(),
            'otp': next.otp, // Pass OTP for auto-verification if provided
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
                    'Enter your registered phone number to verify your identity.',
                    style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 48),

                  InputField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hintText: '2000000000',
                    prefixIcon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 40),

                  // Send OTP Button
                  CommonButton(
                    text: 'Request OTP',
                    onPressed: _handleSendOtp,
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
