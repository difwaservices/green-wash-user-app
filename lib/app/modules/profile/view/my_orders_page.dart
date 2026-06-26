import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/food_models.dart';
import '../../../data/services/order_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/db_service.dart';
import 'package:intl/intl.dart';
import '../../../widgets/bounce_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/review_dialog.dart';

final _orderDateFormat = DateFormat('dd MMM yyyy, hh:mm a');

final filteredOrdersProvider = Provider.family<List<UserOrder>, List<UserOrder>>((ref, orders) {
  return orders
      .where((o) => o.status.toLowerCase() != 'cancelled')
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      backgroundColor:
          const Color(0xFFF8FAFC), // Matching the clean vibe of active orders
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF1B5E20), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order History',
          style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF1B5E20)),
            onPressed: () => ref.invalidate(myOrdersProvider),
          ),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) {
          final filteredOrders = ref.watch(filteredOrdersProvider(orders));

          return filteredOrders.isEmpty
              ? const _EmptyOrdersView()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: filteredOrders.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _OrderCard(order: filteredOrders[index]),
                );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF1B5E20))),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No orders yet',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B))),
          const SizedBox(height: 8),
          const Text('Your past orders will appear here.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final UserOrder order;
  const _OrderCard({required this.order});

  void _showOrderDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => _OrderDetailsSheet(order: order),
    );
  }

  void _reorder(BuildContext context) {
    HapticFeedback.mediumImpact();
    final cartProv = CartProviderScope.of(context);
    final shopId = order.retailer?['_id']?.toString();
    final shopName = order.plantName;

    void executeReorder() {
      for (var item in order.items) {
        cartProv.addToCart(CartItem(
          id: item.id.isNotEmpty ? item.id : 'reorder_${item.name}',
          title: item.name,
          unitPrice: item.price,
          subtitle: 'Reorder',
          image: item.image,
          category: 'Reorder',
          quantity: item.quantity,
          shopId: shopId,
          shopName: shopName,
        ));
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added to cart for reorder!'),
        backgroundColor: Color(0xFF1B5E20),
        behavior: SnackBarBehavior.floating,
      ));
    }

    if (!cartProv.isSameShop(shopId)) {
      final oldShopName = cartProv.cartShopName ?? 'another shop';
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Replace cart items?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            'Your cart contains products from $oldShopName. Do you want to discard them and add products from $shopName for reordering?',
            style: const TextStyle(
                color: Colors.black87, fontSize: 14, height: 1.5),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFFFFF1F0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(
                          color: Color(0xFFFC5A44),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cartProv.clearCart();
                      executeReorder();
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF1B5E20),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Replace',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      executeReorder();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imageUrl =
        order.items.isNotEmpty ? order.items.first.image : '';
    final String status = order.status.toLowerCase().trim();
    final bool isDelivered = status == 'delivered' || 
                             status == 'completed' || 
                             status == 'success' || 
                             status == 'done';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _showOrderDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF00ACC1).withOpacity(0.2),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                        order.items.isNotEmpty
                            ? order.items.first.name.replaceFirst(RegExp(r'^\d+x\s*'), '')
                            : 'Order',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF1E293B))),
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
              const Divider(height: 32, thickness: 1, color: Color(0xFFF3F4F6)),

              // Content
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl.isNotEmpty
                          ? Image.network(imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _fallbackIcon())
                          : _fallbackIcon(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            order.items
                                .map((i) => '${i.quantity}x ${i.name}')
                                .join(', '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF1E293B))),
                        const SizedBox(height: 4),
                        _summaryText(
                            'Placed: ${_orderDateFormat.format(order.date)}'),
                        if (isDelivered)
                          _summaryText(
                              'Delivered: ${_orderDateFormat.format(order.date.add(const Duration(hours: 1)))}'),
                        if (order.riderName.isNotEmpty)
                          _summaryText('Rider: ${order.riderName}'),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Bottom Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Bill',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('â‚¹${order.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BounceWidget(
                        onTap: () => _reorder(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF1B5E20), width: 1.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text('Reorder',
                              style: TextStyle(
                                  color: Color(0xFF1B5E20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      ),
                      if (isDelivered) ...[
                        const SizedBox(width: 8),
                        _buildRatingButton(context, ref),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingButton(BuildContext context, WidgetRef ref) {
    final ratedOrders = ref.watch(ratedOrdersProvider);
    final bool alreadyRated = order.isReviewed || ratedOrders.contains(order.id);

    if (alreadyRated) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          border: Border.all(color: Colors.green, width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text('Submitted Rating',
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
      );
    }

    return BounceWidget(
      onTap: () {
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
                order.retailer?['_id']?.toString() ?? '65e9f8f8f8f8f8f8f8f8f8f8',
            isOrderReview: true,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF1B5E20), width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text('Rate Items',
            style: TextStyle(
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.bold,
                fontSize: 13)),
      ),
    );
  }

  Widget _summaryText(String t) =>
      Text(t, style: TextStyle(color: Colors.grey.shade600, fontSize: 13));

  Widget _buildStatusBadge(String status) {
    status = status.toLowerCase().trim();
    Color color = const Color(0xFF2E7D32); // Success green
    Color bg = const Color(0xFFE2F5E9);
    
    String displayStatus = status.toUpperCase();

    if (status == 'delivered' || status == 'completed' || status == 'success' || status == 'done') {
      color = const Color(0xFF2E7D32);
      bg = const Color(0xFFE2F5E9);
      displayStatus = 'DELIVERED';
    } else if (status.contains('pickup') || status.contains('picked')) {
      color = const Color(0xFF2E7D32); // Cyan for picked up
      bg = const Color(0xFFCFFAFE);
      displayStatus = 'PICKED UP';
    } else if (status.contains('way') || status.contains('delivery')) {
      color = const Color(0xFF1B5E20);
      bg = const Color(0xFFECFEFF);
      displayStatus = 'OUT FOR DELIVERY';
    } else {
      color = const Color(0xFFB45309); // Amber for pending/others
      bg = const Color(0xFFFEF3C7);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(displayStatus,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _fallbackIcon() => const Center(
      child: Icon(Icons.water_drop, color: Color(0xFF1B5E20), size: 32));
}

class _OrderDetailsSheet extends StatelessWidget {
  final UserOrder order;
  const _OrderDetailsSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
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
                      borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 24),
          const Text('Order Details',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B))),
          Text(
              'ID: #${order.id.length > 8 ? order.id.substring(order.id.length - 8).toUpperCase() : order.id.toUpperCase()}',
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          if (order.plantName.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.factory_outlined,
                    size: 16, color: Color(0xFF1B5E20)),
                const SizedBox(width: 8),
                Text(
                  order.plantName,
                  style: const TextStyle(
                      color: Color(0xFF1B5E20),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          const Text('ITEMS ORDERED',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1)),
          const SizedBox(height: 12),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text('${item.quantity}x',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(item.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF1E293B)))),
                    Text('â‚¹${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
          const Divider(height: 40),
          const Text('BILL DETAILS',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1)),
          _row('Item Total', order.total - order.deliveryFee),
          _row('Delivery Fee', order.deliveryFee),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('â‚¹${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1A1A1A))),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('GOT IT',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String l, double v) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text('â‚¹${v.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600))
      ]));
}
