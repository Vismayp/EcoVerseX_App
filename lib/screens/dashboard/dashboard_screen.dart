import 'package:flutter/material.dart';
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user.name.split(' ')[0]}! 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Tier: ${user.tier}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2E7D32), // Dark green
                      const Color(0xFF388E3C), // Medium green
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'EcoCoins',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${user.walletBalance}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                color: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Explore',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.2),
                    child: Icon(
                      _getActivityIcon(activity.category),
                      color: Theme.of(context).colorScheme.primary,
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
                              ? Colors.green
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
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title,
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.8),
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
        return Icons.delete;
      case 'Energy':
        return Icons.bolt;
      default:
        return Icons.eco;
    }
  }
}
