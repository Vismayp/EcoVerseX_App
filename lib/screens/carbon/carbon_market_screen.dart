import 'dart:ui';

import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_chip.dart';
import '../../widgets/neo/neo_primary_button.dart';
import '../../widgets/neo/neo_scaffold.dart';
import '../../widgets/neo/neo_section_header.dart';

class CarbonMarketScreen extends StatefulWidget {
  const CarbonMarketScreen({super.key});

  @override
  State<CarbonMarketScreen> createState() => _CarbonMarketScreenState();
}

class _CarbonMarketScreenState extends State<CarbonMarketScreen> {
  int _tabIndex = 0;
  final TextEditingController _treeCountController = TextEditingController();
  double _calculatedCarbon = 0.0;

  @override
  void dispose() {
    _treeCountController.dispose();
    super.dispose();
  }

  void _calculateCarbon() {
    final int count = int.tryParse(_treeCountController.text) ?? 0;
    setState(() {
      _calculatedCarbon = count * 22.0; // 22kg per tree
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return NeoScaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedHeaderDelegate(
              minExtent: 152,
              maxExtent: 152,
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
                                'Marketplace',
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
                          _WalletPill(value: user.walletBalance),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Buy verified carbon offsets and trade credits',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.mutedOnDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 44,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final label =
                                index == 0 ? 'Calculator' : 'Marketplace';
                            return NeoChip(
                              label: label,
                              icon: index == 0
                                  ? Icons.calculate
                                  : Icons.storefront,
                              selected: _tabIndex == index,
                              onTap: () => setState(() => _tabIndex = index),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _tabIndex == 0
                  ? _CalculatorTab(
                      key: const ValueKey('calculator'),
                      treeCountController: _treeCountController,
                      calculatedCarbonKg: _calculatedCarbon,
                      onCalculate: _calculateCarbon,
                    )
                  : const _MarketplaceTab(key: ValueKey('marketplace')),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
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

class _CalculatorTab extends StatelessWidget {
  final TextEditingController treeCountController;
  final double calculatedCarbonKg;
  final VoidCallback onCalculate;

  const _CalculatorTab({
    super.key,
    required this.treeCountController,
    required this.calculatedCarbonKg,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    final credits = calculatedCarbonKg > 0 ? calculatedCarbonKg / 1000.0 : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeoSectionHeader(title: 'Carbon Credit Calculator'),
          const SizedBox(height: 10),
          NeoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calculate potential carbon credits from your trees',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.mutedOnDark,
                  ),
                ),
                const SizedBox(height: 16),
                _NeoInputField(
                  controller: treeCountController,
                  label: 'Number of Mango Trees',
                  hintText: 'e.g., 10',
                  icon: Icons.forest_outlined,
                ),
                const SizedBox(height: 14),
                NeoPrimaryButton(
                  label: 'Calculate',
                  icon: Icons.calculate,
                  height: 52,
                  onPressed: onCalculate,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (calculatedCarbonKg > 0)
            _ResultCard(
              carbonKgPerYear: calculatedCarbonKg,
              creditsPerYear: credits,
            ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final double carbonKgPerYear;
  final double creditsPerYear;

  const _ResultCard({
    required this.carbonKgPerYear,
    required this.creditsPerYear,
  });

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      child: Column(
        children: [
          Text(
            'Estimated Sequestration',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.mutedOnDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${carbonKgPerYear.toStringAsFixed(1)} kg CO2/year',
            style: AppTheme.headlineSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credits/year',
                style:
                    AppTheme.bodyMedium.copyWith(color: AppColors.mutedOnDark),
              ),
              Text(
                creditsPerYear.toStringAsFixed(2),
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.onDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.18)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.directions_car, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Equivalent driving: ${(carbonKgPerYear / 0.2).toStringAsFixed(0)} km',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.onDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketplaceTab extends StatelessWidget {
  const _MarketplaceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = MockData.carbonProjects;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeoSectionHeader(title: 'Verified Projects'),
          const SizedBox(height: 12),
          ...projects.map(
            (project) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ProjectCard(project: project),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final CarbonProject project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: AppTheme.headlineSmall.copyWith(
                    color: AppColors.onDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _VerifiedPill(),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppColors.mutedOnDark),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  project.location,
                  style: AppTheme.bodyMedium
                      .copyWith(color: AppColors.mutedOnDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            project.description,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.mutedOnDark,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price per Ton',
                    style:
                        AppTheme.caption.copyWith(color: AppColors.mutedOnDark),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${project.pricePerTon.toStringAsFixed(2)}',
                    style: AppTheme.headlineSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              _SmallPrimaryButton(label: 'Buy Offset', onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerifiedPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.22)),
      ),
      child: Text(
        'Verified',
        style: AppTheme.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SmallPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SmallPrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          label,
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _NeoInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;

  const _NeoInputField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: AppColors.mutedOnDark,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceInput,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(icon, color: AppColors.mutedOnDark),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: AppTheme.bodyLarge.copyWith(color: AppColors.onDark),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppTheme.bodyMedium
                        .copyWith(color: AppColors.mutedOnDark),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
