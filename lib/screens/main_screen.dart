import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../widgets/neo/neo_bottom_nav_bar.dart';
import '../widgets/neo/neo_scaffold.dart';
import 'activity_logging/activity_log_sheet.dart';
import 'community/community_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'missions/missions_screen.dart';
import 'shop/shop_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const MissionsScreen(),
    const ShopScreen(),
    const CommunityScreen(),
  ];

  void _openActivityLog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ActivityLogSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NeoScaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: _openActivityLog,
        backgroundColor: AppColors.primary,
        elevation: 8,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.backgroundDark, width: 4),
        ),
        child: const Icon(Icons.add, color: AppColors.backgroundDark, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NeoBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        onCenterTap: _openActivityLog,
        items: const [
          NeoBottomNavItem(
            label: 'Home',
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
          ),
          NeoBottomNavItem(
            label: 'Missions',
            icon: Icons.flag_outlined,
            selectedIcon: Icons.flag,
          ),
          NeoBottomNavItem(
            label: 'Shop',
            icon: Icons.shopping_bag_outlined,
            selectedIcon: Icons.shopping_bag,
          ),
          NeoBottomNavItem(
            label: 'Community',
            icon: Icons.groups_outlined,
            selectedIcon: Icons.groups,
          ),
        ],
      ),
    );
  }
}
