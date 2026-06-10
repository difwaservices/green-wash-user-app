import 'dart:async';
import 'package:flutter/material.dart';
import 'connection_listener.dart';
import '../widgets/ds_offline_banner.dart';

class OfflineBuilder extends StatefulWidget {
  final Widget child;

  const OfflineBuilder({
    super.key,
    required this.child,
  });

  @override
  State<OfflineBuilder> createState() => _OfflineBuilderState();
}

class _OfflineBuilderState extends State<OfflineBuilder> {
  late StreamSubscription<bool> _subscription;
  bool _isOnline = true;
  bool _showBackOnline = false;

  @override
  void initState() {
    super.initState();
    _isOnline = ConnectionListener.instance.isOnline;
    
    // Ensure initialized
    ConnectionListener.instance.initialize();
    
    _subscription = ConnectionListener.instance.onConnectivityChanged.listen((online) {
      if (mounted) {
        setState(() {
          if (!_isOnline && online) {
            // transitioned from offline to online
            _showBackOnline = true;
            Future.delayed(const Duration(milliseconds: 2500), () {
              if (mounted) {
                setState(() {
                  _showBackOnline = false;
                });
              }
            });
          }
          _isOnline = online;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which banner to show and if we should slide it in
    final bool showBanner = !_isOnline || _showBackOnline;
    final bool isBackOnline = _showBackOnline;

    return Stack(
      children: [
        // Ensure child shrinks slightly or adds padding at bottom to avoid overlapping content
        Padding(
          padding: EdgeInsets.only(bottom: showBanner ? 40.0 : 0.0),
          child: widget.child,
        ),
        
        // Sliding status banner
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          bottom: showBanner ? 0 : -60,
          child: DsOfflineBanner(isBackOnline: isBackOnline),
        ),
      ],
    );
  }
}
