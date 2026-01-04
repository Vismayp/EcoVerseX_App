class User {
  final String id;
  final String name;
  final String email;
  final String photoURL;
  final int walletBalance;
  final int streakCount;
  final String tier;
  final int points;
  final int rank;
  final double carbonSaved;
  final double waterSaved;
  final double wasteReduced;
  final int treesPlanted;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.photoURL,
    required this.walletBalance,
    required this.streakCount,
    required this.tier,
    required this.points,
    required this.rank,
    required this.carbonSaved,
    required this.waterSaved,
    required this.wasteReduced,
    required this.treesPlanted,
  });
}

class Activity {
  final String id;
  final String title;
  final String category;
  final int coinReward;
  final DateTime date;
  final String status; // Pending, Approved, Rejected
  final double? latitude;
  final double? longitude;
  final double? co2Saved;
  final double? waterSaved;
  final int? treesPlanted;
  final String? imageURL;

  Activity({
    required this.id,
    required this.title,
    required this.category,
    required this.coinReward,
    required this.date,
    required this.status,
    this.latitude,
    this.longitude,
    this.co2Saved,
    this.waterSaved,
    this.treesPlanted,
    this.imageURL,
  });
}

class MissionLog {
  final String id;
  final String description;
  final String? message;
  final String? imageURL;
  final String status;
  final int progressIncrement;
  final DateTime createdAt;

  MissionLog({
    required this.id,
    required this.description,
    this.message,
    this.imageURL,
    required this.status,
    this.progressIncrement = 0,
    required this.createdAt,
  });
}

class Mission {
  final String id;
  final String? userMissionId;
  final String title;
  final String description;
  final int reward;
  final int durationDays;
  final bool isJoined;
  final double progress;
  final String? status;
  final String? imageURL;
  final bool isActive;
  final List<MissionLog> logs;

  Mission({
    required this.id,
    this.userMissionId,
    required this.title,
    required this.description,
    required this.reward,
    required this.durationDays,
    this.isJoined = false,
    this.progress = 0.0,
    this.status,
    this.imageURL,
    this.isActive = true,
    this.logs = const [],
  });
}

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final String category;
  final int stock;
  final bool isFeatured;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.category = 'General',
    this.stock = 0,
    this.isFeatured = false,
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
  final DateTime? date;
  final String? duration;

  Tour({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.date,
    this.duration,
  });
}

class CommunityCircle {
  final String id;
  final String name;
  final String description;
  final int membersCount;
  final bool isJoined;
  final String category;
  final String? link;
  final String? platform;

  CommunityCircle({
    required this.id,
    required this.name,
    required this.description,
    required this.membersCount,
    required this.isJoined,
    required this.category,
    this.link,
    this.platform,
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
