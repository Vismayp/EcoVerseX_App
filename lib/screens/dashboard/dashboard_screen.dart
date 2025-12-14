import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/beautiful_tree_widget.dart';
import '../carbon/carbon_market_screen.dart';
import '../tours/tours_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header removed as it is now in MainScreen AppBar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${user.name.split(' ')[0]}! 👋',
                  style: AppTheme.headlineMedium,
                ),
                Text(
                  'Let\'s make an impact today',
                  style: AppTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // EcoCoins & Tier Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user.walletBalance}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Tier: ${user.tier}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: AppColors.secondary,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tree Visualization
            BeautifulTreeWidget(
              streakCount: user.streakCount,
              progress: (user.carbonSaved / 1000).clamp(0.0, 1.0),
            ),

            const SizedBox(height: 24),

            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                StatCard(
                  label: 'Carbon Saved',
                  value: '${user.carbonSaved} kg',
                  icon: Icons.cloud_off,
                  color: Colors.blueGrey,
                ),
                StatCard(
                  label: 'Water Saved',
                  value: '${user.waterSaved} L',
                  icon: Icons.water_drop,
                  color: Colors.blue,
                ),
                StatCard(
                  label: 'Waste Reduced',
                  value: '${user.wasteReduced} kg',
                  icon: Icons.delete_outline,
                  color: Colors.brown,
                ),
                StatCard(
                  label: 'Trees Planted',
                  value:
                      '${(user.carbonSaved / 22).toStringAsFixed(1)}', // Approx 22kg per tree
                  icon: Icons.forest,
                  color: AppColors.primary,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Explore',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    'AgriTours',
                    Icons.agriculture,
                    Colors.orange,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ToursScreen())),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    'Carbon Market',
                    Icons.co2,
                    Colors.teal,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CarbonMarketScreen())),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Activity
            Text(
              'Recent Activity',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: MockData.recentActivities.length,
              itemBuilder: (context, index) {
                final activity = MockData.recentActivities[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        _getActivityIcon(activity.category),
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(activity.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(activity.date.toString().split(' ')[0]),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '+${activity.coinReward} Coins',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          activity.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: activity.status == 'Approved'
                                ? AppColors.primary
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
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
