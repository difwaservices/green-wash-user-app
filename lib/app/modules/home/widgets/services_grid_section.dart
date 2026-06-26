import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../view/service_detail_page.dart';

class ServicesGridSection extends StatelessWidget {
  const ServicesGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Professional Care',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get Every Service Very Easily',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: const [
              _ServiceCard(title: 'WASH & FOLD', icon: Icons.local_laundry_service),
              _ServiceCard(title: 'WASH & IRON', icon: Icons.iron),
              _ServiceCard(title: 'DRY CLEAN', icon: Icons.dry_cleaning),
              _ServiceCard(title: 'STARCHING', icon: Icons.waves),
              _ServiceCard(title: 'STEAM PRESS', icon: Icons.air),
              _ServiceCard(title: 'PREMIUM LAUNDRY', icon: Icons.star_border),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ServiceCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ServiceDetailPage(serviceName: title)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: AppColors.primaryLight.withValues(alpha: 0.3),
              child: Icon(icon, size: 24, color: AppColors.primary),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      letterSpacing: 0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, size: 10, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
