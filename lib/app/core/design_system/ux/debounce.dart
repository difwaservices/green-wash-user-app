import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility to delay executing a callback until a specified duration has passed
/// without any new invocations. Highly useful for search inputs or scrolling.
class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce({this.delay = const Duration(milliseconds: 300)});

  /// Runs the provided [action] after the configured delay.
  /// If run is called again before the delay completes, the previous timer is cancelled.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any active pending timer.
  void cancel() {
    _timer?.cancel();
  }
}
