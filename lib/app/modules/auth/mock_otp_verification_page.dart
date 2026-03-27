import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../../routes/app_routes.dart';
import 'provider/auth_provider.dart';

class MockOtpVerificationPage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String initialOtp;

  const MockOtpVerificationPage({
    super.key,
    required this.phoneNumber,
    this.initialOtp = '',
  });

  @override
  ConsumerState<MockOtpVerificationPage> createState() =>
      _MockOtpVerificationPageState();
}

class _MockOtpVerificationPageState
    extends ConsumerState<MockOtpVerificationPage> {
  int _resendTimer = 30;
  bool _isVerifying = false;
  final int _otpLength = 6;
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Show OTP in SnackBar for 25 seconds for testing visibility
    if (widget.initialOtp.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Test OTP: ${widget.initialOtp}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            duration: const Duration(seconds: 25),
            backgroundColor: const Color(0xFF06B6D4),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
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
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _resendOtp() async {
    if (_resendTimer > 0) return;

    setState(() {
      _resendTimer = 30;
      _pinController.clear();
    });
    _startTimer();

    try {
      final notifier = ref.read(authProvider.notifier);
      await notifier.sendOtp(phoneNumber: widget.phoneNumber);

      final state = ref.read(authProvider);
      if (state is AuthSuccess) {
        _showSnackBar('A new OTP has been sent to ${widget.phoneNumber}',
            backgroundColor: const Color(0xFF06B6D4));
        if (state.otp != null) {
          _showSnackBar('Test OTP: ${state.otp}', duration: 25);
        }
      } else if (state is AuthError) {
        _showSnackBar(state.message, backgroundColor: Colors.red);
      }
    } catch (e) {
      _showSnackBar('Failed to resend OTP. Please try again.',
          backgroundColor: Colors.red);
    }
  }

  Future<void> _verifyOtp(String otp) async {
    if (otp.length < _otpLength) return;

    setState(() => _isVerifying = true);

    try {
      final notifier = ref.read(authProvider.notifier);
      await notifier.verifyOtp(
        phoneNumber: widget.phoneNumber,
        otp: otp,
      );

      final state = ref.read(authProvider);
      if (state is AuthAuthenticated) {
        if (!mounted) return;
        _showSnackBar('Verification successful!',
            backgroundColor: Colors.green);
        if (state.user?.role == "rider") {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.riderHome, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.home, (route) => false);
        }
      } else if (state is AuthError) {
        _showSnackBar(state.message, backgroundColor: Colors.red);
        _pinController.clear();
      }
    } catch (e) {
      _showSnackBar('An error occurred during verification.',
          backgroundColor: Colors.red);
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  void _showSnackBar(String message,
      {Color backgroundColor = Colors.black87, int duration = 3}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: duration),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF8FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFF06B6D4), width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Soft water-like cyan
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
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
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100,
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
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            height: 1.5),
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
                    Pinput(
                      length: _otpLength,
                      controller: _pinController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      onCompleted: _verifyOtp,
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _resendTimer > 0
                              ? "Resend code in "
                              : "Didn't receive the code? ",
                          style: const TextStyle(
                              color: Color(0xFF64748B), fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: _resendOtp,
                          child: Text(
                            _resendTimer > 0
                                ? "00:${_resendTimer.toString().padLeft(2, '0')}"
                                : 'Resend Now',
                            style: TextStyle(
                              color: _resendTimer > 0
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
                    GestureDetector(
                      onTap: _isVerifying
                          ? null
                          : () => _verifyOtp(_pinController.text),
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
                              color: const Color(0xFF00ACC1)
                                  .withValues(alpha: 0.3),
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
