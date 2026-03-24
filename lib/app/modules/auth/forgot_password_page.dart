import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider/auth_provider.dart';
import 'widgets/input_field.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  bool _otpSent = false;

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

  Future<void> _sendResetOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showSnackBar('Please enter your phone number',
          backgroundColor: Colors.orange.shade700);
      return;
    }

    await ref.read(authProvider.notifier).forgotPassword(email: phone);

    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState is AuthSuccess) {
      setState(() => _otpSent = true);
      _showSnackBar(authState.message, backgroundColor: Colors.green.shade600);
      ref.read(authProvider.notifier).reset();
    } else if (authState is AuthError) {
      _showSnackBar(authState.message, backgroundColor: Colors.red);
      ref.read(authProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

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

              // ── White form card ──
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100, // Roughly taking up remaining space
                ),
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: _otpSent ? _buildSuccessState() : _buildFormState(isLoading),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Form state ──────────────────────────────────────────────────────────
  Widget _buildFormState(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo or Icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF8FA),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.lock_reset,
              color: Color(0xFF06B6D4),
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 32),

        const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'No worries! Enter your registered phone number and we\'ll send you a verification code to reset your password.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.6),
        ),
        const SizedBox(height: 38),

        // Phone input
        InputField(
          controller: _phoneController,
          label: 'Phone Number',
          hintText: 'Enter your registered phone number',
          prefixIcon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 48),

        // Send reset link gradient button
        GestureDetector(
          onTap: isLoading ? null : _sendResetOtp,
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
                      'Get Verification Code',
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

        // Back to login link
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back, size: 16, color: Color(0xFF06B6D4)),
                const SizedBox(width: 8),
                const Text(
                  'Back to Login',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF06B6D4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Success state (after OTP sent) ──────────────────────────────────────
  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFEDF8FA),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: Color(0xFF06B6D4),
            size: 40,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Code Sent!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'We\'ve sent a verification code to your phone number. Please enter it to reset your password.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.6),
        ),
        const SizedBox(height: 48),

        // Go to OTP (Simulated for now, usually navigates to a ResetPasswordPage)
        GestureDetector(
          onTap: () {
            _showSnackBar('Transitioning to Reset Password flow...');
          },
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
            child: const Center(
              child: Text(
                'Reset Password',
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
        const SizedBox(height: 24),

        GestureDetector(
          onTap: () => setState(() => _otpSent = false),
          child: const Text(
            'Change number',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF06B6D4),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF06B6D4),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}




