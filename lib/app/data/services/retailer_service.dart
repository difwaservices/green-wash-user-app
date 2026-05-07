import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import 'package:flutter/foundation.dart';

class RetailerService {
  final ApiClient _apiClient;

  RetailerService(this._apiClient);

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _apiClient.get(
        '/retailer/dashboard-stats',
        requiresAuth: true,
      );
      return response['data'] ?? response;
    } catch (e) {
      debugPrint('Error fetching retailer stats: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getRetailerIncome() async {
    try {
      final response = await _apiClient.get(
        '/delivery-charge/retailer-income',
        requiresAuth: true,
      );
      return response['data'] ?? response;
    } catch (e) {
      debugPrint('Error fetching retailer income: $e');
      return {};
    }
  }

  Future<List<dynamic>> getRetailerProducts() async {
    try {
      final response = await _apiClient.get(
        '/retailer/products',
        requiresAuth: true,
      );
      return response['data'] ?? response['products'] ?? [];
    } catch (e) {
      debugPrint('Error fetching retailer products: $e');
      return [];
    }
  }
}

final retailerServiceProvider = Provider<RetailerService>((ref) {
  return RetailerService(ref.watch(apiClientProvider));
});
