import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../providers/user_provider.dart';

final shopItemsProvider =
    FutureProvider.autoDispose<List<ShopItem>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getShopItems();

  return data
      .map((item) => ShopItem(
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? 'Unknown Item',
            description: item['description'] ?? '',
            price: (item['price'] ?? 0).toInt(),
            imageUrl: item['imageUrl'] ?? '',
            category: item['category'] ?? 'General',
            stock: item['stock'] ?? 0,
          ))
      .toList();
});
