import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

final notificationsProvider =
    FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getNotifications();
});

final unreadNotificationsCountProvider = Provider.autoDispose<int>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  return notificationsAsync.when(
    data: (notifications) =>
        notifications.where((n) => n['isRead'] == false).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});
