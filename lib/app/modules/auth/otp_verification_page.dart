import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_colors.dart';
import 'provider/auth_provider.dart';
import '../../data/models/food_models.dart';
import '../../data/services/db_service.dart';
import '../../routes/app_routes.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/generated/app_localizations.dart';

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

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage>
    with TickerProviderStateMixin {
  // â”€â”€ Controllers & Focus â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  // â”€â”€ State â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  int _resendTimer = 30;
  bool _isVerifying = false;
  bool _isSendingOtp = false;
  final int _otpLength = 6;

  // track which box is "filled" for animation
  final List<bool> _filled = List.generate(6, (_) => false);

  // â”€â”€ Animation Controllers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late AnimationController _fadeCtrl;
  late AnimationController _slideCtrl;
  late AnimationController _shakeCtrl;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();

    // Page entrance
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));

    _fadeCtrl.forward();
    _slideCtrl.forward();

    _startTimer();

    // Show test OTP
    if (widget.otp != null && widget.otp!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOtpSnackBar(widget.otp!);
      });
    }
  }

// hbhg btrxsdcfvgbhjnmkjnhgvfdrersxtdrcgbhjn
  void _showOtpSnackBar(String otp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test OTP: $otp',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 200,
          left: 20,
          right: 20,
        ),
        action: SnackBarAction(
          label: 'Auto Fill',
          textColor: Colors.white,
          onPressed: () {
            _pinController.text = otp;
            _verifyOtp();
          },
        ),
      ),
    );
  }

  // Pinput handles most logic now.
  // Normalizing old methods to avoid breakages if called elsewhere.
  void _fillOtp(String digits) {
    _pinController.text = digits;
    if (digits.length == _otpLength) {
      _verifyOtp();
    }
  }

  void _onDigitChanged(int index, String value) {}
  bool _handleKeyEvent(int index, KeyEvent event) => false;

  // â”€â”€ Timer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() => _resendTimer--);
        _startTimer();
      }
    });
  }

  // â”€â”€ Network actions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _sendOtp() async {
    if (_isSendingOtp) return;
    setState(() => _isSendingOtp = true);
    try {
      await ref
          .read(authProvider.notifier)
          .sendOtp(phoneNumber: widget.phoneNumber);
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _isSendingOtp = false;
      _resendTimer = 30;
    });
    _startTimer();
  }

  Future<void> _verifyOtp() async {
    if (_isVerifying) return;

    final otp = _pinController.text;
    if (otp.length < _otpLength) {
      _shakeCtrl.forward(from: 0);
      _showSnackBar('Please enter the complete 6-digit OTP.',
          backgroundColor: Colors.orange.shade700);
      return;
    }

    setState(() => _isVerifying = true);
    try {
      await ref.read(authProvider.notifier).verifyOtp(
            phoneNumber: widget.phoneNumber,
            otp: otp,
          );
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        String errMsg = e.toString();
        if (errMsg.toLowerCase().contains('invalid') || errMsg.toLowerCase().contains('wrong')) {
          errMsg = l10n.invalidOtp;
        } else if (errMsg.toLowerCase().contains('expired')) {
          errMsg = l10n.otpExpired;
        }
        _showSnackBar(errMsg, backgroundColor: Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.black87}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _shakeCtrl.dispose();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  // â”€â”€ Build â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 600;

    ref.listen<ProviderAuthState>(authProvider, (previous, next) {
      if (next is AuthOtpSent && next.otp != null) {
        _showOtpSnackBar(next.otp!);
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
          cartProvider.syncLocalCartToServer();
          cartProvider.syncOrders();
          cartProvider.syncWallet();
          cartProvider.loadAddresses();
        } catch (_) {}

        if (role.contains('rider') ||
            role.contains('delivery') ||
            role.contains('driver') ||
            role.contains('staff')) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.riderHome, (r) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.home, (r) => false);
        }
      } else if (next is AuthError) {
        if (mounted) {
          _shakeCtrl.forward(from: 0);
          _showSnackBar(next.message, backgroundColor: Colors.red);
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // â”€â”€ Back button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF2E7D32),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // â”€â”€ White card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: screenSize.height,
                    ),
                    padding: EdgeInsets.fromLTRB(
                        28, isSmallScreen ? 10 : 20, 28, 40),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Key icon
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF8FA),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.vpn_key_outlined,
                            size: 44,
                            color: Color(0xFF2E7D32),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(curve: Curves.elasticOut),
                        const SizedBox(height: 32),

                        Text(
                          l10n.otpVerification,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 22 : 28,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1E293B),
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                        const SizedBox(height: 12),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '${l10n.enterOtpSentTo}\n',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                height: 1.5),
                            children: [
                              TextSpan(
                                text: widget.phoneNumber,
                                style: const TextStyle(
                                  color: Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 12),

                        const SizedBox(height: 36),

                        // â”€â”€ OTP boxes â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                        if (_isSendingOtp)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(
                                color: Color(0xFF2E7D32)),
                          )
                        else
                          Pinput(
                            length: _otpLength,
                            controller: _pinController,
                            focusNode: _pinFocusNode,
                            onCompleted: (_) => _verifyOtp(),
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsUserConsentApi,
                            defaultPinTheme: PinTheme(
                              width: 50,
                              height: 56,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF8FA),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF2E7D32)
                                      .withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 50,
                              height: 56,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: const Color(0xFF2E7D32), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            submittedPinTheme: PinTheme(
                              width: 50,
                              height: 56,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: const Color(0xFF2E7D32)),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            showCursor: true,
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  width: 20,
                                  height: 2,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 400.ms).scale(
                              begin: const Offset(0.9, 0.9),
                              curve: Curves.easeOutBack),

                        const SizedBox(height: 40),

                        // â”€â”€ Resend timer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_resendTimer > 0)
                              Text(
                                l10n.resendIn(_resendTimer),
                                style: const TextStyle(
                                    color: Color(0xFF64748B), fontSize: 13),
                              )
                            else ...[
                              const Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                    color: Color(0xFF64748B), fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: _isSendingOtp ? null : _sendOtp,
                                child: Text(
                                  l10n.resendOtp,
                                  style: const TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 48),

                        // â”€â”€ Verify button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                        AnimatedScale(
                          scale: _isVerifying ? 0.97 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: GestureDetector(
                            onTap: _isVerifying ? null : () => _verifyOtp(),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: _isVerifying
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.iconBgStart.withValues(alpha: 0.6),
                                          AppColors.iconBgEnd.withValues(alpha: 0.6),
                                        ],
                                      )
                                    : AppColors.buttonBgGradient,
                                boxShadow: _isVerifying
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Center(
                                child: _isVerifying
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5),
                                      )
                                    : Text(
                                        l10n.verify,
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
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'By proceeding, you agree to our Terms of Service\nand Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
