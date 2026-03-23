import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common_button.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_colors.dart';
import 'provider/auth_provider.dart';
import '../../data/models/food_models.dart';
import '../../data/services/db_service.dart';
import '../../routes/app_routes.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String? otp;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    this.otp,
  });

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  int _resendTimer = 30;
  bool _isVerifying = false;
  bool _isSendingOtp = false;
  final int _otpLength = 6;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Pre-fill OTP if development mode (provided from registration)
    if (widget.otp != null && widget.otp!.length == _otpLength) {
      for (int i = 0; i < _otpLength; i++) {
        _controllers[i].text = widget.otp![i];
      }
      
      // ── AUTO-VERIFY FEATURE ──
      // If OTP is provided, auto-trigger the verification to save user time
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('[OTP] Auto-verifying from backend code: ${widget.otp}');
        Future.delayed(const Duration(milliseconds: 1500), () => _verifyOtp());
      });
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() => _resendTimer--);
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() => _isSendingOtp = true);
    await ref
        .read(authProvider.notifier)
        .sendOtp(phoneNumber: widget.phoneNumber);
    if (!mounted) return;
    setState(() {
      _isSendingOtp = false;
      _resendTimer = 30;
    });
    _startTimer();
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < _otpLength) {
      _showSnackBar('Please enter the complete 6-digit OTP.',
          backgroundColor: Colors.orange.shade700);
      return;
    }

    setState(() => _isVerifying = true);

    await ref.read(authProvider.notifier).verifyOtp(
          phoneNumber: widget.phoneNumber,
          otp: otp,
        );

    if (!mounted) return;
    setState(() => _isVerifying = false);

    final authState = ref.read(authProvider);

    if (authState is AuthSuccess) {
      debugPrint('[OTP] Verification successful!');
      ref.read(authProvider.notifier).reset();
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
        arguments: {'verified': true},
      );
    } else if (authState is AuthAuthenticated) {
      debugPrint('[OTP] Authentication successful! Navigating home.');

      // Update legacy CartProvider profile (kept for rest of UI compatibility)
      try {
        final cartProvider = CartProviderScope.of(context);
        cartProvider.updateUserProfile(
          UserProfile(
            name: authState.user.fullName,
            email: authState.user.email,
            phone: authState.user.phoneNumber,
            profileImage: AppImages.defaultAvatar,
          ),
        );
        cartProvider.loadCartFromApi();
      } catch (e) {
        debugPrint('Failed to update CartProvider profile: $e');
      }

      debugPrint('[OTP] User role: ${authState.user.role}');
      final role = (authState.user.role).toLowerCase();
      // Broad check to handle various rider roles (e.g., 'rider', 'shop_rider', 'retailer_rider')
      if (role.contains('rider') || role.contains('delivery') || role.contains('driver')) {
        debugPrint('[OTP] Navigating to Rider Dashboard (role: $role)');
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.riderHome, (route) => false);
      } else {
        debugPrint('[OTP] Navigating to Customer Home (role: $role)');
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
      }
    } else if (authState is AuthError) {
      debugPrint('[OTP] Verification failed: ${authState.message}');
      _showSnackBar(authState.message, backgroundColor: Colors.red);
      // ref.read(authProvider.notifier).reset(); // REMOVED: This was causing "Session Expired" on second attempt
    }
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.black87}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Verification',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              
              // Branding Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.vpn_key_outlined,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(height: 32),

              const Text(
                'Enter 6-Digit Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Code has been sent to ',
                  style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // ── 6 OTP boxes ─────────────────────────────────────────────
              if (_isSendingOtp)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_otpLength, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 48,
                      height: 56,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                          fillColor: Colors.grey.shade50,
                          filled: true,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (index < _otpLength - 1) {
                              _focusNodes[index + 1].requestFocus();
                            } else {
                              _focusNodes[index].unfocus();
                            }
                          } else {
                            if (index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                          }
                        },
                      ),
                    );
                  }),
                ),

              const SizedBox(height: 40),

              // ── Resend & Timer ──────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _resendTimer > 0 
                      ? "Resend code in " 
                      : "Didn't receive the code? ",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: (_isSendingOtp || _resendTimer > 0) ? null : _sendOtp,
                    child: Text(
                      _resendTimer > 0 ? "00:${_resendTimer.toString().padLeft(2, '0')}" : 'Resend Now',
                      style: TextStyle(
                        color: (_isSendingOtp || _resendTimer > 0)
                            ? Colors.grey
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // ── Confirm Button ───────────────────────────────────────────
              CommonButton(
                text: 'Verify & Proceed',
                onPressed: _verifyOtp,
                backgroundColor: AppColors.primary,
                borderRadius: 16,
                isLoading: _isVerifying,
              ),

              const SizedBox(height: 32),
              
              const Text(
                'By proceeding, you agree to our Terms of Service\nand Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
