import 'package:flutter/material.dart';
import '../../../widgets/common_card.dart';
import '../../../core/constants/app_images.dart';

class VegetablesPage extends StatelessWidget {
  const VegetablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        'title': '20L Mineral Jar',
        'price': '₹80.00',
        'subtitle': 'Premium RO+UV',
        'image': AppImages.water20L,
        'hasCounter': false,
        'isFavorite': false,
        'badgeText': 'HOT',
        'badgeColor': const Color(0xFFFFCDD2),
        'badgeTextColor': const Color(0xFFE53935),
      },
      {
        'title': '1L Bottle',
        'price': '₹20.00',
        'subtitle': 'Pack of 1',
        'image': AppImages.waterSmall,
        'hasCounter': true,
        'isFavorite': false,
        'badgeText': 'NEW',
        'badgeColor': const Color(0xFFFFECB3),
        'badgeTextColor': const Color(0xFFFF9800),
      },
      {
        'title': 'Dispenser Tap',
        'price': '₹150.00',
        'subtitle': 'Food Grade',
        'image': AppImages.bottleIcon,
        'hasCounter': false,
        'isFavorite': true,
        'badgeText': null,
      },
      {
        'title': 'Automatic Pump',
        'price': '₹299.00',
        'subtitle': 'USB Rechargeable',
        'image': AppImages.water20L,
        'hasCounter': false,
        'isFavorite': false,
        'badgeText': '-16%',
        'badgeColor': const Color(0xFFFFCDD2),
        'badgeTextColor': const Color(0xFFE53935),
      },
      {
        'title': 'Bottle Stand',
        'price': '₹499.00',
        'subtitle': 'Metal Frame',
        'image': AppImages.waterSmall,
        'hasCounter': true,
        'isFavorite': false,
        'badgeText': 'NEW',
        'badgeColor': const Color(0xFFFFECB3),
        'badgeTextColor': const Color(0xFFFF9800),
      },
      {
        'title': 'Cleaning Kit',
        'price': '₹99.00',
        'subtitle': '3-Piece Set',
        'image': AppImages.bottleIcon,
        'hasCounter': false,
        'isFavorite': true,
        'badgeText': null,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Water & Accessories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final int crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);
            final double itemWidth = (screenWidth - (crossAxisCount - 1) * 16) / crossAxisCount;
            final double targetHeight = (itemWidth * 1.5).clamp(230.0, 265.0);
            final double childAspectRatio = itemWidth / targetHeight;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return CommonCard(
              title: product['title'],
              price: product['price'],
              subtitle: product['subtitle'],
              image: product['image'],
              hasCounter: product['hasCounter'],
              isFavorite: product['isFavorite'],
              badgeText: product['badgeText'],
              badgeColor: product['badgeColor'],
              badgeTextColor: product['badgeTextColor'],
            );
          },
        );
      },
    ),
  ),
);
  }
}
