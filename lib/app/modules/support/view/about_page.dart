import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'About Difwa',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF00ACC1).withValues(alpha: 0.1),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Section
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00ACC1).withValues(alpha: 0.05),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/logos/app_logo.png',
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.water_drop_rounded,
                      size: 70,
                      color: Color(0xFF06B6D4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Main Intro Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF00ACC1).withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Difwa Services',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Difwa is your trusted partner for pure and fresh water delivery. We bridge the gap between water plants and customers, ensuring that you receive the best quality water at your doorstep with just a few clicks.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF475569),
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Mission & Why Choose Row/List
              _ModernInfoCard(
                title: 'Our Mission',
                content:
                    'To provide accessible, affordable, and high-quality drinking water to every household, promoting health and convenience through technology.',
                icon: Icons.lightbulb_rounded,
                iconColor: Colors.amber,
              ),
              const SizedBox(height: 20),

              _ModernInfoCard(
                title: 'Why Choose Us?',
                content:
                    '• Pure & Certified Water\n• Real-time Tracking\n• Flexible Subscriptions\n• Timely Delivery\n• Secure Payments',
                icon: Icons.verified_user_rounded,
                iconColor: const Color(0xFF06B6D4),
              ),

              const SizedBox(height: 48),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Difwa App',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.4+3',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernInfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;

  const _ModernInfoCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF00ACC1).withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF475569),
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
