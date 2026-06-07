import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central configuration for API and Socket URLs.
/// All services should use these getters as the single source of truth.
class ApiConfig {
  static String get baseUrl {
    if (kDebugMode) {
      if (kIsWeb) return 'http://127.0.0.1:5001/api';
      return Platform.isAndroid
          ? 'http://192.168.1.10:5001/api'
          : 'http://127.0.0.1:5001/api';
    }
    return dotenv.env['API_BASE_URL'] ??
        'https://difwa-backend.up.railway.app/api';
  }

  static String get socketUrl {
    if (kDebugMode) {
      if (kIsWeb) return 'http://127.0.0.1:5001';
      return Platform.isAndroid
          ? 'http://192.168.1.10:5001'
          : 'http://127.0.0.1:5001';
    }
    return dotenv.env['SOCKET_URL'] ?? 'https://difwa-backend.up.railway.app';
  }
}
