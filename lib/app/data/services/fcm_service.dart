import 'package:flutter/material.dart';
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

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
          payload: message.data.toString(),
        );
      }
    });

    // Handle interaction when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔔 Notification caused app to open from background!');
      _handleNotificationClick(message);
    });

    // Handle interaction when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('🔔 Notification caused app to open from terminated state!');
        _handleNotificationClick(message);
      }
    });

    listenToTokenRefresh();

    // Initial token send (if user is already logged in)
    await sendTokenToBackend();

    debugPrint('✅ FCMService initialized (Real Firebase)');
  }

  static void _handleNotificationClick(RemoteMessage message) {
    debugPrint('🔔 Navigating from notification: ${message.data}');
    
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Example based on common FCM payloads
    final type = message.data['type'];
    final id = message.data['id'] ?? message.data['orderId'];

    if (type == 'ORDER' || type == 'NEW_ORDER') {
      Navigator.pushNamed(context, '/track-order', arguments: {'orderId': id});
    } else if (type == 'RIDER_ORDER') {
      Navigator.pushNamed(context, '/rider-order-details', arguments: {'orderId': id});
    } else if (type == 'WALLET') {
      Navigator.pushNamed(context, '/wallet');
    }
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

      final client = ApiClient.createDefault();
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

