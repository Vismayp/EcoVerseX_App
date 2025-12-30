import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final userProfileProvider = FutureProvider.autoDispose<User>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final data = await apiService.getUserProfile();

  // Refresh user profile every 60 seconds to update balance/streak
  final timer = Timer(const Duration(seconds: 60), () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  return User(
    id: data['id'] ?? '',
    name: data['displayName'] ?? 'Eco Warrior',
    email: data['email'] ?? '',
    photoURL: data['photoURL'] ??
        'https://ui-avatars.com/api/?name=${data['displayName'] ?? 'Eco+Warrior'}&background=random',
    walletBalance: data['ecoCoins'] ?? 0,
    streakCount: data['streak'] ?? 0,
    tier: data['tier'] ?? 'BRONZE',
    carbonSaved: (data['totalCarbonSaved'] ?? 0).toDouble(),
    waterSaved: (data['totalWaterSaved'] ?? 0).toDouble(),
    wasteReduced: (data['wasteReduced'] ?? 0).toDouble(),
    treesPlanted: data['totalTreesPlanted'] ?? 0,
  );
});

final activitiesProvider =
    FutureProvider.autoDispose<List<Activity>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getMyActivities();

  // Refresh activities every 30 seconds to catch admin approvals
  final timer = Timer(const Duration(seconds: 30), () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  return data.map((item) {
    return Activity(
      id: item['id'].toString(),
      title: item['title'] ?? 'Activity',
      category: item['type'] ?? 'Other',
      coinReward: 0, // Backend doesn't return reward in list yet
      date:
          DateTime.parse(item['createdAt'] ?? DateTime.now().toIso8601String()),
      status: item['status'] ?? 'PENDING',
      latitude: item['latitude'] != null
          ? (item['latitude'] as num).toDouble()
          : null,
      longitude: item['longitude'] != null
          ? (item['longitude'] as num).toDouble()
          : null,
      co2Saved: (item['co2Saved'] ?? 0).toDouble(),
      waterSaved: (item['waterSaved'] ?? 0).toDouble(),
      treesPlanted: item['treesPlanted'],
    );
  }).toList();
});
