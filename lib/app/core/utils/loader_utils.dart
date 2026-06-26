import 'dart:async';
import 'package:flutter/material.dart';

class LoaderUtils {
  /// Wraps an API call with a minimum execution time of 900ms.
  /// Purpose: Prevents skeleton loader flickering for very fast APIs.
  static Future<T> wrapWithSkeleton<T>(Future<T> Function() call, {int minDelayMs = 900}) async {
    final startTime = DateTime.now();
    try {
      final result = await call();
      final endTime = DateTime.now();
      final elapsed = endTime.difference(startTime).inMilliseconds;
      
      if (elapsed < minDelayMs) {
        await Future.delayed(Duration(milliseconds: minDelayMs - elapsed));
      }
      return result;
    } catch (e) {
      // Still respect minimum time for errors to avoid UI jumps
      final endTime = DateTime.now();
      final elapsed = endTime.difference(startTime).inMilliseconds;
      if (elapsed < minDelayMs) {
        await Future.delayed(Duration(milliseconds: minDelayMs - elapsed));
      }
      rethrow;
    }
  }

  /// Executes an action and only shows a loading indicator if it takes more than [delayShowMs].
  /// Purpose: Prevents "flashing" loaders for fast mutations.
  static Future<T> timedAction<T>(
    BuildContext context, 
    Future<T> Function() action, {
    int delayShowMs = 300,
  }) async {
    bool isStillRunning = true;
    bool isLoaderShowing = false;

    // Start the timer to show loader
    Future.delayed(Duration(milliseconds: delayShowMs), () {
      if (isStillRunning && context.mounted) {
        isLoaderShowing = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const Center(
            child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
          ),
        );
      }
    });

    try {
      final result = await action();
      return result;
    } finally {
      isStillRunning = false;
      if (isLoaderShowing && context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
