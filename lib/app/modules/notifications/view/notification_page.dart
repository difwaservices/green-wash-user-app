import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/network/api_client.dart';
import '../../../data/providers/notification_provider.dart';
import '../../../data/models/notification_model.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  final Set<String> _deletedIds = {};

  Future<void> _deleteNotification(String id) async {
    // Instantly mask it from the UI so Dismissible doesn't crash
    setState(() {
      _deletedIds.add(id);
    });
    
    try {
      final client = ref.read(apiClientProvider);
      await client.delete('/app/notifications/$id', requiresAuth: true);
      // Wait for background refresh so the global model syncs silently
      ref.invalidate(notificationsProvider);
    } catch (e) {
      // Revert if API fails
      setState(() {
        _deletedIds.remove(id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error deleting notification')));
      }
    }
  }

  Future<void> _markAsRead(String id) async {
    try {
      final client = ref.read(apiClientProvider);
      await client.put('/app/notifications/$id/read', requiresAuth: true);
      ref.invalidate(notificationsProvider);
    } catch (e) {
      // Ignore error for marking as read
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(notificationsProvider.future),
        child: notificationsAsync.when(
          data: (allNotifications) {
            // Filter out items that are optimistically deleted locally
            final notifications = allNotifications.where((n) => !_deletedIds.contains(n.id)).toList();
            
            if (notifications.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
                  ),
                  onDismissed: (direction) => _deleteNotification(notification.id),
                  child: _NotificationItem(
                    title: notification.title,
                    message: notification.message,
                    date: _formatDate(notification.createdAt),
                    isRead: notification.isRead,
                    onTap: () => _markAsRead(notification.id),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                const Text('Could not load notifications',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Pull down to try again',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No notifications yet', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    try {
      final localDt = dt.toLocal();
      return DateFormat('dd MMM, hh:mm a').format(localDt);
    } catch (_) {
      return '';
    }
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final bool isRead;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.title,
    required this.message,
    required this.date,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFE0F7FA).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF00ACC1).withValues(alpha: 0.2),
            width: isRead ? 1.0 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isRead ? 0.03 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isRead ? const Color(0xFF94A3B8) : const Color(0xFF06B6D4)).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isRead ? Icons.notifications_none_rounded : Icons.notifications_active_rounded,
                color: isRead ? const Color(0xFF64748B) : const Color(0xFF06B6D4),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title, 
                          style: TextStyle(
                            fontWeight: isRead ? FontWeight.w700 : FontWeight.w900, 
                            fontSize: 16, 
                            color: isRead ? const Color(0xFF475569) : const Color(0xFF083344),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 10, 
                          height: 10, 
                          decoration: const BoxDecoration(
                            color: Colors.red, 
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.redAccent, blurRadius: 4),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message, 
                    style: TextStyle(
                      color: isRead ? const Color(0xFF64748B) : const Color(0xFF1E293B), 
                      fontSize: 14, 
                      height: 1.5,
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    date, 
                    style: TextStyle(
                      color: isRead ? const Color(0xFF94A3B8) : const Color(0xFF06B6D4), 
                      fontSize: 11, 
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
