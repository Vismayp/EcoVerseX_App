import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final userProvider = FutureProvider.autoDispose<User>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final data = await apiService.getUserProfile();

  return User(
    id: data['id'] ?? '',
    name: data['displayName'] ?? 'Eco Warrior',
    email: data['email'] ?? '',
    walletBalance: data['ecoCoins'] ?? 0,
    streakCount: data['streak'] ?? 0,
    tier: data['tier'] ?? 'BRONZE',
    carbonSaved: (data['carbonSaved'] ?? 0).toDouble(),
    waterSaved: (data['waterSaved'] ?? 0).toDouble(),
    wasteReduced: (data['wasteReduced'] ?? 0).toDouble(),
  );
});
