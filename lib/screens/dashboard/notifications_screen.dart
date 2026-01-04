import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/neo/neo_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  String _formatTime(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return DateFormat('MMM d').format(date);
      }
    } catch (e) {
      return '';
    }
  }

  IconData _getIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains('welcome')) return Icons.eco;
    if (t.contains('mission')) return Icons.flag;
    if (t.contains('deal') || t.contains('shop')) return Icons.shopping_bag;
    if (t.contains('community')) return Icons.groups;
    return Icons.notifications;
  }

  Color _getColor(String title) {
    final t = title.toLowerCase();
    if (t.contains('welcome')) return AppColors.primary;
    if (t.contains('mission')) return Colors.blue;
    if (t.contains('deal') || t.contains('shop')) return Colors.amber;
    if (t.contains('community')) return Colors.purple;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Notifications',
          style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.onDark),
            onPressed: () => ref.invalidate(notificationsProvider),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
        data: (notifications) => notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: AppColors.onDarkMuted.withOpacity(0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: AppTheme.bodyLarge
                          .copyWith(color: AppColors.onDarkMuted),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final isRead = notification['isRead'] ?? false;
                  final title = notification['title'] ?? 'Notification';
                  final body = notification['body'] ?? '';
                  final time = notification['createdAt'] != null
                      ? _formatTime(notification['createdAt'])
                      : '';

                  return InkWell(
                    onTap: () async {
                      if (!isRead) {
                        final apiService = ref.read(apiServiceProvider);
                        await apiService
                            .markNotificationAsRead(notification['id']);
                        ref.invalidate(notificationsProvider);
                      }
                    },
                    child: NeoCard(
                      padding: const EdgeInsets.all(16),
                      color: isRead
                          ? AppColors.cardDark.withOpacity(0.5)
                          : AppColors.cardDark,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getColor(title).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _getIcon(title),
                              color: _getColor(title),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: AppTheme.bodyLarge.copyWith(
                                          color: AppColors.onDark,
                                          fontWeight: isRead
                                              ? FontWeight.w600
                                              : FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    if (!isRead)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  body,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppColors.onDarkMuted,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  time,
                                  style: AppTheme.caption.copyWith(
                                    color: AppColors.faintOnDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
