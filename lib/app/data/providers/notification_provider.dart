import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../models/notification_model.dart';

class NotificationsNotifier extends AsyncNotifier<List<NotificationModel>> {
  @override
  Future<List<NotificationModel>> build() async {
    final client = ref.read(apiClientProvider);
    try {
      final response = await client.get('/app/notifications', requiresAuth: true);
      final List<dynamic> list = response['data'] as List<dynamic>;
      return list.map((n) => NotificationModel.fromJson(n)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> markAllAsRead() async {
    final previousState = state;
    final currentList = state.value ?? [];
    
    // 1. Optimistic update
    final updatedList = currentList.map((n) => n.copyWith(isRead: true)).toList();
    state = AsyncValue.data(updatedList);
    
    try {
      final client = ref.read(apiClientProvider);
      await client.put('/app/notifications/mark-all-read', requiresAuth: true);
      // Let backend state resync silently
      ref.invalidateSelf();
    } catch (e) {
      // Revert if API fails
      state = previousState;
      rethrow;
    }
  }

  Future<void> markAsRead(String id) async {
    final previousState = state;
    final currentList = state.value ?? [];
    
    // 1. Optimistic update
    final updatedList = currentList.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
    state = AsyncValue.data(updatedList);
    
    try {
      final client = ref.read(apiClientProvider);
      await client.put('/app/notifications/$id/read', requiresAuth: true);
      ref.invalidateSelf();
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> deleteNotification(String id) async {
    final previousState = state;
    final currentList = state.value ?? [];
    
    // 1. Optimistic update
    final updatedList = currentList.where((n) => n.id != id).toList();
    state = AsyncValue.data(updatedList);
    
    try {
      final client = ref.read(apiClientProvider);
      await client.delete('/app/notifications/$id', requiresAuth: true);
      ref.invalidateSelf();
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> deleteSelected(List<String> ids) async {
    final previousState = state;
    final currentList = state.value ?? [];
    
    // 1. Optimistic update
    final updatedList = currentList.where((n) => !ids.contains(n.id)).toList();
    state = AsyncValue.data(updatedList);
    
    try {
      final client = ref.read(apiClientProvider);
      for (final id in ids) {
        try {
          await client.delete('/app/notifications/$id', requiresAuth: true);
        } catch (_) {}
      }
      ref.invalidateSelf();
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationModel>>(() {
  return NotificationsNotifier();
});

final unreadNotificationsCountProvider = Provider.autoDispose<int>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  return notificationsAsync.maybeWhen(
    data: (list) => list.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
});
