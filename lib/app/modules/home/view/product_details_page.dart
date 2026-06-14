import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/food_models.dart';
import '../../../data/services/db_service.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/favorites_service.dart';
import '../widgets/cart_summary_bar.dart';
import '../widgets/quantity_selector.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Replace selection?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
  Widget build(BuildContext context) {
    final product = widget.product;
    final cart = CartProviderScope.of(context);

    final cartItem = cart.items.firstWhere(
      (item) =>
          (item.id.isNotEmpty && product.id.isNotEmpty && item.id == product.id) ||
          ((item.id.isEmpty || product.id.isEmpty) &&
              item.title.isNotEmpty &&
              item.title == product.name &&
              item.shopId != null &&
              item.shopId!.isNotEmpty &&
              item.shopId == product.shopId),
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

    // ── Live favourite state from provider ──────────────────────────────────
    final favsAsync = ref.watch(favoritesProvider);
    final isFav = favsAsync.asData?.value.contains(product.id) ?? false;

    String cleanText(String text) {
      String cleaned = text.replaceAll(RegExp(r'"id"\s*:\s*"[a-fA-F0-9]{24}"\,?\s*'), '');
      cleaned = cleaned.replaceAll(RegExp(r'\{?\s*"id"\s*:\s*"[a-fA-F0-9]{24}"\s*\}?\,?\s*'), '');
      cleaned = cleaned.replaceAll(RegExp(r'[a-fA-F0-9]{24}'), '');
      cleaned = cleaned.replaceAll(RegExp(r'\{\s*"id"\s*:\s*""\s*\}\s*'), '');
      cleaned = cleaned.replaceAll(RegExp(r'"id"\s*:\s*""\,?\s*'), '');
      return cleaned.trim();
    }

    final description = cleanText(product.description.isNotEmpty &&
            !product.description.contains('तथा')
        ? product.description
        : 'Enjoy pure, healthy, and refreshing hydration with Difwa Alkaline Water. Enriched with essential minerals and balanced pH, it is ideal for homes, offices, gyms, and commercial use.');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable Content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 64, bottom: 160), // Space for top header and bottom sticky bar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Card
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _FullScreenImagePage(imageUrl: product.image),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            width: 1.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: product.image.isEmpty
                                    ? const Center(
                                        child: Icon(Icons.water_drop_outlined,
                                            size: 64, color: Colors.grey))
                                    : product.image.startsWith('http')
                                        ? Image.network(
                                            product.image,
                                            fit: BoxFit.contain,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return const Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.primary,
                                                ),
                                              );
                                            },
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
                              // Zoom Icon Overlay
                              Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.zoom_in, color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Product Information
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge (Offer/New/Low Stock)
                          if (product.badgeText.isNotEmpty || isOutOfStock || isLowStock)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                          
                          // Title & Price in Same Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  cleanText(product.name),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '₹${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Specifications Grid
                          _buildAttributesSection(context, product),
                          const SizedBox(height: 24),
                          
                          // Product Description
                          const Text(
                            'Product Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Why Choose Us Section
                          if (product.whyChoose.isNotEmpty) ...[
                            const Text(
                              'Why Choose Our Water',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 12),
                            ...product.whyChoose.map((point) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: AppColors.primary, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          point,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Header Overlay Buttons (Back & Wishlist)
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildHeaderButton(
                    icon: isFav ? Icons.favorite : Icons.favorite_border,
                    iconColor: isFav ? Colors.red : Colors.grey.shade700,
                    onTap: () async {
                      try {
                        await ref
                            .read(favoritesProvider.notifier)
                            .toggle(product.id);
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not update favourites. Please try again.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),

            // Cart Summary Overlay (if items exist, float above sticky bottom bar)
            if (cart.itemCount > 0)
              Positioned(
                bottom: 135,
                left: 0,
                right: 0,
                child: CartSummaryBar(
                  cart: cart,
                ),
              ),

            // Sticky Bottom Add-to-Cart Panel
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
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xFF00ACC1).withValues(alpha: 0.15),
                      width: 1.0,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isInCart) ...[
                        // Item is in cart — show live quantity stepper + Go to Cart
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'In Cart',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            QuantitySelector(
                              quantity: cartItem.quantity,
                              onIncrement: () {
                                if (isAvailable) cart.increment(product.id);
                              },
                              onDecrement: () {
                                if (isAvailable) cart.decrement(product.id);
                              },
                              size: 36,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006064),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Go to Cart',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ] else ...[
                        // Item is NOT in cart — show simple Add to Cart button
                        ElevatedButton(
                          onPressed: isAvailable
                              ? () {
                                  _addToCart(
                                    context,
                                    cart,
                                    CartItem.fromProduct(product, quantity: 1),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isAvailable ? AppColors.primary : Colors.grey,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            isOutOfStock ? 'Out of Stock' : 'Add to Cart',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    Color iconColor = Colors.black87,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _buildAttributesSection(BuildContext context, Product product) {
    final List<Map<String, dynamic>> attributes = [];
    if (product.category.isNotEmpty) {
      attributes.add({
        'label': 'Category',
        'value': product.category,
        'icon': Icons.category_outlined,
      });
    }
    if (product.shopName.isNotEmpty) {
      attributes.add({
        'label': 'Source',
        'value': product.shopName,
        'icon': Icons.business_outlined,
      });
    }
    if (product.stockStatus.isNotEmpty) {
      attributes.add({
        'label': 'Stock Status',
        'value': product.stockStatus,
        'icon': Icons.inventory_2_outlined,
      });
    }

    if (attributes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Specifications',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: attributes.length,
          itemBuilder: (context, index) {
            final attr = attributes[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Icon(
                    attr['icon'] as IconData,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          attr['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          attr['value'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  const _FullScreenImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: 'product_image_zoom',
            child: imageUrl.isEmpty
                ? const Icon(Icons.water_drop_outlined, size: 120, color: Colors.grey)
                : imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.water_drop_outlined,
                            size: 120,
                            color: Colors.grey),
                      )
                    : Image.asset(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.water_drop_outlined,
                            size: 120,
                            color: Colors.grey),
                      ),
          ),
        ),
      ),
    );
  }
}
