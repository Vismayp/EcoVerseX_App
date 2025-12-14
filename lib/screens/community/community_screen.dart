import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/custom_button.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = MockData.communityGroups;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLeaderboard(context),
          const SizedBox(height: 24),
          Text(
            'EcoCircles',
            style: AppTheme.headlineMedium.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 16),
          ...groups.map((group) => _buildGroupCard(context, group)),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.leaderboard, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Global Leaderboard',
                  style: AppTheme.headlineSmall.copyWith(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildLeaderboardItem(context, 1, 'Sarah J.', 1200, true),
            const Divider(height: 24),
            _buildLeaderboardItem(context, 2, 'Mike T.', 1150, false),
            const Divider(height: 24),
            _buildLeaderboardItem(
                context, 3, 'Arjun K.', 1100, false), // Current User
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(
      BuildContext context, int rank, String name, int score, bool isTop) {
    Color rankColor;
    if (rank == 1) {
      rankColor = const Color(0xFFFFD700); // Gold
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Silver
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32); // Bronze
    } else {
      rankColor = Colors.grey[300]!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: rankColor, width: 2),
            ),
            child: Text(
              '#$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rankColor == Colors.grey[300]
                    ? Colors.black54
                    : rankColor, // Darker text for visibility
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            name,
            style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            '$score pts',
            style: AppTheme.bodyLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, CommunityGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.secondary.withOpacity(0.1),
          child: Icon(Icons.group, color: AppColors.secondary),
        ),
        title: Text(
          group.name,
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${group.members} Members • ${group.description}',
            style: AppTheme.caption,
          ),
        ),
        trailing: CustomButton(
          text: 'Join',
          onPressed: () {},
          width: 70,
          height: 36,
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }
}
