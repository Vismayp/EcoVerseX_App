import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/user_provider.dart';
import '../../widgets/neo/neo_card.dart';

class ActivityHistoryScreen extends ConsumerWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Activity History',
          style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: activitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (activities) {
          if (activities.isEmpty) {
            return const Center(
              child: Text(
                'No activities yet.',
                style: TextStyle(color: AppColors.mutedOnDark),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final activity = activities[index];
              final isApproved = activity.status.toLowerCase() == 'approved';

              return NeoCard(
                borderRadius: BorderRadius.circular(18),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _getActivityIcon(activity.category),
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppColors.onDark,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.date.toString().split(' ').first,
                            style: AppTheme.caption.copyWith(
                              color: AppColors.mutedOnDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (activity.coinReward > 0)
                          Text(
                            '+${activity.coinReward} Coins',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isApproved
                                ? AppColors.primary.withOpacity(0.14)
                                : Colors.orange.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            activity.status,
                            style: AppTheme.caption.copyWith(
                              color: isApproved
                                  ? AppColors.primary
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getActivityIcon(String category) {
    switch (category) {
      case 'Transport':
        return Icons.directions_bike;
      case 'Food':
        return Icons.restaurant;
      case 'Waste':
        return Icons.delete_outline;
      case 'Energy':
        return Icons.bolt;
      default:
        return Icons.eco;
    }
  }
}
