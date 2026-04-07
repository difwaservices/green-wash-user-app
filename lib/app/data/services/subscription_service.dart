import '../models/subscription_model.dart';
import '../network/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for SubscriptionService
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService(client: ref.watch(apiClientProvider));
});

/// Notifier for fetching and managing user subscriptions with optimistic updates
final mySubscriptionsProvider =
    AsyncNotifierProvider<SubscriptionNotifier, List<UserSubscription>>(
        SubscriptionNotifier.new);

class SubscriptionNotifier extends AsyncNotifier<List<UserSubscription>> {
  @override
  Future<List<UserSubscription>> build() async {
    return ref.watch(subscriptionServiceProvider).getMySubscriptions();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(subscriptionServiceProvider).getMySubscriptions());
  }

  Future<bool> updateStatus(String subId, String status) async {
    final oldState = state;
    if (state.hasValue) {
      state = AsyncValue.data(state.value!.map((s) {
        if (s.id == subId) {
          return s.copyWith(status: status);
        }
        return s;
      }).toList());
    }

    final success =
        await ref.read(subscriptionServiceProvider).updateStatus(subId, status);
    if (!success) {
      state = oldState; // Rollback on failure
    } else {
      refresh();
    }
    return success;
  }

  Future<Map<String, dynamic>> updateVacation({
    required String subscriptionId,
    required DateTime startDate,
    required DateTime endDate,
    bool isReset = false,
  }) async {
    final oldState = state;
    
    // Track if this is a single day resume action for the backend
    bool isResume = false;

    // Optimistic update for instant visual feedback
    if (state.hasValue) {
      state = AsyncValue.data(state.value!.map((s) {
        if (s.id == subscriptionId) {
          if (isReset) {
            // Complete reset from tomorrow onwards. Retain past and current day 
            // if they were already part of the vacation.
            final startDay = DateTime(startDate.year, startDate.month, startDate.day);
            final retainedDates = s.vacationDates.where((vd) {
              final vDay = DateTime(vd.year, vd.month, vd.day);
              return vDay.isBefore(startDay);
            }).toList();
            return s.copyWith(vacationDates: retainedDates);
          } else if (startDate == endDate) {
            // Single day toggle (Pause/Resume Tomorrow)
            final startDay = DateTime(startDate.year, startDate.month, startDate.day);
            final existingIndex = s.vacationDates.indexWhere((vd) =>
                DateTime(vd.year, vd.month, vd.day) == startDay);

            if (existingIndex != -1) {
              // OPTIMISTIC REMOVE (Resume)
              isResume = true;
              final newList = List<DateTime>.from(s.vacationDates)
                ..removeAt(existingIndex);
              return s.copyWith(vacationDates: newList);
            } else {
              // OPTIMISTIC ADD (Pause)
              return s.copyWith(
                  vacationDates: [...s.vacationDates, startDate]);
            }
          } else {
            // ADDS rangeDates to vacationDates (for setting new ranges)
            final rangeDates = <DateTime>[];
            var current = DateTime(startDate.year, startDate.month, startDate.day);
            final endDay = DateTime(endDate.year, endDate.month, endDate.day);
            
            while (!current.isAfter(endDay)) {
              if (!s.vacationDates.any((vd) => 
                  vd.year == current.year && vd.month == current.month && vd.day == current.day)) {
                rangeDates.add(current);
              }
              current = current.add(const Duration(days: 1));
            }

            return s.copyWith(
                vacationDates: [...s.vacationDates, ...rangeDates]);
          }
        }
        return s;
      }).toList());
    }

    final res = await ref.read(subscriptionServiceProvider).updateVacation(
          subscriptionId: subscriptionId,
          startDate: startDate,
          endDate: endDate,
          isReset: isReset,
          isResume: isResume,
        );

    if (res['success'] == true) {
      refresh();
    } else {
      state = oldState; // Rollback on failure
    }
    return res;
  }
}

/// Service layer for subscriptions.
class SubscriptionService {
  final ApiClient _client;

  SubscriptionService({ApiClient? client}) : _client = client ?? ApiClient.createDefault();

  /// Fetch all available subscription plans.
  Future<List<SubscriptionPlan>> getSubscriptions() async {
    try {
      final json = await _client.get('${ApiClient.subscriptionBaseUrl}/',
          requiresAuth: true);
      final success = json['success'] as bool? ?? false;
      if (!success) {
        throw ApiException(
            message:
                json['message']?.toString() ?? 'Failed to load subscriptions');
      }
      final data = json['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Fetch user's active subscriptions.
  Future<List<UserSubscription>> getMySubscriptions() async {
    try {
      final json = await _client.get('${ApiClient.subscriptionBaseUrl}/my',
          requiresAuth: true);
      final success = json['success'] as bool? ?? false;
      if (!success) {
        throw ApiException(
            message: json['message']?.toString() ??
                'Failed to load user subscriptions');
      }
      final data = json['subscriptions'] as List<dynamic>? ?? [];
      return data
          .map((e) => UserSubscription.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Create a new subscription for a product.
  Future<Map<String, dynamic>> subscribeToProduct({
    required String productId,
    required String frequency,
    required int quantity,
    List<String> customDays = const [],
    DateTime? startDate,
    String? deliverySlot,
  }) async {
    try {
      final payload = {
        'productId': productId,
        'frequency': frequency,
        'quantity': quantity,
        'customDays': customDays,
        'startDate': startDate?.toIso8601String(),
        if (deliverySlot != null) 'deliverySlot': deliverySlot,
      };

      final json = await _client.post(
        '${ApiClient.subscriptionBaseUrl}/subscribe',
        data: payload,
        requiresAuth: true,
      );

      return {
        'success': json['success'] as bool? ?? false,
        'message': json['message']?.toString() ?? 'Subscription successful',
        'data': json['subscription'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Pause or Resume a subscription.
  Future<bool> updateStatus(String subscriptionId, String status) async {
    try {
      final json = await _client.patch(
        '${ApiClient.subscriptionBaseUrl}/status',
        data: {'subscriptionId': subscriptionId, 'status': status},
        requiresAuth: true,
      );
      return json['success'] as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Schedule vacation (pause delivery for a range).
  Future<Map<String, dynamic>> updateVacation({
    required String subscriptionId,
    required DateTime startDate,
    required DateTime endDate,
    bool isReset = false,
    bool isResume = false,
  }) async {
    try {
      // Normalize dates to midnight to avoid time-zone/comparison issues
      final normalizedStart =
          DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEnd =
          DateTime(endDate.year, endDate.month, endDate.day);

      final json = await _client.post(
        '${ApiClient.subscriptionBaseUrl}/vacation',
        data: {
          'subscriptionId': subscriptionId,
          'startDate': normalizedStart.toIso8601String(),
          'endDate': normalizedEnd.toIso8601String(),
          if (isReset) 'isReset': true,
          if (isResume) 'isResume': true,
        },
        requiresAuth: true,
      );
      return {
        'success': json['success'] as bool? ?? false,
        'message': json['message']?.toString() ?? 'Vacation updated',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
