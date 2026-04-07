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

  @override
  void initState() {
    super.initState();
    // Show 3 days in the past and scroll forward from there
    _startDate = DateTime.now().subtract(const Duration(days: 3));
  }

  /// Returns true if the subscription delivers on the given date
  bool _deliversOn(UserSubscription sub, DateTime date) {
    // Check if date is before subscription start
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStart =
        DateTime(sub.startDate.year, sub.startDate.month, sub.startDate.day);
    if (normalizedDate.isBefore(normalizedStart)) return false;

    // Check if endDate passed
    if (sub.endDate != null) {
      final normalizedEnd =
          DateTime(sub.endDate!.year, sub.endDate!.month, sub.endDate!.day);
      if (normalizedDate.isAfter(normalizedEnd)) return false;
    }

    // Check vacation dates
    final isOnVacation = sub.vacationDates
        .any((vd) => DateTime(vd.year, vd.month, vd.day) == normalizedDate);
    if (isOnVacation) return false;

    // Check frequency
    switch (sub.frequency) {
      case 'Daily':
        return true;
      case 'Alternate Days':
        final diff = normalizedDate.difference(normalizedStart).inDays;
        return diff % 2 == 0;
      case 'Weekly':
        // customDays holds selected days e.g. ['Sunday', 'Wednesday']
        const dayNames = [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday'
        ];
        final dayName = dayNames[date.weekday % 7];
        return sub.customDays.contains(dayName);
      default:
        return false;
    }
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(mySubscriptionsProvider);
            ref.invalidate(myOrdersProvider);
            ref.invalidate(walletBalanceProvider);
          },
          color: const Color(0xFF06B6D4),
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
                            color: Color(0xFF06B6D4))),
                    error: (e, _) =>
                        Center(child: Text('Error loading orders: $e')),
                  ),
                  loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF06B6D4))),
                  error: (e, _) => Center(child: Text('Error: $e')),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daily Deliveries',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A))),
                Text(DateFormat('MMMM yyyy').format(_selectedDate),
                    style: const TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ),
          // Wallet balance pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet,
                    color: Color(0xFF06B6D4), size: 16),
                const SizedBox(width: 6),
                balanceAsync.when(
                  data: (b) => Text('₹${b.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Color(0xFF0891B2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  loading: () => const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  error: (_, __) => const Text('--'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar(
      AsyncValue<List<UserSubscription>> subsAsync) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
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

          // Prioritize vacation indicator over delivery dots if user requested "all dates as vacation"
          final isPaused = subsAsync.maybeWhen(
            data: (subs) => subs.any((s) =>
                s.status == 'Active' &&
                s.vacationDates.any((vd) =>
                    DateTime(vd.year, vd.month, vd.day) ==
                    DateTime(date.year, date.month, date.day))),
            orElse: () => false,
          );

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF06B6D4)
                    : isPaused
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isToday && !isSelected
                    ? Border.all(
                        color: const Color(0xFF06B6D4).withValues(alpha: 0.4))
                    : isPaused
                        ? Border.all(
                            color: Colors.blue.withValues(alpha: 0.3), width: 1)
                        : null,
              ),
              child: Opacity(
                opacity: isPaused ? 0.7 : 1.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat('E').format(date).toUpperCase(),
                        style: TextStyle(
                            color: isSelected
                                ? Colors.white70
                                : isPaused
                                    ? Colors.blue
                                    : Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(date.day.toString(),
                        style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isPaused
                                    ? Colors.blue[800]
                                    : Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w900)),
                    if (hasSub)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF06B6D4),
                        ),
                      ),
                    if (isPaused)
                      const Icon(Icons.beach_access,
                          size: 14, color: Colors.blue),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(List<UserSubscription> subs, List<UserOrder> orders) {
    // 1. Find subscriptions that should deliver on this date
    final deliveringSubs = subs
        .where((s) => s.status == 'Active' && _deliversOn(s, _selectedDate))
        .toList();

    // 2. Find real orders created for this date
    final ordersForDate = orders.where((o) {
      final orderDate = o.date;
      return orderDate.day == _selectedDate.day &&
          orderDate.month == _selectedDate.month &&
          orderDate.year == _selectedDate.year;
    }).toList();

    final anySubOnVacation = subs.any((s) =>
        s.status == 'Active' &&
        s.vacationDates.any((vd) =>
            vd.day == _selectedDate.day &&
            vd.month == _selectedDate.month &&
            vd.year == _selectedDate.year));

    final hasDelivery = deliveringSubs.isNotEmpty || ordersForDate.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: anySubOnVacation
            ? Colors.blue.withValues(alpha: 0.05)
            : const Color(0xFFCFFAFE).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: anySubOnVacation
                ? Colors.blue.withValues(alpha: 0.2)
                : const Color(0xFF06B6D4).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: hasDelivery
                      ? const Color(0xFF06B6D4)
                      : anySubOnVacation
                          ? Colors.blue
                          : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  hasDelivery
                      ? 'SCHEDULED'
                      : anySubOnVacation
                          ? 'ON VACATION'
                          : 'NO DELIVERY',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const Spacer(),
              if (hasDelivery)
                Text('${deliveringSubs.length + ordersForDate.length} item(s)',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            ],
          ),
          const SizedBox(height: 16),
          if (!hasDelivery)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                    anySubOnVacation
                        ? 'Deliveries are paused for this day.'
                        : 'No deliveries scheduled for this day.',
                    style: const TextStyle(color: Colors.grey)),
              ),
            )
          else ...[
            // Show matched/real orders first
            ...ordersForDate.map((order) {
              if (order.items.isEmpty) return const SizedBox();
              return _buildRealOrderItem(order);
            }),
            // Show subscriptions that haven't turned into orders yet
            ...deliveringSubs.where((sub) {
              // Avoid duplicates if order is already shown
              return !ordersForDate.any((o) {
                return o.items.any((item) =>
                    // Ideally check product ID here, but our model uses name for simplicity in some places
                    item.name == sub.productName);
              });
            }).map((sub) => _buildDeliveryItem(sub)),
          ],
        ],
      ),
    );
  }

  Widget _buildRealOrderItem(UserOrder order) {
    if (order.items.isEmpty) return const SizedBox();
    final item = order.items.first;
    final name = item.name;
    final image = item.image;
    final qty = item.quantity.toString();
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('Qty $qty • Subscription Order',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: Color(0xFF06B6D4), size: 14),
                    const SizedBox(width: 2),
                    Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF06B6D4),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
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
          ),
          const SizedBox(width: 12),
          Icon(isDelivered ? Icons.check_circle : Icons.radio_button_checked,
              color: const Color(0xFF06B6D4)),
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
                ? Image.network(sub.productImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder)
                : _imagePlaceholder,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sub.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (sub.retailerName.isNotEmpty)
                  Text(sub.retailerName,
                      style: TextStyle(
                          color: const Color(0xFF0891B2).withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                Text('Qty ${sub.quantity} • ${sub.frequency}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

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
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Icon(Icons.check_circle, color: Color(0xFF06B6D4)),
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
          Text('Fetching order details…'),
        ]),
        duration: Duration(seconds: 10),
        backgroundColor: Color(0xFF0891B2),
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
        SnackBar(
          content: Text('Could not load order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget get _imagePlaceholder => Container(
        width: 50,
        height: 50,
        color: const Color(0xFFE8F5E9),
        child: const Icon(Icons.set_meal, color: Color(0xFF06B6D4), size: 24),
      );

  Widget _buildYourPlans(List<UserSubscription> subs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Plans',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (isActive ? const Color(0xFF06B6D4) : Colors.grey)
                .withValues(alpha: 0.12),
            child: Icon(isActive ? Icons.check : Icons.pause,
                color: isActive ? const Color(0xFF06B6D4) : Colors.grey),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sub.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(sub.frequency,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          // Pause / Resume toggle
          Switch(
            value: isActive,
            activeThumbColor: const Color(0xFF06B6D4),
            onChanged: (val) async {
              final confirmed = await _showConfirmationDialog(
                title: val ? 'Resume Subscription?' : 'Pause Subscription?',
                message: val
                    ? 'Do you want to resume deliveries for ${sub.productName}?'
                    : 'Do you want to pause deliveries for ${sub.productName}?',
                confirmText: val ? 'Resume' : 'Pause',
                confirmColor: val ? const Color(0xFF06B6D4) : Colors.orange,
              );
              if (!confirmed) return;

              final newStatus = val ? 'Active' : 'Paused';
              final ok = await ref
                  .read(mySubscriptionsProvider.notifier)
                  .updateStatus(sub.id, newStatus);
              if (ok) {
                // Notifier handles refresh/rollback
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(List<UserSubscription> subs) {
    final now = DateTime.now();
    final isAfterDeadline = now.hour >= 20; // 8 PM Deadline

    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final isVacationOn = subs.any((s) =>
        s.status == 'Active' &&
        s.vacationDates.any((vd) => vd.isAfter(todayEnd)));

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final isTomorrowPaused = subs.any((s) =>
        s.status == 'Active' &&
        s.vacationDates.any((vd) =>
            DateTime(vd.year, vd.month, vd.day) ==
            DateTime(tomorrow.year, tomorrow.month, tomorrow.day)));

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
                icon: isTomorrowPaused
                    ? Icons.play_circle_outline
                    : Icons.pause_circle_outline,
                label: isTomorrowPaused ? 'Resume Tomorrow' : 'Pause Tomorrow',
                color: isTomorrowPaused ? Colors.green : Colors.orange,
                onTap: (subs.isEmpty || isAfterDeadline)
                    ? null
                    : () => _pauseTomorrow(subs),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _ActionButton(
                icon: Icons.flight_takeoff,
                label: isVacationOn ? 'Vacation: ON' : 'Vacation: OFF',
                color: isVacationOn ? Colors.blue : Colors.redAccent,
                onTap: (subs.isEmpty || isAfterDeadline)
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

    final isTomorrowAlreadyPaused = activeSubs.first.vacationDates.any((vd) =>
        DateTime(vd.year, vd.month, vd.day) ==
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day));

    final confirmed = await _showConfirmationDialog(
      title: isTomorrowAlreadyPaused ? 'Resume Delivery?' : 'Pause Delivery?',
      message: isTomorrowAlreadyPaused
          ? 'Are you sure you want to resume tomorrow\'s delivery?'
          : 'Are you sure you want to pause tomorrow\'s delivery?',
      confirmText: isTomorrowAlreadyPaused ? 'Resume' : 'Pause',
      confirmColor: isTomorrowAlreadyPaused ? Colors.green : Colors.orange,
    );
    if (!confirmed) return;

    for (final sub in activeSubs) {
      await ref.read(mySubscriptionsProvider.notifier).updateVacation(
            subscriptionId: sub.id,
            startDate: tomorrow,
            endDate: tomorrow,
          );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isTomorrowAlreadyPaused
            ? 'Tomorrow\'s delivery resumed successfully!'
            : 'Tomorrow\'s delivery paused successfully!'),
        backgroundColor: isTomorrowAlreadyPaused ? Colors.green : Colors.orange,
      ));
    }
  }

  void _toggleVacationMode(
      List<UserSubscription> subs, bool isCurrentlyOn) async {
    final now = DateTime.now();
    final isAfterDeadline = now.hour >= 20; // 8 PM Deadline

    if (isAfterDeadline && !isCurrentlyOn) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Cannot start vacation for tomorrow after 8 PM.'),
          backgroundColor: Colors.orange,
        ));
      }
      return;
    }

    final activeSubs = subs.where((s) => s.status == 'Active').toList();
    if (activeSubs.isEmpty) return;

    if (isCurrentlyOn) {
      final confirmed = await _showConfirmationDialog(
        title: 'Turn Off Vacation?',
        message:
            'Are you sure you want to turn off vacation mode? Deliveries will resume from tomorrow.',
        confirmText: 'Turn Off',
        confirmColor: Colors.orange,
      );
      if (!confirmed) return;

      // Turn Vacation Mode OFF - comprehensively clear from today onwards
      final todayStart = DateTime(now.year, now.month, now.day);

      for (final sub in activeSubs) {
        // Find all active/upcoming vacation dates starting from today
        final futureDates = sub.vacationDates.where((vd) => !vd.isBefore(todayStart)).toList();
        
        if (futureDates.isEmpty) continue; // Nothing to clear
        
        // Process dates concurrently so the UI updates flawlessly in a single frame
        // without visual "popping", while preserving safe single-date transmissions.
        final futures = futureDates.map((vd) =>
            ref.read(mySubscriptionsProvider.notifier).updateVacation(
                  subscriptionId: sub.id,
                  startDate: vd,
                  endDate: vd,
                ));
        await Future.wait(futures);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Vacation Mode OFF! Deliveries resume from tomorrow.'),
          backgroundColor: Colors.orange,
        ));
      }
    } else {
      // First possible date depends on 8 PM deadline
      DateTime firstPossibleDate = now.add(const Duration(days: 1));
      if (isAfterDeadline) {
        firstPossibleDate = now.add(const Duration(days: 2));
      }

      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: firstPossibleDate,
        initialDateRange: DateTimeRange(
            start: firstPossibleDate,
            end: firstPossibleDate.add(const Duration(days: 6))),
        lastDate: DateTime.now().add(const Duration(days: 90)),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF06B6D4),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        ),
      );

      if (picked != null) {
        final confirmed = await _showConfirmationDialog(
          title: 'Start Vacation?',
          message:
              'Are you sure you want to pause deliveries from ${DateFormat('MMM d').format(picked.start)} to ${DateFormat('MMM d').format(picked.end)}?',
          confirmText: 'Start Vacation',
          confirmColor: const Color(0xFF06B6D4),
        );
        if (!confirmed) return;

        for (final sub in activeSubs) {
          await ref.read(mySubscriptionsProvider.notifier).updateVacation(
                subscriptionId: sub.id,
                startDate: picked.start,
                endDate: picked.end,
              );
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Vacation mode activated!'),
            backgroundColor: Colors.blue,
          ));
        }
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
            content: Text(message, style: const TextStyle(color: Colors.black87)),
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
                        color: confirmColor ?? const Color(0xFF06B6D4),
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
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: onTap == null ? Colors.grey : color, size: 24),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    color: onTap == null ? Colors.grey : color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
