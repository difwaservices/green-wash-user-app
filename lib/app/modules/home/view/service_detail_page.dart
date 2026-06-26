import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/db_service.dart';
import '../../../data/models/product_model.dart';

class ServiceDetailPage extends StatefulWidget {
  final String serviceName;

  const ServiceDetailPage({super.key, required this.serviceName});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  final Map<String, int> _itemQuantities = {};

  void _incrementQuantity(String itemName) {
    setState(() {
      _itemQuantities[itemName] = (_itemQuantities[itemName] ?? 0) + 1;
    });
  }

  void _decrementQuantity(String itemName) {
    setState(() {
      int currentQuantity = _itemQuantities[itemName] ?? 0;
      if (currentQuantity > 0) {
        _itemQuantities[itemName] = currentQuantity - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          widget.serviceName,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.3),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_laundry_service, size: 60, color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Premium ${widget.serviceName}',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildItemCard("Men's Shirt", 'â‚¹40', Icons.checkroom),
                  const SizedBox(height: 12),
                  _buildItemCard('T-Shirt', 'â‚¹30', Icons.checkroom),
                  const SizedBox(height: 12),
                  _buildItemCard('Trousers / Jeans', 'â‚¹50', Icons.airline_seat_legroom_extra),
                  const SizedBox(height: 12),
                  _buildItemCard('Bedsheet', 'â‚¹80', Icons.bed),
                  const SizedBox(height: 12),
                  _buildItemCard('Blanket', 'â‚¹150', Icons.ac_unit),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              final cart = CartProviderScope.of(context);
              int totalAdded = 0;
              
              _itemQuantities.forEach((name, quantity) {
                if (quantity > 0) {
                  double price = 0;
                  if (name == "Men's Shirt") price = 40.0;
                  else if (name == 'T-Shirt') price = 30.0;
                  else if (name == 'Trousers / Jeans') price = 50.0;
                  else if (name == 'Bedsheet') price = 80.0;
                  else if (name == 'Blanket') price = 150.0;

                  final item = CartItem(
                    id: 'svc_${name.replaceAll(' ', '_').toLowerCase()}',
                    title: name,
                    unitPrice: price,
                    subtitle: widget.serviceName,
                    image: '', 
                    category: 'Service',
                    shopId: 'green_wash_co_services',
                    shopName: 'Green Wash Co. Services',
                    quantity: quantity,
                  );
                  cart.addToCart(item);
                  totalAdded += quantity;
                }
              });

              if (totalAdded > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$totalAdded Items added to cart!')),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select at least one item')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continue to Cart',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(String name, String price, IconData icon) {
    int quantity = _itemQuantities[name] ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: () => _decrementQuantity(name),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
                Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                  onPressed: () => _incrementQuantity(name),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
