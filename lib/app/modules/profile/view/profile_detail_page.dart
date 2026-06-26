import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/order_service.dart';
import '../../../data/services/db_service.dart';
import '../../../data/services/subscription_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/subscription_model.dart';
import '../../../data/models/food_models.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/review_dialog.dart';
import '../../../../core/state/auth_store.dart' as auth_store;
import '../../../core/theme/theme_provider.dart';

class ProfileDetailPage extends ConsumerStatefulWidget {
  final String title;

  const ProfileDetailPage({super.key, required this.title});

  @override
  ConsumerState<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends ConsumerState<ProfileDetailPage> {
  int? _expandedOrderIndex = 0; // Default first one expanded as in Image 3

  // â”€â”€ Subscriptions state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final SubscriptionService _subscriptionService = SubscriptionService();
  List<SubscriptionPlan> _subscriptionPlans = [];
  bool _subscriptionsLoading = false;
  String? _subscriptionsError;
  final Map<String, bool> _notificationSettings = {
    'Allow Notifications': true,
    'Email Notifications': false,
    'Order Notifications': false,
    'General Notifications': true,
  };
  String? _selectedPlanId;

  @override
  void initState() {
    super.initState();
    if (widget.title == 'Subscriptions') {
      _loadSubscriptions();
    }
    if (widget.title == 'My Orders') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadOrders();
      });
    }
    if (widget.title == 'My Address') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CartProviderScope.of(context).loadAddresses();
      });
    }
  }

  Future<void> _loadOrders() async {
    final cartProvider = CartProviderScope.of(context);
    cartProvider.setLoadingOrders(true);
    try {
      final orders = await ref.read(orderServiceProvider).getMyOrders();
      cartProvider.setOrders(orders);
    } catch (e) {
      debugPrint('Error loading orders: $e');
    } finally {
      cartProvider.setLoadingOrders(false);
    }
  }

  Future<void> _loadSubscriptions() async {
    setState(() {
      _subscriptionsLoading = true;
      _subscriptionsError = null;
    });
    try {
      final plans = await _subscriptionService.getSubscriptions();
      setState(() {
        _subscriptionPlans = plans;
        _subscriptionsLoading = false;
      });
    } catch (e) {
      setState(() {
        _subscriptionsError = e
            .toString()
            .replaceFirst('ApiException: ', '')
            .replaceFirst('ApiException(null): ', '');
        _subscriptionsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = CartProviderScope.of(context);

    final isDark = context.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? context.scaffoldBackgroundColor : const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: isDark ? context.scaffoldBackgroundColor : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.title == 'Credit Cards')
            IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
                color: Color(0xFF1A1A1A),
              ),
              onPressed: () {
                // Handle add new
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
            child: _buildContent(widget.title, cartProvider, context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    String title,
    CartProvider provider,
    BuildContext context,
  ) {
    switch (title) {
      case 'My Address':
        return _buildAddressDetail(provider);
      case 'My Orders':
        return _buildOrdersDetail(provider);
      case 'My Favorites':
        return _buildFavoritesDetail(provider);
      case 'Subscriptions':
        return _buildSubscriptionsDetail();
      case 'Transactions':
        return _buildTransactionsDetail();
      case 'Notifications':
        return _buildNotificationsDetail();
      case 'Credit Cards':
        return _buildCardsDetail(provider);
      case 'About me':
        return _buildAboutMeDetail(provider);
      case 'Privacy Policy':
        return _buildPrivacyPolicyDetail();
      case 'Terms & Conditions':
        return _buildTermsDetail();
      case 'Company Details':
        return _buildCompanyDetailsDetail();
      default:
        return Center(child: Text('Content for $title coming soon!'));
    }
  }

  // --- MY ADDRESS DESIGN (Enhanced) ---
  Widget _buildAddressDetail(CartProvider provider) {
    final addresses = provider.addresses;
    final profile = provider.userProfile;

    return Column(
      children: [
        ...addresses.asMap().entries.map((entry) {
          final int index = entry.key;
          final addr = entry.value;
          final isSelected = provider.selectedAddressIndex == index;

          return GestureDetector(
            onTap: () {
              provider.selectAddress(index);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF00ACC1).withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (addr.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCFFAFE),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'DEFAULT',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      // Selection Indicator (Radio Button style)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2E7D32)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2E7D32),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFCFFAFE),
                        child: Icon(
                          addr.title.toLowerCase() == 'home'
                              ? Icons.home_rounded
                              : addr.title.toLowerCase() == 'office' ||
                                      addr.title.toLowerCase() == 'work'
                                  ? Icons.work_rounded
                                  : Icons.location_on_rounded,
                          color: const Color(0xFF2E7D32),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    addr.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          size: 18, color: Colors.grey),
                                      onPressed: () async {
                                        final result =
                                            await Navigator.pushNamed(
                                          context,
                                          '/location-picker',
                                          arguments: {'initialAddress': addr},
                                        );
                                        if (result != null && context.mounted) {
                                          provider.loadAddresses();
                                        }
                                      },
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          size: 18, color: Colors.redAccent),
                                      onPressed: () {
                                        provider.removeAddress(addr.id);
                                      },
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              addr.fullName.isNotEmpty
                                  ? addr.fullName
                                  : (profile.name.isNotEmpty
                                      ? profile.name
                                      : 'Unknown Recipient'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              addr.street,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  height: 1.4),
                            ),
                            Text(
                              addr.details,
                              style: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 12,
                                  height: 1.2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile.phone,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        // Add New Address Button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00ACC1).withValues(alpha: 0.2),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final result =
                    await Navigator.pushNamed(context, '/location-picker');
                if (result != null && context.mounted) {
                  CartProviderScope.of(context).loadAddresses();
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: Color(0xFF2E7D32)),
                    SizedBox(width: 8),
                    Text(
                      'Add New Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersDetail(CartProvider provider) {
    if (provider.isOrdersLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child:
            Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32))),
      );
    }

    final orders = provider.orders;
    if (orders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: Text('No orders yet.')),
      );
    }
    return Column(
      children: List.generate(orders.length, (index) {
        final isExpanded = _expandedOrderIndex == index;
        return _buildOrderCard(index, isExpanded, orders[index]);
      }),
    );
  }

  Widget _buildOrderCard(int index, bool isExpanded, UserOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00ACC1).withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFCFFAFE),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF2E7D32),
              ),
            ),
            title: Text(
              'Order #${order.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Placed on ${_formatDate(order.date)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Items:',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      ' ${order.items.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Total:',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      ' â‚¹${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              isExpanded
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
              color: const Color(0xFF2E7D32),
            ),
            onTap: () {
              setState(() {
                _expandedOrderIndex = isExpanded ? null : index;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildTimelineItem(
                    'Order Placed',
                    _formatDate(order.date),
                    Icons.inventory_2_outlined,
                    true,
                    true,
                  ),
                  _buildTimelineItem(
                    'Order Confirmed',
                    _formatDate(order.date),
                    Icons.check_circle_outline,
                    true,
                    true,
                  ),
                  _buildTimelineItem(
                    'Order Shipped',
                    'Processing',
                    Icons.edit_road_outlined,
                    true,
                    true,
                  ),
                  _buildTimelineItem(
                    'Order Delivered',
                    order.status == 'Delivered'
                        ? _formatDate(order.date)
                        : 'Pending',
                    Icons.shopping_basket_outlined,
                    order.status == 'Delivered',
                    order.status == 'Delivered',
                    isLast: true,
                  ),
                  if (order.status == 'Delivered' ||
                      order.status == 'Completed') ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: order.isReviewed
                          ? OutlinedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.check_circle_outline,
                                  color: Colors.green),
                              label: const Text(
                                'Rating Submitted',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.green),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            )
                          : OutlinedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ReviewDialog(
                                    orderId: order.id,
                                    items: order.items
                                        .map((i) => {
                                              '_id': i.id,
                                              'name': i.name,
                                              'image': i.image,
                                            })
                                        .toList(),
                                    retailerId:
                                        order.retailer?['_id']?.toString() ??
                                            '65e9f8f8f8f8f8f8f8f8f8f8',
                                    isOrderReview: true,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.star_outline,
                                  color: Color(0xFF2E7D32)),
                              label: const Text(
                                'Rate Items',
                                style: TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0xFF2E7D32)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- NOTIFICATIONS DESIGN (Image 4) ---
  Widget _buildNotificationsDetail() {
    return Column(
      children: _notificationSettings.keys.map((key) {
            return _buildNotificationCard(
              key,
              'Get real-time updates for $key.',
              _notificationSettings[key]!,
            );
          }).toList() +
          [
            const SizedBox(height: 60),
            _buildSaveButton('Save settings'),
          ],
    );
  }

  Widget _buildCardsDetail(CartProvider provider) {
    if (provider.payments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
            child: Text('No credit cards saved yet.',
                style: TextStyle(color: Colors.grey, fontSize: 16))),
      );
    }

    return Column(
      children: [
        // Map over provider.payments here when ready
        const SizedBox(height: 32),
        _buildSaveButton('Save card'),
      ],
    );
  }

  Widget _buildPrivacyPolicyDetail() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00ACC1).withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 16),
          Text(
            '1. Introduction\n'
            'Welcome to Green Wash Co. We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about our policy, or our practices with regards to your personal information, please contact us.\n\n'
            '2. Information We Collect\n'
            'We collect personal information that you provide to us such as name, address, contact information, passwords and security data, and payment information.\n\n'
            '3. How We Use Your Information\n'
            'We use personal information collected via our App for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations.\n\n'
            '4. Will Your Information Be Shared With Anyone?\n'
            'We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations.\n\n'
            '5. How Long Do We Keep Your Information?\n'
            'We keep your information for as long as necessary to fulfill the purposes outlined in this privacy policy unless otherwise required by law.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsDetail() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00ACC1).withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Conditions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 16),
          Text(
            '1. Acceptance of Terms\n'
            'By accessing or using the Green Wash Co. app, you agree to be bound by these Terms and Conditions and all applicable laws and regulations.\n\n'
            '2. Services Provided\n'
            'We provide an eco-friendly car wash booking service. The details of the services, pricing, and availability are subject to change without notice.\n\n'
            '3. User Responsibilities\n'
            'You are responsible for maintaining the confidentiality of your account information, including your password, and for all activity that occurs under your account.\n\n'
            '4. Payments and Cancellations\n'
            'All payments must be made through the app using the provided payment methods. Cancellations may be subject to a fee depending on how close to the scheduled time the cancellation is made.\n\n'
            '5. Limitation of Liability\n'
            'Green Wash Co. shall not be liable for any indirect, incidental, special, consequential or punitive damages, or any loss of profits or revenues.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyDetailsDetail() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00ACC1).withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Company Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Modernizing laundry management for businesses and individuals. Eco-friendly, fast, and professional.',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF64748B),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildSimpleContactRow(Icons.phone_android_rounded, '+91 9451034909'),
          const SizedBox(height: 16),
          _buildSimpleContactRow(Icons.email_outlined, 'ask003683@gmail.com'),
          const SizedBox(height: 16),
          _buildSimpleContactRow(Icons.language_rounded, 'www.greenwash.co'),
          const SizedBox(height: 16),
          _buildSimpleContactRow(Icons.location_on_outlined,
              'Hari Nagar colony, near riya boy\'s hostel, Chinhat, Semra, Uttar Pradesh 226028'),
          const SizedBox(height: 16),
          _buildSimpleContactRow(
              Icons.access_time_rounded, 'Mon - Sat: 8:00 AM - 8:00 PM'),
        ],
      ),
    );
  }

  Widget _buildSimpleContactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // --- SHARED COMPONENTS ---

  Widget _buildIconTextField(
    IconData icon,
    String hint, {
    IconData? trailingIcon,
    bool readOnly = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          suffixIcon: trailingIcon != null
              ? Icon(trailingIcon, color: Colors.grey)
              : (readOnly
                  ? const Icon(Icons.lock_outline, size: 16, color: Colors.grey)
                  : null),
        ),
      ),
    );
  }

  Widget _buildSaveButton(String text,
      {VoidCallback? onPressed, bool isLoading = false}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Text(
                text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    IconData icon,
    bool isActive,
    bool isCompleted, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFCFFAFE)
                    : const Color(0xFFF1F4F8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isCompleted ? const Color(0xFF2E7D32) : Colors.grey,
                size: 24,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted
                    ? const Color(0xFFCFFAFE)
                    : const Color(0xFFF1F4F8),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Divider(height: 48),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(String title, String desc, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00ACC1).withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: (v) {
              setState(() {
                _notificationSettings[title] = v;
              });
            },
            activeThumbColor: const Color(0xFF2E7D32),
            activeTrackColor: const Color(0xFFCFFAFE),
          ),
        ],
      ),
    );
  }

  // --- MY FAVORITES DESIGN (Image 5) ---
  Widget _buildFavoritesDetail(CartProvider provider) {
    if (provider.favRestaurants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text('No Favorites Yet',
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ),
      );
    }

    return Column(
      children: provider.favRestaurants.map((fav) {
        return _buildFavoriteCard(
          fav.name,
          fav.discount,
          'â€”',
          1,
          fav.image,
          const Color(0xFFE3F2FD),
        );
      }).toList(),
    );
  }

  Widget _buildFavoriteCard(
    String title,
    String weight,
    String price,
    int count,
    String image,
    Color bgColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    image,
                    width: 45,
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'â‚¹$price x $count',
                    style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    weight,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                    color: Color(0xFF2E7D32),
                  ),
                  onPressed: () {},
                ),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove, size: 18, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
            if (title == 'Black Grapes') // Match Image 5's swipe state
              Container(
                width: 60,
                height: 110,
                color: const Color(0xFFFF5252),
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  // --- TRANSACTIONS DESIGN ---
  Widget _buildTransactionsDetail() {
    final cartProvider = CartProviderScope.of(context);
    if (cartProvider.transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text('No transactions found.',
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ),
      );
    }

    return Column(
      children: cartProvider.transactions.map((tx) {
        final amount = tx['amount'] ?? 0;
        final isNegative = tx['type'] == 'Debit';
        return _buildTransactionItem(
          tx['description'] ?? 'Transaction',
          _formatDate(tx['createdAt'] ?? ''),
          '${isNegative ? '-' : '+'}â‚¹$amount',
          tx['status'] ?? 'Completed',
          isNegative: isNegative,
          isFailed: tx['status'] == 'Failed',
        );
      }).toList(),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String date,
    String amount,
    String status, {
    bool isNegative = true,
    bool isFailed = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isFailed
                ? Colors.red.withValues(alpha: 0.1)
                : (isNegative
                    ? Colors.orange.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1)),
            child: Icon(
              isFailed
                  ? Icons.error_outline
                  : (isNegative
                      ? Icons.shopping_bag_outlined
                      : Icons.account_balance_wallet_outlined),
              color: isFailed
                  ? Colors.red
                  : (isNegative ? Colors.orange : AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isFailed
                      ? Colors.grey
                      : (isNegative ? Colors.black : AppColors.primary),
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  color: isFailed ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Use late to avoid initialization errors
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isUpdatingProfile = false;

  Widget _buildAboutMeDetail(CartProvider provider) {
    final profile = provider.userProfile;

    // Refresh controllers if profile data in CartProvider has been updated externally
    if (profile.name.isNotEmpty &&
        _nameController.text != profile.name &&
        !_isUpdatingProfile) {
      _nameController.text = profile.name;
    }
    if (profile.email.isNotEmpty &&
        _emailController.text != profile.email &&
        !_isUpdatingProfile) {
      _emailController.text = profile.email;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        _buildIconTextField(Icons.person_outline, 'Full Name',
            controller: _nameController),
        const SizedBox(height: 12),
        // Email is now editable as per user request
        _buildIconTextField(Icons.mail_outline, 'Email Address',
            controller: _emailController),
        const SizedBox(height: 12),
        _buildIconTextField(Icons.phone_android_outlined, profile.phone,
            readOnly: true),
        const SizedBox(height: 12),
        const Text(
          'Note: Phone number cannot be changed after verification.',
          style: TextStyle(
              fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 32),
        const Text(
          'Security',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        _buildIconTextField(Icons.lock_outline, 'Change password',
            trailingIcon: Icons.chevron_right),
        const SizedBox(height: 40),
        _buildSaveButton('Update Profile', isLoading: _isUpdatingProfile,
            onPressed: () async {
          final currentProfile = provider.userProfile;
          final newName = _nameController.text.trim();
          final newEmail = _emailController.text.trim();

          String? nameToUpdate;
          String? emailToUpdate;

          if (newName != currentProfile.name) nameToUpdate = newName;
          if (newEmail != currentProfile.email) emailToUpdate = newEmail;

          if (nameToUpdate == null && emailToUpdate == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('No changes to save'),
              backgroundColor: Colors.orange,
            ));
            return;
          }

          setState(() => _isUpdatingProfile = true);
          try {
            final result = await ref.read(authServiceProvider).updateProfile(
                  fullName: nameToUpdate,
                  email: emailToUpdate,
                );

            if (result.success && mounted) {
              // Sync with AuthStore to update header and other global UI
              if (result.data != null) {
                ref
                    .read(auth_store.authStoreProvider.notifier)
                    .syncUser(result.data!);
              }
              // Refresh local profile
              await provider.syncUserProfile();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Profile updated successfully!')));
            } else if (mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(result.message)));
            }
          } finally {
            if (mounted) setState(() => _isUpdatingProfile = false);
          }
        }),
      ],
    );
  }

  // â”€â”€ SUBSCRIPTIONS DESIGN â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildSubscriptionsDetail() {
    if (_subscriptionsLoading) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF2E7D32),
          ),
        ),
      );
    }

    if (_subscriptionsError != null) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Colors.redAccent, size: 48),
              const SizedBox(height: 12),
              Text(
                _subscriptionsError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadSubscriptions,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_subscriptionPlans.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Text(
            'No subscription plans available.',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.card_membership_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Your Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Unlock exclusive Difwa benefits',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Plan cards
        ..._subscriptionPlans.map((plan) => _buildSubscriptionCard(plan)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSubscriptionCard(SubscriptionPlan plan) {
    final isSelected = _selectedPlanId == plan.id;
    final isSilver = plan.name.toLowerCase().contains('silver');
    final planColor =
        isSilver ? const Color(0xFF2979FF) : const Color(0xFFFF6D00);
    final planGradient = isSilver
        ? const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFE65100), Color(0xFFFFB74D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? planColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan header gradient strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              gradient: planGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'â‚¹${plan.price}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '/${plan.billingCycle}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (plan.badge != null && plan.badge!.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      plan.badge!,
                      style: TextStyle(
                        color: planColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  plan.description,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),

                // Highlights row
                Row(
                  children: [
                    _buildHighlightChip(
                      Icons.discount_outlined,
                      '${plan.discountPercentage}% off',
                      planColor,
                    ),
                    const SizedBox(width: 8),
                    _buildHighlightChip(
                      Icons.shopping_bag_outlined,
                      'Up to ${plan.maxOrderQuantity}kg',
                      planColor,
                    ),
                    if (plan.priorityDelivery) ...[
                      const SizedBox(width: 8),
                      _buildHighlightChip(
                        Icons.bolt,
                        'Priority',
                        planColor,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Features
                ...plan.features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: planColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: planColor,
                            size: 13,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            f,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Select button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _selectedPlanId = plan.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? planColor
                          : planColor.withValues(alpha: 0.12),
                      foregroundColor: isSelected ? Colors.white : planColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: planColor,
                          width: isSelected ? 0 : 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      isSelected
                          ? 'Selected âœ“'
                          : 'Select ${plan.name.split(' ').first} Plan',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
