import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../../../routes/app_routes.dart';

class OrderSuccessPage extends StatefulWidget {
  final Map<String, dynamic>? order;
  const OrderSuccessPage({super.key, this.order});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  late ConfettiController _confettiController;
  Map<String, dynamic>? _order;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _confettiController.play();
        HapticFeedback.heavyImpact();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _order = widget.order ??
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String? get _orderId {
    final id = _order?['_id'] ?? _order?['id'] ?? _order?['orderId'];
    if (id == null) return null;
    final s = id.toString();
    return s.length > 8 ? '#${s.substring(s.length - 8).toUpperCase()}' : '#$s';
  }

  @override
  Widget build(BuildContext context) {
    final orderId = _orderId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.home, (route) => false);
          },
        ),
        title: const Text(
          'Order Placed',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Success Icon
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCFFAFE),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xFF06B6D4),
                    size: 80,
                  ),
                )
                    .animate()
                    .scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                        begin: const Offset(0.3, 0.3))
                    .fadeIn(duration: 400.ms)
                    .shake(delay: 600.ms, duration: 400.ms),
                const SizedBox(height: 32),
                const Text(
                  'Your order was\nplaced successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 12),
                if (orderId != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Order $orderId',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0E7490),
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 12),
                const Text(
                  'You will get a response within\na few minutes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 3),
                // Track Order Button (only when we have order ID)
                if (_order != null) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(
                          context,
                          AppRoutes.trackOrder,
                          arguments: {
                            'orderId': _order!['_id'] ?? _order!['id'] ?? '',
                            'status': _order!['status'],
                            'deliveryAddressStr':
                                _order!['deliveryAddress']?.toString(),
                          },
                        );
                      },
                      icon: const Icon(Icons.local_shipping_outlined,
                          color: Color(0xFF06B6D4)),
                      label: const Text(
                        'Track Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF06B6D4),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF06B6D4), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                // Go to Home Page Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.home, (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06B6D4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Go to Home Page',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Confetti Overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: const [
                Color(0xFF06B6D4),
                Color(0xFF0E7490),
                Color(0xFFFFD700),
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }
}


