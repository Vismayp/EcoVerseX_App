import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
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
import 'order_history_screen.dart';

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
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleSpacing: 0,
          toolbarHeight: 80,
          flexibleSpace: const _BlurHeader(child: SizedBox.expand()),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
              ],
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
        /*
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
        */
        /*
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
        */
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
                /*
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
                */
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: shopItemsAsync.when(
            data: (items) {
              final featuredItems =
                  items.where((item) => item.isFeatured).toList();
              if (featuredItems.isEmpty) {
                return const SizedBox.shrink();
              }
              return SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return _FeaturedDealCard(item: featuredItems[index]);
                  },
                ),
              );
            },
            loading: () => const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
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
  const _BlurHeader({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          height: double.infinity,
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderHistoryScreen(),
                            ),
                          );
                        },
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

class _FeaturedDealCard extends StatelessWidget {
  const _FeaturedDealCard({required this.item});

  final ShopItem item;

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
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'FEATURED',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.backgroundDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    style: AppTheme.headlineSmall.copyWith(
                      color: AppColors.onDark,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
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

class _PurchaseDialog extends StatefulWidget {
  final ShopItem item;

  const _PurchaseDialog({required this.item});

  @override
  State<_PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<_PurchaseDialog> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text('Confirm Purchase',
          style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Do you want to buy ${widget.item.name} for ${widget.item.price} EcoCoins?',
                style:
                    AppTheme.bodyMedium.copyWith(color: AppColors.onDarkMuted)),
            const SizedBox(height: 20),
            Text('Delivery Contact Number',
                style: AppTheme.caption.copyWith(color: AppColors.primary)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter mobile number',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _phoneController.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Buy Now', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

class _ShopProductCard extends ConsumerWidget {
  const _ShopProductCard({required this.item});

  final ShopItem item;

  Future<void> _handlePurchase(BuildContext context, WidgetRef ref) async {
    try {
      // Show confirmation dialog with mobile number input
      final String? mobileNumber = await showDialog<String>(
        context: context,
        builder: (context) => _PurchaseDialog(item: item),
      );

      if (mobileNumber == null) return;

      // Show loading
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing purchase...')),
      );

      final apiService = ref.read(apiServiceProvider);
      await apiService.createOrder(item.id, 1, mobileNumber);

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
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = e.response?.data['error'] ?? e.message;
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchase failed: $errorMessage'),
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
