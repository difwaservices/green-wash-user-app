import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/providers/notification_provider.dart';
import '../../../data/models/notification_model.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _deleteSelected(List<String> ids) async {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
    
    try {
      await ref.read(notificationsProvider.notifier).deleteSelected(ids);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error deleting notifications')),
        );
      }
    }
  }

  Future<void> _deleteNotification(String id) async {
    try {
      await ref.read(notificationsProvider.notifier).deleteNotification(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error deleting notification')),
        );
      }
    }
  }

  Future<void> _markAsRead(String id) async {
    try {
      await ref.read(notificationsProvider.notifier).markAsRead(id);
    } catch (e) {
      // Ignore error for marking as read
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await ref.read(notificationsProvider.notifier).markAllAsRead();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error marking notifications as read')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final notifications = notificationsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => <NotificationModel>[],
    );
    final allSelected = notifications.isNotEmpty && _selectedIds.length == notifications.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _isSelectionMode
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedIds.clear();
                  });
                },
              ),
              title: Text('${_selectedIds.length} Selected', style: const TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (allSelected) {
                        _selectedIds.clear();
                        _isSelectionMode = false;
                      } else {
                        _selectedIds.addAll(notifications.map((n) => n.id));
                      }
                    });
                  },
                  child: Text(
                    allSelected ? 'Deselect All' : 'Select All',
                    style: const TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  onPressed: () {
                    if (_selectedIds.isNotEmpty) {
                      _deleteSelected(_selectedIds.toList());
                    }
                  },
                ),
              ],
            )
          : AppBar(
              title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
              actions: [
                if (notifications.any((n) => !n.isRead))
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: const Text(
                      'Mark all as read',
                      style: TextStyle(
                        color: Color(0xFF06B6D4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

      body: RefreshIndicator(
        onRefresh: () => ref.refresh(notificationsProvider.future),
        child: notificationsAsync.when(
          data: (_) {
            if (notifications.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final isSelected = _selectedIds.contains(notification.id);

                return Dismissible(
                  key: Key(notification.id),
                  direction: _isSelectionMode ? DismissDirection.none : DismissDirection.endToStart,
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
                    isSelectionMode: _isSelectionMode,
                    isSelected: isSelected,
                    onTap: () {
                      if (_isSelectionMode) {
                        _toggleSelection(notification.id);
                      } else {
                        _markAsRead(notification.id);
                      }
                    },
                    onLongPress: () {
                      if (!_isSelectionMode) {
                        setState(() {
                          _isSelectionMode = true;
                          _selectedIds.add(notification.id);
                        });
                      }
                    },
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
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;

  const _NotificationItem({
    required this.title,
    required this.message,
    required this.date,
    required this.isRead,
    required this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
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
            if (isSelectionMode) ...[
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                activeColor: const Color(0xFF06B6D4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 8),
            ],
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
