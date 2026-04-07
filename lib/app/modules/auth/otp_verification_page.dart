import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_images.dart';
import 'provider/auth_provider.dart';
import '../../data/models/food_models.dart';
import '../../data/services/db_service.dart';
import '../../data/services/fcm_service.dart';
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
    // Show initial OTP from navigation arguments
    if (widget.otp != null && widget.otp!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSnackBar("Test OTP: ${widget.otp}",
            backgroundColor: const Color(0xFF06B6D4));
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

    if (!mounted) return;
    setState(() => _isVerifying = true);

    await ref.read(authProvider.notifier).verifyOtp(
          phoneNumber: widget.phoneNumber,
          otp: otp,
        );

    if (!mounted) return;
    setState(() => _isVerifying = false);
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
    ref.listen<ProviderAuthState>(authProvider, (previous, next) {
      if (next is AuthOtpSent && next.otp != null) {
        _showSnackBar("New OTP: ${next.otp}",
            backgroundColor: const Color(0xFF06B6D4));
      } else if (next is AuthAuthenticated) {
        final role = (next.user.role).toLowerCase();
        
        try {
          final cartProvider = CartProviderScope.of(context);
          cartProvider.updateUserProfile(
            UserProfile(
              name: next.user.fullName,
              email: next.user.email,
              phone: next.user.phoneNumber,
              profileImage: AppImages.defaultAvatar,
            ),
          );
          cartProvider.loadCartFromApi();
          cartProvider.syncWallet();
          cartProvider.loadAddresses();
        } catch (e) {
          // Silent catch in production
        }

        // ── ROLE-BASED NAVIGATION ──
        
        if (role.contains('rider') || 
            role.contains('delivery') || 
            role.contains('driver') ||
            role.contains('staff')) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.riderHome, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
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
              // ── Header Empty space + Back Button ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF06B6D4),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // ── White Card Form ──
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100, // Remaining space
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon Logo
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF8FA),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.vpn_key_outlined,
                        size: 44,
                        color: Color(0xFF06B6D4),
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Enter 6-Digit Code',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Code has been sent to \n',
                        style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
                        children: [
                          TextSpan(
                            text: widget.phoneNumber,
                            style: const TextStyle(
                              color: Color(0xFF06B6D4),
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
                          child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
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
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDF8FA), // Light cyan bg
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: Colors.white, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 2),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
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
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: (_isSendingOtp || _resendTimer > 0) ? null : _sendOtp,
                          child: Text(
                            _resendTimer > 0 ? "00:${_resendTimer.toString().padLeft(2, '0')}" : 'Resend Now',
                            style: TextStyle(
                              color: (_isSendingOtp || _resendTimer > 0)
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF06B6D4),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // ── Confirm Gradient Button ───────────────────────────────────────────
                    GestureDetector(
                      onTap: _isVerifying ? null : _verifyOtp,
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
                          child: _isVerifying
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Text(
                                  'Verify & Proceed',
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
                    
                    const Text(
                      'By proceeding, you agree to our Terms of Service\nand Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
