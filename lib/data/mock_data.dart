import 'models.dart';

class MockData {
  static final User currentUser = User(
    id: '1',
    name: 'Arjun Kumar',
    email: 'arjun@example.com',
    walletBalance: 1250,
    streakCount: 5,
    tier: 'Sapling',
    carbonSaved: 45.5,
    waterSaved: 120.0,
    wasteReduced: 15.2,
  );

  static final List<Activity> recentActivities = [
    Activity(
      id: '1',
      title: 'Cycled to Work',
      category: 'Transport',
      coinReward: 50,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'Approved',
    ),
    Activity(
      id: '2',
      title: 'Used Reusable Bag',
      category: 'Waste',
      coinReward: 20,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Pending',
    ),
    Activity(
      id: '3',
      title: 'Plant Based Meal',
      category: 'Food',
      coinReward: 30,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Approved',
    ),
  ];

  static final List<Mission> missions = [
    Mission(
      id: '1',
      title: 'Plastic-Free Week',
      description: 'Avoid single-use plastics for 7 days.',
      reward: 500,
      durationDays: 7,
      isJoined: true,
      progress: 0.4,
    ),
    Mission(
      id: '2',
      title: 'Bike to Work',
      description: 'Cycle to work for 2 weeks.',
      reward: 800,
      durationDays: 14,
    ),
    Mission(
      id: '3',
      title: 'Water Warrior',
      description: 'Save water by fixing leaks and using buckets.',
      reward: 600,
      durationDays: 30,
    ),
  ];

  static final List<ShopItem> shopItems = [
    ShopItem(
      id: '1',
      name: 'Bamboo Toothbrush',
      description: 'Biodegradable handle, charcoal bristles.',
      price: 150,
      imageUrl:
          'https://images.unsplash.com/photo-1607613009820-a29f7bb6dcaf?auto=format&fit=crop&q=80&w=200',
    ),
    ShopItem(
      id: '2',
      name: 'Seed Paper Pens',
      description: 'Plantable pens that grow into herbs.',
      price: 200,
      imageUrl:
          'https://images.unsplash.com/photo-1585336261022-680e295ce3fe?auto=format&fit=crop&q=80&w=200',
    ),
    ShopItem(
      id: '3',
      name: 'Organic Cotton Bag',
      description: 'Reusable tote bag for shopping.',
      price: 300,
      imageUrl:
          'https://images.unsplash.com/photo-1597484662317-c9253e609f0e?auto=format&fit=crop&q=80&w=200',
    ),
  ];

  static final List<Tour> tours = [
    Tour(
      id: '1',
      title: 'Organic Farm Experience',
      location: 'Tumakuru',
      description:
          'Learn organic farming techniques and enjoy a farm-fresh meal.',
      price: 1500,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&q=80&w=400',
    ),
    Tour(
      id: '2',
      title: 'Ragi Farm & Cooking',
      location: 'Mysuru',
      description: 'Harvest Ragi and learn traditional cooking methods.',
      price: 1200,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?auto=format&fit=crop&q=80&w=400',
    ),
    Tour(
      id: '3',
      title: 'Eco Homestay',
      location: 'Coorg',
      description: 'Stay in a sustainable homestay amidst coffee plantations.',
      price: 2500,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1587595431973-160d0d94add1?auto=format&fit=crop&q=80&w=400',
    ),
  ];

  static final List<CarbonProject> carbonProjects = [
    CarbonProject(
      id: '1',
      name: 'Reforestation in Western Ghats',
      location: 'Karnataka',
      pricePerTon: 15.0,
      description: 'Planting native trees to restore biodiversity.',
    ),
    CarbonProject(
      id: '2',
      name: 'Solar Power for Rural Homes',
      location: 'Raichur',
      pricePerTon: 12.0,
      description: 'Providing clean energy to off-grid villages.',
    ),
  ];

  static final List<CommunityGroup> communityGroups = [
    CommunityGroup(
      id: '1',
      name: 'Bangalore Eco Warriors',
      members: 1250,
      description: 'A group for sustainability enthusiasts in Bangalore.',
    ),
    CommunityGroup(
      id: '2',
      name: 'Mysuru Green Clean',
      members: 800,
      description: 'Cleaning drives and tree planting in Mysuru.',
    ),
  ];
}
