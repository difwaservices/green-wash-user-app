import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_images.dart';
import 'widgets/input_field.dart';
import '../../routes/app_routes.dart';
import '../../../../core/state/auth_store.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/generated/app_localizations.dart';

class MobileLoginPage extends ConsumerStatefulWidget {
  const MobileLoginPage({super.key});

  @override
  ConsumerState<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends ConsumerState<MobileLoginPage> {
  final _phoneController = TextEditingController();
  bool _isSubmitting = false;

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

  Future<void> _handleContinue(AppLocalizations l10n) async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      _showSnackBar(l10n.pleaseEnterMobileNumber, backgroundColor: Colors.red);
      return;
    }
    
    // 10-digit mobile number validation (Starts with 6-9)
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!phoneRegex.hasMatch(phone)) {
      _showSnackBar(l10n.enterValidMobileNumber, backgroundColor: Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // ── SEND REAL OTP ──
      // This calls the backend API to send an OTP
      await ref.read(authStoreProvider.notifier).sendOtp(phoneNumber: phone);
      
      final state = ref.read(authStoreProvider);
      if (state is AuthOtpSent) {
        if (!mounted) return;
        Navigator.pushNamed(
          context, 
          AppRoutes.otp, 
          arguments: {
            'phoneNumber': phone,
            'otp': state.otp, 
          }
        );
      } else if (state is AuthError) {
        _showSnackBar(state.message, backgroundColor: Colors.red);
      } else {
        _showSnackBar(l10n.failedToSendOtp, backgroundColor: Colors.red);
      }
    } catch (e) {
      _showSnackBar(l10n.anErrorOccurred, backgroundColor: Colors.red);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Dynamic top spacing
              SizedBox(height: isSmallScreen ? 30 : 60),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  // Ensures the container takes at least the remaining screen height
                  minHeight: screenSize.height - (isSmallScreen ? 80 : 120),
                ),
                padding: EdgeInsets.fromLTRB(28, isSmallScreen ? 25 : 40, 28, 40),
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
                    Center(
                      child: Image.asset(
                        AppImages.difwaLogoPng,
                        width: isSmallScreen ? 120 : 160,
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
                    SizedBox(height: isSmallScreen ? 20 : 32),
                    Text(
                      l10n.loginWithMobileNumber,
                      style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E293B)),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
                    const SizedBox(height: 10),
                    Text(
                      l10n.enterMobileDescription,
                      style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14, 
                          color: const Color(0xFF64748B), 
                          height: 1.5),
                    ).animate().fadeIn(delay: 400.ms),
                    SizedBox(height: isSmallScreen ? 25 : 38),
                    InputField(
                      controller: _phoneController,
                      label: l10n.mobileNumber,
                      hintText: l10n.mobileHint,
                      prefixIcon: Icons.phone_android,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                    SizedBox(height: isSmallScreen ? 24 : 32),
                    GestureDetector(
                      onTap: _isSubmitting ? null : () => _handleContinue(l10n),
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
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isSubmitting 
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              l10n.sendOtp,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 30 : 40),
                    Center(
                      child: Text(
                        l10n.secureLoginText,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
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
