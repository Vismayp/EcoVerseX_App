import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../providers/community_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_section_header.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  static const _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC4cdr7xByeoJPBCnFwM27g7SHaTBK2JnOfc73wUjeuSA-8FNzUXtrN3aUmKpuRviivnTNoSac6BikBESQwDOw1e_Vva6PFdfxqCuCtB6GuP2vl6L90LyOFuPLsAorpxys11GeUjHVFaEQ7L3mgQpdGq1ELRQxDJsZjjYsAAdDY8_44voGuH6EjomSWqYnaN4204IV2pwcV0k2Ps3ec8BUNRlNKbt9bG_Mgow1QCfDH404KilZROtf6J7CTuaSkAW6QHWLuKT0FRcBi';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final circlesAsync = ref.watch(communityCirclesProvider);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _PinnedHeaderDelegate(
                minExtent: 72,
                maxExtent: 72,
                child: _BlurHeader(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const _AvatarWithBadge(
                              imageUrl: _avatarUrl,
                              badgeText: '15',
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Community Hub',
                              style: AppTheme.headlineSmall.copyWith(
                                color: AppColors.onDark,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        userAsync.when(
                          data: (user) =>
                              _BalancePill(balance: user.walletBalance),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    userAsync.when(
                      data: (user) => _TierProgressCard(
                        tierLabel: '${user.tier} Tier',
                        globalRank: 15,
                        nextTierLabel: 'Gold Tier',
                        pointsToNext: 350,
                        progress: 0.65,
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
                    const SizedBox(height: 18),
                    NeoSectionHeader(
                      title: 'Top EcoWarriors',
                      actionText: 'View All',
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    const _LeaderboardList(),
                    const SizedBox(height: 18),
                    Text(
                      'Join the Conversation',
                      style: AppTheme.headlineSmall.copyWith(
                        color: AppColors.onDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    circlesAsync.when(
                      data: (circles) => Column(
                        children: circles
                            .map(
                              (g) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _CommunityGroupCard(
                                  title: g.name,
                                  subtitle: g.description,
                                  icon: Icons.forum,
                                  onTap: () {},
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
                    _CommunityGroupCard(
                      title: 'Carbon Offset Traders',
                      subtitle: 'Trade credits and swap tips',
                      icon: Icons.swap_horiz,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  _PinnedHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

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

class _BlurHeader extends StatelessWidget {
  final Widget child;

  const _BlurHeader({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withOpacity(0.86),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
            ),
          ),
          child: SafeArea(bottom: false, child: child),
        ),
      ),
    );
  }
}

class _AvatarWithBadge extends StatelessWidget {
  final String imageUrl;
  final String badgeText;

  const _AvatarWithBadge({
    required this.imageUrl,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.backgroundDark, width: 2),
            ),
            child: Text(
              badgeText,
              style: AppTheme.caption.copyWith(
                color: AppColors.backgroundDark,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BalancePill extends StatelessWidget {
  final int balance;

  const _BalancePill({required this.balance});

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: BorderRadius.circular(999),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const EcoCoinIcon(size: 20),
          const SizedBox(width: 8),
          Text(
            '$balance',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.onDark,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierProgressCard extends StatelessWidget {
  final String tierLabel;
  final int globalRank;
  final String nextTierLabel;
  final int pointsToNext;
  final double progress;

  const _TierProgressCard({
    required this.tierLabel,
    required this.globalRank,
    required this.nextTierLabel,
    required this.pointsToNext,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -48,
          top: -48,
          child: Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
          ),
        ),
        NeoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Status',
                        style: AppTheme.caption.copyWith(
                          color: AppColors.mutedOnDark,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.verified, color: AppColors.mutedOnDark),
                          const SizedBox(width: 8),
                          Text(
                            tierLabel,
                            style: AppTheme.headlineSmall.copyWith(
                              color: AppColors.onDark,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Global Rank',
                        style: AppTheme.caption.copyWith(
                          color: AppColors.mutedOnDark,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '#$globalRank',
                        style: AppTheme.headlineSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next: $nextTierLabel',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppColors.onDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$pointsToNext pts to go',
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
                child: SizedBox(
                  height: 10,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.06),
                    color: AppColors.primary,
                    minHeight: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList();

  @override
  Widget build(BuildContext context) {
    const entries = [
      _LeaderboardEntry(
        rank: 1,
        handle: '@EcoWarrior99',
        tier: 'Gold Tier',
        points: 5400,
        isTop: true,
      ),
      _LeaderboardEntry(rank: 2, handle: '@GreenGiant', points: 4850),
      _LeaderboardEntry(rank: 3, handle: '@SustainAlice', points: 4120),
      _LeaderboardEntry(
          rank: 15, handle: '@EcoUser_15', points: 2350, isYou: true),
    ];

    return Column(
      children: entries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LeaderboardTile(entry: e),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _LeaderboardEntry {
  final int rank;
  final String handle;
  final String? tier;
  final int points;
  final bool isTop;
  final bool isYou;

  const _LeaderboardEntry({
    required this.rank,
    required this.handle,
    this.tier,
    required this.points,
    this.isTop = false,
    this.isYou = false,
  });
}

class _LeaderboardTile extends StatelessWidget {
  final _LeaderboardEntry entry;

  const _LeaderboardTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final borderColor = entry.isYou
        ? AppColors.primary.withOpacity(0.30)
        : Colors.white.withOpacity(0.08);

    return NeoCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Stack(
        children: [
          if (entry.isYou)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Text(
                  'YOU',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.backgroundDark,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _RankBadge(
                    rank: entry.rank, isTop: entry.isTop, isYou: entry.isYou),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.handle,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.onDark,
                          fontWeight:
                              entry.isTop ? FontWeight.w900 : FontWeight.w700,
                        ),
                      ),
                      if (entry.tier != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          entry.tier!,
                          style: AppTheme.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${entry.points}',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.onDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'pts',
                      style: AppTheme.caption
                          .copyWith(color: AppColors.mutedOnDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  final bool isTop;
  final bool isYou;

  const _RankBadge({
    required this.rank,
    required this.isTop,
    required this.isYou,
  });

  @override
  Widget build(BuildContext context) {
    if (isTop) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.16),
              border: Border.all(color: AppColors.primary.withOpacity(0.40)),
            ),
            alignment: Alignment.center,
            child: Text(
              '1',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Positioned(
            right: -6,
            top: -8,
            child: Icon(Icons.emoji_events, color: AppColors.primary, size: 20),
          ),
        ],
      );
    }

    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isYou
            ? AppColors.primary.withOpacity(0.16)
            : AppColors.surfaceInput,
        border: Border.all(
          color: isYou
              ? AppColors.primary.withOpacity(0.35)
              : Colors.white.withOpacity(0.10),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '$rank',
        style: AppTheme.bodyMedium.copyWith(
          color: isYou ? AppColors.primary : AppColors.mutedOnDark,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CommunityGroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _CommunityGroupCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: NeoCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppColors.onDark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppTheme.caption.copyWith(color: AppColors.mutedOnDark),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right, color: AppColors.mutedOnDark),
          ],
        ),
      ),
    );
  }
}
