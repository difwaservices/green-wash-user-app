import 'package:flutter/material.dart';
import '../../../core/utils/app_logger.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 16,
        left: 20,
        right: 12, // slightly less right padding for the icon button
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Image.asset('assets/images/app_logo.png', height: 45),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Icon
              IconButton(
                onPressed: () {
                  AppLogger.info('Search icon clicked from HomeHeader');
                  Navigator.pushNamed(context, '/search');
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9), // Light greyish bg for contrast
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF475569), // Slate grey icon
                    size: 24,
                  ),
                ),
              ),
              // Profile Icon
              IconButton(
                onPressed: () {
                  AppLogger.info('Profile icon clicked from HomeHeader');
                  Navigator.pushNamed(context,
                      '/profile'); // Using string directly to avoid import issues or import AppRoutes if preferred
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9), // Light green bg
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF2E7D32), // Vibrant green icon
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
