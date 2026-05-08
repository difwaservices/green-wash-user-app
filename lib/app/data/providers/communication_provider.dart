import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../models/communication_model.dart';

final communicationProvider = FutureProvider.autoDispose<List<CommunicationModel>>((ref) async {
  final client = ref.read(apiClientProvider);
  try {
    // Attempting to fetch broadcast notifications. 
    // The user provided /communication/notify-all as the source of data.
    // We'll try GET first as it's standard for fetching lists.
    final response = await client.get('/communication/notify-all', requiresAuth: true);
    
    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> list = response['data'] as List<dynamic>;
      return list.map((n) => CommunicationModel.fromJson(n)).toList();
    }
    return [];
  } catch (e) {
    // If GET fails or returns empty, we might try another fallback or return empty
    return [];
  }
});
