import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About Difwa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/logos/app_logo.png', errorBuilder: (c, e, s) => const Icon(Icons.water_drop, size: 60, color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Difwa Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 16),
            const Text(
              'Difwa is your trusted partner for pure and fresh water delivery services. We bridge the gap between water plants and customers, ensuring that you receive the best quality water at your doorstep with just a few clicks.',
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 24),
            const _InfoSection(
              title: 'Our Mission',
              content: 'To provide accessible, affordable, and high-quality drinking water to every household and office, promoting health and convenience through technology.',
            ),
            const SizedBox(height: 20),
            const _InfoSection(
              title: 'Why Choose Us?',
              content: '• Pure & Certified Water\n• Real-time Tracking\n• Flexible Subscriptions\n• Timely Delivery\n• Secure Payments',
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Version 1.0.4+3',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String content;

  const _InfoSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.4)),
      ],
    );
  }
}
