import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PremiumClubPage extends StatefulWidget {
  const PremiumClubPage({super.key});

  @override
  State<PremiumClubPage> createState() => _PremiumClubPageState();
}

class _PremiumClubPageState extends State<PremiumClubPage>
    with SingleTickerProviderStateMixin {
  bool _isYearly = false;
  int _selectedPlan = 1; // 0=Free, 1=Pro, 2=Enterprise
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeroSection(context),
              _buildBillingToggle(),
              _buildPlanCards(context),
              _buildFeatureTable(),
              _buildSubscribeButton(context),
              _buildRestoreButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // â”€â”€â”€ HERO â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 380,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF062112), Color(0xFF0A3D1F), Color(0xFF051A0E)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2E7D32).withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF065F46).withOpacity(0.1),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xFF2E7D32),
                            Color(0xFF065F46),
                          ]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'WASH CLUB',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_pulseController.value * 0.05),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF34D399)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.diamond_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Unlock Premium\nWash Experience',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      letterSpacing: 0.3,
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                  const SizedBox(height: 12),
                  Text(
                    'Join 10,000+ happy members enjoying\npriority care for their wardrobe.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // â”€â”€â”€ BILLING TOGGLE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildBillingToggle() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _toggleOption('Monthly', !_isYearly),
          _toggleOption('Yearly  ðŸ”¥ Save 33%', _isYearly),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _toggleOption(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isYearly = label.startsWith('Yearly')),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF065F46)],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // â”€â”€â”€ PLAN CARDS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildPlanCards(BuildContext context) {
    final plans = [
      {
        'name': 'Free',
        'price': 'â‚¹0',
        'period': 'forever',
        'color': const Color(0xFF1E293B),
        'features': ['2 pickups/month', 'Standard processing', 'Basic support'],
      },
      {
        'name': 'Pro',
        'price': _isYearly ? 'â‚¹7,999' : 'â‚¹999',
        'period': _isYearly ? '/year' : '/month',
        'color': const Color(0xFF2E7D32),
        'features': [
          'Unlimited pickups',
          '10% cashback',
          'Priority 24h processing',
          'Premium garment bags',
          'Dedicated support',
        ],
      },
      {
        'name': 'Enterprise',
        'price': _isYearly ? 'â‚¹19,999' : 'â‚¹1,999',
        'period': _isYearly ? '/year' : '/month',
        'color': const Color(0xFF7C3AED),
        'features': [
          'Everything in Pro',
          'Team accounts (5 users)',
          'Invoice billing',
          'SLA guarantee',
          'Account manager',
        ],
      },
    ];

    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        itemCount: plans.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final plan = plans[index];
          final isSelected = _selectedPlan == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedPlan = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 200,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected
                    ? (plan['color'] as Color).withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (plan['color'] as Color)
                      : const Color(0xFFE2E8F0),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              (plan['color'] as Color).withOpacity(0.2),
                          blurRadius: 16,
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 1)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'MOST POPULAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  Text(
                    plan['name'] as String,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        plan['price'] as String,
                        style: TextStyle(
                          color: plan['color'] as Color,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        plan['period'] as String,
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 8),
                  ...(plan['features'] as List<String>).take(3).map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: plan['color'] as Color,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              f,
                              style: const TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  // â”€â”€â”€ FEATURE TABLE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildFeatureTable() {
    final features = [
      {'label': 'Pickups per month', 'free': '2', 'pro': 'âˆž', 'ent': 'âˆž'},
      {'label': 'Cashback', 'free': '0%', 'pro': '10%', 'ent': '15%'},
      {'label': 'Processing time', 'free': '48h', 'pro': '24h', 'ent': '12h'},
      {'label': 'Premium bags', 'free': 'âœ—', 'pro': 'âœ“', 'ent': 'âœ“'},
      {'label': 'Dedicated support', 'free': 'âœ—', 'pro': 'âœ“', 'ent': 'âœ“'},
      {'label': 'Team accounts', 'free': 'âœ—', 'pro': 'âœ—', 'ent': '5 users'},
    ];

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(flex: 3, child: SizedBox()),
                _tableHeader('Free'),
                _tableHeader('Pro', highlight: true),
                _tableHeader('Ent.'),
              ],
            ),
          ),
          const Divider(color: Color(0xFFE2E8F0), height: 1),
          ...features.map((f) => _featureRow(f)).toList(),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _tableHeader(String text, {bool highlight = false}) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: highlight ? const Color(0xFF2E7D32) : const Color(0xFF64748B),
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _featureRow(Map<String, String> feature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              feature['label']!,
              style: const TextStyle(color: Color(0xFF475569), fontSize: 13),
            ),
          ),
          _tableValue(feature['free']!),
          _tableValue(feature['pro']!, highlight: true),
          _tableValue(feature['ent']!),
        ],
      ),
    );
  }

  Widget _tableValue(String value, {bool highlight = false}) {
    final isCheck = value == 'âœ“';
    final isCross = value == 'âœ—';
    return Expanded(
      flex: 2,
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isCross
              ? const Color(0xFFCBD5E1)
              : isCheck || highlight
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFF64748B),
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  // â”€â”€â”€ SUBSCRIBE BUTTON â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildSubscribeButton(BuildContext context) {
    final planNames = ['Free Plan', 'Pro Plan', 'Enterprise Plan'];
    final planPrices = [
      'Get Started Free',
      _isYearly ? 'Subscribe â€” â‚¹7,999/year' : 'Subscribe â€” â‚¹999/month',
      _isYearly
          ? 'Subscribe â€” â‚¹19,999/year'
          : 'Subscribe â€” â‚¹1,999/month',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF065F46)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                splashColor: Colors.white.withOpacity(0.15),
                onTap: () {
                  if (_selectedPlan == 0) {
                    Navigator.pop(context);
                    return;
                  }
                  // TODO: Trigger PurchaseService.instance.buyById(...)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white),
                          const SizedBox(width: 12),
                          Text(
                            '${planNames[_selectedPlan]} selected! Purchase coming soon.',
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF2E7D32),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    planPrices[_selectedPlan],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cancel anytime â€¢ Secure payment â€¢ No hidden fees',
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2);
  }

  // â”€â”€â”€ RESTORE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildRestoreButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: PurchaseService.instance.restorePurchases()
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checking for previous purchases...')),
        );
      },
      child: const Text(
        'Restore Purchases',
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      ),
    ).animate().fadeIn(delay: 700.ms);
  }
}
