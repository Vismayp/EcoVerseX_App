import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme.dart';
import '../../data/models.dart';
import '../../providers/shop_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_chip.dart';
import '../../widgets/neo/neo_search_field.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final shopItemsAsync = ref.watch(shopItemsProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          backgroundColor: AppColors.backgroundDark.withOpacity(0.86),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0,
          toolbarHeight: 78,
          title: _BlurHeader(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withOpacity(0.10)),
                    ),
                    child: ClipOval(
                      child: userAsync.when(
                        data: (user) => CachedNetworkImage(
                          imageUrl: user.photoURL,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white.withOpacity(0.04),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.white.withOpacity(0.04),
                            child: const Icon(Icons.person,
                                color: AppColors.onDarkMuted),
                          ),
                        ),
                        loading: () => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                        error: (_, __) => const Icon(Icons.person,
                            color: AppColors.onDarkMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: AppTheme.bodyMedium
                              .copyWith(color: AppColors.faintOnDark),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'EcoShop',
                          style: AppTheme.headlineMedium.copyWith(
                            color: AppColors.onDark,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _CartButton(onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(
            child: userAsync.when(
              data: (user) => _BalanceCard(balance: user.walletBalance),
              loading: () => Container(
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) =>
                  Text('Error: $e', style: const TextStyle(color: Colors.red)),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          sliver: SliverToBoxAdapter(
            child: NeoSearchField(
              hintText: 'Find sustainable goods...',
              trailingIcon: Icons.tune,
              onTrailingTap: () {},
              onChanged: (_) {},
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _CategoryChip(
                    label: _categories[index], selected: index == 0);
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Deals',
                  style:
                      AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
                ),
                TextButton(
                  onPressed: () {},
                  style:
                      TextButton.styleFrom(foregroundColor: AppColors.primary),
                  child: Text(
                    'See all',
                    style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 180,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              scrollDirection: Axis.horizontal,
              itemCount: _featuredDeals.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final deal = _featuredDeals[index];
                return _FeaturedDealCard(deal: deal);
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Popular Rewards',
              style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
            ),
          ),
        ),
        shopItemsAsync.when(
          data: (items) => SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.73,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ShopProductCard(item: items[index]),
                childCount: items.length,
              ),
            ),
          ),
          loading: () => const SliverToBoxAdapter(
            child: Center(
                child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            )),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Center(
                child: Text('Error loading shop: $e',
                    style: const TextStyle(color: Colors.red))),
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

class _CartButton extends StatelessWidget {
  const _CartButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.shopping_cart, color: AppColors.onDark),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(18),
      color: AppColors.cardDark,
      child: Stack(
        children: [
          Positioned(
            top: -34,
            right: -26,
            child: Icon(
              Icons.eco,
              size: 140,
              color: AppColors.primary.withOpacity(0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Balance',
                style:
                    AppTheme.bodyMedium.copyWith(color: AppColors.faintOnDark),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$balance',
                    style: AppTheme.displayLarge.copyWith(
                      color: AppColors.onDark,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const EcoCoinIcon(size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'EcoCoins',
                          style: AppTheme.headlineSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.backgroundDark,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_circle, size: 18),
                            SizedBox(width: 8),
                            Text('Earn More'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.06),
                          foregroundColor: AppColors.onDark,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.10)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.history, size: 18),
                            SizedBox(width: 8),
                            Text('History'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return NeoChip(
      label: label,
      selected: selected,
      onTap: () {},
    );
  }
}

class _FeaturedDeal {
  const _FeaturedDeal({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.primaryBadge = true,
  });

  final String badge;
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool primaryBadge;
}

class _FeaturedDealCard extends StatelessWidget {
  const _FeaturedDealCard({required this.deal});

  final _FeaturedDeal deal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: NeoCard(
        borderRadius: BorderRadius.circular(22),
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: deal.imageUrl,
                fit: BoxFit.cover,
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
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
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
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          deal.primaryBadge ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      deal.badge,
                      style: AppTheme.caption.copyWith(
                        color: deal.primaryBadge
                            ? AppColors.backgroundDark
                            : AppColors.backgroundDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    deal.title,
                    style: AppTheme.headlineSmall.copyWith(
                      color: AppColors.onDark,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal.subtitle,
                    style: AppTheme.bodyMedium
                        .copyWith(color: AppColors.onDarkMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _ShopProductCard extends ConsumerWidget {
  const _ShopProductCard({required this.item});

  final ShopItem item;

  Future<void> _handlePurchase(BuildContext context, WidgetRef ref) async {
    try {
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          title: Text('Confirm Purchase',
              style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark)),
          content: Text(
              'Do you want to buy ${item.name} for ${item.price} EcoCoins?',
              style:
                  AppTheme.bodyMedium.copyWith(color: AppColors.onDarkMuted)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child:
                  const Text('Buy Now', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // Show loading
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing purchase...')),
      );

      final apiService = ref.read(apiServiceProvider);
      await apiService.createOrder(item.id, 1);

      // Refresh user profile to update balance
      ref.invalidate(userProfileProvider);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully purchased ${item.name}!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchase failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NeoCard(
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(12),
      color: AppColors.surfaceInput,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
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
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.40),
                        borderRadius: BorderRadius.circular(999),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.10)),
                      ),
                      child: const Icon(Icons.favorite,
                          size: 18, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.name,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.onDark,
              fontWeight: FontWeight.w900,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: AppTheme.caption.copyWith(color: AppColors.mutedOnDark),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.eco, size: 18, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${item.price}',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _handlePurchase(context, ref),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.add,
                      color: AppColors.backgroundDark, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const List<String> _categories = [
  'All',
  'Home',
  'Personal Care',
  'Stationery',
  'Lifestyle',
];

const List<_FeaturedDeal> _featuredDeals = [
  _FeaturedDeal(
    badge: '20% OFF',
    title: 'Bamboo Essentials Kit',
    subtitle: 'Start your zero-waste journey.',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuATrk1IgD45iB2I2Qj3GKjzkXlx-TAGYDNZQvw997bfK-VZzBCCz8I6OCEUhksZXqb2TqqRpmszkK2X_IIDZOIvcZhAys0MP7FMpCHKYom_lVb7ioYTm7XaEdWef2AXqdaI908DXwd--RS9H47IVNC0QUo3RmFk7zX_pKA0MRNjofQYSX7lMiX9Ue8a4KNnetA7enjoSdiUC_ba2kgFSyIOXaErpwUNol7iE_Vpa6xNL0VtDTHKiwo-0IShV32IYOzD8Tdvw8MOtwHM',
    primaryBadge: true,
  ),
  _FeaturedDeal(
    badge: 'New Arrival',
    title: 'Insulated Flask',
    subtitle: 'Keep it cold for 24h.',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBUNBqAAiQaqbWEBP3BWYnk_Y5SrKX2VFBS-odru0EbU5EuacWsHLQNKm0EDZIP9iplfGb89B1b11OClenJRt6s7mUgNouMhgnF-L-suSDaSg2aGAsiezi7IvIm2l9g2vPsBD5NUG4LZC1svKtqgtruQuXbZSmZnEBboaSGhtn8s5YtWeOYts10ulq-qPxA_J0ky_vDFk0HqS4lAQzSqcMuoH1rXGNOl3QGNEzIbUf_le-7FoLUgqCVFtzFas1g_UWBHLawsaZz9d2U',
    primaryBadge: false,
  ),
];
