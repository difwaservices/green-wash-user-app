import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shop_product_model.dart';
import '../models/food_models.dart';
import '../network/api_client.dart';
import 'package:flutter/foundation.dart';

/// Provider for ShopService
final shopServiceProvider = Provider<ShopService>((ref) {
  return ShopService(client: ref.watch(apiClientProvider));
});

/// Service layer for shops.

class ShopService {
  final ApiClient _client;

  ShopService({required ApiClient client}) : _client = client;

  Future<List<ShopModel>> getShops() async {
    try {
      final json = await _client.get(
        '${ApiClient.baseUrl}/shops',
        requiresAuth: true,
      );

      final raw = json['data'] as List<dynamic>? ?? [];
      return raw
          .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('ShopService: Error fetching shops: $e');
      return [];
    }
  }

  Future<List<ShopProduct>> getShopProducts(String shopId) async {
    try {
      final json = await _client.get(
        '${ApiClient.baseUrl}/shops/$shopId/products',
        requiresAuth: true,
      );
      final data = (json['data'] ?? json['products']) as List<dynamic>? ?? [];
      return data
          .map((e) => ShopProduct.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
          message:
              'Failed to fetch products for shop $shopId: ${e.toString()}');
    }
  }

  Future<List<FoodCategory>> getCategories() async {
    try {
      final json = await _client.get(
        '${ApiClient.baseUrl}/categories',
        requiresAuth: true,
      );
      final raw = json['data'] as List<dynamic>? ?? [];
      return raw
          .map((e) => FoodCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('ShopService: Error fetching categories: $e');
      return [];
    }
  }
}
