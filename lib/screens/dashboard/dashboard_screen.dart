import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../providers/user_provider.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_icon_button.dart';
import '../../widgets/neo/neo_section_header.dart';
import '../carbon/carbon_market_screen.dart';
import '../tours/tours_screen.dart';
import 'activity_history_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final activitiesAsync = ref.watch(activitiesProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (user) {
        final firstName = user.name.trim().split(' ').isEmpty
            ? user.name
            : user.name.trim().split(' ').first;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(userProvider);
            ref.invalidate(activitiesProvider);
            await ref.read(userProvider.future);
            await ref.read(activitiesProvider.future);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _DashboardHeaderDelegate(
                  minExtent: 100,
                  maxExtent: 100,
                  child: _BlurHeader(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 10),
                      child: Row(
                        children: [
                          _AvatarWithStatus(
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCviuQMguw4KYQ22oFiEDfLn_pX5PlLt3KCgO1Wlkd7H10jTkeqJjjVRQ0A3XEsAIFDsQ04WUNNfc2b9BiwLtXy6HU5B0h22S8c6KHBYM1xxqAJiH_S295STjiVUj5e3At5zpfKpUIy3uA__yy-mHHDEUFvEhU7lTvwc1jKn4qthzyS2ZqKh_jq0GbllEToGYyLqgbZ_JrlBaU2eNoUraGGIIfge2PW6aUJMtLrdF8pas9KxY2kJ5cgiqONFL7u4wajOprNxJmgTl0l',
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back',
                                  style: AppTheme.caption.copyWith(
                                    color: AppColors.faintOnDark,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  firstName,
                                  style: AppTheme.headlineMedium.copyWith(
                                    color: AppColors.onDark,
                                    fontWeight: FontWeight.w800,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          NeoIconButton(
                            tooltip: 'Refresh',
                            icon: Icons.refresh,
                            onPressed: () {
                              ref.invalidate(userProvider);
                              ref.invalidate(activitiesProvider);
                            },
                          ),
                          const SizedBox(width: 8),
                          NeoIconButton(
                            tooltip: 'Notifications',
                            icon: Icons.notifications,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.local_fire_department,
                          iconBg: Colors.orange.withOpacity(0.18),
                          iconColor: Colors.orange,
                          value: '${user.streakCount} Days',
                          label: 'Streak',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.psychology,
                          iconBg: AppColors.primary.withOpacity(0.18),
                          iconColor: AppColors.primary,
                          value: user.tier,
                          label: 'Current Tier',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                  child: _HeroTreeCard(
                    streakCount: user.streakCount,
                    progress: (user.carbonSaved / 1000).clamp(0.0, 1.0),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                sliver: SliverToBoxAdapter(
                  child: _WalletSection(balance: user.walletBalance),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: NeoSectionHeader(
                    title: 'Your Impact',
                    actionText: 'View History',
                    onAction: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ActivityHistoryScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                sliver: SliverToBoxAdapter(
                  child: _ImpactGrid(
                    carbonSavedKg: user.carbonSaved,
                    waterSavedL: user.waterSaved,
                    wasteReducedKg: user.wasteReduced,
                    treesPlanted: user.treesPlanted.toDouble(),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore',
                        style: AppTheme.headlineSmall
                            .copyWith(color: AppColors.onDark),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ExploreCard(
                              title: 'AgriTours',
                              icon: Icons.agriculture,
                              color: Colors.orange,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ToursScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ExploreCard(
                              title: 'Carbon Market',
                              icon: Icons.co2,
                              color: AppColors.primary,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CarbonMarketScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Recent Activity',
                    style: AppTheme.headlineSmall
                        .copyWith(color: AppColors.onDark),
                  ),
                ),
              ),
              activitiesAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Center(child: Text('Error loading activities: $err')),
                ),
                data: (activities) {
                  if (activities.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'No activities yet. Start logging!',
                            style: TextStyle(color: AppColors.mutedOnDark),
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
                    sliver: SliverList.separated(
                      itemCount: activities.length > 3 ? 3 : activities.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        final isApproved =
                            activity.status.toLowerCase() == 'approved';

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
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
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

class _BlurHeader extends StatelessWidget {
  const _BlurHeader({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
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

class _DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  _DashboardHeaderDelegate({
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
    return SizedBox(
      height: maxExtent,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _DashboardHeaderDelegate oldDelegate) {
    return minExtent != oldDelegate.minExtent ||
        maxExtent != oldDelegate.maxExtent ||
        child != oldDelegate.child;
  }
}

class _AvatarWithStatus extends StatelessWidget {
  const _AvatarWithStatus({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: 44,
                  height: 44,
                  placeholder: (context, url) => Container(
                    color: Colors.white.withOpacity(0.04),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.white.withOpacity(0.04),
                    child:
                        const Icon(Icons.person, color: AppColors.onDarkMuted),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.backgroundDark, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(22),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTheme.headlineSmall.copyWith(
              color: AppColors.onDark,
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            style: AppTheme.caption.copyWith(
              color: AppColors.faintOnDark,
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HeroTreeCard extends StatelessWidget {
  const _HeroTreeCard({required this.streakCount, required this.progress});

  final int streakCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    const imageUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCuBOfKHZynUenR14Ew57HORM-7v5aGHHbuAdeP3YrmY3Dn4G2mx9CqRDVdr4woaPjPknfhz2haGv2TfGTq94C2w1Ays1U0-9IhzvmhVUb0FzpRCPcJrnmpt42WJ3UqkGt-LCKPORvpSs-WnQDPQYLiXoyEjaYinLsHnNQ293Cy3KED7iVklPxyOE9rmriWtMV7sPv6_-Wpmb7gAMVy-m3vLwgqWaYmFL-2Ew-Q0gOAOVlhrOfXeifND1SKwkyawKc7P40hDL6Sf36l';

    return NeoCard(
      borderRadius: BorderRadius.circular(28),
      padding: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        memCacheHeight: 1200,
                        placeholder: (context, url) => Container(
                          color: Colors.white.withOpacity(0.04),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.white.withOpacity(0.04),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.onDarkMuted,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 140,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary.withOpacity(0.10),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.backgroundDark,
                              Color(0x33000000),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.45, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tree is growing healthy',
                        style: AppTheme.bodyMedium
                            .copyWith(color: AppColors.onDarkMuted),
                      ),
                    ],
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

class _WalletSection extends StatelessWidget {
  const _WalletSection({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EcoCoinIcon(size: 22),
            const SizedBox(width: 10),
            Text(
              '$balance EcoCoins',
              style: AppTheme.displayLarge.copyWith(
                color: AppColors.onDark,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Available balance to spend',
          style: AppTheme.bodyMedium.copyWith(color: AppColors.faintOnDark),
        ),
        const SizedBox(height: 14),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.redeem, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Redeem Rewards',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImpactGrid extends StatelessWidget {
  const _ImpactGrid({
    required this.carbonSavedKg,
    required this.waterSavedL,
    required this.wasteReducedKg,
    required this.treesPlanted,
  });

  final double carbonSavedKg;
  final double waterSavedL;
  final double wasteReducedKg;
  final double treesPlanted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NeoCard(
          borderRadius: BorderRadius.circular(22),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARBON SAVED',
                      style: AppTheme.caption
                          .copyWith(color: AppColors.faintOnDark),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          carbonSavedKg.toStringAsFixed(0),
                          style: AppTheme.displayLarge.copyWith(
                            color: AppColors.onDark,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            'kg CO2e',
                            style: AppTheme.bodyMedium
                                .copyWith(color: AppColors.mutedOnDark),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.cloud_queue,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SmallImpactCard(
                icon: Icons.water_drop,
                iconColor: Colors.blue.shade300,
                iconBg: Colors.blue.withOpacity(0.12),
                value: '${waterSavedL.toStringAsFixed(0)}L',
                label: 'WATER SAVED',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SmallImpactCard(
                icon: Icons.delete_outline,
                iconColor: Colors.brown.shade300,
                iconBg: Colors.brown.withOpacity(0.14),
                value: '${wasteReducedKg.toStringAsFixed(0)}kg',
                label: 'WASTE REDUCED',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SmallImpactCard(
                icon: Icons.forest,
                iconColor: AppColors.primary,
                iconBg: AppColors.primary.withOpacity(0.12),
                value: treesPlanted.toStringAsFixed(1),
                label: 'TREES PLANTED',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SmallImpactCard(
                icon: Icons.eco,
                iconColor: AppColors.primary,
                iconBg: AppColors.primary.withOpacity(0.10),
                value: 'Live',
                label: 'STATUS',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SmallImpactCard extends StatelessWidget {
  const _SmallImpactCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTheme.headlineSmall.copyWith(
              color: AppColors.onDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTheme.caption.copyWith(color: AppColors.faintOnDark),
          ),
        ],
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      borderRadius: BorderRadius.circular(22),
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
