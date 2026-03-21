import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../network/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';

/// Stub FCMService without Firebase Cloud Messaging
/// Uses local notifications only
class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'Difwabite_high_importance',
    'Difwabite Notifications',
    description: 'Important notifications for orders, OTPs, and updates',
    importance: Importance.max,
  );

  // ── Initialise (call once from main.dart) ────

  static Future<void> init() async {
    // Create Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Init local notifications plugin
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotifications.initialize(
      const InitializationSettings(
          android: androidSettings, iOS: iosSettings),
    );

    debugPrint('✅ FCMService initialized (Local notifications only)');
  }

  // ── Permission ─────────────────────────────────────────────────────────────

  Future<void> requestPermission() async {
    debugPrint('🔔 Local notifications permission granted');
  }

  // ── Token ──────────────────────────────────────────────────────────────────

  /// Returns a stub token for local notifications
  Future<String?> getToken() async {
    try {
      final deviceId = '${Platform.operatingSystem}_${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('📱 Device Token (Local): $deviceId');
      return deviceId;
    } catch (e) {
      debugPrint('❌ Error getting device token: $e');
      return null;
    }
  }

  // ── Send token to backend ─────────────────────────────────────────────────

  /// Call this after login/register to register the device token with the server.
  static Future<void> sendTokenToBackend() async {
    try {
      final token = await FCMService().getToken();
      if (token == null) return;

      // Use the existing API client's token
      final storage = SecureStorageService();
      final authToken = await storage.getAccessToken();
      if (authToken == null) return;

      final client = ApiClient();
      await client.post(
        '${ApiClient.baseUrl}/update-fcm-token',
        data: {'fcmToken': token},
        requiresAuth: true,
      );
      debugPrint('✅ Device token sent to backend');
    } catch (e) {
      debugPrint('⚠️ Failed to send device token to backend: $e');
      // Non-blocking — no rethrow
    }
  }

  /// Listen to token refresh (stub - not used without FCM)
  static void listenToTokenRefresh() {
    debugPrint('🔄 Token refresh listener initialized (local only)');
  }

  // ── Show local notification ────────────────────────────────────────────────

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await _localNotifications.show(
        title.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: payload,
      );
      debugPrint('🔔 Local notification shown: $title');
    } catch (e) {
      debugPrint('❌ Error showing notification: $e');
    }
  }
}
