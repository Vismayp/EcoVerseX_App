import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import 'user_provider.dart';

final missionsProvider = FutureProvider.autoDispose<List<Mission>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getMissions();

  // Refresh missions every 5 minutes
  final timer = Timer(const Duration(minutes: 5), () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  return data.map((item) {
    return Mission(
      id: item['id'].toString(),
      title: item['title'] ?? 'Mission',
      description: item['description'] ?? '',
      reward: item['reward'] ?? 0,
      durationDays: item['durationDays'] ?? 7,
      isJoined: item['isJoined'] ?? false,
      progress: (item['progress'] ?? 0).toDouble(),
    );
  }).toList();
});
