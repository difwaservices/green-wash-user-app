import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:difwawaterapp/app/core/utils/auth_helper.dart';
import 'package:difwawaterapp/core/state/auth_store.dart';
import '../../../data/services/auth_service.dart' as auth;
import '../../../data/models/auth_models.dart' as models;
import '../../../routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/notification_provider.dart';

import './edit_profile_page.dart';
import './my_orders_page.dart';
import '../../subscription/view/subscription_dashboard_page.dart';
import '../../home/view/favorites_page.dart';
import '../../../core/theme/theme_provider.dart';
import './admin_banners_page.dart';
import './profile_detail_page.dart';
import './change_password_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isAuth = ref.watch(isAuthenticatedProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final titleColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    if (!isAuth) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('Settings', style: TextStyle(color: titleColor)),
          backgroundColor: bgColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: AuthHelper.loginRequiredPlaceholder(
          context: context,
          featureName: 'Settings',
          description: 'Login to manage your account settings and preferences.',
        ),
      );
    }

    final coreState = ref.watch(authStoreProvider);
    final user = coreState is AuthAuthenticated ? coreState.user : null;

    return Scaffold(
      backgroundColor: isDark ? bgColor : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? bgColor : Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(auth.userProfileProvider.future),
          color: AppColors.primaryDark,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user?.role == 'admin') ...[
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Admin Tools'),
                  const SizedBox(height: 12),
                  _SettingsTile(
                    icon: Icons.campaign_outlined,
                    title: 'Manage Banners',
                    iconColor: const Color(0xFF0EA5E9),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminBannersPage()),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                const _SectionTitle(title: 'Account Settings'),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Account Details',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage()),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: 'Saved Addresses',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.shippingAddress),
                ),
                _SettingsTile(
                  icon: Icons.credit_card_outlined,
                  title: 'Payment Methods',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.payment),
                ),

                const SizedBox(height: 24),
                const _SectionTitle(title: 'Preferences'),
                const SizedBox(height: 12),
                Consumer(builder: (context, ref, child) {
                  final unreadCount =
                      ref.watch(unreadNotificationsCountProvider);
                  return _SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    badgeCount: unreadCount,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.notifications),
                  );
                }),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.languageSelection),
                ),
                Consumer(builder: (context, ref, child) {
                  final themeMode = ref.watch(themeProvider);
                  String themeText = 'System';
                  if (themeMode == ThemeMode.light) themeText = 'Light';
                  if (themeMode == ThemeMode.dark) themeText = 'Dark';
                  return _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Appearance',
                    subtitle: themeText,
                    onTap: () => _showThemePicker(context, ref, themeMode),
                  );
                }),

                const SizedBox(height: 24),
                const _SectionTitle(title: 'Support'),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.headset_mic_outlined,
                  title: 'Help Center',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.help),
                ),
                _SettingsTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Contact Us',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.contact),
                ),

                const SizedBox(height: 24),
                const _SectionTitle(title: 'Legal & About'),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About Us',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.about),
                ),
                _SettingsTile(
                  icon: Icons.business_rounded,
                  title: 'Company Details',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ProfileDetailPage(title: 'Company Details')),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ProfileDetailPage(title: 'Privacy Policy')),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileDetailPage(
                            title: 'Terms & Conditions')),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Rate App',
                  onTap: () => _showRatingDialog(context),
                ),
                _SettingsTile(
                  icon: Icons.share_outlined,
                  title: 'Share App',
                  onTap: () {
                    // TODO: Implement actual sharing logic with share_plus or url_launcher
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share functionality arriving soon!')),
                    );
                  },
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement Account Deletion
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delete Account functionality arriving soon!')),
                      );
                    },
                    icon: const Icon(Icons.person_remove_rounded, color: Colors.white),
                    label: const Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleLogout(context, ref),
                    icon: const Icon(Icons.logout_rounded, color: Colors.red),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.red.withOpacity(0.3)),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'App Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 100), // padding for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    int selectedStars = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Rate Green Wash Co.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('How would you rate your experience?',
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStars = index + 1;
                        });
                      },
                      child: Icon(
                        index < selectedStars
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: Colors.amber,
                        size: 36,
                      ),
                    );
                  }),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: selectedStars > 0
                    ? () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Thank you for your rating!')),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child:
                    const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(authStoreProvider.notifier).logout();
    }
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, ThemeMode currentTheme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Choose Theme',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                _buildThemeOption(context, ref, ThemeMode.system, 'System Default', Icons.settings_system_daydream, currentTheme),
                _buildThemeOption(context, ref, ThemeMode.light, 'Light', Icons.light_mode, currentTheme),
                _buildThemeOption(context, ref, ThemeMode.dark, 'Dark', Icons.dark_mode, currentTheme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(BuildContext context, WidgetRef ref, ThemeMode mode, String title, IconData icon, ThemeMode currentTheme) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2E7D32)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: currentTheme == mode
          ? const Icon(Icons.check_circle, color: Color(0xFF2E7D32))
          : null,
      onTap: () {
        ref.read(themeProvider.notifier).setTheme(mode);
        Navigator.pop(context);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  final models.UserModel user;

  const _UserProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : AppColors.primaryDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : AppColors.primaryDark.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border:
                  Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            ),
            child: Center(
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primaryDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName.isNotEmpty ? user.fullName : 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (user.phoneNumber.isNotEmpty)
                  Text(
                    user.phoneNumber,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                if (user.email.isNotEmpty)
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF94A3B8),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? iconColor;
  final int badgeCount;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF2E7D32)).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? const Color(0xFF2E7D32)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )
            : null,
        trailing: trailing ??
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badgeCount > 0)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.grey, size: 20),
              ],
            ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
