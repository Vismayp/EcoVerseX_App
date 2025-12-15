import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_chip.dart';
import 'mission_detail_screen.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MissionsBody();
  }
}

class _MissionsBody extends StatefulWidget {
  const _MissionsBody();

  @override
  State<_MissionsBody> createState() => _MissionsBodyState();
}

class _MissionsBodyState extends State<_MissionsBody> {
  int _selectedChipIndex = 0;

  static const List<String> _chips = [
    'For You',
    'High Reward',
    'Short Duration',
    'Newest',
  ];

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final missions = MockData.missions;

    final activeMissions = missions.where((m) => m.isJoined).toList();
    final availableMissions = missions.where((m) => !m.isJoined).toList();

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _PinnedHeaderDelegate(
            minExtent: 140,
            maxExtent: 140,
            child: _BlurHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Missions',
                          style: AppTheme.displayLarge.copyWith(
                            color: AppColors.onDark,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                        _WalletPill(value: user.walletBalance),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 46,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _chips.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final selected = index == _selectedChipIndex;
                        return NeoChip(
                          label: _chips[index],
                          selected: selected,
                          onTap: () =>
                              setState(() => _selectedChipIndex = index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Active Missions',
                  style:
                      AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  child: Text(
                    'View All',
                    style: AppTheme.caption.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 310,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
              scrollDirection: Axis.horizontal,
              itemCount: activeMissions.isEmpty ? 1 : activeMissions.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                if (activeMissions.isEmpty) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.82,
                    child: NeoCard(
                      borderRadius: BorderRadius.circular(18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flag, color: AppColors.primary, size: 34),
                          const SizedBox(height: 10),
                          Text(
                            'No active missions yet',
                            style: AppTheme.bodyLarge
                                .copyWith(color: AppColors.onDark),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Join one below to get started.',
                            style: AppTheme.bodyMedium
                                .copyWith(color: AppColors.mutedOnDark),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final mission = activeMissions[index];
                return _ActiveMissionCard(mission: mission);
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Available Missions',
              style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
          sliver: SliverList.separated(
            itemCount: availableMissions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final mission = availableMissions[index];
              return _AvailableMissionCard(mission: mission, index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _BlurHeader extends StatelessWidget {
  const _BlurHeader({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withOpacity(0.92),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  final double minExtent;
  @override
  final double maxExtent;
  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return minExtent != oldDelegate.minExtent ||
        maxExtent != oldDelegate.maxExtent ||
        child != oldDelegate.child;
  }
}

class _WalletPill extends StatelessWidget {
  const _WalletPill({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          const EcoCoinIcon(size: 18),
          const SizedBox(width: 6),
          Text(
            value.toString(),
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveMissionCard extends StatelessWidget {
  const _ActiveMissionCard({required this.mission});

  final Mission mission;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.82;
    final imageUrl = _activeMissionImages[mission.title] ??
        'https://lh3.googleusercontent.com/aida-public/AB6AXuClychwMVlm6AIGPurs3GttwquSNacHwO7XpYfgfiNTnRfM627_YOKfdO0P4RhzFqJpT3Av3bfepx-RjEc7Nc4pb9BF4k1Yy1pSSFBKTazhpBH8JOJRquLJN0DfvFdvsnD5E2iHminQz_-RTghP_7QyHWopBCYi6YzlLy1SpjSSj13SSprqfycXO4HojfyBvbS95PofmhXjy_3daypAWsXYil7O7OirEpevWKgfATjuA4RY48k2Zmnm3PxdaZer6J8NNpX0lMVWtBxI';

    return SizedBox(
      width: width,
      child: NeoCard(
        borderRadius: BorderRadius.circular(18),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(18)),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        memCacheHeight: 600,
                        placeholder: (context, url) => Container(
                          color: Colors.white.withOpacity(0.04),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.white.withOpacity(0.04),
                          child: const Icon(Icons.image_not_supported,
                              color: AppColors.onDarkMuted),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.75),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.10)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer,
                              size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            '${mission.durationDays} days left',
                            style: AppTheme.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mission.title,
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppColors.onDark,
                                fontWeight: FontWeight.w900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              mission.description,
                              style: AppTheme.caption.copyWith(
                                color: AppColors.mutedOnDark,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Reward',
                            style: AppTheme.caption
                                .copyWith(color: AppColors.faintOnDark),
                          ),
                          const SizedBox(height: 4),
                          EcoCoinAmount(
                            amount: mission.reward.toString(),
                            iconSize: 18,
                            gap: 6,
                            textStyle: AppTheme.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: AppTheme.caption.copyWith(
                          color: AppColors.mutedOnDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${(mission.progress * 100).toInt()}%',
                        style: AppTheme.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: mission.progress,
                      minHeight: 10,
                      backgroundColor: Colors.white.withOpacity(0.10),
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Log Today\'s Progress',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailableMissionCard extends StatelessWidget {
  const _AvailableMissionCard({required this.mission, required this.index});

  final Mission mission;
  final int index;

  @override
  Widget build(BuildContext context) {
    final badge =
        _availableMissionBadges[index % _availableMissionBadges.length];
    final imageUrl =
        _availableMissionImages[index % _availableMissionImages.length];

    return NeoCard(
      borderRadius: BorderRadius.circular(16),
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MissionDetailScreen(mission: mission),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Stack(
            children: [
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badge.color.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: badge.color.withOpacity(0.30)),
                    ),
                    child: Text(
                      badge.label.toUpperCase(),
                      style: AppTheme.caption.copyWith(
                        color: badge.color,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      memCacheWidth: 200,
                      memCacheHeight: 200,
                      placeholder: (context, url) => Container(
                        width: 84,
                        height: 84,
                        color: Colors.white.withOpacity(0.04),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 84,
                        height: 84,
                        color: Colors.white.withOpacity(0.04),
                        child: const Icon(Icons.image_not_supported,
                            color: AppColors.onDarkMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 82),
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
                        const SizedBox(height: 6),
                        Text(
                          mission.description,
                          style: AppTheme.bodyMedium
                              .copyWith(color: AppColors.mutedOnDark),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.schedule,
                                size: 16, color: AppColors.onDarkFaint),
                            const SizedBox(width: 6),
                            Text(
                              '${mission.durationDays} Day${mission.durationDays == 1 ? '' : 's'}',
                              style: AppTheme.caption
                                  .copyWith(color: AppColors.mutedOnDark),
                            ),
                            const SizedBox(width: 14),
                            EcoCoinAmount(
                              amount: '+${mission.reward}',
                              iconSize: 16,
                              gap: 6,
                              textStyle: AppTheme.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge {
  const _Badge(this.label, this.color);
  final String label;
  final Color color;
}

const Map<String, String> _activeMissionImages = {
  'Plastic-Free Week':
      'https://lh3.googleusercontent.com/aida-public/AB6AXuClychwMVlm6AIGPurs3GttwquSNacHwO7XpYfgfiNTnRfM627_YOKfdO0P4RhzFqJpT3Av3bfepx-RjEc7Nc4pb9BF4k1Yy1pSSFBKTazhpBH8JOJRquLJN0DfvFdvsnD5E2iHminQz_-RTghP_7QyHWopBCYi6YzlLy1SpjSSj13SSprqfycXO4HojfyBvbS95PofmhXjy_3daypAWsXYil7O7OirEpevWKgfATjuA4RY48k2Zmnm3PxdaZer6J8NNpX0lMVWtBxI',
  'Zero Waste Grocery':
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBNUfpAKgIsnJ81qhl1znZKg_oPHX5EOQp_2iHIkYv2fOEbDQ2uOTmygb5uilHfXktFLFOY9JFpJFI4d3PgdlTLocnXTS0zkI3GOsY9YJnX4fHRTSs-UJ3jcYLq80fLq8a0x3Lj6ysrfd0vCpo4ChMYxDzR0vveRyv1swZ8JkgNqm-GfSB2MF9hKjbXpQvyDJdwdI0O971NEYN0-xgwIsSUy5vHlRQ-zFIqFkJrgtsepN18CPdGWfqDO40-u7VEKQVtqPUUAHKIVUKo',
};

const List<String> _availableMissionImages = [
  'https://lh3.googleusercontent.com/aida-public/AB6AXuCdgRmra0WKxUs78FW0l7VqVDdzDublIIm2OGlOGzBT0Y6qM5HT1sQJ3oCjunxHNe-PzAw1l-qV_utlzrCL5P8t8vvjNr84CFqPR_QMrJGhlXe2zCFSR5BTGhe58bywJ86562DQ21Tv4D8oo6xdPGi2LC8UI8Rptz2JZ_X31yRAA7G886Ug5i8bo8kitLnvteuKpMoZRM6YRM9X48OTSf6tpT6c7LTH-IDRuxVzwBfK-FO949GVR9C9OGS75khfuP7Z1F2wak5K6Euy',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuAJQpfhI42oNyC0bHFIxfjPYfLFQ-FGoR4MRq2kTWY4VH7MYobXf2E78Ee-9cbMjriHGeVtcMVIz9WJ5E7vUFnbTSuJGNsN6hMQYMQWIvFxDVgATLvdrK4Y05DSpTfrcEkuXv26Is2NIK6baGhhIVfyrSrn2rSs7SsXaUZkvHJC_FEXNVGwFCDvEqhVfWSwH7k_Tmko8QMM-cNqlgXlMat9mXqz83D6cSTbU4iIbMyULURIZEDSSabt5Kp2ZDZq37VXALKVvd1NYqzj',
  'https://lh3.googleusercontent.com/aida-public/AB6AXuAWcDr4ao4EyHQ4jgVXFSrgfwzzpueX6KVonfB8KfEFCU3J7cLxZ0bzNmwXyyuyKcQYvHWSTxTkHbuylmH9QgZzonnr-JMXmdtlraoYQ-AiycqBvg0FupoikuQgYUXJlONW5S8TaS6dtySreK4hdveqy6WLUfRX6i3KjbyzcV2IhBLEkmdr06455QpWxW2C0OqWfDASO2QffLPaXJKPUSMNLNFkeGWAeQQO_jKum8HqUUHbH_Do1q3goVSLEy7NCPwwS1GRLlaUz8uR',
];

const List<_Badge?> _availableMissionBadges = [
  _Badge('Trending', AppColors.primary),
  null,
  _Badge('Hard', Colors.orange),
  null,
];
