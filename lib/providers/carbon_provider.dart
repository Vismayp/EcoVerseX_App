import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../providers/user_provider.dart';

final carbonProjectsProvider =
    FutureProvider.autoDispose<List<CarbonProject>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final List<dynamic> data = await apiService.getCarbonProjects();

  return data
      .map((item) => CarbonProject(
            id: item['id']?.toString() ?? '',
            name: item['name'] ?? 'Unknown Project',
            description: item['description'] ?? '',
            location: item['location'] ?? 'Unknown Location',
            pricePerCredit: (item['pricePerCredit'] ?? 0).toInt(),
            availableCredits: (item['availableCredits'] ?? 0).toDouble(),
            imageURL: item['imageURL'] ?? '',
          ))
      .toList();
});
