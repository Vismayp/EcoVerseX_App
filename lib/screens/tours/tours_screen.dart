import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_chip.dart';
import '../../widgets/neo/neo_primary_button.dart';
import '../../widgets/neo/neo_search_field.dart';
import '../../widgets/neo/neo_section_header.dart';

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilter = 0;

  static const List<_TourFilter> _filters = [
    _TourFilter('All', Icons.travel_explore),
    _TourFilter('Organic Farms', Icons.agriculture),
    _TourFilter('Workshops', Icons.school),
    _TourFilter('Volunteer', Icons.volunteer_activism),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final tours = MockData.tours;

    final query = _searchController.text.trim().toLowerCase();
    final selectedFilter = _filters[_selectedFilter].label;

    final filteredTours = tours.where((t) {
      if (query.isNotEmpty) {
        final haystack =
            '${t.title} ${t.location} ${t.description}'.toLowerCase();
        if (!haystack.contains(query)) return false;
      }

      if (selectedFilter == 'Organic Farms') {
        return t.title.toLowerCase().contains('farm') ||
            t.title.toLowerCase().contains('organic');
      }
      if (selectedFilter == 'Workshops') {
        return t.title.toLowerCase().contains('workshop') ||
            t.title.toLowerCase().contains('cooking');
      }
      if (selectedFilter == 'Volunteer') {
        return t.title.toLowerCase().contains('volunteer') ||
            t.description.toLowerCase().contains('volunteer');
      }

      return true;
    }).toList(growable: false);

    final featured =
        tours.where((t) => t.rating >= 4.8).take(2).toList(growable: false);

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _PinnedHeaderDelegate(
            minExtent: 150,
            maxExtent: 150,
            child: _BlurHeader(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                              'Explore',
                              style: AppTheme.caption.copyWith(
                                color: AppColors.mutedOnDark,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'AgriTours',
                                  style: AppTheme.headlineSmall.copyWith(
                                    color: AppColors.onDark,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.expand_more,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ],
                        ),
                        _BalancePill(balance: user.walletBalance),
                      ],
                    ),
                    const SizedBox(height: 12),
                    NeoSearchField(
                      controller: _searchController,
                      hintText: 'Search farms, workshops in Karnataka...',
                      trailingIcon: Icons.tune,
                      onChanged: (_) => setState(() {}),
                      onTrailingTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                return NeoChip(
                  label: filter.label,
                  icon: filter.icon,
                  selected: index == _selectedFilter,
                  onTap: () => setState(() => _selectedFilter = index),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: NeoSectionHeader(
              title: 'Trending Experiences',
              actionText: 'See all',
              onAction: () {},
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              itemCount: featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final tour = featured[index];
                final badge = index == 0 ? '🔥 Trending' : '⭐ Top Rated';
                return _FeaturedTourCard(tour: tour, badge: badge);
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Text(
              'All Tours in Karnataka',
              style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          sliver: SliverList.separated(
            itemCount: filteredTours.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final tour = filteredTours[index];
              return _TourListCard(
                tour: tour,
                showPrimaryCta: index == 0,
                carbonSavedKg: _estimateCarbonSavedKg(tour),
              );
            },
          ),
        ),
      ],
    );
  }

  double _estimateCarbonSavedKg(Tour tour) {
    // Tours don't currently include carbon metrics; keep this as a lightweight,
    // deterministic placeholder aligned with the UI template.
    final kg = (tour.price / 1000.0) * 1.3;
    return kg.clamp(0.8, 4.5);
  }
}

class _TourFilter {
  final String label;
  final IconData icon;

  const _TourFilter(this.label, this.icon);
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
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDarker.withOpacity(0.80),
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

class _BalancePill extends StatelessWidget {
  final int balance;

  const _BalancePill({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withOpacity(0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.savings, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '$balance',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.onDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'ECO',
            style: AppTheme.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedTourCard extends StatelessWidget {
  final Tour tour;
  final String badge;

  const _FeaturedTourCard({
    required this.tour,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: tour.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.cardDark,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.cardDark,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.mutedOnDark,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.10),
                      Colors.black.withOpacity(0.65),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: _BadgePill(text: badge),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${tour.location}, KA',
                            style: AppTheme.caption.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${tour.price} EcoCoins',
                        style: AppTheme.bodyMedium.copyWith(
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
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  final String text;

  const _BadgePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.20)),
      ),
      child: Text(
        text,
        style: AppTheme.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TourListCard extends StatelessWidget {
  final Tour tour;
  final bool showPrimaryCta;
  final double carbonSavedKg;

  const _TourListCard({
    required this.tour,
    required this.showPrimaryCta,
    required this.carbonSavedKg,
  });

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TourImageHeader(
            imageUrl: tour.imageUrl,
            rating: tour.rating,
            carbonSavedKg: carbonSavedKg,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.title,
                            style: AppTheme.headlineSmall.copyWith(
                              color: AppColors.onDark,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: AppColors.mutedOnDark,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${tour.location}, Karnataka',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppColors.mutedOnDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${tour.price}',
                          style: AppTheme.headlineSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'EcoCoins',
                          style: AppTheme.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  tour.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.mutedOnDark,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                if (showPrimaryCta)
                  NeoPrimaryButton(
                    label: 'Book Now',
                    icon: Icons.arrow_forward,
                    height: 52,
                    onPressed: () {},
                  )
                else
                  _SecondaryButton(
                    label: 'View Details',
                    onPressed: () {},
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TourImageHeader extends StatelessWidget {
  final String imageUrl;
  final double rating;
  final double carbonSavedKg;

  const _TourImageHeader({
    required this.imageUrl,
    required this.rating,
    required this.carbonSavedKg,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.surfaceInput,
                alignment: Alignment.center,
                child: const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceInput,
                alignment: Alignment.center,
                child: Icon(
                  Icons.image_not_supported,
                  color: AppColors.mutedOnDark,
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDarker.withOpacity(0.80),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.primary.withOpacity(0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.eco, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Save ${carbonSavedKg.toStringAsFixed(1)}kg CO2',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.onDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SecondaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side:
              BorderSide(color: AppColors.primary.withOpacity(0.25), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
