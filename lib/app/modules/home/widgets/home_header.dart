import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/notification_provider.dart';
import '../../../core/constants/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controller/main_controller.dart';
import '../../../widgets/bounce_widget.dart';
import '../../../routes/app_routes.dart';
import '../../../data/services/db_service.dart';
import '../../profile/view/profile_detail_page.dart';
import '../../../../core/state/auth_store.dart';

class HomeHeader extends ConsumerStatefulWidget {
  const HomeHeader({super.key});

  @override
  ConsumerState<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends ConsumerState<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    final cart = CartProviderScope.of(context);
    final address = cart.selectedAddress;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      decoration: const BoxDecoration(color: Color(0xFFF7F8FA)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Picker Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final isAuth = ref.read(isAuthenticatedProvider);
                    if (!isAuth) {
                      Navigator.pushNamed(context, AppRoutes.login);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ProfileDetailPage(title: 'My Address'),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: AppColors.textPrimary, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            address?.title ?? 'Add Address',
                            style: const TextStyle(
                              fontSize: 14.6,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down, size: 20),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address?.street ?? 'Tap to set your delivery location',
                        style:
                            const TextStyle(fontSize: 10.2, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // Profile Button
              const SizedBox(width: 8),
              BounceWidget(
                onTap: () {
                  final isAuth = ref.read(isAuthenticatedProvider);
                  if (!isAuth) {
                    Navigator.pushNamed(context, AppRoutes.login);
                    return;
                  }
                  MainControllerScope.of(context).changePage(4);
                },
                child: Hero(
                  tag: 'profile_pic',
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Notification Button
              Consumer(
                builder: (context, ref, child) {
                  final unreadCount = ref.watch(unreadNotificationsCountProvider);
                  return BounceWidget(
                    onTap: () {
                      final isAuth = ref.read(isAuthenticatedProvider);
                      if (!isAuth) {
                        Navigator.pushNamed(context, AppRoutes.login);
                        return;
                      }
                      Navigator.pushNamed(context, AppRoutes.notifications);
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.textPrimary),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                              child: Text(
                                unreadCount > 9 ? '9+' : unreadCount.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search Bar Row
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              readOnly: true,
              onTap: () => Navigator.pushNamed(context, AppRoutes.search),
              decoration: InputDecoration(
                hintText: 'Search for water...',
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.1, duration: 400.ms, curve: Curves.easeOut);
  }
}
