import 'package:flutter/material.dart';

import '../../config/theme.dart';
import 'neo_bottom_nav.dart';

class NeoBottomNavItem {
  const NeoBottomNavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
}

class NeoBottomNavBar extends StatelessWidget {
  const NeoBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
    this.centerIcon = Icons.qr_code_scanner,
  });

  final List<NeoBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;
  final IconData centerIcon;

  @override
  Widget build(BuildContext context) {
    // items expected to be 4: left(2), right(2). Center scan button in between.
    assert(items.length == 4);

    Widget buildItem(int visualIndex, NeoBottomNavItem item) {
      final bool selected = currentIndex == visualIndex;
      final Color fg = selected ? AppColors.primary : AppColors.mutedOnDark;

      return Expanded(
        child: InkWell(
          onTap: () => onTap(visualIndex),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(selected ? (item.selectedIcon ?? item.icon) : item.icon,
                    color: fg, size: 26),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: fg,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return NeoBottomNavContainer(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildItem(0, items[0]),
              buildItem(1, items[1]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -18),
                        child: InkWell(
                          onTap: onCenterTap,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.35),
                                  blurRadius: 22,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(
                                color: AppColors.backgroundDark,
                                width: 4,
                              ),
                            ),
                            child: Icon(centerIcon,
                                color: AppColors.backgroundDark, size: 28),
                          ),
                        ),
                      ),
                      Text(
                        'Scan',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: AppColors.mutedOnDark),
                      ),
                    ],
                  ),
                ),
              ),
              buildItem(2, items[2]),
              buildItem(3, items[3]),
            ],
          ),
        ),
      ),
    );
  }
}
