import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../providers/user_provider.dart';

final communityCirclesProvider =
    FutureProvider.autoDispose<List<CommunityCircle>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getCircles();

  return data
      .map((item) => CommunityCircle(
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? 'Unknown Circle',
            description: item['description'] ?? '',
            membersCount: item['membersCount'] ?? 0,
            imageUrl: item['imageUrl'] ?? '',
            isJoined: item['isJoined'] ?? false,
            category: item['category'] ?? 'General',
          ))
      .toList();
});
