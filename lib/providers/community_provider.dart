import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../providers/user_provider.dart';

final communityCirclesProvider =
    FutureProvider.autoDispose<List<CommunityCircle>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getCircles();

  // Refresh circles every 60 seconds to catch new members or circles
  final timer = Timer(const Duration(seconds: 60), () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  return data
      .map((item) => CommunityCircle(
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? 'Unknown Circle',
            description: item['description'] ?? '',
            membersCount: item['_count']?['members'] ?? 0,
            isJoined: item['isJoined'] ?? false,
            category: item['category'] ?? 'General',
            link: item['link'],
            platform: item['platform'],
          ))
      .toList();
});
