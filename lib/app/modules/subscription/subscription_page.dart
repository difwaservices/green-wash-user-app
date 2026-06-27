import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/food_models.dart';
import '../../data/models/subscription_model.dart';
import '../../data/services/subscription_service.dart';
import '../../data/services/order_service.dart';
import '../../data/services/wallet_service.dart' show walletBalanceProvider;
import '../orders/view/order_tracking_page.dart';

import '../../core/utils/auth_helper.dart';
import 'package:difwawaterapp/core/state/auth_store.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  const SubscriptionPage({super.key});

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> {
  DateTime _selectedDate = DateTime.now();
  late final DateTime _startDate;
  late final PageController _pageController;
  int _currentImageIndex = 0;

  final List<String> _sliderImages = [
    'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?q=80&w=800&auto=format&fit=crop',
    'assets/images/hero_banner_wash.png',
    'assets/images/laundry_package_1.png',
  ];

  @override
  void initState() {
    super.initState();
    // Show 3 days in the past and scroll forward from there
    _startDate = DateTime.now().subtract(const Duration(days: 3));
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Returns true if the subscription delivers on the given date (ignoring vacation)
  bool _isPotentialDeliveryDay(UserSubscription sub, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStart =
        DateTime(sub.startDate.year, sub.startDate.month, sub.startDate.day);
    if (normalizedDate.isBefore(normalizedStart)) return false;

    if (sub.endDate != null) {
      final normalizedEnd =
          DateTime(sub.endDate!.year, sub.endDate!.month, sub.endDate!.day);
      if (normalizedDate.isAfter(normalizedEnd)) return false;
    }

    final freq = sub.frequency.toLowerCase();
    switch (freq) {
      case 'daily':
        return true;
      case 'alternate days':
        final diff = normalizedDate.difference(normalizedStart).inDays;
        return diff % 2 == 0;
      case 'weekly':
        const dayNames = [
          'sunday',
          'monday',
          'tuesday',
          'wednesday',
          'thursday',
          'friday',
          'saturday'
        ];
        final dayName = dayNames[date.weekday % 7];
        return sub.customDays.map((d) => d.toLowerCase()).contains(dayName);
      default:
        return false;
    }
  }

  /// Returns true if the subscription delivers on the given date
  bool _deliversOn(UserSubscription sub, DateTime date) {
    if (!_isPotentialDeliveryDay(sub, date)) return false;

    // Finally check vacation
    return !sub.isOnVacationOn(date);
  }

  @override
  Widget build(BuildContext context) {
    final isAuth = ref.watch(isAuthenticatedProvider);
    if (!isAuth) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: AuthHelper.loginRequiredPlaceholder(
          context: context,
          featureName: 'Daily Deliveries',
          description:
              'Keep track of your scheduled water updates and pause your deliveries from here.',
        ),
      );
    }

    final subscriptionsAsync = ref.watch(mySubscriptionsProvider);
    final ordersAsync = ref.watch(myOrdersProvider);
    final balanceAsync = ref.watch(walletBalanceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(mySubscriptionsProvider);
            ref.invalidate(myOrdersProvider);
            ref.invalidate(walletBalanceProvider);
          },
          color: const Color(0xFF2E7D32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(balanceAsync),
              _buildHorizontalCalendar(subscriptionsAsync),
              Expanded(
                child: subscriptionsAsync.when(
                  data: (subs) => ordersAsync.when(
                    data: (orders) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildStatusCard(subs, orders),
                          const SizedBox(height: 20),
                          _buildYourPlans(subs),
                          const SizedBox(height: 30),
                          _buildQuickActions(subs),
                        ],
                      ),
                    ),
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF2E7D32))),
                    error: (e, _) => const Center(
                      child: Text(
                        'Could not load orders. Pull down to refresh.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ),
                  loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF2E7D32))),
                  error: (e, _) => const Center(
                    child: Text(
                      'Could not load subscriptions. Pull down to refresh.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AsyncValue<double> balanceAsync) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF064E3B),
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Concierge',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF064E3B))),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    balanceAsync.when(
                      data: (b) => Text('₹${b.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      loading: () => const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white)),
                      error: (_, __) => const Text('--', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('DAILY\nDELIVERIES',
              style: TextStyle(
                  fontSize: 26,
                  height: 1.1,
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF064E3B))),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(DateFormat('MMMM yyyy').format(_selectedDate).toUpperCase(),
                  style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5)),
              const SizedBox(width: 16),
              Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar(
      AsyncValue<List<UserSubscription>> subsAsync) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: 30,
        itemBuilder: (context, index) {
          final date = _startDate.add(Duration(days: index));
          final isSelected = date.day == _selectedDate.day &&
              date.month == _selectedDate.month;
          final isToday = date.day == DateTime.now().day &&
              date.month == DateTime.now().month;

          // Show dot if any subscriptions deliver that day
          final hasSub = subsAsync.maybeWhen(
            data: (subs) =>
                subs.any((s) => s.status == 'Active' && _deliversOn(s, date)),
            orElse: () => false,
          );

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF064E3B)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E').format(date).toUpperCase(),
                      style: TextStyle(
                          color: isSelected
                              ? Colors.white70
                              : const Color(0xFF64748B),
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(date.day.toString(),
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  if (isSelected || hasSub) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(List<UserSubscription> subs, List<UserOrder> orders) {
    final deliveringSubs = subs
        .where((s) => s.status == 'Active' && _deliversOn(s, _selectedDate))
        .toList();

    final ordersForDate = orders.where((o) {
      final orderDate = o.date;
      return orderDate.day == _selectedDate.day &&
          orderDate.month == _selectedDate.month &&
          orderDate.year == _selectedDate.year;
    }).toList();

    final hasDelivery = deliveringSubs.isNotEmpty || ordersForDate.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light grayish-blue bg
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hasDelivery)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemCount: _sliderImages.length,
                      itemBuilder: (context, index) {
                        final img = _sliderImages[index];
                        if (img.startsWith('http')) {
                          return Image.network(img, fit: BoxFit.cover);
                        }
                        return Image.asset(img, fit: BoxFit.cover);
                      },
                    ),
                  ),
                ),

                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _sliderImages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentImageIndex == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentImageIndex == index
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else ...[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF064E3B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'SCHEDULED',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  Text('${deliveringSubs.length + ordersForDate.length} item(s)',
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, color: Color(0xFF064E3B))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ...ordersForDate.map((order) {
                    if (order.items.isEmpty) return const SizedBox();
                    return _buildRealOrderItem(order);
                  }),
                  ...deliveringSubs.where((sub) {
                    return !ordersForDate.any((o) {
                      return o.items.any((item) => item.name == sub.productName);
                    });
                  }).map((sub) => _buildDeliveryItem(sub)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildRealOrderItem(UserOrder order) {
    if (order.items.isEmpty) return const SizedBox();

    // Combine all item names into a single string for summary
    final itemsNames = order.items.map((i) => i.name).join(', ');
    final image = order.items.first.image;
    final totalQty = order.items.fold(0, (sum, i) => sum + i.quantity);
    final status = order.status;
    final isDelivered = status.toLowerCase() == 'delivered';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: image.isNotEmpty
                ? Image.network(image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder)
                : _imagePlaceholder,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemsNames,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Qty $totalQty • ₹${order.total.toStringAsFixed(0)}',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 11)),
                    if (order.deliverySlot != null &&
                        order.deliverySlot!.isNotEmpty)
                      _infoChip(
                        icon: Icons.schedule,
                        label: order.deliverySlot!,
                        color: Colors.teal,
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: order.isSubscription
                            ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: order.isSubscription
                                ? const Color(0xFF2E7D32).withValues(alpha: 0.3)
                                : Colors.grey.shade300),
                      ),
                      child: Text(
                        (order.orderType ?? 'ONE-TIME').toUpperCase() ==
                                'SUBSCRIPTION'
                            ? 'SUBS'
                            : (order.orderType ?? 'ONE-TIME').toUpperCase(),
                        style: TextStyle(
                            fontSize: 8,
                            color: order.isSubscription
                                ? const Color(0xFF2E7D32)
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Builder(builder: (context) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final selected = DateTime(
                _selectedDate.year, _selectedDate.month, _selectedDate.day);
            final isFuture = selected.isAfter(today);

            return ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: isFuture
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderTrackingPage(order: {
                                  '_id': order.id,
                                  'status': order.status,
                                }),
                              ),
                            );
                          },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: isFuture
                                ? Colors.grey
                                : const Color(0xFF2E7D32),
                            size: 14),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: isFuture
                                  ? Colors.grey
                                  : const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isFuture) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderTrackingPage(order: {
                              '_id': order.id,
                              'status': order.status,
                            }),
                          ),
                        );
                      },
                      child: const Text(
                        'Track',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(width: 8),
          Icon(isDelivered ? Icons.check_circle : Icons.radio_button_checked,
              size: 20, color: const Color(0xFF2E7D32)),
        ],
      ),
    );
  }

  Widget _buildDeliveryItem(UserSubscription sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: sub.productImage.isNotEmpty
                ? (sub.productImage.startsWith('http')
                    ? Image.network(sub.productImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder)
                    : Image.asset(sub.productImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder))
                : _imagePlaceholder,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sub.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (sub.retailerName.isNotEmpty)
                  Text(sub.retailerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: const Color(0xFF1B5E20).withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                // Quantity + Frequency chips
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _infoChip(
                      icon: Icons.water_drop,
                      label: 'Qty ${sub.quantity}',
                      color: const Color(0xFF2E7D32),
                    ),
                    _infoChip(
                      icon: Icons.repeat,
                      label: sub.frequency,
                      color: Colors.indigo,
                    ),
                    if (sub.deliverySlot != null &&
                        sub.deliverySlot!.isNotEmpty)
                      _infoChip(
                        icon: Icons.schedule,
                        label: sub.deliverySlot!,
                        color: Colors.teal,
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color:
                                const Color(0xFF2E7D32).withValues(alpha: 0.3)),
                      ),
                      child: const Text('SUBS',
                          style: TextStyle(
                              fontSize: 8,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Builder(builder: (context) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final selected = DateTime(
                _selectedDate.year, _selectedDate.month, _selectedDate.day);
            final isFuture = selected.isAfter(today);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isFuture)
                  GestureDetector(
                    onTap: () => _openTrackingForSubscription(sub),
                    child: const Text(
                      'Upcoming',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                else
                  const Text(
                    'Upcoming',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(width: 8),
          const Icon(Icons.check_circle, size: 20, color: Color(0xFF2E7D32)),
        ],
      ),
    );
  }

  /// Fetches the latest order for [sub] from the backend and navigates
  /// to [OrderTrackingPage] with the real order data.
  Future<void> _openTrackingForSubscription(UserSubscription sub) async {
    // Show a loading snackbar while we fetch
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Row(children: [
          SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          SizedBox(width: 12),
          Text('Fetching order detailsâ€¦'),
        ]),
        duration: Duration(seconds: 10),
        backgroundColor: Color(0xFF1B5E20),
      ),
    );

    try {
      final orderService = ref.read(orderServiceProvider);
      Map<String, dynamic> order =
          await orderService.getOrderBySubscriptionId(sub.id);

      // If no backend order found, use a sensible stub so the page still opens
      if (order.isEmpty) {
        order = {
          '_id': sub.id,
          'orderId': sub.id,
          'status': 'Processing',
          'orderType': 'Subscription',
          'frequency': sub.frequency,
          'customDays': sub.customDays,
          'items': [
            {
              'quantity': sub.quantity,
              'price': 0,
              'product': {
                'name': sub.productName,
                'images': [sub.productImage],
              },
            }
          ],
        };
      }

      if (!mounted) return;
      messenger.hideCurrentSnackBar();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderTrackingPage(order: order),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load order details. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget get _imagePlaceholder => Container(
        width: 50,
        height: 50,
        color: const Color(0xFFE8F5E9),
        child: const Icon(Icons.water_drop, color: Color(0xFF2E7D32), size: 24),
      );

  /// Small compact chip used inside delivery items
  Widget _infoChip(
      {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildYourPlans(List<UserSubscription> subs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Your Plans',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF064E3B))),
            const SizedBox(width: 16),
            Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 24),
        if (subs.isEmpty)
          const Text('No active plans. Subscribe to a product to get started!',
              style: TextStyle(color: Colors.grey))
        else
          ...subs.map((sub) => _buildPlanItem(sub)),
      ],
    );
  }

  Widget _buildPlanItem(UserSubscription sub) {
    final isActive = sub.status == 'Active';

    return GestureDetector(
      onTap: () => _showPlanDetailsSheet(sub),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF064E3B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(sub.productName,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isActive,
                    activeColor: const Color(0xFF064E3B),
                    activeTrackColor: const Color(0xFFA7F3D0),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade400,
                    onChanged: (val) async {
                      if (isActive) {
                        await ref.read(mySubscriptionsProvider.notifier).updateStatus(sub.id, 'Paused');
                      } else {
                        await ref.read(mySubscriptionsProvider.notifier).updateStatus(sub.id, 'Active');
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _planChip('QTY ${sub.quantity}', Colors.white.withOpacity(0.2), Colors.white),
                _planChip(sub.frequency.toUpperCase(), Colors.white.withOpacity(0.2), Colors.white),
                _planChip('₹${(sub.price * sub.quantity).toStringAsFixed(0)}', const Color(0xFFA7F3D0), const Color(0xFF064E3B)),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(isActive ? Icons.check_circle_outline : Icons.pause_circle_outline, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(isActive ? 'ACTIVE PLAN' : 'PAUSED PLAN', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.white70, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _planChip(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  void _showPlanDetailsSheet(UserSubscription sub) {
    final hasSlot = sub.deliverySlot != null && sub.deliverySlot!.isNotEmpty;
    final address = sub.deliveryAddress ?? {};
    final fullAddress =
        (address['fullAddress'] ?? address['address'] ?? '').toString();
    final area = address['label']?.toString() ?? 'Home';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Plan Details',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A1A1A))),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (sub.status == 'Active'
                              ? Colors.green
                              : Colors.orange)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      sub.status.toUpperCase(),
                      style: TextStyle(
                        color: sub.status == 'Active'
                            ? Colors.green
                            : Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Product Info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: sub.productImage.isNotEmpty
                        ? (sub.productImage.startsWith('http')
                            ? Image.network(sub.productImage,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _imagePlaceholder)
                            : Image.asset(sub.productImage,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _imagePlaceholder))
                        : _imagePlaceholder,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sub.productName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('By ${sub.retailerName}',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Details Table-like Rows
              _detailRow(Icons.repeat, 'Frequency', sub.frequency),
              _detailRow(
                  Icons.water_drop_outlined, 'Quantity', 'Qty ${sub.quantity}'),
              _detailRow(Icons.schedule, 'Delivery Slot',
                  hasSlot ? sub.deliverySlot! : 'Morning (Standard)'),
              _detailRow(Icons.calendar_today_outlined, 'Started On',
                  DateFormat('dd MMM yyyy').format(sub.startDate)),
              if (fullAddress.isNotEmpty)
                _detailRow(Icons.location_on_outlined, 'Delivery to',
                    '$area: $fullAddress'),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Price info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Price per delivery',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500)),
                  Text('₹${(sub.price * sub.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1B5E20))),
                ],
              ),
              const SizedBox(height: 24),

              // Quick action in sheet
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Close Details',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 12),
          Text('$label:',
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)))),
        ],
      ),
    );
  }

  /// Shows a bottom sheet with full delivery address details
  void _showAddressSheet(UserSubscription sub) {
    final m = sub.deliveryAddress ?? {};
    final fullName = m['fullName']?.toString() ?? '';
    final label = m['label']?.toString() ?? '';
    final fullAddress =
        (m['fullAddress'] ?? m['address'] ?? m['street'] ?? '').toString();
    final city = m['city']?.toString() ?? '';
    final state = m['state']?.toString() ?? '';
    final pincode = m['pincode']?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.location_on,
                      color: Color(0xFF2E7D32), size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Delivery Address',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800)),
                    Text(sub.productName,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _addressRow(Icons.person_outline,
                fullName.isNotEmpty ? fullName : 'â€”', 'Recipient'),
            if (label.isNotEmpty)
              _addressRow(Icons.label_outline, label, 'Label'),
            if (fullAddress.isNotEmpty)
              _addressRow(Icons.home_outlined, fullAddress, 'Street'),
            if (city.isNotEmpty)
              _addressRow(Icons.location_city_outlined, city, 'City'),
            if (state.isNotEmpty)
              _addressRow(Icons.map_outlined, state, 'State'),
            if (pincode.isNotEmpty)
              _addressRow(Icons.pin_drop_outlined, pincode, 'Pincode'),
            if (sub.deliverySlot != null && sub.deliverySlot!.isNotEmpty) ...[
              const Divider(height: 24),
              _addressRow(Icons.schedule, sub.deliverySlot!, 'Delivery Slot'),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _addressRow(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(List<UserSubscription> subs) {
    final now = DateTime.now();
    final isAfterDeadline = now.hour >= 20; // 8 PM Deadline

    final today = DateTime(now.year, now.month, now.day);
    // Vacation is ON if any active subscription has a vacation date from today onwards
    final isVacationOn = subs.any((s) =>
        s.status == 'Active' &&
        s.vacationDates.any((vd) => !vd.isBefore(today)));

    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    // Tomorrow is considered 'paused' only if ALL active subs have it in vacation
    final activeSubs = subs.where((s) => s.status == 'Active').toList();
    final isTomorrowPaused = activeSubs.isNotEmpty &&
        activeSubs.every((s) => s.isOnVacationOn(tomorrow));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAfterDeadline && subs.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Deadline passed (8 PM). Tomorrow\'s delivery is locked.',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: isTomorrowPaused ? Icons.play_arrow : Icons.pause,
                label: isTomorrowPaused ? 'Resume\nTomorrow' : 'Pause\nTomorrow',
                iconColor: const Color(0xFFFDE68A),
                iconBgColor: const Color(0xFFFEF3C7),
                iconDarkColor: const Color(0xFFD97706),
                onTap: (subs.isEmpty || (isAfterDeadline && !isTomorrowPaused))
                    ? null
                    : () => _pauseTomorrow(subs),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ActionButton(
                icon: Icons.flight_takeoff,
                label: 'Vacation\n${isVacationOn ? "ON" : "OFF"}',
                iconColor: const Color(0xFFFECACA),
                iconBgColor: const Color(0xFFFEE2E2),
                iconDarkColor: const Color(0xFFDC2626),
                onTap: (subs.isEmpty)
                    ? null
                    : () => _toggleVacationMode(subs, isVacationOn),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _pauseTomorrow(List<UserSubscription> subs) async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final activeSubs = subs.where((s) => s.status == 'Active').toList();
    if (activeSubs.isEmpty) return;

    final isTomorrowAlreadyPaused =
        activeSubs.every((s) => s.isOnVacationOn(tomorrow));

    // Only block new pauses after 8 PM â€” always allow resume
    if (now.hour >= 20 && !isTomorrowAlreadyPaused) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Deadline passed (8 PM). Cannot pause tomorrow\'s delivery.'),
          backgroundColor: Colors.orange,
        ));
      }
      return;
    }

    // (activeSubs / isTomorrowAlreadyPaused already computed above)

    final confirmed = await _showConfirmationDialog(
      title: isTomorrowAlreadyPaused ? 'Resume Tomorrow?' : 'Pause Tomorrow?',
      message: isTomorrowAlreadyPaused
          ? 'Are you sure you want to resume all scheduled deliveries for tomorrow?'
          : 'Are you sure you want to skip all scheduled deliveries for tomorrow?',
      confirmText: isTomorrowAlreadyPaused ? 'Resume' : 'Pause',
      confirmColor: isTomorrowAlreadyPaused ? Colors.green : Colors.orange,
    );
    if (!confirmed) return;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Processing...'),
        duration: Duration(seconds: 1),
      ));
    }

    // Process all subs in parallel
    final notifier = ref.read(mySubscriptionsProvider.notifier);
    final futures = activeSubs
        .map((sub) => notifier.updateVacation(
              subscriptionId: sub.id,
              startDate: tomorrow,
              endDate: tomorrow,
              isResume: isTomorrowAlreadyPaused,
            ))
        .toList();

    await Future.wait(futures);
    await notifier.refresh(); // Single refresh at end

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isTomorrowAlreadyPaused
            ? 'Tomorrow\'s delivery resumed!'
            : 'Tomorrow\'s delivery paused!'),
        backgroundColor: isTomorrowAlreadyPaused ? Colors.green : Colors.orange,
      ));
    }
  }

  void _toggleVacationMode(
      List<UserSubscription> subs, bool isCurrentlyOn) async {
    final now = DateTime.now();
    final isAfterDeadline = now.hour >= 20; // 8 PM Deadline

    // Cannot START a new vacation after 8 PM
    if (isAfterDeadline && !isCurrentlyOn) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Deadline passed (8 PM). Cannot start vacation for tomorrow.'),
          backgroundColor: Colors.orange,
        ));
      }
      return;
    }

    final activeSubs = subs.where((s) => s.status == 'Active').toList();
    if (activeSubs.isEmpty) return;

    if (isCurrentlyOn) {
      // --- VACATION MODE OFF ---
      final confirmed = await _showConfirmationDialog(
        title: 'Turn Off Vacation?',
        message: 'Turn off vacation mode? All paused deliveries will resume.',
        confirmText: 'Turn Off',
        confirmColor: Colors.green,
      );
      if (!confirmed) return;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Clearing vacation dates...'),
          duration: Duration(seconds: 1),
        ));
      }

      // clearAllVacations: sends the exact future dates with isResume:true
      // so the backend removes them from the Do-Not-Pack list.
      // Each call does its own optimistic clear; we do ONE refresh at the end.
      final notifier = ref.read(mySubscriptionsProvider.notifier);
      for (final sub in activeSubs) {
        await notifier.clearAllVacations(sub.id);
      }
      // Single refresh to sync server state after all clears complete
      await notifier.refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Vacation Mode OFF! Deliveries are resumed.'),
          backgroundColor: Colors.green,
        ));
      }
    } else {
      // --- VACATION MODE ON â€” user picks both start and end date ---
      // Earliest selectable start date is tomorrow (or day-after if past 8 PM)
      final firstPossible = isAfterDeadline
          ? DateTime(now.year, now.month, now.day + 2)
          : DateTime(now.year, now.month, now.day + 1);

      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: firstPossible,
        initialDateRange: DateTimeRange(
          start: firstPossible,
          end: firstPossible.add(const Duration(days: 6)),
        ),
        lastDate: DateTime.now().add(const Duration(days: 90)),
        helpText: 'SELECT VACATION DATES',
        saveText: 'SET VACATION',
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        ),
      );

      if (picked == null) return;

      // Normalize to midnight local dates
      final startDate =
          DateTime(picked.start.year, picked.start.month, picked.start.day);
      final endDate =
          DateTime(picked.end.year, picked.end.month, picked.end.day);

      final confirmed = await _showConfirmationDialog(
        title: 'Start Vacation?',
        message:
            'Pause all deliveries from ${DateFormat('MMM d').format(startDate)} to ${DateFormat('MMM d').format(endDate)}?',
        confirmText: 'Start Vacation',
        confirmColor: const Color(0xFF2E7D32),
      );
      if (!confirmed) return;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Activating vacation mode...'),
          duration: Duration(seconds: 1),
        ));
      }

      // Send the full chosen range to backend for each active subscription
      final futures = activeSubs.map(
          (sub) => ref.read(mySubscriptionsProvider.notifier).updateVacation(
                subscriptionId: sub.id,
                startDate: startDate,
                endDate: endDate,
                isResume: false,
              ));
      await Future.wait(futures);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Vacation mode activated!'),
          backgroundColor: Colors.blue,
        ));
      }
    }
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content:
                Text(message, style: const TextStyle(color: Colors.black87)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(cancelText,
                    style: const TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmText,
                    style: TextStyle(
                        color: confirmColor ?? const Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBgColor;
  final Color iconDarkColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBgColor,
    required this.iconDarkColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconDarkColor, size: 20),
            ),
            Text(
              label,
              style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w900,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
