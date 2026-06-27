import 'package:flutter/foundation.dart';
import '../models/food_models.dart';
import '../network/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for ProductService
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(client: ref.watch(apiClientProvider));
});

/// Service layer for products and categories.
class ProductService {
  final ApiClient _client;

  ProductService({required ApiClient client}) : _client = client;

  /// Fetch all product categories.
  /// Response shape: { "success": true, "categories": [...] }
  Future<List<FoodCategory>> getCategories() async {
    // Return hardcoded laundry categories instead of API water-related data
    return [
      const FoodCategory(id: 'c1', name: 'Wash & Fold', image: ''),
      const FoodCategory(id: 'c2', name: 'Dry Clean', image: ''),
      const FoodCategory(id: 'c3', name: 'Ironing', image: ''),
      const FoodCategory(id: 'c4', name: 'Premium Care', image: ''),
      const FoodCategory(id: 'c5', name: 'Blankets', image: ''),
      const FoodCategory(id: 'c6', name: 'Shoe Care', image: ''),
      const FoodCategory(id: 'c7', name: 'Stain Removal', image: ''),
    ];
  }

  static List<FoodCategory> _parseCategories(List<dynamic> data) {
    return data
        .map((e) => FoodCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch products, optionally filtered by category.
  /// Returns an empty list if the endpoint is not yet available (404),
  /// so the UI can fall back to local data silently.
  Future<List<Product>> getProducts({String? category}) async {
    try {
      final queryParams = category != null ? {'category': category} : null;
      final json = await _client.get(
        '${ApiClient.baseUrl}/products',
        queryParameters: queryParams,
        requiresAuth: false,
      );
      
      final rawData = (json['products'] ?? json['data']) as List<dynamic>? ?? [];
      
      // Senior Dev: Offload mapping of large product lists to BACKGROUND isolate
      return await compute(_parseProducts, rawData);
    } on ApiException catch (e) {
      if (e.statusCode == 404) return [];
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Unexpected error: ${e.toString()}');
    }
  }

  static List<Product> _parseProducts(List<dynamic> data) {
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
