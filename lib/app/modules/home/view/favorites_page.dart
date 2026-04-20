import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/shop_product_model.dart';
import '../../../data/services/favorites_service.dart';
import '../../../data/services/db_service.dart';
import '../../../data/models/product_model.dart';
import '../controller/main_controller.dart';
import '../widgets/quantity_selector.dart';
import '../../../core/constants/app_colors.dart';
import '../../categories/controller/categories_controller.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(favoriteProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Favorite Products',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF06B6D4)),
            onPressed: () => ref.invalidate(favoriteProductsProvider),
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
        ),
        error: (err, _) => _buildError(context, ref, err),
        data: (products) => products.isEmpty
            ? _buildEmptyState(context, ref)
            : _buildGrid(context, ref, products),
      ),
    );
  }

  Widget _buildGrid(
      BuildContext context, WidgetRef ref, List<ShopProduct> products) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) =>
          _FavProductCard(product: products[index]),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: const BoxDecoration(
                    color: Color(0xFFCFFAFE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_outline_rounded,
                    size: 72,
                    color: Color(0xFF06B6D4),
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(mainIndexProvider.notifier).setIndex(0);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.storefront_outlined),
                  label: const Text('Explore Products',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('Could not load favorites',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(err.toString(),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(favoriteProductsProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: AppColors.primary),
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _FavProductCard extends ConsumerWidget {
  final ShopProduct product;
  const _FavProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = CartProviderScope.of(context);
    final p = product;
    final isFav = ref.watch(favoritesProvider).maybeWhen(
          data: (ids) => ids.contains(p.id),
          orElse: () => true,
        );

    final cartItem = cart.items.firstWhere(
      (item) => item.id == p.id,
      orElse: () => CartItem(
          id: p.id,
          title: p.name,
          unitPrice: p.price,
          subtitle: p.category?.name ?? '',
          image: p.primaryImage,
          category: 'restaurant',
          quantity: 0),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: p.primaryImage.isNotEmpty
                    ? Image.network(
                        p.primaryImage,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              if (p.stockStatus == 'Out of Stock' || p.stock <= 0)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45),
                      child: const Center(
                        child: Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (p.stockStatus == 'Low Stock' && p.stock > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'ONLY ${p.stock} LEFT!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () =>
                      ref.read(favoritesProvider.notifier).toggle(p.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isFav
                          ? Colors.red.shade50
                          : Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                if (p.category != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(p.category!.name,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey)),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${p.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                if (p.stockStatus == 'Out of Stock' || p.stock <= 0)
                  const Icon(Icons.add, color: Colors.grey, size: 18)
                else if (cartItem.quantity == 0)
                  GestureDetector(
                    onTap: () => cart.addToCart(CartItem(
                      id: p.id,
                      title: p.name,
                      unitPrice: p.price,
                      subtitle: p.category?.name ?? 'Difwa',
                      image: p.primaryImage,
                      category: 'restaurant',
                    )),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF06B6D4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  )
                else
                  QuantitySelector(
                    quantity: cartItem.quantity,
                    onIncrement: () => cart.increment(p.name),
                    onDecrement: () => cart.decrement(p.name),
                    size: 30,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        height: 120,
        color: Colors.grey.shade100,
        child: const Center(
          child: Icon(Icons.set_meal_outlined, size: 36, color: Colors.grey),
        ),
      );
}
