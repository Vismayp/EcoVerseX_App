import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../data/models.dart';
import '../../providers/carbon_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/neo/neo_scaffold.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_primary_button.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../services/api_service.dart';
import 'calculator_screen.dart';

class CarbonMarketScreen extends ConsumerWidget {
  const CarbonMarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(carbonProjectsProvider);
    final userAsync = ref.watch(userProfileProvider);

    return NeoScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            centerTitle: true,
            flexibleSpace: const _BlurHeader(),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offset',
                        style: AppTheme.caption.copyWith(
                          color: AppColors.mutedOnDark,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Carbon Market',
                        style: AppTheme.headlineSmall.copyWith(
                          color: AppColors.onDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CalculatorScreen()),
                          );
                        },
                        icon: const Icon(Icons.calculate_outlined,
                            color: AppColors.primary),
                        tooltip: 'Calculator',
                      ),
                      userAsync.when(
                        data: (user) => _WalletPill(value: user.walletBalance),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          projectsAsync.when(
            data: (projects) => SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final project = projects[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: NeoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (project.imageURL.isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  project.imageURL,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                          height: 150, color: Colors.grey[800]),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          project.name,
                                          style: AppTheme.headlineSmall
                                              .copyWith(
                                                  color: AppColors.onDark),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${project.pricePerCredit} Coins',
                                          style: AppTheme.caption.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    project.location,
                                    style: AppTheme.caption
                                        .copyWith(color: AppColors.mutedOnDark),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    project.description,
                                    style: AppTheme.bodyMedium.copyWith(
                                        color:
                                            AppColors.onDark.withOpacity(0.8)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
                                  NeoPrimaryButton(
                                    label: 'Buy Credits',
                                    onPressed: () {
                                      // Show buy dialog
                                      _showBuyDialog(context, ref, project);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: projects.length,
                ),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                  child: Text('Error loading projects',
                      style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyDialog(
      BuildContext context, WidgetRef ref, CarbonProject project) {
    final controller = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Buy Credits', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How many credits do you want to buy?',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Credits',
                labelStyle: TextStyle(color: AppColors.onDarkMuted),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.onDarkMuted)),
          ),
          TextButton(
            onPressed: () async {
              final credits = double.tryParse(controller.text) ?? 0;
              if (credits > 0) {
                try {
                  final apiService = ref.read(apiServiceProvider);
                  await apiService.buyCarbonCredits(project.id, credits);
                  Navigator.pop(context);
                  ref.invalidate(carbonProjectsProvider);
                  ref.invalidate(userProfileProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Purchase successful!')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Purchase failed. Check balance.')),
                  );
                }
              }
            },
            child:
                const Text('Buy', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _BlurHeader extends StatelessWidget {
  const _BlurHeader();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: AppColors.backgroundDark.withOpacity(0.7),
        ),
      ),
    );
  }
}

class _WalletPill extends StatelessWidget {
  final int value;
  const _WalletPill({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const EcoCoinIcon(size: 16),
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
