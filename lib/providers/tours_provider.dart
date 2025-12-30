import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../providers/user_provider.dart';

final toursProvider = FutureProvider.autoDispose<List<Tour>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getTours();

  return data
      .map((item) => Tour(
            id: item['id']?.toString() ?? '',
            title: item['name'] ?? item['title'] ?? 'Unknown Tour',
            description: item['description'] ?? '',
            location: item['location'] ?? 'Unknown Location',
            price: (item['price'] ?? 0).toInt(),
            imageUrl: item['imageUrl'] ?? '',
            date: DateTime.tryParse(item['date'] ?? '') ?? DateTime.now(),
            duration: item['duration'] ?? '1 Day',
            rating: (item['rating'] ?? 0).toDouble(),
          ))
      .toList();
});
