import 'dart:async';
import 'dart:io';

/// A pure-Dart connectivity monitor that checks if the device has actual internet access.
/// Avoids external plugins while maintaining high reliability and fast check cycles.
class ConnectionListener {
  ConnectionListener._();
  static final ConnectionListener instance = ConnectionListener._();

  final _statusController = StreamController<bool>.broadcast();
  Timer? _timer;
  bool _isOnline = true;
  bool _initialized = false;

  /// Sync access to current network status
  bool get isOnline => _isOnline;

  /// Stream to listen to real-time connectivity changes
  Stream<bool> get onConnectivityChanged => _statusController.stream;

  /// Initiates periodic connectivity checking. Safe to call multiple times.
  void initialize() {
    if (_initialized) return;
    _initialized = true;
    
    // Immediate check
    _checkStatus();
    
    // Check every 6 seconds to capture drops quickly without battery drain
    _timer = Timer.periodic(const Duration(seconds: 6), (_) => _checkStatus());
  }

  /// Manually force a connection re-check
  Future<bool> forceCheck() async {
    return await _checkStatus();
  }

  /// Cancels checks and closes streams.
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _initialized = false;
    _statusController.close();
  }

  Future<bool> _checkStatus() async {
    bool previous = _isOnline;
    try {
      // Lookup google.com. If success, internet is active.
      // Set short timeout (3.5s) to avoid UI hang in poor networks.
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(milliseconds: 3500));
      
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      // In Web, InternetAddress.lookup might not be supported or fail depending on settings.
      // Provide a fallback check.
      _isOnline = false;
    }

    if (previous != _isOnline) {
      _statusController.add(_isOnline);
    }
    return _isOnline;
  }
}
