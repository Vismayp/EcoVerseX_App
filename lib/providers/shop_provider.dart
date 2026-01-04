import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../providers/user_provider.dart';

final shopItemsProvider =
    FutureProvider.autoDispose<List<ShopItem>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getShopItems();

  // Refresh shop items every 30 seconds to catch admin updates
  final timer = Timer(const Duration(seconds: 30), () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  return data
      .map((item) => ShopItem(
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? 'Unknown Item',
            description: item['description'] ?? '',
            price: (item['price'] ?? 0).toInt(),
            imageUrl: item['imageURL'] ?? '',
            category: item['category'] ?? 'General',
            stock: item['stock'] ?? 0,
            isFeatured: item['isFeatured'] ?? false,
          ))
      .toList();
});

final userOrdersProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getMyOrders();
  return data.cast<Map<String, dynamic>>();
});
