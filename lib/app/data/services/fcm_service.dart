import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../network/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationChannel(
    'difwa_high_importance',
    'Difwa Notifications',
    description: 'Important notifications for orders, OTPs, and updates',
    importance: Importance.max,
  );

  static Future<void> init() async {
    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Create Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

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

    // Request permissions
    await FCMService().requestPermission();

    // Foreground listening
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔔 Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        showNotification(
          title: message.notification!.title ?? 'New Notification',
          body: message.notification!.body ?? '',
        );
      }
    });

    listenToTokenRefresh();

    debugPrint('✅ FCMService initialized (Real Firebase)');
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('🔔 User granted permission: ${settings.authorizationStatus}');
  }

  Future<String?> getToken() async {
    try {
      final String? token = await FirebaseMessaging.instance.getToken();
      debugPrint('📱 FCM Device Token: $token');
      return token;
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      return null;
    }
  }

  static Future<void> sendTokenToBackend() async {
    try {
      final token = await FCMService().getToken();
      if (token == null) return;

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
    }
  }

  static void listenToTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
       debugPrint('🔄 FCM Token refreshed!');
       // Optional: Send to backend immediately if logged in
       await sendTokenToBackend();
    });
  }

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
    } catch (e) {
      debugPrint('❌ Error showing local notification: $e');
    }
  }
}

