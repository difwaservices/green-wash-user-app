import 'package:flutter/foundation.dart';
import 'dart:io';

// https://difwa-backend.onrender.com/api
final LiveUrl = 'https://difwa-backend.up.railway.app/api';

final LocalUrl = Platform.isAndroid
    ? 'http://10.0.2.2:5001/api'
    : 'http://127.0.0.1:5001/api';

class ApiConfig {
  static String get baseUrl {
    if (kDebugMode) {
      return LocalUrl;
    }
    return LiveUrl;
  }

  static String get socketUrl {
    if (kDebugMode) {
      return LocalUrl;
    }
    return LiveUrl;
  }
}
