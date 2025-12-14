class User {
  final String id;
  final String name;
  final String email;
  final int walletBalance;
  final int streakCount;
  final String tier;
  final double carbonSaved;
  final double waterSaved;
  final double wasteReduced;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.walletBalance,
    required this.streakCount,
    required this.tier,
    required this.carbonSaved,
    required this.waterSaved,
    required this.wasteReduced,
  });
}

class Activity {
  final String id;
  final String title;
  final String category;
  final int coinReward;
  final DateTime date;
  final String status; // Pending, Approved, Rejected

  Activity({
    required this.id,
    required this.title,
    required this.category,
    required this.coinReward,
    required this.date,
    required this.status,
  });
}

class Mission {
  final String id;
  final String title;
  final String description;
  final int reward;
  final int durationDays;
  final bool isJoined;
  final double progress;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.reward,
    required this.durationDays,
    this.isJoined = false,
    this.progress = 0.0,
  });
}

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class Tour {
  final String id;
  final String title;
  final String location;
  final String description;
  final int price;
  final double rating;
  final String imageUrl;

  Tour({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });
}

class CarbonProject {
  final String id;
  final String name;
  final String location;
  final double pricePerTon;
  final String description;

  CarbonProject({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerTon,
    required this.description,
  });
}

class CommunityGroup {
  final String id;
  final String name;
  final int members;
  final String description;

  CommunityGroup({
    required this.id,
    required this.name,
    required this.members,
    required this.description,
  });
}
