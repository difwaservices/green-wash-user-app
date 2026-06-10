import 'food_models.dart';

class CartItem {
  final String id;
  final String title;
  final double unitPrice;
  final String subtitle;
  final String image;
  final String category;
  final String? shopId;
  final String? shopName;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.unitPrice,
    required this.subtitle,
    required this.image,
    required this.category,
    this.shopId,
    this.shopName,
    this.quantity = 1,
  });

  factory CartItem.fromProduct(Product product) {
    return CartItem(
      id: product.id,
      title: product.name,
      unitPrice: product.price,
      subtitle: product.weight,
      image: product.image,
      category: product.category,
      shopId: product.shopId,
      shopName: product.shopName,
    );
  }

  double get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'unitPrice': unitPrice,
      'subtitle': subtitle,
      'image': image,
      'category': category,
      'shopId': shopId,
      'shopName': shopName,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      unitPrice: (json['unitPrice'] as num? ?? 0.0).toDouble(),
      subtitle: (json['subtitle'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      shopId: json['shopId']?.toString(),
      shopName: json['shopName']?.toString(),
      quantity: (json['quantity'] as num? ?? 1).toInt(),
    );
  }
}

/// Alias for future migration clarity.
typedef ProductModel = CartItem;
