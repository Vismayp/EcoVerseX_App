import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = MockData.communityGroups;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLeaderboard(context),
          const SizedBox(height: 24),
          Text(
            'EcoCircles',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...groups.map((group) => _buildGroupCard(context, group)),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Global Leaderboard',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildLeaderboardItem(context, 1, 'Sarah J.', 1200, true),
            const Divider(),
            _buildLeaderboardItem(context, 2, 'Mike T.', 1150, false),
            const Divider(),
            _buildLeaderboardItem(
                context, 3, 'Arjun K.', 1100, false), // Current User
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(
      BuildContext context, int rank, String name, int score, bool isTop) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isTop ? Colors.amber : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Text(
              '#$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isTop ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Text(
            '$score pts',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, CommunityGroup group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.group, color: Colors.white),
        ),
        title: Text(group.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${group.members} Members • ${group.description}'),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            minimumSize: const Size(60, 36),
          ),
          child: const Text('Join'),
        ),
      ),
    );
  }
}
