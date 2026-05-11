import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/food_models.dart';
import '../../../data/services/db_service.dart';
import '../../../data/models/product_model.dart';
import '../widgets/cart_summary_bar.dart';
import '../widgets/quantity_selector.dart';

import '../../../core/constants/app_colors.dart';
import '../../../../core/state/auth_store.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/auth_helper.dart';
import '../../../data/services/shop_service.dart';
import '../../profile/view/address_form_page.dart';

class ProductDetailsPage extends ConsumerWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  void _addToCart(BuildContext context, CartProvider cart, CartItem newItem) {
    if (!cart.isSameShop(newItem.shopId)) {
      _showReplaceCartDialog(context, cart, newItem);
    } else {
      cart.addToCart(newItem);
    }
  }

  void _showReplaceCartDialog(
      BuildContext context, CartProvider cart, CartItem newItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace selection?'),
        content: Text('Your cart contains products from ${cart.cartShopName}. '
            'Do you want to discard them and add products from ${newItem.shopName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              cart.clearCart();
              cart.addToCart(newItem);
              Navigator.pop(context);
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Note: CartProviderScope.of(context) might need ref.watch(cartProvider) if refactored
    // Using context for legacy compatibility if CartProviderScope still exists
    final cart = CartProviderScope.of(context);
    final cartItem = cart.items.firstWhere(
      (item) => item.id == product.id,
      orElse: () => CartItem(
        id: product.id,
        title: product.name,
        unitPrice: product.price,
        subtitle: product.weight,
        image: product.image,
        category: product.category,
        quantity: 0,
      ),
    );
    final isInCart = cartItem.quantity > 0;
    final isOutOfStock = product.stockStatus == 'Out of Stock';
    final isLowStock = product.stockStatus == 'Low Stock';
    final isAvailable = product.isShopActive && !isOutOfStock;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              product.isFavorite ? Colors.red : Colors.black87,
                        ),
                        onPressed: () => cart.toggleFavorite(product.id),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ColorFiltered(
                    colorFilter: isAvailable
                        ? const ColorFilter.mode(
                            Colors.transparent, BlendMode.multiply)
                        : const ColorFilter.mode(
                            Colors.grey, BlendMode.saturation),
                    child: Hero(
                      tag: 'product_${product.id}',
                      child: product.image.isEmpty
                          ? const Center(
                              child: Icon(Icons.water_drop_outlined,
                                  size: 64, color: Colors.grey))
                          : product.image.startsWith('http')
                              ? Image.network(
                                  product.image,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.water_drop_outlined,
                                          size: 64, color: Colors.grey)),
                                )
                              : Image.asset(
                                  product.image,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.water_drop_outlined,
                                          size: 64, color: Colors.grey)),
                                ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.badgeText.isNotEmpty ||
                          isOutOfStock ||
                          isLowStock)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                              color: isOutOfStock
                                  ? Colors.black87
                                  : (isLowStock
                                      ? Colors.orange.shade700
                                      : Colors.red),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            isOutOfStock
                                ? 'OUT OF STOCK'
                                : (isLowStock
                                    ? (product.stock > 0
                                        ? 'ONLY ${product.stock} LEFT!'
                                        : 'SELLING FAST!')
                                    : product.badgeText.toUpperCase()),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(product.name,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A1A))),
                          ),
                          Text('₹${product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(product.weight,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black)),
                      const SizedBox(height: 24),
                      const Text('Product Description',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A))),
                      const SizedBox(height: 12),
                      Text(product.description,
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Colors.black)),
                      const SizedBox(height: 24),
                      if (product.whyChoose.isNotEmpty) ...[
                        const Text('Why Choose Our Water',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 16),
                        ...product.whyChoose.map((point) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: AppColors.primary, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Text(point,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black))),
                                ],
                              ),
                            )),
                      ],
                      const SizedBox(height: 180),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Cart Summary Overlay
          if (cart.itemCount > 0)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 85,
              left: 0,
              right: 0,
              child: CartSummaryBar(
                cart: cart,
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
              border: Border.all(
                color: const Color(0xFF00ACC1).withOpacity(0.2),
                width: 1.0,
              ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    !isInCart
                        ? ElevatedButton(
                            onPressed: isAvailable
                                ? () => _addToCart(context, cart,
                                    CartItem.fromProduct(product))
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isAvailable ? AppColors.primary : Colors.grey,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: Text(
                                isOutOfStock ? 'Out of Stock' : 'Add to Cart',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          )
                        : Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF7F8FA),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppColors.primary
                                        .withOpacity(0.2))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Selected Quantity',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A))),
                                QuantitySelector(
                                  quantity: cartItem.quantity,
                                  onIncrement: isAvailable
                                      ? () => cart.increment(product.name)
                                      : () {},
                                  onDecrement: isAvailable
                                      ? () => cart.decrement(product.name)
                                      : () {},
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
