import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/theme.dart';
import '../../providers/community_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_section_header.dart';
import '../../data/models.dart';

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
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              titleSpacing: 0,
              toolbarHeight: 82,
              flexibleSpace: const _BlurHeader(),
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        userAsync.when(
                          data: (user) => _AvatarWithBadge(
                            imageUrl: user.photoURL,
                            badgeText: user.rank > 0 && user.rank < 100
                                ? '#${user.rank}'
                                : '',
                          ),
                          loading: () => const CircleAvatar(radius: 21),
                          error: (_, __) => const CircleAvatar(radius: 21),
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
                      data: (user) => _BalancePill(balance: user.walletBalance),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    userAsync.when(
                      data: (user) {
                        // Simple tier logic for UI display
                        String nextTier = 'Silver';
                        int nextTierPoints = 1000;
                        if (user.tier == 'SILVER') {
                          nextTier = 'Gold';
                          nextTierPoints = 5000;
                        } else if (user.tier == 'GOLD') {
                          nextTier = 'Platinum';
                          nextTierPoints = 10000;
                        }

                        double progress = user.points / nextTierPoints;
                        if (progress > 1.0) progress = 1.0;

                        return _TierProgressCard(
                          tierLabel: '${user.tier} Tier',
                          globalRank: (user.rank > 0 && user.rank < 100)
                              ? '#${user.rank}'
                              : '100+',
                          nextTierLabel: '$nextTier Tier',
                          pointsToNext: nextTierPoints - user.points > 0
                              ? nextTierPoints - user.points
                              : 0,
                          progress: progress,
                          currentPoints: user.points,
                        );
                      },
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
                            .map<Widget>(
                              (g) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _CommunityGroupCard(
                                  circle: g,
                                  onTap: () async {
                                    if (g.link != null && g.link!.isNotEmpty) {
                                      try {
                                        String url = g.link!;
                                        if (!url.startsWith('http') &&
                                            !url.startsWith('whatsapp://')) {
                                          url = 'https://$url';
                                        }
                                        final uri = Uri.parse(url);
                                        // Track click
                                        ref
                                            .read(apiServiceProvider)
                                            .trackCircleClick(g.id);

                                        await launchUrl(uri,
                                            mode:
                                                LaunchMode.externalApplication);
                                      } catch (e) {
                                        debugPrint('Error launching URL: $e');
                                      }
                                    }
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
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

class _BlurHeader extends StatelessWidget {
  final Widget? child;

  const _BlurHeader({this.child});

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
          child: child ?? const SizedBox.expand(),
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
        if (badgeText.isNotEmpty)
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
  final String globalRank;
  final String nextTierLabel;
  final int pointsToNext;
  final double progress;
  final int currentPoints;

  const _TierProgressCard({
    required this.tierLabel,
    required this.globalRank,
    required this.nextTierLabel,
    required this.pointsToNext,
    required this.progress,
    required this.currentPoints,
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
                          const SizedBox(width: 8),
                          Text(
                            '($currentPoints pts)',
                            style: AppTheme.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
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
                        globalRank,
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

class _LeaderboardList extends ConsumerWidget {
  const _LeaderboardList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final currentUserAsync = ref.watch(userProfileProvider);

    return leaderboardAsync.when(
      data: (users) {
        final currentUser = currentUserAsync.value;

        return Column(
          children: users.asMap().entries.map<Widget>((entry) {
            final index = entry.key;
            final user = entry.value;
            final isYou = currentUser?.id == user.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LeaderboardTile(
                entry: _LeaderboardEntry(
                  rank: index + 1,
                  handle: user.name,
                  tier: '${user.tier} Tier',
                  points: user.points,
                  isTop: index == 0,
                  isYou: isYou,
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
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
  final CommunityCircle circle;
  final VoidCallback onTap;

  const _CommunityGroupCard({
    required this.circle,
    required this.onTap,
  });

  IconData _getPlatformIcon(String? platform) {
    switch (platform?.toUpperCase()) {
      case 'WHATSAPP':
        return Icons.chat;
      case 'TELEGRAM':
        return Icons.send;
      case 'INSTAGRAM':
        return Icons.camera_alt;
      default:
        return Icons.forum;
    }
  }

  Color _getPlatformColor(String? platform) {
    switch (platform?.toUpperCase()) {
      case 'WHATSAPP':
        return const Color(0xFF25D366);
      case 'TELEGRAM':
        return const Color(0xFF0088cc);
      case 'INSTAGRAM':
        return const Color(0xFFE1306C);
      default:
        return AppColors.primary;
    }
  }

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
                color: _getPlatformColor(circle.platform).withOpacity(0.12),
              ),
              child: Icon(
                _getPlatformIcon(circle.platform),
                color: _getPlatformColor(circle.platform),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    circle.name,
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppColors.onDark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    circle.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppTheme.caption.copyWith(color: AppColors.mutedOnDark),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.chevron_right, color: AppColors.mutedOnDark),
                if (circle.membersCount > 0)
                  Text(
                    '${circle.membersCount} members',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
