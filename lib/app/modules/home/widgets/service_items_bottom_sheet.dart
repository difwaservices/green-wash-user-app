import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../data/services/db_service.dart';
import '../../../data/models/product_model.dart';

class ServiceItemsBottomSheet extends StatefulWidget {
  final String serviceName;

  const ServiceItemsBottomSheet({super.key, required this.serviceName});

  static Future<void> show(BuildContext context, String serviceName) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceItemsBottomSheet(serviceName: serviceName),
    );
  }

  @override
  State<ServiceItemsBottomSheet> createState() =>
      _ServiceItemsBottomSheetState();
}

class _ServiceItemsBottomSheetState extends State<ServiceItemsBottomSheet> {
  final Map<String, int> _quantities = {};

  String _getHeroImage(String serviceName) {
    if (serviceName.contains('Wash')) return 'assets/images/pkg_monthly_wash.png';
    if (serviceName.contains('Dry Clean')) return 'assets/images/pkg_dry_clean.png';
    if (serviceName.contains('Iron')) return 'assets/images/pkg_ironing.png';
    if (serviceName.contains('Shoe')) return 'assets/images/pkg_shoe_care.png';
    if (serviceName.contains('Blanket')) return 'assets/images/laundry_package_1.png';
    return 'assets/images/hero_banner_wash.png';
  }

  List<Map<String, dynamic>> _getItemsForService() {
    // Generate dummy items based on service name
    if (widget.serviceName.contains('Wash')) {
      return [
        {
          'name': 'T-Shirt / Shirt',
          'price': 30,
          'icon': Icons.checkroom_rounded
        },
        {
          'name': 'Trousers / Jeans',
          'price': 40,
          'icon': Icons.dry_cleaning_rounded
        },
        {'name': 'Shorts', 'price': 25, 'icon': Icons.boy_rounded},
        {
          'name': 'Undergarments',
          'price': 15,
          'icon': Icons.local_laundry_service_rounded
        },
      ];
    } else if (widget.serviceName.contains('Dry Clean')) {
      return [
        {
          'name': '2-Piece Suit',
          'price': 250,
          'icon': Icons.dry_cleaning_rounded
        },
        {
          'name': 'Blazer / Coat',
          'price': 150,
          'icon': Icons.dry_cleaning_rounded
        },
        {
          'name': 'Premium Dress',
          'price': 200,
          'icon': Icons.checkroom_rounded
        },
      ];
    } else if (widget.serviceName.contains('Blanket')) {
      return [
        {
          'name': 'Single Blanket',
          'price': 150,
          'icon': Icons.king_bed_rounded
        },
        {
          'name': 'Double Blanket',
          'price': 250,
          'icon': Icons.king_bed_rounded
        },
        {
          'name': 'Duvet / Comforter',
          'price': 300,
          'icon': Icons.king_bed_rounded
        },
      ];
    } else if (widget.serviceName.contains('Shoe')) {
      return [
        {
          'name': 'Sneakers Cleaning',
          'price': 199,
          'icon': Icons.ice_skating_rounded
        },
        {
          'name': 'Leather Polish',
          'price': 149,
          'icon': Icons.ice_skating_rounded
        },
      ];
    } else if (widget.serviceName.contains('Iron')) {
      return [
        {'name': 'Shirt Ironing', 'price': 15, 'icon': Icons.iron_rounded},
        {'name': 'Pants Ironing', 'price': 20, 'icon': Icons.iron_rounded},
      ];
    } else if (widget.serviceName.contains('Package')) {
      return [
        {
          'name': 'Monthly Wash Plan',
          'price': 1499,
          'icon': Icons.all_inclusive_rounded
        },
        {
          'name': 'Premium Dry Clean',
          'price': 499,
          'icon': Icons.dry_cleaning_rounded
        },
        {
          'name': 'Family Bundle',
          'price': 2499,
          'icon': Icons.family_restroom_rounded
        },
        {
          'name': 'Shoe Care Pack',
          'price': 899,
          'icon': Icons.ice_skating_rounded
        },
      ];
    } else if (widget.serviceName.contains('Premium')) {
      return [
        {'name': 'Designer Suit', 'price': 499, 'icon': Icons.dry_cleaning_rounded},
        {'name': 'Wedding Dress / Gown', 'price': 999, 'icon': Icons.checkroom_rounded},
        {'name': 'Premium Silk Saree', 'price': 399, 'icon': Icons.dry_cleaning_rounded},
        {'name': 'Leather Jacket', 'price': 599, 'icon': Icons.checkroom_rounded},
      ];
    } else if (widget.serviceName.contains('Stain')) {
      return [
        {'name': 'Tough Stain Removal (Shirt)', 'price': 99, 'icon': Icons.auto_fix_high_rounded},
        {'name': 'Ink/Oil Stain (Pants)', 'price': 149, 'icon': Icons.auto_fix_high_rounded},
        {'name': 'Deep Carpet/Rug Stain', 'price': 299, 'icon': Icons.auto_fix_high_rounded},
      ];
    } else {
      // Default items for "More" or others
      return [
        {'name': 'Curtains Wash (Per kg)', 'price': 199, 'icon': Icons.window_rounded},
        {'name': 'Soft Toys Cleaning', 'price': 149, 'icon': Icons.toys_rounded},
        {'name': 'Bag / Backpack Wash', 'price': 249, 'icon': Icons.backpack_rounded},
      ];
    }
  }

  int get _totalPrice {
    int total = 0;
    final items = _getItemsForService();
    for (var item in items) {
      final name = item['name'] as String;
      final price = item['price'] as int;
      final qty = _quantities[name] ?? 0;
      total += price * qty;
    }
    return total;
  }

  int get _totalItems {
    return _quantities.values.fold(0, (sum, val) => sum + val);
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItemsForService();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // Take 85% of screen because of image
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Hero Image
          Container(
            width: double.infinity,
            height: 140,
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(_getHeroImage(widget.serviceName)),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.serviceName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0A4429),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Select items and quantities',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                ),
              ],
            ),
          ),

          const Divider(height: 16),

          // Item List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                final name = item['name'] as String;
                final price = item['price'] as int;
                final icon = item['icon'] as IconData;
                final qty = _quantities[name] ?? 0;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFFE8F5E9), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A4429).withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: const Color(0xFF2E7D32)),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0A4429),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹$price / piece',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Counter
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            _buildCounterButton(
                              icon: Icons.remove_rounded,
                              onTap: () {
                                if (qty > 0) {
                                  setState(() => _quantities[name] = qty - 1);
                                }
                              },
                            ),
                            SizedBox(
                              width: 32,
                              child: Center(
                                child: Text(
                                  qty.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0A4429),
                                  ),
                                ),
                              ),
                            ),
                            _buildCounterButton(
                              icon: Icons.add_rounded,
                              onTap: () {
                                setState(() => _quantities[name] = qty + 1);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Add to Cart Bar
          if (_totalItems > 0)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  final cartProvider = CartProviderScope.of(context);
                  
                  final items = _getItemsForService();
                  for (var item in items) {
                    final name = item['name'] as String;
                    final qty = _quantities[name] ?? 0;
                    if (qty > 0) {
                      final price = item['price'] as int;
                      cartProvider.addToCart(CartItem(
                        id: 'service_${name.toLowerCase().replaceAll(' ', '_')}',
                        title: name,
                        unitPrice: price.toDouble(),
                        subtitle: '',
                        category: '',
                        image: '', 
                        quantity: qty,
                        shopId: 'service_${widget.serviceName.toLowerCase().replaceAll(' ', '_')}',
                        shopName: widget.serviceName,
                      ));
                    }
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added $_totalItems items to cart!'),
                      backgroundColor: const Color(0xFF0F9D58),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A4429),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add $_totalItems Items to Cart',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '₹$_totalPrice',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFA5D6A7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 20,
          color: const Color(0xFF0A4429),
        ),
      ),
    );
  }
}
