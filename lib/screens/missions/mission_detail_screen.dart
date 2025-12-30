import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../data/models.dart';
import '../../providers/missions_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_scaffold.dart';
import 'mission_log_sheet.dart';

class MissionDetailScreen extends ConsumerWidget {
  final Mission mission;

  const MissionDetailScreen({super.key, required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NeoScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mission Details',
          style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCdgRmra0WKxUs78FW0l7VqVDdzDublIIm2OGlOGzBT0Y6qM5HT1sQJ3oCjunxHNe-PzAw1l-qV_utlzrCL5P8t8vvjNr84CFqPR_QMrJGhlXe2zCFSR5BTGhe58bywJ86562DQ21Tv4D8oo6xdPGi2LC8UI8Rptz2JZ_X31yRAA7G886Ug5i8bo8kitLnvteuKpMoZRM6YRM9X48OTSf6tpT6c7LTH-IDRuxVzwBfK-FO949GVR9C9OGS75khfuP7Z1F2wak5K6Euy', // Placeholder or map from title
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.white.withOpacity(0.04),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.white.withOpacity(0.04),
                  child: const Icon(Icons.image_not_supported,
                      color: AppColors.onDarkMuted),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              mission.title,
              style: AppTheme.displayLarge.copyWith(
                color: AppColors.onDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                          mission.status == 'COMPLETED'
                              ? Icons.check_circle
                              : Icons.timer,
                          size: 16,
                          color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        mission.status == 'COMPLETED'
                            ? 'Done'
                            : '${mission.durationDays} Days',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const EcoCoinIcon(size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${mission.reward} Coins',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Description',
              style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
            ),
            const SizedBox(height: 8),
            Text(
              mission.description,
              style: AppTheme.bodyLarge.copyWith(
                color: AppColors.mutedOnDark,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            if (!mission.isJoined)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref
                          .read(apiServiceProvider)
                          .joinMission(mission.id);
                      ref.invalidate(missionsProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Joined Mission!')),
                        );
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to join: $e')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Join Mission',
                    style: AppTheme.headlineSmall.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: mission.status == 'PENDING_APPROVAL'
                      ? Colors.orange.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: mission.status == 'PENDING_APPROVAL'
                          ? Colors.orange.withOpacity(0.3)
                          : AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            mission.status == 'PENDING_APPROVAL'
                                ? Icons.hourglass_empty
                                : Icons.check_circle,
                            color: mission.status == 'PENDING_APPROVAL'
                                ? Colors.orange
                                : AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          mission.status == 'PENDING_APPROVAL'
                              ? 'Awaiting Approval'
                              : mission.status == 'COMPLETED'
                                  ? 'Mission Completed'
                                  : 'Mission Active',
                          style: AppTheme.headlineSmall.copyWith(
                            color: mission.status == 'PENDING_APPROVAL'
                                ? Colors.orange
                                : AppColors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: mission.progress,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          mission.status == 'PENDING_APPROVAL'
                              ? Colors.orange
                              : AppColors.primary),
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(mission.progress * 100).toInt()}% Completed',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.mutedOnDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (mission.status != 'PENDING_APPROVAL' &&
                        mission.status != 'COMPLETED') ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  MissionLogSheet(mission: mission),
                            );
                          },
                          icon: const Icon(Icons.add_a_photo_outlined),
                          label: Text(
                            'Log Progress',
                            style: AppTheme.headlineSmall.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            if (mission.isJoined && mission.logs.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                'Progress History',
                style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mission.logs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = mission.logs[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: log.status == 'APPROVED'
                                    ? Colors.green.withOpacity(0.1)
                                    : log.status == 'REJECTED'
                                        ? Colors.red.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                log.status,
                                style: TextStyle(
                                  color: log.status == 'APPROVED'
                                      ? Colors.green
                                      : log.status == 'REJECTED'
                                          ? Colors.red
                                          : Colors.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (log.status == 'APPROVED')
                              Text(
                                '+${log.progressIncrement}% Progress',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Text(
                              '${log.createdAt.day}/${log.createdAt.month}/${log.createdAt.year}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          log.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (log.message != null && log.message!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            '"${log.message}"',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        if (log.imageURL != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: log.imageURL!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
