import 'package:flutter/material.dart';
import '../../../data/services/db_service.dart';
import '../../../data/models/food_models.dart';
import '../../home/view/product_details_page.dart';
import '../../home/controller/main_controller.dart';
import '../../home/widgets/quantity_selector.dart';
import 'shipping_address_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../routes/app_routes.dart';
import '../../../core/utils/auth_helper.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  String _getPlaceholderImage(String title) {
    final t = title.toLowerCase();
    if (t.contains('saree')) return 'https://images.unsplash.com/photo-1583391733958-d25e07fac04f?q=80&w=800&auto=format&fit=crop'; // Saree
  if (t.contains('suit')) return 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?q=80&w=800&auto=format&fit=crop';
  if (t.contains('blazer') || t.contains('coat') || t.contains('jacket')) return 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?q=80&w=800&auto=format&fit=crop';
    if (t.contains('dress') || t.contains('gown')) return 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?q=80&w=800&auto=format&fit=crop';
    if (t.contains('shirt') || t.contains('t-shirt') || t.contains('top')) return 'https://images.unsplash.com/photo-1621072156002-e2fccdc0b176?q=80&w=800&auto=format&fit=crop';
  if (t.contains('jeans') || t.contains('trousers') || t.contains('pants')) return 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?q=80&w=800&auto=format&fit=crop';
  if (t.contains('polish')) return 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=800&auto=format&fit=crop'; // Leather shoes
  if (t.contains('shoe') || t.contains('sneaker')) return 'https://images.unsplash.com/photo-1549298916-b41d501d3772?q=80&w=800&auto=format&fit=crop';
  if (t.contains('single blanket')) return 'https://images.unsplash.com/photo-1580301762395-21ce84d00bc6?q=80&w=800&auto=format&fit=crop';
  if (t.contains('double blanket')) return 'https://images.unsplash.com/photo-1579656592043-a20e25a4aa4b?q=80&w=800&auto=format&fit=crop';
  if (t.contains('blanket')) return 'https://images.unsplash.com/photo-1580301762395-21ce84d00bc6?q=80&w=800&auto=format&fit=crop';
  if (t.contains('duvet') || t.contains('comforter') || t.contains('bed')) return 'https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=800&auto=format&fit=crop';
  if (t.contains('iron')) return 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?q=80&w=800&auto=format&fit=crop';
  if (t.contains('undergarment') || t.contains('shorts')) return 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?q=80&w=800&auto=format&fit=crop';
    if (t.contains('curtain')) return 'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=800&auto=format&fit=crop';
    if (t.contains('toy')) return 'https://images.unsplash.com/photo-1559454403-b8fb88521f11?q=80&w=800&auto=format&fit=crop';
    if (t.contains('bag') || t.contains('backpack')) return 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=800&auto=format&fit=crop';
    if (t.contains('stain')) return 'https://images.unsplash.com/photo-1585421514738-01798e348b17?q=80&w=800&auto=format&fit=crop'; // Cleaning spray/stain
    if (t.contains('dry clean')) return 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?q=80&w=800&auto=format&fit=crop';
    if (t.contains('wash')) return 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?q=80&w=800&auto=format&fit=crop';
    return 'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?q=80&w=800&auto=format&fit=crop'; // Default folded clothes
  }

  Widget _buildProductImage(String image, String title) {
    String imgUrl = image.isEmpty ? _getPlaceholderImage(title) : image;
    if (imgUrl.startsWith('http')) {
      return Image.network(imgUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Image.asset('assets/images/empty_wash.png', fit: BoxFit.cover));
    } else {
      return Image.asset(imgUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Image.asset('assets/images/empty_wash.png', fit: BoxFit.cover));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... items ...
    final cart = CartProviderScope.of(context);
    final items = cart.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      // ... appBar ...
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF00ACC1).withOpacity(0.1),
            height: 1,
          ),
        ),
      ),
      body: items.isEmpty
          ? _buildEmptyCart(context, ref)
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 400),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildCartItem(context, cart, item);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildSummarySection(context, ref, cart),
                ),
              ],
            ),
    );
  }

  // ... _buildEmptyCart remains same ...
  Widget _buildEmptyCart(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Color(0xFFCFFAFE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add some delicious items to your\ncart to get started!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.search);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Shop Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartProvider cart, dynamic item) {
    return GestureDetector(
      key: ValueKey(item.id),
      onTap: () {
        // Find the full product object to pass to details page
        final product = Product(
          id: item.id,
          name: item.title,
          image: item.image,
          price: item.unitPrice,
          weight: item.subtitle,
          category: '',
          description: '',
          whyChoose: [],
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 80,
                  height: 80,
                  color: const Color(0xFFF7F8FA),
                  child: _buildProductImage(item.image, item.title),
                ),
              ),
              const SizedBox(width: 16),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '₹${item.unitPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  QuantitySelector(
                    quantity: item.quantity,
                    onIncrement: () => cart.increment(item.id),
                    onDecrement: () => cart.decrement(item.id),
                    size: 34, // Slightly smaller for list view
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(
      BuildContext context, WidgetRef ref, CartProvider cart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF00ACC1).withOpacity(0.2),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryRow('Subtotal', '₹${cart.subtotal.toStringAsFixed(0)}'),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Shipping',
              '₹${cart.shippingCharges.toStringAsFixed(0)}',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F4F8)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  '₹${cart.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (!AuthHelper.checkAuth(
                    context: context,
                    ref: ref,
                    message: 'Please log in to proceed with your order.',
                  )) {
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ShippingAddressPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          '₹${cart.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
