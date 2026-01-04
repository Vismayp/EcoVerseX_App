import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class EcoCoinPlan {
  final String id;
  final String name;
  final String description;
  final int coins;
  final double price;

  EcoCoinPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.coins,
    required this.price,
  });

  factory EcoCoinPlan.fromJson(Map<String, dynamic> json) {
    return EcoCoinPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      coins: json['coins'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

final ecoCoinPlansProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final response = await apiService.get('/ecocoin/plans');

  final List<dynamic> plansData = response.data['plans'];
  final String upiId = response.data['upiId'];

  return {
    'plans': plansData.map((p) => EcoCoinPlan.fromJson(p)).toList(),
    'upiId': upiId,
  };
});

final purchaseHistoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final response = await apiService.get('/ecocoin/my-purchases');
  return List<Map<String, dynamic>>.from(response.data);
});
