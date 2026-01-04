import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../providers/user_provider.dart';

final toursProvider = FutureProvider.autoDispose<List<Tour>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getTours();

  // Refresh tours every 60 seconds to catch admin updates
  final timer = Timer(const Duration(seconds: 60), () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  return data
      .map((item) => Tour(
            id: item['id']?.toString() ?? '',
            title: item['name'] ?? item['title'] ?? 'Unknown Tour',
            description: item['description'] ?? '',
            details: item['details'],
            location: item['location'] ?? 'Unknown Location',
            price: (item['price'] ?? 0).toInt(),
            imageUrl: item['imageURL'] ?? '',
            date: DateTime.tryParse(item['date'] ?? '') ?? DateTime.now(),
            duration: item['duration'] ?? '1 Day',
            rating: (item['rating'] ?? 0).toDouble(),
          ))
      .toList();
});
