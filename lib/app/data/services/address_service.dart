import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';

class AddressService {
  final ApiClient _client;

  AddressService(this._client);

  Future<dynamic> saveAddress({
    required String fullName,
    required String email,
    required String label,
    required String fullAddress,
    required String city,
    required String state,
    required String pincode,
    required bool isDefault,
    double? latitude,
    double? longitude,
  }) async {
    return await _client.post(
      '${ApiClient.baseUrl}/address',
      data: {
        "fullName": fullName,
        "email": email,
        "label": label,
        "fullAddress": fullAddress,
        "city": city,
        "state": state,
        "pincode": pincode,
        "isDefault": isDefault,
        if (latitude != null) "latitude": latitude,
        if (longitude != null) "longitude": longitude,
        // Match user's specific backend requirement (lat/lng)
        if (latitude != null) "lat": latitude,
        if (longitude != null) "lng": longitude,
        // Send as nested object for backend indexing (coordinates: {lat, lng})
        if (latitude != null && longitude != null)
          "coordinates": {
            "latitude": latitude,
            "longitude": longitude,
            "lat": latitude,
            "lng": longitude,
          },
      },
      requiresAuth: true,
    );
  }

  Future<dynamic> updateAddress({
    required String id,
    required String fullName,
    required String email,
    required String label,
    required String fullAddress,
    required String city,
    required String state,
    required String pincode,
    required bool isDefault,
    double? latitude,
    double? longitude,
  }) async {
    final payload = {
      "id": id,
      "_id": id, // Often expected by MongoDB backends
      "addressId": id, // Alternative common name
      "fullName": fullName,
      "email": email,
      "label": label,
      "fullAddress": fullAddress,
      "city": city,
      "state": state,
      "pincode": pincode,
      "isDefault": isDefault,
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
      // Match user's specific backend requirement (lat/lng)
      if (latitude != null) "lat": latitude,
      if (longitude != null) "lng": longitude,
      // Send as nested object for backend indexing (coordinates: {lat, lng})
      if (latitude != null && longitude != null)
        "coordinates": {
          "latitude": latitude,
          "longitude": longitude,
          "lat": latitude,
          "lng": longitude,
        },
    };

    if (kDebugMode) {
      debugPrint('ðŸ“ Updating Address: $id');
      debugPrint('ðŸ“ Payload: $payload');
    }

    try {
      final response = await _client.post(
        '${ApiClient.baseUrl}/address/update',
        data: payload,
        requiresAuth: true,
      );
      
      if (kDebugMode) {
        debugPrint('ðŸ“ Update Response: $response');
      }
      
      return response;
    } catch (e) {
      debugPrint('ðŸ“ Update Address Error: $e');
      rethrow;
    }
  }

  Future<dynamic> getAddresses() async {
    return await _client.get(
      '${ApiClient.baseUrl}/address',
      requiresAuth: true,
    );
  }

  Future<dynamic> deleteAddress(String id) async {
    return await _client.delete(
      '${ApiClient.baseUrl}/address/$id',
      requiresAuth: true,
    );
  }
}

final addressServiceProvider = Provider<AddressService>((ref) {
  return AddressService(ref.watch(apiClientProvider));
});
