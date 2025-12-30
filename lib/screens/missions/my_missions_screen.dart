import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../data/models.dart';
import '../../providers/missions_provider.dart';
import '../../widgets/neo/neo_scaffold.dart';
import 'missions_screen.dart';
import 'mission_detail_screen.dart';

class MyMissionsScreen extends ConsumerWidget {
  const MyMissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionsAsync = ref.watch(missionsProvider);

    return NeoScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Missions',
          style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: missionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (missions) {
          final joinedMissions = missions.where((m) => m.isJoined).toList();

          if (joinedMissions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag_outlined, color: AppColors.primary, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No missions joined yet',
                    style: AppTheme.headlineSmall
                        .copyWith(color: AppColors.onDark),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore available missions to get started.',
                    style: AppTheme.bodyMedium
                        .copyWith(color: AppColors.mutedOnDark),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: joinedMissions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final mission = joinedMissions[index];
              return _MyMissionListCard(mission: mission);
            },
          );
        },
      ),
    );
  }
}

class _MyMissionListCard extends StatelessWidget {
  final Mission mission;

  const _MyMissionListCard({required this.mission});

  @override
  Widget build(BuildContext context) {
    final isCompleted = mission.status == 'COMPLETED';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MissionDetailScreen(mission: mission),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? AppColors.primary.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isCompleted)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'DONE',
                            style: AppTheme.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          mission.title,
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppColors.onDark,
                            fontWeight: FontWeight.w900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mission.description,
                    style:
                        AppTheme.caption.copyWith(color: AppColors.mutedOnDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: mission.progress,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      color: isCompleted
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(mission.progress * 100).toInt()}%',
                  style: AppTheme.bodyMedium.copyWith(
                    color: isCompleted ? AppColors.primary : AppColors.onDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                if (!isCompleted)
                  Text(
                    '${mission.durationDays}d left',
                    style:
                        AppTheme.caption.copyWith(color: AppColors.mutedOnDark),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
