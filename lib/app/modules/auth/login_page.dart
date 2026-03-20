import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../routes/app_routes.dart';
import '../../core/constants/app_images.dart';
import '../../data/models/food_models.dart';
import '../../data/services/db_service.dart';
import '../../widgets/common_button.dart';
import 'provider/auth_provider.dart';
import 'widgets/input_field.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_profile_page.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    // Show "verified" toast only when arriving from OTP verification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['verified'] == true) {
        _showSnackBar(
          'User register successful please login',
          backgroundColor: Colors.green.shade600,
          icon: Icons.check_circle,
        );
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _showSnackBar(
    String message, {
    Color backgroundColor = Colors.black87,
    IconData? icon,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Login action ─────────────────────────────────────────────────────────

  Future<void> _login() async {
    // ── AUTH BYPASS (for faster development) ──
    final cartProvider = CartProviderScope.of(context);
    cartProvider.updateUserProfile(
      UserProfile(
        name: 'Difwa User',
        email: 'user@difwa.com',
        phone: _phoneController.text.trim(),
        profileImage: 'assets/images/difwalogo.svg',
      ),
    );
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    return;

    /* Original login code
    final phone = _phoneController.text.trim();
    // ... remaining original code ...
    */
  }

  // ── Google Sign-In action ────────────────────────────────────────────────
  Future<void> _handleGoogleSignIn() async {
    try {
      debugPrint('[GOOGLE AUTH] Sign-in process started...');
      // Cancel any previous sign-in first to avoid stale data
      await _googleSignIn.signOut();

      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        // User cancelled the sign-in
        return;
      }

      // ── LOG GOOGLE SIGN-IN SUCCESS ──────────────────────────────────────────
      debugPrint('');
      debugPrint('╔══════════════════════════════════════════════════════════════╗');
      debugPrint('║              GOOGLE SIGN-IN SUCCESS                          ║');
      debugPrint('╟──────────────────────────────────────────────────────────────╢');
      debugPrint('║  Name  : ${account.displayName?.padRight(44) ?? "N/A"}║');
      debugPrint('║  Email : ${account.email.padRight(44)}║');
      debugPrint('║  ID    : ${account.id.padRight(44)}║');
      debugPrint('╚══════════════════════════════════════════════════════════════╝');
      debugPrint('');
      // ───────────────────────────────────────────────────────────────────────

      // Success! Navigate to the detail page (or perform backend sync)
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GoogleProfilePage(account: account),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('');
      debugPrint('╔══════════════════════════════════════════════════════════════╗');
      debugPrint('║              GOOGLE SIGN-IN FAILED                           ║');
      debugPrint('╟──────────────────────────────────────────────────────────────╢');
      debugPrint('║  Error: ${e.toString().padRight(52)}║');
      debugPrint('╚══════════════════════════════════════════════════════════════╝');
      debugPrint('Stacktrace: $stackTrace');
      debugPrint('');

      if (mounted) {
        _showSnackBar(
          'Google Sign-In Failed: $e',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Login Page Reached! (UI removed for testing)", style: TextStyle(fontSize: 18, color: Colors.black)),
      ),
    );
  }
}
