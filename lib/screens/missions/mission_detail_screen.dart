import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../data/models.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_scaffold.dart';

class MissionDetailScreen extends StatelessWidget {
  final Mission mission;

  const MissionDetailScreen({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
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
                      const Icon(Icons.timer,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        '${mission.durationDays} Days',
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
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Join logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Joined Mission!')),
                  );
                  Navigator.of(context).pop();
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
            ),
          ],
        ),
      ),
    );
  }
}
