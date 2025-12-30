import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import 'user_provider.dart';

final missionsProvider = FutureProvider.autoDispose<List<Mission>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getMissions();

  // Refresh missions every 30 seconds to catch progress updates from verified activities
  final timer = Timer(const Duration(seconds: 30), () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  return data.map((item) {
    final List<dynamic> logsData = item['logs'] ?? [];
    final logs = logsData.map((l) {
      return MissionLog(
        id: l['id'].toString(),
        description: l['description'] ?? '',
        message: l['message'],
        imageURL: l['imageURL'],
        status: l['status'] ?? 'PENDING',
        progressIncrement: l['progressIncrement'] ?? 0,
        createdAt: DateTime.parse(l['createdAt']),
      );
    }).toList();

    return Mission(
      id: item['id'].toString(),
      userMissionId: item['userMissionId']?.toString(),
      title: item['title'] ?? 'Mission',
      description: item['description'] ?? '',
      reward: item['reward'] ?? 0,
      durationDays: item['duration'] ?? 7,
      isJoined: item['isJoined'] ?? false,
      progress: (item['progress'] ?? 0).toDouble() / 100.0,
      status: item['userMissionStatus'],
      logs: logs,
    );
  }).toList();
});
