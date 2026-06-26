import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../core/config/api_config.dart';
import 'package:dio/dio.dart';
import '../../../core/api/api_provider.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../providers/notification_provider.dart';
import 'fcm_service.dart';

/// Singleton Socket.IO wrapper â€” connects once per session.
/// Uses the auth token in headers so the server can authenticate the client.
class SocketService {
  static const String _orderUpdateEvent = 'orderUpdate';
  static const String _riderAssignedEvent = 'riderAssigned';
  static const String _orderDeliveredEvent = 'orderDelivered';
  static const String _newOrderEvent =
      'newOrderAssigned'; // rider receives new order
  static const String _deliveryOtpEvent = 'DELIVERY_OTP';

  io.Socket? _socket;
  bool _initialized = false;
  final List<Map<String, dynamic>> _emitQueue = [];
  final Set<String> _activeRooms = {};
  final Dio _dio = Dio();
  ProviderContainer? _container;

  // â”€â”€ Connection â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> _wakeUpRender(String url) async {
    try {
      debugPrint('ðŸš€ Poking Render server to wake up: $url');
      // Just a quick HTTP ping to wake the server up
      await _dio.get(url, options: Options(receiveTimeout: const Duration(seconds: 5), sendTimeout: const Duration(seconds: 5)));
      debugPrint('âœ… Render Poked!');
    } catch (e) {
      // Ignore errors, we just need to hit the server
      debugPrint('âš ï¸ Render poke finished (likely 404/ignored): $e');
    }
  }

  Future<void> connect(SecureStorageService storage, [ProviderContainer? container]) async {
    if (_initialized && (_socket?.connected ?? false)) return;
    if (container != null) _container = container;

    final token = await storage.getAccessToken();
    final baseUrl = ApiConfig.socketUrl;
    final apiBaseUrl = ApiConfig.baseUrl;

    // 1. Poke Render/Backend (both API and Socket URLs) to wake up (background)
    _wakeUpRender(baseUrl);
    if (apiBaseUrl.isNotEmpty) {
      _wakeUpRender(apiBaseUrl);
    }

    // REMOVED: 12s delay. It's too long and causes "not working immediately" issues.
    // The socket's internal reconnection logic will handle it if the server is still booting.
    debugPrint('ðŸ”Œ Initializing socket for $baseUrl...');

    _socket?.disconnect();
    _socket?.dispose();

    final Map<String, dynamic> headers =
        token != null ? {'Authorization': 'Bearer $token'} : {};

    _socket = io.io(
      baseUrl,
      <String, dynamic>{
        'transports': ['websocket', 'polling'], // websocket first for speed
        'autoConnect': true,
        'extraHeaders': headers,
        'reconnection': true,
        'reconnectionAttempts': 50,
        'reconnectionDelay': 2000, // Reduced from 8000 for faster recovery
        'timeout': 60000, // 1 minute timeout
      },
    );


    _socket!.onConnect((_) {
      debugPrint('âœ… SocketService connected');
      _rejoinRooms();
      _flushQueue();
    });

    // Setup global notification listener (using .off() first to prevent duplicates on reconnect)
    _socket!.off('notification');
    _socket!.on('notification', (data) {
      debugPrint('ðŸ”” New Socket Notification: $data');
      if (_container != null) {
        _container!.invalidate(notificationsProvider);
      }
      
      // Show local notification if the app is in foreground
      try {
        final title = data['title'] ?? 'New Notification';
        final body = data['message'] ?? data['body'] ?? data['content'] ?? '';
        
        FCMService.showNotification(
          title: title, 
          body: body,
          data: Map<String, dynamic>.from(data),
        );
      } catch (e) {
        debugPrint('âŒ Error showing socket notification: $e');
      }
    });

    _socket!.onDisconnect((_) => debugPrint('ðŸ”Œ SocketService disconnected'));
    _socket!.onConnectError((err) {
      debugPrint('âš ï¸ SocketService connect error: $err');
    });
    _socket!.onError((err) => debugPrint('ðŸ’¥ SocketService error: $err'));

    // Reconnection logs
    _socket!.onReconnect((_) {
      debugPrint('â™»ï¸ SocketService reconnected');
      _rejoinRooms();
    });
    _socket!.onReconnectAttempt((count) =>
        debugPrint('ðŸ”„ SocketService reconnection attempt: $count'));
    _socket!.onReconnectError(
        (err) => debugPrint('âŒ SocketService reconnection error: $err'));
    _socket!.onReconnectFailed(
        (_) => debugPrint('ðŸ›‘ SocketService reconnection failed'));

    _initialized = true;
  }

  void _rejoinRooms() {
    if (_activeRooms.isEmpty) return;
    debugPrint('ðŸ”„ Rejoining ${_activeRooms.length} active rooms');
    for (final room in _activeRooms) {
      _socket?.emit('join', room);
    }
  }

  void _flushQueue() {
    if (_emitQueue.isEmpty) return;
    debugPrint('ðŸ“¤ Flushing ${_emitQueue.length} queued emits');
    final items = List<Map<String, dynamic>>.from(_emitQueue);
    _emitQueue.clear();
    for (final item in items) {
      _emit(item['event'], item['data']);
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _initialized = false;
  }

  bool get isConnected => _socket?.connected ?? false;

  // â”€â”€ Room Management â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// JOIN user room â€” call immediately after login for all-orders updates.
  /// `socket.emit("join", "user_{userId}")`
  void joinUserRoom(String userId) {
    final room = 'user_$userId';
    _activeRooms.add(room);
    _emit('join', room);
    debugPrint('ðŸ‘¤ Joined user room: $room');
  }

  void leaveUserRoom(String userId) {
    final room = 'user_$userId';
    _activeRooms.remove(room);
    _emit('leave', room);
    debugPrint('ðŸ‘¤ Left user room: $room');
  }

  /// JOIN rider room â€” rider receives new order assignments here.
  /// `socket.emit("join", "rider_{riderId}")`
  void joinRiderRoom(String riderId) {
    final room = 'rider_$riderId';
    _activeRooms.add(room);
    _emit('join', room);
    debugPrint('ðŸ›µ Joined rider room: $room');
  }

  void leaveRiderRoom(String riderId) {
    final room = 'rider_$riderId';
    _activeRooms.remove(room);
    _emit('leave', room);
    debugPrint('ðŸ›µ Left rider room: $room');
  }

  /// JOIN specific order room â€” for real-time status during tracking.
  /// `socket.emit("join", "order_{orderId}")`
  void joinOrderRoom(String orderId) {
    final room = 'order_$orderId';
    _activeRooms.add(room);
    _emit('join', room);
    debugPrint('ðŸ“¦ Joined order room: $room');
  }

  void leaveOrderRoom(String orderId) {
    final room = 'order_$orderId';
    _activeRooms.remove(room);
    _emit('leave', room);
  }

  /// JOIN retailer notifications room â€” for real-time app notifications.
  /// `socket.emit("join", "retailer_notifications_{userId}")`
  void joinRetailerNotificationRoom(String userId) {
    final room = 'retailer_notifications_$userId';
    _activeRooms.add(room);
    _emit('join', room);
    debugPrint('ðŸ”” Joined retailer notification room: $room');
  }

  void leaveRetailerNotificationRoom(String userId) {
    final room = 'retailer_notifications_$userId';
    _activeRooms.remove(room);
    _emit('leave', room);
    debugPrint('ðŸ”” Left retailer notification room: $room');
  }

  // â”€â”€ Rider location broadcasting â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Rider emits their GPS coordinates during active delivery.
  void emitRiderLocation({
    required String orderId,
    required double lat,
    required double lng,
  }) {
    _emit('riderLocation', {'orderId': orderId, 'lat': lat, 'lng': lng});
  }

  // â”€â”€ Listeners â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// `orderUpdate` â€” fires on every status change.
  /// Payload: `{ status: "Out for Delivery", orderId: "ORD-...", data: {...} }`
  /// `orderUpdate` â€” fires on every status change.
  /// Payload: `{ status: "Out for Delivery", orderId: "ORD-...", data: {...} }`
  void onOrderUpdate(void Function(dynamic) callback) {
    _socket?.on(_orderUpdateEvent, callback);
  }

  void offOrderUpdate([void Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off(_orderUpdateEvent, callback);
    } else {
      _socket?.off(_orderUpdateEvent);
    }
  }

  /// `riderAssigned` â€” fires when a rider is assigned to a user's order.
  /// Payload: `{ riderId, riderName, riderPhone, orderId }`
  void onRiderAssigned(void Function(dynamic) callback) {
    _socket?.on(_riderAssignedEvent, callback);
  }

  void offRiderAssigned([void Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off(_riderAssignedEvent, callback);
    } else {
      _socket?.off(_riderAssignedEvent);
    }
  }

  void onRiderLocation(void Function(dynamic) callback) {
    _socket?.on('riderLocation', callback);
  }

  void offRiderLocation([void Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off('riderLocation', callback);
    } else {
      _socket?.off('riderLocation');
    }
  }

  /// `newOrderAssigned` â€” fires on the RIDER side when a new order is dispatched.
  /// Payload: `{ orderId, customerName, deliveryAddress, ... }`
  void onNewOrderAssigned(void Function(dynamic) callback) {
    _socket?.on(_newOrderEvent, callback);
  }

  void offNewOrderAssigned([void Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off(_newOrderEvent, callback);
    } else {
      _socket?.off(_newOrderEvent);
    }
  }

  /// `shopStatusUpdate` â€” fires when a retailer toggles status.
  /// Payload: `{ shopId: "65e...", isShopActive: false }`
  void onShopStatusUpdate(void Function(dynamic) callback) {
    _socket?.on('shopStatusUpdate', callback);
  }

  void offShopStatusUpdate([void Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off('shopStatusUpdate', callback);
    } else {
      _socket?.off('shopStatusUpdate');
    }
  }

  /// `orderDelivered` â€” fires when an order is successfully delivered.
  /// Payload: `{ orderId: "...", products: [...] }`
  void onOrderDelivered(void Function(dynamic) callback) {
    _socket?.on(_orderDeliveredEvent, callback);
  }

  void offOrderDelivered([void Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off(_orderDeliveredEvent, callback);
    } else {
      _socket?.off(_orderDeliveredEvent);
    }
  }

  /// `notification` â€” fires when a new real-time notification is generated for the user.
  void onNotification(void Function(dynamic) callback) {
    _socket?.on('notification', callback);
  }

  void offNotification([void Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off('notification', callback);
    } else {
      _socket?.off('notification');
    }
  }

  /// `DELIVERY_OTP` â€” fires on the customer side when a rider requests OTP.
  /// Payload: `{ orderId: "#ABC12345", otp: "4821", expiresAt: "ISO-string" }`
  void onDeliveryOtp(void Function(dynamic) callback) {
    _socket?.on(_deliveryOtpEvent, callback);
  }

  void offDeliveryOtp([void Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off(_deliveryOtpEvent, callback);
    } else {
      _socket?.off(_deliveryOtpEvent);
    }
  }

  /// Generic remove listener.
  void offEvent(String event, [void Function(dynamic)? callback]) {
    if (callback != null) {
      _socket?.off(event, callback);
    } else {
      _socket?.off(event);
    }
  }

  // â”€â”€ Internal â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  void _emit(String event, dynamic data) {
    if (_socket == null || !isConnected) {
      debugPrint('â³ SocketService._emit queued â€” not connected ($event)');
      _emitQueue.add({'event': event, 'data': data});
      return;
    }
    _socket!.emit(event, data);
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
    _initialized = false;
  }
}

// â”€â”€ Provider â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();

  // Connect when the provider is first read
  final storage = ref.read(storageServiceProvider);
  service.connect(storage, ref.container);

  ref.onDispose(service.dispose);
  return service;
});
