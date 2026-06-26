import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../models/product_model.dart';

/// Provider for CartService
final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(client: ref.watch(apiClientProvider));
});

class CartService {
  final ApiClient _client;

  CartService({required ApiClient client}) : _client = client;

  // â”€â”€ Fetch Cart â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// GET /api/app/cart (requires auth token)
  Future<List<CartItem>> getCart() async {
    try {
      final json = await _client.get(
        '${ApiClient.baseUrl}/cart',
        requiresAuth: true,
      );

      if (json == null || json['cart'] == null) return [];

      List<dynamic> data = [];
      final cartObj = json['cart'];
      if (cartObj is List) {
        data = cartObj;
      } else if (cartObj is Map) {
        final items = cartObj['items'] ?? cartObj['products'] ?? [];
        if (items is List) data = items;
      }

      final mapped = data
          .map((e) => _mapToCartItem(Map<String, dynamic>.from(e)))
          .where((item) => item.id.isNotEmpty && item.quantity > 0)
          .toList();
      
      debugPrint('CartService: Fetched ${mapped.length} valid items from API cart');
      return mapped;
    } catch (e) {
      print('CartService: Error fetching cart: $e');
      return [];
    }
  }

  // â”€â”€ Add to Cart â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// POST /api/app/cart/add (requires auth token)
  Future<bool> addToCart(String productId, int quantity) async {
    try {
      final response = await _client.post(
        '${ApiClient.baseUrl}/cart/add',
        data: {
          'productId': productId,
          'quantity': quantity,
        },
        requiresAuth: true,
      );
      return response != null;
    } catch (e) {
      debugPrint('CartService: Error adding to cart (Backend rejected it): $e');
      throw Exception('Backend failed to add item: $e');
    }
  }

  // â”€â”€ Update Cart Item â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// PUT /api/app/cart/update (requires auth token)
  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      await _client.put(
        '${ApiClient.baseUrl}/cart/update',
        data: {
          'productId': productId,
          'quantity': quantity,
        },
        requiresAuth: true,
      );
    } catch (e) {
      print('CartService: Error updating quantity: $e');
    }
  }

  // â”€â”€ Remove from Cart â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// DELETE /api/app/cart/remove/:productId (requires auth token)
  Future<void> removeFromCart(String productId) async {
    try {
      await _client.delete(
        '${ApiClient.baseUrl}/cart/remove/$productId',
        requiresAuth: true,
      );
    } catch (e) {
      // SILENT FAIL
    }
  }

  // â”€â”€ Clear Cart â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// DELETE /api/app/cart/clear (requires auth token)
  Future<void> clearCart() async {
    try {
      await _client.delete(
        '${ApiClient.baseUrl}/cart/clear',
        requiresAuth: true,
      );
    } catch (e) {
      // SILENT FAIL
    }
  }

  // â”€â”€ Mapper â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  CartItem _mapToCartItem(Map<String, dynamic> json) {
    // Backend may return nested product details or flat structure
    final Map<String, dynamic> p =
        json['product'] is Map ? json['product'] : json;

    final mappedId =
        (p['_id'] ?? p['id'] ?? json['productId'] ?? '').toString();
    final mappedShopId = _extractId(
      json['retailerId'] ??
          json['shopId'] ??
          p['retailerId'] ??
          p['retailer'],
    );

    debugPrint(
      '[CartAPI] productId=$mappedId shopId=$mappedShopId '
      'productField=${json['product'].runtimeType} '
      'rawRetailer=${p['retailer']} rawRetailerId=${json['retailerId']}',
    );

    return CartItem(
      id: mappedId,
      title: (p['name'] ?? p['productName'] ?? json['productName'] ?? '')
          .toString(),
      unitPrice: (json['price'] as num?)?.toDouble() ??
          (p['price'] as num?)?.toDouble() ??
          0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      subtitle:
          (p['category'] is Map ? p['category']['name'] : (p['category'] ?? ''))
              .toString(),
      image: (p['image'] ??
              p['imageUrl'] ??
              (p['images'] is List && p['images'].isNotEmpty
                  ? p['images'][0]
                  : ''))
          .toString(),
      category: (p['type'] ?? json['type'] ?? 'standard').toString(),
      shopId: mappedShopId,
      shopName: (json['retailerName'] ?? json['shopName'] ?? '').toString(),
    );
  }

  /// Extracts a string ID from a value that may be a String or a populated Map.
  static String _extractId(dynamic value) {
    if (value == null) return '';
    if (value is Map) {
      return (value['_id'] ?? value['id'] ?? '').toString();
    }
    return value.toString();
  }
}
